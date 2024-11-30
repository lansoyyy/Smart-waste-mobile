import 'package:flutter/material.dart';
import 'package:smart_waste_mobile/utlis/colors.dart';

import '../widgets/text_widget.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: background,
          title: TextWidget(
              text: 'Terms and Conditions', fontSize: 24, color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextWidget(
                    align: TextAlign.start,
                    text: '''
Welcome to the Smart Solid Waste Collection.\nBefore using our services, please read and accept the following Terms and Conditions:\n
1. Data Collection\n
By using this service, you agree to provide the following personal information:
Name
Email Address
Feedback
Location
Images
This information will be collected solely for the purposes of improving environmental services provided by CENRO.\n
2. Purpose of Data Collection\n
We collect your personal data for the following purposes:
To enhance the environmental services of CENRO.
To perform research and analysis aimed at improving environmental policies.
To respond to your inquiries and send you updates related to CENRO services.
To support location-based operations and environmental monitoring by CENRO.\n
3. Confidentiality and Data Protection\n
All personal data will remain strictly confidential and accessible only to authorized CENRO personnel. The following measures will ensure the security of your data:
Encryption: Your data will be encrypted both in transit and at rest.
Restricted Access: Only authorized CENRO personnel will have access to your data.
Confidential Storage: Your data will be stored in a secure, confidential database accessible only by CENRO.\n
4. Data Sharing\n
Your personal data will never be shared, sold, or distributed to third parties without your consent, except when required by law. Only CENRO will have access to your data for official purposes.\n
5. Retention Period\n
We will retain your personal data only for as long as necessary to fulfill the purposes outlined above, or as required by law. Once no longer needed, your data will be permanently deleted from our systems.\n
6. User Rights\n
You have the following rights concerning your personal data:
Access: You can request access to your personal information.
Correction: You can request corrections to any inaccurate data.
Deletion: You may request the deletion of your data at any time.\n
7. Consent\n
By using this app and providing your personal data, you consent to the collection, storage, and use of your information as outlined in these Terms and Conditions. If you do not agree, you may opt out by not providing your personal data or discontinuing the use of the service.\n
8. Contact Us\n
If you have any questions or concerns about these Terms and Conditions or the use of your personal data, please reach out to us at:\n
Email: infoserve.cityenroffice19@gmail.com
Mobile No.: 0997-790-0290 /0969-208-8277
''',
                    fontSize: 14)
              ],
            ),
          ),
        ));
  }
}
