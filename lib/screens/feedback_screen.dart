import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_waste_mobile/screens/feedback_list.dart';
import 'package:smart_waste_mobile/screens/terms_conditions_page.dart';
import 'package:smart_waste_mobile/services/add_feedback.dart';
import 'package:smart_waste_mobile/utlis/app_constants.dart';
import 'package:smart_waste_mobile/utlis/colors.dart';
import 'package:smart_waste_mobile/widgets/button_widget.dart';
import 'package:smart_waste_mobile/widgets/drawer_widget.dart';
import 'package:smart_waste_mobile/widgets/textfield_widget.dart';
import 'package:smart_waste_mobile/widgets/toast_widget.dart';
import 'package:path/path.dart' as path;
import '../widgets/text_widget.dart';
import 'home_screen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  Future<void> triggerOnceADay(Function callback) async {
    // Get the last triggered date from GetStorage
    String? lastTriggeredDate = box.read('lastTriggeredDate');

    // Get the current date
    final today = DateTime.now();

    // Check if the function has already been triggered today
    if (lastTriggeredDate != null) {
      final lastDate = DateTime.parse(lastTriggeredDate);

      // If the last triggered date is today, do not run the function
      if (lastDate.year == today.year &&
          lastDate.month == today.month &&
          lastDate.day == today.day) {
        print('Already triggered today');
        return;
      }
    }

    // Run the callback function and update the last triggered date
    callback();

    // Save the current date as the last triggered date in GetStorage
    box.write('lastTriggeredDate', today.toIso8601String());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    triggerOnceADay(() {
      box.write('submitted', false);
    });
  }

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  final messageController = TextEditingController();

  bool ischecked = false;

  final box = GetStorage();

  List images = [];

  List names = [];

  String? selectedBarangay;
  final List<String> barangays = [
    'Aglayan',
    'Bangcud',
    'Barangay 1',
    'Barangay 2',
    'Barangay 3',
    'Barangay 4',
    'Barangay 5',
    'Barangay 6',
    'Barangay 7',
    'Barangay 8',
    'Barangay 9',
    'Barangay 10',
    'Busdi',
    'Cabangahan',
    'Caburacanan',
    'Can-ayan',
    'Capitan Bayong',
    'Casisang',
    'Dalwangan',
    'Indalasa',
    'Kalasungay',
    'Kibalabag',
    'Kulaman',
    'Laguitas',
    'Linabo',
    'Maligaya',
    'Magsaysay (Panadtalan)',
    'Managok',
    'Mapayag',
    'Mapulo',
    'Miglamin',
    'Patpat',
    'Rizal (Poblacion)',
    'San Jose',
    'Santo Niño',
    'Silae',
    'Simaya',
    'Sinanglanan',
    'Sumpong',
    'Violeta',
    'Zamboanguita',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      endDrawer: const DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  TextWidget(
                    text: 'Smart Solid\nWaste Collector',
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: 'Bold',
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
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'Give Us Feedback',
                        fontSize: 18,
                        fontFamily: 'Bold',
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextWidget(
                        text: 'Your feedback is important to us!',
                        fontSize: 14,
                        fontFamily: 'Bold',
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 200,
                        child: TextWidget(
                          align: TextAlign.start,
                          text:
                              'Please share your thoughts or report any issues you encountered. We appreciate your help in improving our service.',
                          fontSize: 12,
                          fontFamily: 'Regular',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    'assets/images/new-removebg-preview.png',
                    height: 100,
                  ),
                ],
              ),
              const Divider(
                color: Colors.white,
              ),
              const SizedBox(
                height: 20,
              ),
              TextWidget(
                text: 'Give us a Feedback',
                fontSize: 18,
                fontFamily: 'Bold',
                color: Colors.white,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                borderColor: Colors.black,
                width: 500,
                controller: nameController,
                label: 'Name',
              ),
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                borderColor: Colors.black,
                width: 500,
                controller: emailController,
                isRequred: false,
                label: 'Email (optional)',
              ),
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                borderColor: Colors.black,
                width: 500,
                controller: messageController,
                label: 'Feedback',
                maxLine: 10,
                height: 150,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Location',
                style: TextStyle(
                  fontFamily: 'Bold',
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: DropdownButton<String>(
                    value: selectedBarangay,
                    hint: const Text('Select a Barangay'),
                    items: barangays.map((String barangay) {
                      return DropdownMenuItem<String>(
                        value: barangay,
                        child: Text(barangay),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBarangay = newValue;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'Upload Images',
                    fontSize: 14,
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                onTap: () {
                                  if (images.length <= 2) {
                                    uploadPicture('camera');
                                  }
                                },
                                title: const Text('Camera'),
                                trailing: const Icon(Icons.camera),
                              ),
                              ListTile(
                                onTap: () {
                                  if (images.length <= 2) {
                                    uploadPicture('gallery');
                                  }
                                },
                                title: const Text('Gallery'),
                                trailing: const Icon(Icons.photo),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Icon(
                      Icons.upload,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                  height: 100,
                  width: 500,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (int i = 0; i < images.length; i++)
                          Card(
                            child: SizedBox(
                              height: 25,
                              child: TextWidget(
                                color: Colors.black,
                                text: names[i],
                                fontSize: 18,
                              ),
                            ),
                          )
                      ],
                    ),
                  )),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        ischecked = !ischecked;
                      });
                    },
                    icon: Icon(
                      ischecked
                          ? Icons.check_box
                          : Icons.check_box_outline_blank_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const TermsAndConditionsPage()));
                    },
                    child: TextWidget(
                      text: 'I ACCEPT THE TERMS AND CONDITIONS',
                      fontSize: 14,
                      fontFamily: 'Bold',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ButtonWidget(
                  radius: 15,
                  color: primary,
                  label: 'Submit',
                  onPressed: () {
                    if (ischecked) {
                      if (box.read('submitted') == null ||
                          box.read('submitted') == 'null' ||
                          box.read('submitted') == false) {
                        if (emailController.text != '' ||
                            messageController.text != '' ||
                            nameController.text != '') {
                          addFeedback(
                              emailController.text,
                              messageController.text,
                              nameController.text,
                              images,
                              selectedBarangay);
                          showSubmittedDialog();
                        } else {
                          showToast('Cannot proceed! All fields are required');
                        }
                      } else {
                        showToast(
                            'You can only submit one feedback per day. Please try again tomorrow!');
                      }
                    } else {
                      showToast('Please check the terms and condition first!');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showSubmittedDialog() {
    setState(() {
      box.write('submitted', true);
    });
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/new-removebg-preview.png',
                  height: 100,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextWidget(
                  text: 'SUBMITTED!',
                  fontSize: 24,
                  color: Colors.black,
                  fontFamily: 'Bold',
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                  child: ButtonWidget(
                    radius: 15,
                    color: primary,
                    label: 'Back to Dashboard',
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  late String fileName = '';

  late File imageFile;

  late String imageURL = '';
  Future<void> uploadPicture(String inputSource) async {
    final picker = ImagePicker();
    XFile pickedImage;

    pickedImage = (await picker.pickImage(
        source:
            inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1920))!;

    fileName = path.basename(pickedImage.path);
    imageFile = File(pickedImage.path);

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const Padding(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: AlertDialog(
              title: Row(
            children: [
              SizedBox(
                height: 25,
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Uploading...',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'QRegular',
                        fontSize: 16),
                  ),
                  Text(
                    'Please wait',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Regular'),
                  ),
                ],
              ),
            ],
          )),
        ),
      );

      await firebase_storage.FirebaseStorage.instance
          .ref('Pictures/$fileName')
          .putFile(imageFile);
      imageURL = await firebase_storage.FirebaseStorage.instance
          .ref('Pictures/$fileName')
          .getDownloadURL();

      setState(() {
        names.add(fileName);
        images.add(imageURL);
      });

      Navigator.of(context).pop();
      showToast('Image uploaded!');
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }
}
