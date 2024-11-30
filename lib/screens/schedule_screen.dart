import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_waste_mobile/screens/announcement_screen.dart';
import 'package:smart_waste_mobile/screens/notif_screen.dart';
import 'package:smart_waste_mobile/utlis/colors.dart';
import 'package:smart_waste_mobile/utlis/distance_calculations.dart';
import 'package:smart_waste_mobile/utlis/schedule_data.dart';
import 'package:smart_waste_mobile/widgets/button_widget.dart';
import 'package:smart_waste_mobile/widgets/drawer_widget.dart';
import 'package:smart_waste_mobile/widgets/text_widget.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final searchController = TextEditingController();
  String nameSearched = '';

  List data = [
    {
      'name': 'Monday',
      'time': '8:00AM-12:00NN',
    },
    {
      'name': 'Tuesday',
      'time': '6:00AM-12:00NN',
    },
    {
      'name': 'Wednesday',
      'time': '8:00AM-12:00NN',
    },
    {
      'name': 'Thursday',
      'time': '8:00AM-12:00NN',
    },
    {
      'name': 'Friday',
      'time': '8:00AM-12:00NN',
    },
    {
      'name': 'Saturday',
      'time': '6:00AM-10:00AM',
    },
    {
      'name': 'Sunday',
      'time': '2:00PM-8:00PM',
    },
  ];

  List notes = [
    '',
    '',
    '''
Silae - Miglamin 2nd Wednesday
of the Month\n
Mapulo - Miglamin 4th Wednesday
of the Month
''',
    '''
Mapayag - Can - ayan\n1st Thursday of the month
    ''',
    '',
    '',
    '',
  ];
  int index = 0;
  bool isNote = false;
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
                      GestureDetector(
                        child: TextWidget(
                          text: 'Smart Solid\nWaste Collector',
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'Bold',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextWidget(
                        text: 'SCHEDULE',
                        fontSize: 18,
                        color: Colors.black,
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
              Container(
                width: double.infinity,
                height: 600,
                decoration: BoxDecoration(
                  color: Colors.green[800],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      color: Colors.brown,
                      child: Center(
                        child: TextWidget(
                          text: data[index]['name'],
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextWidget(
                      text: 'Time',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ButtonWidget(
                      width: 200,
                      color: primary,
                      label: data[index]['time'],
                      onPressed: () {},
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (details.velocity.pixelsPerSecond.dx > 0) {
                          if (index > 0) {
                            setState(() {
                              index--;
                            });
                          }
                        } else if (details.velocity.pixelsPerSecond.dx < 0) {
                          if (index < 6) {
                            setState(() {
                              index++;
                            });
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: double.infinity,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.green[400],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.green[600],
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                  child: TextWidget(
                                    text: isNote ? 'Note' : 'Area',
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: isNote
                                      ? TextWidget(
                                          text: notes[index],
                                          fontSize: 14,
                                          color: Colors.white,
                                        )
                                      : Image.asset(
                                          'assets/images/${index + 1}.PNG',
                                          height: 210,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ButtonWidget(
                      width: 150,
                      color: Colors.grey,
                      radius: 100,
                      label: !isNote ? 'Note' : 'Back',
                      onPressed: () {
                        if (!isNote) {
                          setState(() {
                            isNote = true;
                          });
                        } else {
                          setState(() {
                            isNote = false;
                          });
                        }
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }
}
