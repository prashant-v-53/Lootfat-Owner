import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lootfat_owner/api_provider/auth_api.dart';
import 'package:lootfat_owner/utils/colors.dart';
import '../../model/common_data_model.dart';
import '../../utils/helper.dart';
import '../../utils/images.dart';
import '../../utils/utils.dart';
import '../widgets/app_text_field.dart';
import '../widgets/loading_overlay.dart';
import 'login_screen.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  final CommonDataModel userData;

  CreateNewPasswordScreen({
    super.key,
    required this.userData,
  });

  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  String password = '';
  String confirmPassword = '';

  String passwordError = '';
  String confirmPasswordError = '';

  String emailAddress = '';
  String screenType = '';

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _obscuredPassword = true;
  bool _obscuredConfirmPassword = true;

  void initState() {
    setState(() {
      emailAddress = widget.userData.emailAddress;
      screenType = widget.userData.screenType;
    });

    super.initState();
  }

  bool validationChangePassword() {
    bool isValid = true;
    setState(() {
      passwordError = '';
      confirmPasswordError = '';
    });

    if (password.isEmpty) {
      setState(() {
        passwordError = "Please Enter New Password";
      });
      isValid = false;
    } else if (!Helper.isPassword(password)) {
      setState(() {
        passwordError = "Enter Valid New Password";
      });
      isValid = false;
    }

    if (confirmPassword.isEmpty) {
      setState(() {
        confirmPasswordError = "Please Enter Confirm Password";
      });

      isValid = false;
    } else if (password != confirmPassword) {
      setState(() {
        confirmPasswordError = "Password does not match";
      });
      isValid = false;
    }

    return isValid;
  }

  resetPasswordApi() {
    try {
      LoadingOverlay.of(context).show();
      FocusScope.of(context).requestFocus(FocusNode());
      AuthAPI.resetPassword(emailAddress, password).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          LoadingOverlay.of(context).hide();
          Utils.toastMessage(res['message']);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => LoginScreen(),
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
      appBar: AppBar(title: Text('Create New Password')),
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
                    "New Password",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Enter the email address associated with your account.",
                    // "To get the One Time Password(OTP) on this mobile number.",
                    style: TextStyle(
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 30),
                  AppTextField(
                    titleText: 'Enter New Password*',
                    onChange: (value) {
                      setState(() {
                        password = value;
                        passwordError = '';
                      });
                    },
                    obscureText: _obscuredPassword,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp("[a-zA-Z0-9@_.-]"),
                      ),
                    ],
                    controller: passwordController,
                    hintText: "New Password",
                    errorMessage: passwordError,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscuredPassword = !_obscuredPassword;
                        });
                      },
                      child: Icon(
                        _obscuredPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                        size: 20,
                        color: _obscuredPassword ? AppColors.appColor : AppColors.main,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    titleText: 'Enter Confirm Password*',
                    onChange: (value) {
                      setState(() {
                        confirmPassword = value;
                        confirmPasswordError = '';
                      });
                    },
                    obscureText: _obscuredConfirmPassword,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp("[a-zA-Z0-9@_.-]"),
                      ),
                    ],
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    errorMessage: confirmPasswordError,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscuredConfirmPassword = !_obscuredConfirmPassword;
                        });
                      },
                      child: Icon(
                        _obscuredConfirmPassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        size: 20,
                        color: _obscuredConfirmPassword ? AppColors.appColor : AppColors.main,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (validationChangePassword()) {
                        resetPasswordApi();
                      }
                    },
                    child: const Center(
                      child: Text(
                        'Create New Password',
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
