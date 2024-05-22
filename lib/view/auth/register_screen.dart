import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lootfat_owner/utils/colors.dart';
import 'package:lootfat_owner/utils/images.dart';

import '../../utils/helper.dart';
import '../widgets/app_text_field.dart';
import 'create_address_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<String> phoneCodes = ["+91", "+92", "+93", "+94", "+08"];
  String phoneCode = "+91";
  String mobileNumber = "";
  String mobileNumberError = "";
  String emailAddress = "";
  String emailAddressError = "";
  String password = "";
  String passwordError = "";
  String shopName = "";
  String shopNameError = "";
  String ownerName = "";
  String ownerNameError = "";
  bool _obscured = true;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final phoneController = TextEditingController();

  bool validRegister() {
    bool isValid = true;
    setState(() {
      shopNameError = '';
      ownerNameError = '';
      mobileNumberError = '';
    });
    if (ownerName.isEmpty) {
      setState(() {
        ownerNameError = "Please Enter Full Name";
      });
      isValid = false;
    } else if (!Helper.isFullName(ownerName)) {
      setState(() {
        ownerNameError = "Please Enter a valid Full Name";
      });
      isValid = false;
    }

    if (shopName.isEmpty) {
      setState(() {
        shopNameError = "Please Enter Shop Name";
      });
      isValid = false;
    }

    if (mobileNumber.isEmpty) {
      setState(() {
        mobileNumberError = "Please Enter Mobile Number";
      });
      isValid = false;
    } else if (!Helper.isPhoneNumber(mobileNumber)) {
      setState(() {
        mobileNumberError = "Please Enter a valid Mobile Number";
      });
      isValid = false;
    }

    if (emailAddress.isEmpty) {
      setState(() {
        emailAddressError = "Please Enter Email Address";
      });
      isValid = false;
    } else if (!Helper.isEmail(emailAddress)) {
      setState(() {
        emailAddressError = "Please Enter a valid Email Address";
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
        passwordError = "Please Enter a valid Password";
      });
      isValid = false;
    }

    return isValid;
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
                  "Shop Registration !!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Create your new account, we are glad that you joined us",
                  style: TextStyle(
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 30),
                AppTextField(
                  inputTitle: "Enter Shop Name*",
                  hintText: "Shop Name",
                  onChange: (value) {
                    setState(() {
                      shopName = value;
                      shopNameError = '';
                    });
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(60),
                  ],
                  errorMessage: shopNameError,
                ),
                const SizedBox(height: 15),
                AppTextField(
                  inputTitle: "Enter Full Name*",
                  hintText: "Full Name",
                  onChange: (value) {
                    setState(() {
                      ownerName = value;
                      ownerNameError = '';
                    });
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(30),
                  ],
                  errorMessage: ownerNameError,
                ),
                const SizedBox(height: 15),
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
                const SizedBox(height: 15),
                AppTextField.inputTitleText('Enter Mobile Number*'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: AppColors.textLight,
                        ),
                      ),
                      child: Center(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: phoneCode,
                            icon: Container(),
                            items: phoneCodes.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                            hint: const Text(""),
                            onChanged: null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppTextField(
                        onChange: (value) {
                          setState(() {
                            mobileNumber = value;
                            mobileNumberError = '';
                          });
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        controller: phoneController,
                        hintText: "Mobile Number",
                        errorMessage: mobileNumberError,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
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
                      _obscured ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                      size: 20,
                      color: _obscured ? AppColors.appColor : AppColors.main,
                    ),
                  ),
                  errorMessage: passwordError,
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    if (validRegister()) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CreateAddressScreen(
                            shopName: shopName,
                            ownerName: ownerName,
                            mobileNumber: mobileNumber,
                            password: password,
                            emailAddress: emailAddress,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Center(
                    child: Text(
                      'Next',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account?',
                      style: const TextStyle(color: AppColors.textLight, fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' Login',
                          style: const TextStyle(
                            color: AppColors.main,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
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
    );
  }
}
