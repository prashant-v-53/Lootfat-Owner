import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lootfat_owner/utils/colors.dart';
import 'package:lootfat_owner/utils/images.dart';
import 'package:lootfat_owner/view/auth/otp_verification.dart';
import 'package:lootfat_owner/view/dashboard/privacy_policy_screen.dart';
import 'package:lootfat_owner/view/dashboard/terms_and_conditions_screen.dart';
import 'package:lootfat_owner/view/widgets/loading_overlay.dart';

import '../../api_provider/auth_api.dart';
import '../../model/common_data_model.dart';
import '../../utils/helper.dart';
import '../../utils/utils.dart';
import '../widgets/app_text_field.dart';

class CreateAddressScreen extends StatefulWidget {
  final String shopName;
  final String ownerName;
  final String mobileNumber;
  final String password;
  final String emailAddress;
  CreateAddressScreen({
    super.key,
    required this.shopName,
    required this.ownerName,
    required this.mobileNumber,
    required this.emailAddress,
    required this.password,
  });

  @override
  State<CreateAddressScreen> createState() => _CreateAddressScreenState();
}

class _CreateAddressScreenState extends State<CreateAddressScreen> {
  String mobileNumber = "";
  String shopName = "";
  String ownerName = "";
  String email = "";
  String password = "";

  String pinCode = "";
  String pinCodeError = "";
  String shopNumber = "";
  String shopNumberError = "";
  String cityName = "";
  String cityNameError = "";
  String countryName = "";
  String countryNameError = "";
  String shopAddress = "";
  String shopAddressError = "";

  @override
  void initState() {
    setState(() {
      shopName = widget.shopName;
      ownerName = widget.ownerName;
      mobileNumber = widget.mobileNumber;
      password = widget.password;
      email = widget.emailAddress;
    });
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const SizedBox(height: 50),
                const Text(
                  "Shop Address !!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Please add your shop address, we are smile if you did that",
                  style: TextStyle(
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 30),
                AppTextField(
                  hintText: "Shop No",
                  inputTitle: "Enter Shop No*",
                  onChange: (value) {
                    setState(() {
                      shopNumber = value;
                      shopNumberError = '';
                    });
                  },
                  errorMessage: shopNumberError,
                ),
                const SizedBox(height: 15),
                AppTextField(
                  hintText: "Landmark",
                  inputTitle: "Enter Shop Address*",
                  onChange: (value) {
                    setState(() {
                      shopAddress = value;
                      shopAddressError = '';
                    });
                  },
                  errorMessage: shopAddressError,
                ),
                const SizedBox(height: 15),
                AppTextField.inputTitleText('Enter City / Country Name*'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        hintText: "City",
                        onChange: (value) {
                          setState(() {
                            cityName = value;
                            cityNameError = '';
                          });
                        },
                        errorMessage: cityNameError,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: AppTextField(
                        hintText: "Country",
                        onChange: (value) {
                          setState(() {
                            countryName = value;
                            countryNameError = '';
                          });
                        },
                        errorMessage: countryNameError,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                AppTextField(
                  hintText: "Pin Code",
                  inputTitle: "Enter Pin Code*",
                  onChange: (value) {
                    setState(() {
                      pinCode = value;
                      pinCodeError = '';
                    });
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                  ],
                  errorMessage: pinCodeError,
                ),
                const SizedBox(height: 100),
                ElevatedButton(
                  onPressed: () {
                    if (validRegister()) {
                      FirebaseMessaging _firebaseMessaging =
                          FirebaseMessaging.instance;
                      _firebaseMessaging.getToken().then((token) {
                        apiRegister(fcmToken: token);
                      });
                    }
                  },
                  child: const Center(
                    child: Text(
                      'Register',
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Center(
                  child: Text(
                    "By signing up I accept the",
                    style: TextStyle(
                      color: AppColors.textLight,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TermsAndConditionsScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Terms & Conditions",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          color: AppColors.main,
                        ),
                      ),
                    ),
                    Text(" & "),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PrivacyPolicyScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Privacy Policy",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          color: AppColors.main,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validRegister() {
    bool isValid = true;
    setState(() {
      cityNameError = '';
      countryNameError = '';
      pinCodeError = '';
      shopNumberError = '';
      shopAddressError = '';
    });
    if (cityName.isEmpty) {
      setState(() {
        cityNameError = "Please Enter City Name";
      });
      isValid = false;
    }
    if (countryName.isEmpty) {
      setState(() {
        countryNameError = "Please Enter Country Name";
      });
      isValid = false;
    }
    if (shopNumber.isEmpty) {
      setState(() {
        shopNumberError = "Please Enter Shop Number";
      });
      isValid = false;
    }
    if (shopAddress.isEmpty) {
      setState(() {
        shopAddressError = "Please Enter Shop Address";
      });
      isValid = false;
    }

    if (pinCode.isEmpty) {
      setState(() {
        pinCodeError = "Please Enter Pin Code";
      });
      isValid = false;
    } else if (!Helper.isPinCode(pinCode)) {
      setState(() {
        pinCodeError = "Please Enter a valid Pin Code";
      });
      isValid = false;
    }

    return isValid;
  }

  apiRegister({fcmToken}) {
    LoadingOverlay.of(context).show();
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      AuthAPI.signUpUser(mobileNumber, pinCode, shopName, ownerName, shopNumber,
              cityName, countryName, shopAddress, email, password, fcmToken)
          .then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          Utils.toastMessage(res['message']);
          LoadingOverlay.of(context).hide();
          CommonDataModel? cdm;
          setState(() {
            cdm = CommonDataModel(
              emailAddress: email,
              screenType: 'createAddress',
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
}
