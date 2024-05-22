import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lootfat_owner/utils/colors.dart';
import 'package:lootfat_owner/view/auth/change_password_screen.dart';
import 'package:lootfat_owner/view/auth/login_screen.dart';
import 'package:lootfat_owner/view/dashboard/edit_address_screen.dart';
import 'package:lootfat_owner/view/dashboard/location_denied.dart';
import 'package:lootfat_owner/view/dashboard/my_qr_code.dart';
import 'package:lootfat_owner/view/dashboard/privacy_policy_screen.dart';
import 'package:lootfat_owner/view/dashboard/reviews_list_screen.dart';
import 'package:lootfat_owner/view/dashboard/terms_and_conditions_screen.dart';
import 'package:lootfat_owner/view/widgets/app_loader.dart';
import 'package:lootfat_owner/view/widgets/are_you_sure_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String shopName = '';
  String shopNumber = '';
  String landMark = '';
  String city = '';
  String country = '';
  String postalCode = '';
  String email = '';
  bool isLoading = false;

  void initState() {
    getPosition();
    profileDataGet();
    super.initState();
  }

  Future<void> getPosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => LocationDenied(),
        ),
      );
    }
    if (permission != LocationPermission.deniedForever) {
      var locationData = await Geolocator.getCurrentPosition();
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('lat', locationData.latitude.toString());
      pref.setString('long', locationData.longitude.toString());
    }
  }

  profileDataGet() async {
    setState(() => isLoading = true);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName').toString();
      lastName = prefs.getString('lastName').toString();
      phoneNumber = prefs.getString('phoneNumber').toString();
      shopName = prefs.getString('shopName').toString();
      shopNumber = prefs.getString('shopNumber').toString();
      landMark = prefs.getString('landMark').toString();
      city = prefs.getString('city').toString();
      country = prefs.getString('country').toString();
      email = prefs.getString('email').toString();
      postalCode = prefs.getString('postalCode').toString();
      isLoading = false;
    });
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
        title: Text("Profile"),
        automaticallyImplyLeading: false,
        actions: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
            ),
            child: InkWell(
              onTap: () async {
                var data = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfileScreen(),
                  ),
                );
                if (data == true) {
                  profileDataGet();
                }
              },
              highlightColor: AppColors.white.withOpacity(0.4),
              splashColor: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? AppLoader()
          : RefreshIndicator(
              color: AppColors.main,
              onRefresh: () async {
                profileDataGet();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xffF4F6FA),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10),
                            Container(
                                width: 80,
                                height: 80,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: AppColors.main,
                                ),
                                child: Text(
                                  '${firstName[0].toUpperCase()}${lastName[0].toUpperCase()}',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.white,
                                  ),
                                )),
                            SizedBox(height: 15),
                            Text(
                              '$firstName $lastName',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.main),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '$email',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.main.withOpacity(0.4)),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '$shopName | +91 $phoneNumber',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.main.withOpacity(0.4)),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Profile setting',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.main.withOpacity(0.4),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffF4F6FA),
                          ),
                          child: Column(children: [
                            userInfoView(
                                onTap: () async {
                                  var data = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditAddressScreen(),
                                    ),
                                  );
                                  if (data == true) {
                                    profileDataGet();
                                  }
                                },
                                title: 'Edit Address'),
                            userInfoView(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ReviewListScreen(),
                                    ),
                                  );
                                },
                                title: 'My Reviews'),
                            userInfoView(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => GetMyQrCode(),
                                    ),
                                  );
                                },
                                title: 'Get My QR Code'),
                            userInfoView(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChangePasswordScreen(),
                                    ),
                                  );
                                },
                                title: 'Change Password'),
                            userInfoView(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PrivacyPolicyScreen(),
                                    ),
                                  );
                                },
                                title: 'Privacy Policy'),
                            userInfoView(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          TermsAndConditionsScreen(),
                                    ),
                                  );
                                },
                                title: 'Terms & Conditions'),
                            userInfoView(
                                onTap: () {
                                  gmailView();
                                },
                                title: 'Help & Support'),
                            userInfoView(
                                onTap: () {
                                  onMenuClicked(
                                    context: context,
                                    isLogout: true,
                                    title: 'Logout?',
                                    description: 'Are you sure want to logout?',
                                    onTap: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.clear();
                                      storeDeviceInfo();
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (_) => LoginScreen(),
                                        ),
                                        (e) => false,
                                      );
                                    },
                                  );
                                },
                                title: 'Logout'),
                          ])),
                      const SizedBox(height: 30),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  storeDeviceInfo() async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((token) {
      storeInfo(token);
    });
  }

  storeInfo(token) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    var locationData = await Geolocator.getCurrentPosition();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      prefs.setString('deviceID', iosDeviceInfo.identifierForVendor.toString());
      prefs.setString('deviceToken', token);
      prefs.setString('deviceType', 'ios');
      prefs.setString('lat', locationData.latitude.toString());
      prefs.setString('long', locationData.longitude.toString());
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      prefs.setString('deviceID', androidDeviceInfo.id.toString());
      prefs.setString('deviceToken', token);
      prefs.setString('deviceType', 'android');
      prefs.setString('lat', locationData.latitude.toString());
      prefs.setString('long', locationData.longitude.toString());
    }
  }

  gmailView() {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'lootfatoffers@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Assistance Needed with LootFat Offers Application',
      }),
    );
    launchUrl(emailLaunchUri);
  }

  userInfoView({required String title, required Function() onTap}) {
    return Material(
      child: InkWell(
        onTap: onTap,
        highlightColor: AppColors.white.withOpacity(0.4),
        splashColor: AppColors.appColor.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.main),
                ),
              ),
              SizedBox(height: 5),
              Container(
                  padding: EdgeInsets.all(6),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.main,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 14,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
