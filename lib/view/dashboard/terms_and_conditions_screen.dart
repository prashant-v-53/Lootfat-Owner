import 'package:flutter/material.dart';
import 'package:lootfat_owner/utils/colors.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  @override
  _TermsAndConditionsScreenState createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Terms & Conditions',
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
                "These Terms and Conditions govern your use of the LootFat food offering application. By using the App, you agree to comply with these Terms. Please read them carefully.",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              tileText(
                title: "1. Use of the App:",
                textList: [
                  "Eligibility: By using the App, you represent that you are at least 12 years old and have the legal capacity to enter into a binding agreement.",
                  "License: We grant you a limited, non-exclusive, non-transferable license to use the App for your personal, non-commercial use. You shall not modify, reproduce, distribute, or create derivative works based on the App.",
                  "User Account: To access certain features of the App, you may be required to create a user account. You are responsible for maintaining the confidentiality of your account credentials and for any activity that occurs under your account.",
                ],
              ),
              tileText(
                title: "2. Content:",
                textList: [
                  "Ownership: All content provided through the App, including text, graphics, images, and trademarks, is owned by us or our licensors and is protected by intellectual property laws.",
                  "User Content: You may have the ability to submit or upload content to the App, such as reviews or comments. By submitting such content, you grant us a worldwide, royalty-free, perpetual, irrevocable, and sub licensable right to use, reproduce, modify, adapt, publish, and display the content.",
                  "Prohibited Content: You shall not submit or upload any content that is unlawful, offensive, infringing, or violates any third-party rights. We reserve the right to remove or block any content that violates these Terms.",
                ],
              ),
              tileText(
                title: "3. Services and Transactions:",
                textList: [
                  "Food Offering: The App enables you to browse, order, and pay for food items offered by participating vendors.",
                ],
              ),
              tileText(
                title: "4. User Conduct:",
                textList: [
                  "Prohibited Activities: You shall not use the App for any unlawful or unauthorised purpose, or engage in any activity that disrupts or interferes with the App's operation or other users' experience.",
                  "Compliance: You agree to comply with all applicable laws, regulations, and third-party agreements related to your use of the App.",
                ],
              ),
              tileText(
                title: "5. Privacy:",
                textList: [
                  "Our collection, use, and disclosure of your personal information are governed by our Privacy Policy. By using the App, you consent to our privacy practices as described in the Privacy Policy.",
                ],
              ),
              tileText(
                title: "6. Limitation of Liability:",
                textList: [
                  "To the extent permitted by law, we shall not be liable for any direct, indirect, incidental, consequential, or punitive damages arising out of or in connection with your use of the App, including but not limited to any errors or omissions in the content, loss of data, or interruption of services.",
                ],
              ),
              tileText(
                title: "7. Termination:",
                textList: [
                  "We reserve the right to suspend or terminate your access to the App at any time for any reason, without prior notice.",
                ],
              ),
              tileText(
                title: "8. Changes to the Terms:",
                textList: [
                  "We may update these Terms from time to time by posting the revised version in the App. Your continued use of the App after any changes indicates your acceptance of the modified Terms.",
                ],
              ),
              tileText(
                title: "9. Contact Us:",
                descText1:
                    "If you have any questions or concerns regarding these Terms, please contact us at ",
                mailText: "lootfatoffers@gmail.com",
                descText2: ".",
              ),
              SizedBox(height: 12),
              Text(
                "By using the LootFat App, you acknowledge that you have read, understood, and agreed to these Terms.",
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
