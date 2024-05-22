import 'package:flutter/material.dart';
import 'package:lootfat_owner/utils/colors.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Privacy Policy',
          style: TextStyle(
            color: AppColors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                "At LootFat, we are committed to protecting the privacy and security of your personal information. This Privacy Policy outlines how we collect, use, disclose, and protect the information you provide to us when using our food offering application (LootFat). By using the App, you consent to the practices described in this Privacy Policy.",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              tileText(
                title: "1. Information We Collect:",
                textList: [
                  "Personal Information: When you register or use our App, we may collect personal information such as your name, phone number, and other details.",
                  "Usage Information: We may collect non-personal information about your use of the App, such as your device information, IP address, browser type, and usage patterns.",
                ],
              ),
              tileText(
                title: "2. Use of Information:",
                textList: [
                  "We may use the collected information to provide and improve our services, process your transactions, communicate with you, personalise your experience, and send you relevant updates and promotional materials.",
                  "We may also use the information to ensure the security and integrity of our App, detect and prevent fraudulent activities, and comply with legal obligations.",
                ],
              ),
              tileText(
                title: "3. Sharing of Information:",
                textList: [
                  "We may share your personal information with trusted third-party service providers who assist us in delivering our services, processing payments, and performing other necessary functions.",
                  "We may disclose your information to comply with applicable laws, regulations, legal processes, or enforceable governmental requests.",
                  "In the event of a merger, acquisition, or sale of our business assets, your information may be transferred to the relevant parties involved in the transaction.",
                ],
              ),
              tileText(
                title: "4. Data Security:",
                textList: [
                  "We implement industry-standard security measures to protect your personal information from unauthorised access, disclosure, or alteration.",
                  "Despite our efforts, no data transmission or storage system can be guaranteed to be 100% secure. Therefore, we cannot guarantee the absolute security of your information.",
                ],
              ),
              tileText(
                title: "5. Your Choices:",
                textList: [
                  "You may update or correct your personal information within the App's settings or by contacting us directly.",
                  "You can opt-out of receiving promotional emails by following the unsubscribe instructions provided in those communications.",
                ],
              ),
              tileText(
                title: "6. Children's Privacy:",
                textList: [
                  "The App is not intended for children under the age of 13. We do not knowingly collect personal information from children under 13. If we become aware of any such data, we will promptly delete it.",
                ],
              ),
              tileText(
                title: "7. Changes to this Privacy Policy:",
                textList: [
                  "We may update this Privacy Policy from time to time. Any changes will be effective upon posting the revised version of the Privacy Policy in the App. We encourage you to review this Privacy Policy periodically.",
                ],
              ),
              tileText(
                title: "8. Contact Us:",
                descText1:
                    "If you have any questions, concerns, or suggestions regarding this Privacy Policy or our privacy practices, please contact us at ",
                mailText: "lootfatoffers@gmail.com",
                descText2: ".",
              ),
              SizedBox(height: 12),
              Text(
                "By using the LootFat App, you acknowledge that you have read and understood this Privacy Policy and consent to the collection, use, and disclosure of your information as described herein.",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tileText({
    required String title,
    List<String> textList = const [],
    String? descText1,
    String? mailText,
    String? descText2,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(
          "$title",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        ...textList
            .asMap()
            .map(
              (i, element) => MapEntry(
                i,
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "➤",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(child: Text(element)),
                    ],
                  ),
                ),
              ),
            )
            .values
            .toList(),
        if (descText1 != null)
          Text.rich(
            TextSpan(
              text: descText1,
              children: [
                TextSpan(
                  text: mailText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text: descText2,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
