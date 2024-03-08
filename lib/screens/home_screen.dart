import 'package:flutter/material.dart';
import 'package:smart_waste_mobile/utlis/colors.dart';
import 'package:smart_waste_mobile/widgets/drawer_widget.dart';
import 'package:smart_waste_mobile/widgets/text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                const SizedBox(
                  width: 50,
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
            Container(
              width: 400,
              height: 390,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
