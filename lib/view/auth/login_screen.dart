import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lootfat_owner/utils/colors.dart';
import 'package:lootfat_owner/utils/helper.dart';
import 'package:lootfat_owner/utils/images.dart';
import 'package:lootfat_owner/view/auth/forgot_password_screen.dart';
import 'package:lootfat_owner/view/auth/otp_verification.dart';
import 'package:lootfat_owner/view/auth/questions_screen.dart';
import 'package:lootfat_owner/view/auth/register_screen.dart';
import 'package:lootfat_owner/view/widgets/app_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api_provider/auth_api.dart';
import '../../model/common_data_model.dart';
import '../../model/login_model.dart';
import '../../utils/utils.dart';
import '../dashboard/bottom_bar_screen.dart';
import '../widgets/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<String> phoneCodes = ["+91", "+92", "+93", "+94", "+08"];
  String phoneCode = "+91";
  final phoneController = TextEditingController();
  String emailAddress = '';
  String emailAddressError = '';
  String password = '';
  String passwordError = '';
  bool _obscured = true;

  bool validLogin() {
    bool isValid = true;
    setState(() {
      emailAddressError = '';
      passwordError = '';
    });
    if (emailAddress.isEmpty) {
      setState(() {
        emailAddressError = "Please Enter Email Address";
      });
      isValid = false;
    } else if (!Helper.isEmail(emailAddress)) {
      setState(() {
        emailAddressError = "Please Enter a Valid Email Address";
      });
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = "Please Enter Password";
      });
      isValid = false;
    } else if (!Helper.isPassword(password)) {
      setState(() {
        passwordError = "Please Enter a Valid Password";
      });
      isValid = false;
    }
    return isValid;
  }

  loginApi({fcmToken}) {
    try {
      LoadingOverlay.of(context).show();
      FocusScope.of(context).requestFocus(FocusNode());
      AuthAPI.loginUser(emailAddress, password, fcmToken).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          if (res['data']['user']['isVerified']) {
            LoginModel registerModelData = LoginModel.fromJson(res);
            LoadingOverlay.of(context).hide();
            Utils.toastMessage(registerModelData.message);
            storePreferences(registerModelData.data.user,
                registerModelData.data.tokens.access.token);
          } else {
            LoadingOverlay.of(context).hide();
            CommonDataModel? cdm;
            setState(() {
              cdm = CommonDataModel(
                emailAddress: emailAddress,
                screenType: 'login',
              );
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OtpVerificationScreen(
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Future.value(false),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: SvgPicture.asset(
                      SvgImages.logo,
                      height: 80,
                    ),
                  ),
                  const SizedBox(height: 120),
                  const Text(
                    "Hey Welcome !!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "To get the One Time Password(OTP) on this mobile number.",
                    style: TextStyle(
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 30),
                  AppTextField(
                    inputTitle: "Enter Email Address*",
                    hintText: "Email Address",
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
                    errorMessage: emailAddressError,
                  ),
                  AppTextField(
                    inputTitle: "Enter Password",
                    hintText: "Password",
                    onChange: (value) {
                      setState(() {
                        password = value;
                        passwordError = '';
                      });
                    },
                    obscureText: _obscured,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscured = !_obscured;
                        });
                      },
                      child: Icon(
                        _obscured
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        size: 20,
                        color: _obscured ? AppColors.appColor : AppColors.main,
                      ),
                    ),
                    errorMessage: passwordError,
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(color: AppColors.orange),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: () {
                      if (validLogin()) {
                        FirebaseMessaging _firebaseMessaging =
                            FirebaseMessaging.instance;
                        _firebaseMessaging.getToken().then((token) {
                          loginApi(fcmToken: token);
                        });
                      }
                    },
                    child: const Center(
                      child: Text(
                        'Login',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account?',
                        style: const TextStyle(
                            color: AppColors.textLight, fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' Register',
                            style: TextStyle(
                              color: AppColors.main,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterScreen(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
