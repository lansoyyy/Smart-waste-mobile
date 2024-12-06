import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_waste_mobile/screens/announcement_screen.dart';
import 'package:smart_waste_mobile/screens/notif_screen.dart';
import 'package:smart_waste_mobile/services/data.dart';
import 'package:smart_waste_mobile/utlis/colors.dart';
import 'package:smart_waste_mobile/utlis/distance_calculations.dart';
import 'package:smart_waste_mobile/widgets/button_widget.dart';
import 'package:smart_waste_mobile/widgets/drawer_widget.dart';
import 'package:smart_waste_mobile/widgets/text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mapController!.dispose();
  }

  bool hasLoaded = false;
  double lat = 0;
  double lng = 0;

  getLocation() async {
    determinePosition();
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((position) async {
      setState(() {
        lat = position.latitude;
        lng = position.longitude;
        hasLoaded = true;
      });
    }).catchError((error) {
      print('Error getting location: $error');
    });
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  GoogleMapController? mapController;

  List<LatLng> getValidLatLngPoints(List<dynamic> points) {
    List<LatLng> validPoints = [];
    for (var point in points) {
      if (point != null) {
        try {
          var coordinates = point.toString().split(',');
          double lat = double.parse(coordinates[0]);
          double lng = double.parse(coordinates[1]);
          validPoints.add(LatLng(lat, lng));
        } catch (e) {
          // Handle parsing errors or log them
          print('Invalid point encountered: $point');
        }
      }
    }
    return validPoints;
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), // Stay in app
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Exit app
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; // Return false if dialog is dismissed
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await _showExitConfirmation(context);
        return shouldExit; // Return true if user confirms, false otherwise
      },
      child: Scaffold(
        endDrawerEnableOpenDragGesture: false,
        drawerEnableOpenDragGesture: false,
        endDrawer: const DrawerWidget(),
        backgroundColor: background,
        body: hasLoaded
            ? Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const AnnouncementScreen()));
                            },
                            icon: const Icon(
                              Icons.campaign_outlined,
                            ),
                          ),
                          StreamBuilder<DatabaseEvent>(
                              stream: FirebaseDatabase.instance.ref().onValue,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  print(snapshot.error);
                                  return const Center(child: Text('Error'));
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox();
                                }
                                final dynamic cardata =
                                    snapshot.data!.snapshot.value;

                                try {
                                  if (calculateDistance(
                                          lat,
                                          lng,
                                          double.parse(cardata['NODES']
                                                      ['Truck-01']['current'][
                                                  cardata['NODES']['Truck-01']
                                                              ['current']
                                                          .length -
                                                      1]
                                              .toString()
                                              .split(',')[0]),
                                          double.parse(cardata['NODES']
                                                      ['Truck-01']['current']
                                                  [cardata['NODES']['Truck-01']['current'].length - 1]
                                              .toString()
                                              .split(',')[1])) <
                                      0.5) {
                                    if (box.read('toshow')) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback(
                                        (timeStamp) {
                                          showGarbageDialog();
                                        },
                                      );
                                    }
                                  }
                                } catch (e) {}
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      child: TextWidget(
                                        text: 'Smart Solid\nWaste Collector',
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontFamily: 'Bold',
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/images/image-removebg-preview (7) 1.png',
                                      height: 125,
                                    ),
                                    TextWidget(
                                      text: 'Garbage Truck Tracker',
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontFamily: 'Bold',
                                    ),
                                  ],
                                );
                              }),
                          Builder(builder: (context) {
                            return IconButton(
                              onPressed: () async {
                                Scaffold.of(context).openEndDrawer();
                              },
                              icon: const Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      StreamBuilder<DatabaseEvent>(
                        stream: FirebaseDatabase.instance.ref().onValue,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            return const Center(child: Text('Error'));
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextWidget(
                                      text: 'Loading. Please wait',
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          final dynamic data = snapshot.data!.snapshot.value;
                          final List<LatLng> validPoints =
                              data['NODES']['Truck-01']['current'] == null
                                  ? [LatLng(lat, lng)]
                                  : getValidLatLngPoints(
                                      data['NODES']['Truck-01']['current']);

                          return Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                width: double.infinity,
                                height: 350,
                                child: GoogleMap(
                                  markers: {
                                    Marker(
                                      position: validPoints.isNotEmpty
                                          ? validPoints.first
                                          : const LatLng(0, 0),
                                      markerId: const MarkerId('Marker'),
                                      infoWindow: InfoWindow(
                                        title: 'Receiver',
                                        snippet:
                                            '${calculateDistance(validPoints.first.latitude, validPoints.first.longitude, validPoints.last.latitude, validPoints.last.longitude)}km away',
                                      ),
                                    ),
                                    Marker(
                                      position: validPoints.isNotEmpty
                                          ? validPoints.last
                                          : const LatLng(0, 0),
                                      markerId: const MarkerId('Truck'),
                                      infoWindow: const InfoWindow(
                                        title: 'Truck',
                                        snippet: 'Truck Location',
                                      ),
                                    ),
                                    for (int i = 0; i < latLongData.length; i++)
                                      Marker(
                                        position: LatLng(
                                            latLongData[i]['latitude'],
                                            latLongData[i]['longitude']),
                                        markerId: MarkerId(i.toString()),
                                        infoWindow: InfoWindow(
                                          title: 'Collection Point ${i + 1}',
                                        ),
                                      ),
                                  },
                                  polylines: {
                                    Polyline(
                                      color: Colors.blue,
                                      width: 5,
                                      points: validPoints,
                                      polylineId: const PolylineId('Location'),
                                    ),
                                  },
                                  mapType: MapType.normal,
                                  initialCameraPosition: CameraPosition(
                                    target: validPoints.isNotEmpty
                                        ? validPoints.first
                                        : const LatLng(0, 0),
                                    zoom: 14.4746,
                                  ),
                                  onMapCreated: (controller) {
                                    _controller.complete(controller);
                                    // setState(() {
                                    //   mapController = controller;
                                    // });
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              ButtonWidget(
                                radius: 15,
                                color: Colors.green,
                                label: 'Track GT',
                                onPressed: () async {
                                  final GoogleMapController controller =
                                      await _controller.future;
                                  await controller.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                              target: LatLng(lat, lng),
                                              zoom: 18)));
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  final box = GetStorage();

  showGarbageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () {
                        box.write('toshow', false);
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      )),
                ),
                TextWidget(
                  text: 'Garbage Truck Collector',
                  fontSize: 18,
                  fontFamily: 'Bold',
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/image-removebg-preview (7) 1.png',
                      height: 125,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget(
                          text: 'has Arrived in\nyour location',
                          fontSize: 11,
                          fontFamily: 'Bold',
                          align: TextAlign.start,
                        ),
                        TextWidget(
                          text: 'Please prepare\nyour garbage',
                          fontSize: 11,
                          fontFamily: 'Bold',
                          align: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextWidget(
                          text: 'Thank you!',
                          fontSize: 16,
                          fontFamily: 'Bold',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
