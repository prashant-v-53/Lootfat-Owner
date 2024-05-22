import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lootfat_owner/model/user_model.dart';
import 'package:lootfat_owner/utils/colors.dart';
import 'package:lootfat_owner/view/widgets/app_loader.dart';
import 'package:lootfat_owner/view/widgets/app_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_provider/auth_api.dart';
import '../../utils/helper.dart';
import '../../utils/utils.dart';
import '../widgets/loading_overlay.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  List<String> phoneCodes = ["+91", "+92", "+93", "+94", "+08"];
  String phoneCode = "+91";
  bool isLoading = false;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController shopName = TextEditingController();
  TextEditingController email = TextEditingController();
  String shortName = '';
  String firstNameError = '';
  String lastNameError = '';
  String phoneNumberError = '';
  String shopNameError = '';

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstName.text = prefs.getString('firstName').toString();
    lastName.text = prefs.getString('lastName').toString();
    phoneNumber.text = prefs.getString('phoneNumber').toString();
    shopName.text = prefs.getString('shopName').toString();
    email.text = prefs.getString('email').toString();
    shortName =
        "${firstName.text[0].toUpperCase()}${lastName.text[0].toUpperCase()}";
    setState(() => isLoading = false);
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
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: isLoading
          ? AppLoader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColors.main,
                        ),
                        child: Text(
                          '$shortName',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    AppTextField(
                      hintText: "Shop name",
                      controller: shopName,
                      errorMessage: shopNameError,
                      titleText: "Shop name*",
                      isTitleText: true,
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      hintText: "First name",
                      errorMessage: firstNameError,
                      controller: firstName,
                      titleText: "First name*",
                      isTitleText: true,
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      hintText: "Last name",
                      errorMessage: lastNameError,
                      controller: lastName,
                      titleText: "Last name*",
                      isTitleText: true,
                    ),
                    AppTextField(
                      hintText: "Email Address",
                      errorMessage: lastNameError,
                      controller: email,
                      titleText: "Email Address*",
                      isTitleText: true,
                      readonly: true,
                      enable: false,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Enter mobile number*',
                      style: TextStyle(
                        color: AppColors.main,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 48,
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
                                items: phoneCodes.map<DropdownMenuItem<String>>(
                                  (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    );
                                  },
                                ).toList(),
                                onChanged: null,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppTextField(
                            hintText: "Mobile Number",
                            errorMessage: phoneNumberError,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            titleText: '',
                            controller: phoneNumber,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        if (validationUser()) {
                          apiUserUpdate();
                        }
                      },
                      child: Center(
                        child: Text(
                          'Submit',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
    );
  }

  bool validationUser() {
    bool isValid = true;
    setState(() {
      shopNameError = '';
      firstNameError = '';
      lastNameError = '';
      phoneNumberError = '';
    });
    if (firstName.text.isEmpty) {
      setState(() {
        firstNameError = "Please Enter First Name";
      });
      isValid = false;
    }
    if (lastName.text.isEmpty) {
      setState(() {
        lastNameError = "Please Enter Last Name";
      });
      isValid = false;
    }
    if (shopName.text.isEmpty) {
      setState(() {
        shopNameError = "Please Enter Shop Name";
      });
      isValid = false;
    }

    if (phoneNumber.text.isEmpty) {
      setState(() {
        phoneNumberError = "Please Enter Mobile Number";
      });
      isValid = false;
    } else if (!Helper.isPhoneNumber(phoneNumber.text)) {
      setState(() {
        phoneNumberError = "Please Enter a valid Mobile Number";
      });
      isValid = false;
    }
    return isValid;
  }

  apiUserUpdate() async {
    LoadingOverlay.of(context).show();
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var longitude = prefs.getString('long');
      var latitude = prefs.getString('lat');
      var shopNumber = prefs.getString('shopNumber');
      var landMark = prefs.getString('landMark');
      var postalCode = prefs.getString('postalCode');
      var city = prefs.getString('city');
      var country = prefs.getString('country');
      AuthAPI.updateUser(
        firstName.text,
        lastName.text,
        shopName.text,
        phoneNumber.text,
        longitude,
        latitude,
        shopNumber,
        landMark,
        postalCode,
        city,
        country,
      ).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          UserDataModal registerModelData = UserDataModal.fromJson(res);
          storePreferences();
          Utils.toastMessage(registerModelData.message);
          LoadingOverlay.of(context).hide();
          Navigator.pop(context, true);
        } else {
          LoadingOverlay.of(context).hide();
          Utils.errorHandling(response);
        }
      });
    } catch (e) {
      LoadingOverlay.of(context).hide();
    }
  }

  Future storePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', firstName.text);
    prefs.setString('lastName', lastName.text);
    prefs.setString('phoneNumber', phoneNumber.text);
    prefs.setString('shopName', shopName.text);
  }
}
