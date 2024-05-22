import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:lootfat_owner/view/auth/questions_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api_provider/auth_api.dart';
import '../../model/common_data_model.dart';
import '../../model/register_model.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';
import '../dashboard/bottom_bar_screen.dart';
import '../widgets/app_text_field.dart';
import '../widgets/loading_overlay.dart';
import 'createnew_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final CommonDataModel userData;

  OtpVerificationScreen({
    super.key,
    required this.userData,
  });
  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String otp = '';
  String otpError = '';

  String emailAddress = '';
  String screenType = '';

  bool enableResend = false;

  Timer? countdownTimer;
  Duration myDuration = Duration(minutes: 10);
  void initState() {
    setState(() {
      emailAddress = widget.userData.emailAddress;
      screenType = widget.userData.screenType;
    });
    startTimer();

    super.initState();
  }

  void startTimer() {
    countdownTimer = Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  // Step 4
  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  // Step 5
  void resetTimer() {
    stopTimer();
    setState(() => myDuration = Duration(minutes: 10));
  }

  // Step 6
  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
        setState(() {
          enableResend = true;
        });
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  dispose() {
    countdownTimer!.cancel();
    super.dispose();
  }

  verifyOTPCode() async {
    try {
      LoadingOverlay.of(context).show();
      AuthAPI.otpVerification(emailAddress, otp).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          if (screenType == 'createAddress' || screenType == 'login') {
            RegisterModel registerModelData = RegisterModel.fromJson(res);
            LoadingOverlay.of(context).hide();
            Utils.toastMessage(registerModelData.message);
            storePreferences(
                registerModelData.data.user, registerModelData.data.tokens.access.token);
          } else {
            CommonDataModel? cdm;
            setState(() {
              cdm = CommonDataModel(
                emailAddress: emailAddress,
                screenType: 'otpVerification',
              );
            });
            LoadingOverlay.of(context).hide();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CreateNewPasswordScreen(
                  userData: cdm!,
                ),
              ),
            );
          }
        } else {
          LoadingOverlay.of(context).hide();
          Utils.errorHandling(response);
        }
      });
    } catch (e) {
      LoadingOverlay.of(context).hide();
    }
  }

  Future storePreferences(data, token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', data.firstName);
    prefs.setString('lastName', data.lastName);
    prefs.setString('email', data.email);
    prefs.setString('phoneNumber', data.phoneNumber);
    prefs.setString('shopName', data.shop.shopName);
    prefs.setString('shopNumber', data.shop.shopNumber);
    prefs.setString('landMark', data.shop.landMark);
    prefs.setString('city', data.shop.city);
    prefs.setString('country', data.shop.country);
    prefs.setString('postalCode', data.shop.postalCode);
    prefs.setString('qrCode', data.shop.qrCode);
    prefs.setString('lat', data.shop.location.coordinates[1].toString());
    prefs.setString('long', data.shop.location.coordinates[0].toString());
    prefs.setBool('isQuestionsFilled', data.isQuestionsFilled);
    prefs.setString('token', token);
    if (data.isQuestionsFilled == true) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BottomBarScreen(),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => QuestionsScreen(),
        ),
      );
    }
  }

  resendOTP() {
    setState(() {
      enableResend = false;
    });
    Navigator.pop(context);
  }

  bool validOtp() {
    bool isValid = true;
    setState(() {
      otpError = '';
    });
    if (otp.isEmpty) {
      setState(() {
        otpError = "Please Enter OTP";
      });
      isValid = false;
    } else if (otp.length < 4) {
      setState(() {
        otpError = "Please Enter a valid OTP";
      });
      isValid = false;
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');

    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: Container(
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ElevatedButton(
          onPressed: () {
            if (validOtp()) {
              verifyOTPCode();
            }
          },
          child: const Center(
            child: Text(
              'Verify',
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Verify your OTP",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Enter the code from the email we sent\nto $emailAddress",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.6,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                OtpTextField(
                  numberOfFields: 4,
                  focusedBorderColor: AppColors.main,
                  showFieldAsBox: true,
                  onCodeChanged: (String code) => setState(() => otp = code),
                  onSubmit: (String verificationCode) {
                    setState(() => otp = verificationCode);
                  },
                ),
                Padding(
                    padding: EdgeInsets.only(left: 35, top: 5, right: 10),
                    child: AppTextField.inputErrorMessage(otpError)),
                const SizedBox(height: 40),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Did not receive the code? ',
                      style: const TextStyle(color: AppColors.textLight, fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                          text: enableResend ? 'Resend' : '$minutes:$seconds',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: AppColors.main,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = enableResend
                                ? () {
                                    resendOTP();
                                  }
                                : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
