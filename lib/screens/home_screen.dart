import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_waste_mobile/screens/announcement_screen.dart';
import 'package:smart_waste_mobile/screens/notif_screen.dart';
import 'package:smart_waste_mobile/utlis/colors.dart';
import 'package:smart_waste_mobile/widgets/button_widget.dart';
import 'package:smart_waste_mobile/widgets/drawer_widget.dart';
import 'package:smart_waste_mobile/widgets/text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const DrawerWidget(),
      backgroundColor: background,
      body: Padding(
        padding: const EdgeInsets.all(20),
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
                        builder: (context) => const AnnouncementScreen()));
                  },
                  icon: const Icon(
                    Icons.campaign_outlined,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'Smart Solid\nWaste Collector',
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'Bold',
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
                ),
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ),
                    );
                  }
                  final dynamic data = snapshot.data!.snapshot.value;

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
                              position: LatLng(
                                  double.parse(data['NODES']['Truck-01']
                                          ['current']
                                      .first
                                      .toString()
                                      .split(',')[0]),
                                  double.parse(data['NODES']['Truck-01']
                                          ['current']
                                      .first
                                      .toString()
                                      .split(',')[1])),
                              markerId: const MarkerId(
                                'Marker',
                              ),
                            ),
                          },
                          polylines: {
                            Polyline(
                              color: Colors.blue,
                              width: 5,
                              points: [
                                for (int i = 0; i < data['NODES']['Truck-01']['current'].length; i++)
                                  data['NODES']['Truck-01']['current'][i] == null
                                      ? LatLng(
                                          double.parse(data['NODES']['Truck-01']
                                                  ['current']
                                              .first
                                              .toString()
                                              .split(',')[0]),
                                          double.parse(data['NODES']['Truck-01']
                                                  ['current']
                                              .first
                                              .toString()
                                              .split(',')[1]))
                                      : LatLng(
                                          double.parse(data['NODES']['Truck-01']
                                                  ['current'][i]
                                              .toString()
                                              .split(',')[0]),
                                          double.parse(data['NODES']['Truck-01']['current'][i].toString().split(',')[1])),
                              ],
                              polylineId: const PolylineId(
                                'Location',
                              ),
                            ),
                          },
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                double.parse(data['NODES']['Truck-01']
                                        ['current']
                                    .first
                                    .toString()
                                    .split(',')[0]),
                                double.parse(data['NODES']['Truck-01']
                                        ['current']
                                    .first
                                    .toString()
                                    .split(',')[1])),
                            zoom: 14.4746,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                            setState(() {
                              mapController = controller;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ButtonWidget(
                        radius: 15,
                        color: Colors.green,
                        label: 'Track GT',
                        onPressed: () {
                          mapController!.animateCamera(
                              CameraUpdate.newLatLngZoom(
                                  LatLng(
                                      double.parse(data['NODES']['Truck-01']
                                              ['current']
                                          .first
                                          .toString()
                                          .split(',')[0]),
                                      double.parse(data['NODES']['Truck-01']
                                              ['current']
                                          .first
                                          .toString()
                                          .split(',')[1])),
                                  18.0));
                        },
                      ),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
