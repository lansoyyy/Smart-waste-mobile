import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String> addFeedback(email, feedback, name, List images) async {
  final docUser = FirebaseFirestore.instance.collection('Feedbacks').doc();

  final json = {
    'Email': email,
    'Feedback': feedback,
    'Name': name,
    'Images': images,
    'postedAt': DateTime.now(),
  };

  await docUser.set(json);

  return docUser.id;
}
