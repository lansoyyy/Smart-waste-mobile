import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_waste_mobile/services/add_feedback.dart';
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
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  bool ischecked = false;

  List images = [];
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
                        text: 'How may I help you?',
                        fontSize: 18,
                        fontFamily: 'Bold',
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextWidget(
                        text: 'how to use the app?',
                        fontSize: 14,
                        fontFamily: 'Bold',
                        color: Colors.white,
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
                label: 'Email',
              ),
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                borderColor: Colors.black,
                width: 500,
                controller: messageController,
                label: 'Message',
                maxLine: 10,
                height: 150,
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
                  IconButton(
                    onPressed: () {
                      uploadPicture('gallery');
                    },
                    icon: const Icon(
                      Icons.upload,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 100,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: TextWidget(
                          color: Colors.black,
                          text: images[index],
                          fontSize: 18,
                        ),
                      ),
                    );
                  },
                ),
              ),
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
                  TextWidget(
                    text: 'I accept the Terms and Service',
                    fontSize: 12,
                    fontFamily: 'Bold',
                    color: Colors.white,
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
                    addFeedback(emailController.text, messageController.text,
                        nameController.text, images);
                    showSubmittedDialog();
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
          padding: EdgeInsets.only(left: 30, right: 30),
          child: AlertDialog(
              title: Row(
            children: [
              CircularProgressIndicator(
                color: Colors.black,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                'Loading . . .',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'QRegular'),
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
