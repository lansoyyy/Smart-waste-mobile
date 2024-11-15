import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_waste_mobile/firebase_options.dart';
import 'package:smart_waste_mobile/screens/home_screen.dart';
import 'package:smart_waste_mobile/screens/landing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'garbage-collector-8c46b',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: box.read('started') ?? false
          ? const HomeScreen()
          : const LandingScreen(),
    );
  }
}
