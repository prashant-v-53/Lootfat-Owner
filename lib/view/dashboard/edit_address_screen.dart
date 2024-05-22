import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lootfat_owner/view/widgets/app_loader.dart';
import 'package:lootfat_owner/view/widgets/app_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api_provider/auth_api.dart';
import '../../model/user_model.dart';
import '../../utils/helper.dart';
import '../../utils/utils.dart';
import '../widgets/loading_overlay.dart';

class EditAddressScreen extends StatefulWidget {
  const EditAddressScreen({super.key});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  TextEditingController shopNumber = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController cityName = TextEditingController();
  TextEditingController countryName = TextEditingController();
  TextEditingController pinCode = TextEditingController();
  bool isLoading = false;
  String shopNumberError = "";
  String landMarkError = "";
  String cityNameError = "";
  String countryNameError = "";
  String pinCodeError = "";
  String latitude = "";
  String longitude = "";

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  getUserData() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      shopNumber.text = prefs.getString('shopNumber').toString();
      landmark.text = prefs.getString('landMark').toString();
      cityName.text = prefs.getString('city').toString();
      countryName.text = prefs.getString('country').toString();
      pinCode.text = prefs.getString('postalCode').toString();
      latitude = prefs.getString('lat').toString();
      longitude = prefs.getString('long').toString();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Address"),
      ),
      body: isLoading
          ? AppLoader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      errorMessage: shopNumberError,
                      hintText: 'shop no',
                      controller: shopNumber,
                      titleText: 'Enter shop no.*',
                    ),
                    SizedBox(height: 10),
                    AppTextField(
                      errorMessage: landMarkError,
                      controller: landmark,
                      hintText: 'Landmark',
                      titleText: 'Enter Landmark*',
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      errorMessage: cityNameError,
                      controller: cityName,
                      hintText: 'City / Town',
                      titleText: "Enter City / Town*",
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      errorMessage: countryNameError,
                      controller: countryName,
                      hintText: 'Country',
                      titleText: "Enter Country*",
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      errorMessage: pinCodeError,
                      controller: pinCode,
                      hintText: 'Pincode',
                      titleText: 'Enter pincode*',
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () {
                        if (validationUser()) {
                          apiUserUpdate();
                        }
                      },
                      child: const Center(
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
      cityNameError = '';
      countryNameError = '';
      landMarkError = '';
      pinCodeError = '';
      shopNumberError = '';
    });

    if (landmark.text.isEmpty) {
      setState(() {
        landMarkError = "Please Enter Shop Address";
      });
      isValid = false;
    }
    if (shopNumber.text.isEmpty) {
      setState(() {
        shopNumberError = "Please Enter Shop Number";
      });
      isValid = false;
    }

    if (cityName.text.isEmpty) {
      setState(() {
        cityNameError = "Please Enter City Name";
      });
      isValid = false;
    }
    if (countryName.text.isEmpty) {
      setState(() {
        countryNameError = "Please Enter country Name";
      });
      isValid = false;
    }

    if (pinCode.text.isEmpty) {
      setState(() {
        pinCodeError = "Please Enter Pin Code";
      });
      isValid = false;
    } else if (!Helper.isPinCode(pinCode.text)) {
      setState(() {
        pinCodeError = "please enter a valid Pin Code";
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
      var shopName = prefs.getString('shopName');
      var phoneNumber = prefs.getString('phoneNumber');
      var lastName = prefs.getString('lastName');
      var firstName = prefs.getString('firstName');

      AuthAPI.updateUser(
              firstName,
              lastName,
              shopName,
              phoneNumber,
              longitude,
              latitude,
              shopNumber.text,
              landmark.text,
              pinCode.text,
              cityName.text,
              countryName.text)
          .then((response) {
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
    prefs.setString('long', longitude);
    prefs.setString('lat', latitude);
    prefs.setString('shopNumber', shopNumber.text);
    prefs.setString('landMark', landmark.text);
    prefs.setString('postalCode', pinCode.text);
    prefs.setString('city', cityName.text);
    prefs.setString('country', countryName.text);
  }
}
