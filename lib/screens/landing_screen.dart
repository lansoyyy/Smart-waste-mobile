import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:smart_waste_mobile/utlis/colors.dart';
import 'package:smart_waste_mobile/widgets/button_widget.dart';
import 'package:smart_waste_mobile/widgets/text_widget.dart';
import 'package:smart_waste_mobile/widgets/toast_widget.dart';

import 'home_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final box = GetStorage();

  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
      (value) {
        setState(() {
          _supportState = value;
        });

        if (value) {
          showToast('This device supports biometrics.');
        } else {
          showToast("This device doesn't supports biometrics!");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: background),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'Smart Solid Waste Collector',
                    fontSize: 32,
                    fontFamily: 'Bold',
                    color: Colors.white,
                  ),
                  Image.asset('assets/images/image-removebg-preview (7) 1.png'),
                  TextWidget(
                    text: '''
        Navigate the Future, Track your Solid Waste Truck Collector: Our Smart Truck for Waste Collectors Leads the Way to a Cleaner Tomorrow!
        ''',
                    fontSize: 12,
                    fontFamily: 'Bold',
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              ButtonWidget(
                color: primary,
                width: 250,
                radius: 15,
                fontSize: 18,
                label: 'Get Started',
                onPressed: () async {
                  if (_supportState) {
                    try {
                      final bool didAuthenticate = await auth.authenticate(
                          options: const AuthenticationOptions(
                            biometricOnly: true,
                          ),
                          localizedReason: 'Please authenticate to proceed!');

                      if (didAuthenticate) {
                        box.write('started', true);

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                      } else {
                        showToast('Invalid biometrics!');
                      }
                      // ···
                    } on PlatformException {
                      showToast('Something went wrong!');
                      // ...
                    }
                  } else {
                    box.write('started', true);

                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
