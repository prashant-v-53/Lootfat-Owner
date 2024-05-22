import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../api_provider/auth_api.dart';
import '../../utils/colors.dart';
import '../../utils/helper.dart';
import '../../utils/images.dart';
import '../../utils/utils.dart';
import '../widgets/app_text_field.dart';
import '../widgets/loading_overlay.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String oldPassword = '';
  String password = '';
  String confirmPassword = '';
  String passwordError = '';
  String oldPasswordError = '';
  String confirmPasswordError = '';
  final passwordController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _obscuredPassword = true;
  bool _obscuredConfirmPassword = true;
  bool _obscuredOldPassword = true;

  bool validationChangePassword() {
    bool isValid = true;
    setState(() {
      passwordError = '';
      confirmPasswordError = '';
      oldPasswordError = '';
    });
    if (oldPassword.isEmpty) {
      setState(() {
        oldPasswordError = "Please Enter old Password";
      });
      isValid = false;
    } else if (!Helper.isPassword(oldPassword)) {
      setState(() {
        oldPasswordError = "Enter Valid old Password";
      });
      isValid = false;
    }

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

  changePasswordApi() {
    try {
      LoadingOverlay.of(context).show();
      FocusScope.of(context).requestFocus(FocusNode());
      AuthAPI.changePassword(oldPassword, password).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          LoadingOverlay.of(context).hide();
          Utils.toastMessage(res['message']);
          Navigator.pop(context);
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
      appBar: AppBar(title: Text('Change Password')),
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
                    "Change Password?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Your new password must be different\nfrom previous used password.",
                    // "To get the One Time Password(OTP) on this mobile number.",
                    style: TextStyle(
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 30),
                  AppTextField(
                    titleText: 'Enter Old Password*',
                    onChange: (value) {
                      setState(() {
                        oldPassword = value;
                        oldPasswordError = '';
                      });
                    },
                    obscureText: _obscuredOldPassword,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp("[a-zA-Z0-9@_.-]"),
                      ),
                    ],
                    controller: oldPasswordController,
                    hintText: "Old Password",
                    errorMessage: oldPasswordError,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscuredOldPassword = !_obscuredOldPassword;
                        });
                      },
                      child: Icon(
                        _obscuredOldPassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        size: 20,
                        color: _obscuredOldPassword ? AppColors.appColor : AppColors.main,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp("[a-zA-Z0-9@_.-]"),
                      ),
                    ],
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    errorMessage: confirmPasswordError,
                    obscureText: _obscuredConfirmPassword,
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
                        changePasswordApi();
                      }
                    },
                    child: const Center(
                      child: Text(
                        'Change Password',
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
