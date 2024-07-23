import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_waste_mobile/utlis/colors.dart';

import '../widgets/text_widget.dart';

class FeedbackListScreen extends StatefulWidget {
  const FeedbackListScreen({super.key});

  @override
  State<FeedbackListScreen> createState() => _FeedbackListScreenState();
}

class _FeedbackListScreenState extends State<FeedbackListScreen> {
  final List<Map<String, String>> notifications = [
    {
      'title': 'New Message',
      'subtitle': 'You have received a new message.',
      'time': '5 mins ago'
    },
    {
      'title': 'Update Available',
      'subtitle': 'A new update is available for your app.',
      'time': '10 mins ago'
    },
    {
      'title': 'Meeting Reminder',
      'subtitle': 'Don\'t forget about the meeting at 3 PM.',
      'time': '30 mins ago'
    },
    {
      'title': 'Task Completed',
      'subtitle': 'You have completed your task.',
      'time': '1 hour ago'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: background,
        title: TextWidget(
          text: 'Feedbacks',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Feedbacks')
                .orderBy('postedAt', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  )),
                );
              }

              final data = snapshot.requireData;
              return ListView.builder(
                itemCount: data.docs.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: SizedBox(
                                height: 500,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (int i = 0;
                                          i < data.docs[index]['Images'].length;
                                          i++)
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            children: [
                                              Image.network(data.docs[index]
                                                  ['Images'][i]),
                                              const Divider(),
                                            ],
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      contentPadding: const EdgeInsets.all(15),
                      leading: Icon(
                        Icons.info_outline,
                        color: primary,
                        size: 40,
                      ),
                      title: Text(
                        data.docs[index]['Feedback'],
                        style: const TextStyle(
                          fontFamily: 'Bold',
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        'By: ${data.docs[index]['Email']}',
                        style: TextStyle(
                          fontFamily: 'Regular',
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      trailing: Text(
                        DateFormat.yMMMd()
                            .add_jm()
                            .format(data.docs[index]['postedAt'].toDate()),
                        style: TextStyle(
                          fontFamily: 'Regular',
                          color: Colors.grey[600],
                          fontSize: 10,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
