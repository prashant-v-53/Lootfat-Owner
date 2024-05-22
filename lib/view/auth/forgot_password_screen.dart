import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lootfat_owner/api_provider/auth_api.dart';
import 'package:lootfat_owner/utils/colors.dart';
import 'package:lootfat_owner/view/auth/otp_verification.dart';

import '../../model/common_data_model.dart';
import '../../utils/helper.dart';
import '../../utils/images.dart';
import '../../utils/utils.dart';
import '../widgets/app_text_field.dart';
import '../widgets/loading_overlay.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String emailAddress = '';
  String emailAddressError = '';
  final emailAddressController = TextEditingController();

  bool validationForgotPassword() {
    bool isValid = true;
    setState(() {
      emailAddressError = '';
    });
    if (emailAddress.isEmpty) {
      setState(() {
        emailAddressError = "Please Enter Email Address";
      });
      isValid = false;
    } else if (!Helper.isEmail(emailAddress)) {
      setState(() {
        emailAddressError = "Enter Valid Email Address";
      });
      isValid = false;
    }

    return isValid;
  }

  forgotPasswordApi() {
    try {
      LoadingOverlay.of(context).show();
      FocusScope.of(context).requestFocus(FocusNode());
      AuthAPI.forgotPassword(emailAddress).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          LoadingOverlay.of(context).hide();
          Utils.toastMessage(res['message']);
          CommonDataModel? cdm;
          setState(() {
            cdm = CommonDataModel(
              emailAddress: emailAddress,
              screenType: 'forgotPassword',
            );
          });

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => OtpVerificationScreen(
                userData: cdm!,
              ),
            ),
          );
        } else {
          LoadingOverlay.of(context).hide();
          Utils.errorHandling(response);
        }
      });
    } catch (e) {
      LoadingOverlay.of(context).hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SvgPicture.asset(
                      SvgImages.logo,
                      height: 80,
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Please enter your email address to\nreceive a verification code.",
                    // "To get the One Time Password(OTP) on this mobile number.",
                    style: TextStyle(
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 30),
                  AppTextField(
                    titleText: 'Enter Email Address*',
                    onChange: (value) {
                      setState(() {
                        emailAddress = value;
                        emailAddressError = '';
                      });
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp("[a-zA-Z0-9@_.-]"),
                      ),
                    ],
                    controller: emailAddressController,
                    hintText: "Email Address",
                    errorMessage: emailAddressError,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (validationForgotPassword()) {
                        forgotPasswordApi();
                      }
                    },
                    child: const Center(
                      child: Text(
                        'Forgot Password',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
