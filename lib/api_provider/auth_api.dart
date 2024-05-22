import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lootfat_owner/res/url.dart';
import 'package:lootfat_owner/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthAPI {
  static Future<http.Response> signUpUser(
      String mobileNumber,
      pinCode,
      shopName,
      ownerName,
      shopNumber,
      cityName,
      countryName,
      shopAddress,
      email,
      password, fcmToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var deviceType = prefs.getString('deviceType');
    var deviceId = prefs.getString('deviceID');
    var lat = prefs.getString('lat');
    var long = prefs.getString('long');
    var names = ownerName.split(' ');
    var firstName = names[0];
    var lastName = names[1];
    return await http
        .post(Uri.parse('${AppUrl.register}'), body: {
          "type": "shop",
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "password": password,
          "phone_number": mobileNumber,
          "latitude": lat,
          "longitude": long,
          "device_token": fcmToken,
          "device_id": deviceId,
          "device_type": deviceType,
          "shop_name": shopName,
          "shop_number": shopNumber,
          "land_mark": shopAddress,
          "postal_code": pinCode,
          "city": cityName,
          "country": countryName,
        })
        .catchError((e) => http.Response(jsonEncode({"message": "Error"}), 401))
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () {
            return http.Response(
                jsonEncode({"message": "Request Timeout"}), 408);
          },
        );
  }

  static Future<http.Response> loginUser(
      String emailAddress, password, fcmToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var deviceType = prefs.getString('deviceType');
    var deviceId = prefs.getString('deviceID');
    var lat = prefs.getString('lat');
    var long = prefs.getString('long');
    return await http
        .post(Uri.parse('${AppUrl.login}'), body: {
          "device_token": fcmToken,
          "device_id": deviceId,
          "device_type": deviceType,
          "type": "shop",
          "email": emailAddress,
          "password": password,
          "latitude": lat,
          "longitude": long,
        })
        .catchError(
          (e) => http.Response("$e", 401),
        )
        .timeout(
          Duration(seconds: Utils.timeoutSecondsApi),
          onTimeout: () => Future.value(
            http.Response("Request Timeout", 408),
          ),
        );
  }

  static Future<http.Response> forgotPassword(emailAddress) async {
    return await http
        .post(
          Uri.parse('${AppUrl.forgotPassword}'),
          headers: {
            "Content-type": "application/json",
          },
          body: jsonEncode({
            "type": "shop",
            "email": emailAddress,
          }),
        )
        .catchError((e) => http.Response(jsonEncode({"message": "Error"}), 401))
        .timeout(
      const Duration(seconds: 8),
      onTimeout: () {
        return http.Response('Request Timeout', 408);
      },
    );
  }

  static Future<http.Response> otpVerification(emailAddress, otp) async {
    return await http
        .post(
          Uri.parse('${AppUrl.verifyOtp}'),
          headers: {
            "Content-type": "application/json",
          },
          body: jsonEncode({
            "type": "shop",
            "email": emailAddress,
            "otp": otp,
          }),
        )
        .catchError((e) => http.Response(jsonEncode({"message": "Error"}), 401))
        .timeout(
      const Duration(seconds: 8),
      onTimeout: () {
        return http.Response('Request Timeout', 408);
      },
    );
  }

  static Future<http.Response> resetPassword(emailAddress, password) async {
    return await http
        .post(
          Uri.parse('${AppUrl.resetPassword}'),
          headers: {
            "Content-type": "application/json",
          },
          body: jsonEncode({
            "type": "shop",
            "email": emailAddress,
            "password": password,
          }),
        )
        .catchError((e) => http.Response(jsonEncode({"message": "Error"}), 401))
        .timeout(
      const Duration(seconds: 8),
      onTimeout: () {
        return http.Response('Request Timeout', 408);
      },
    );
  }

  static Future<http.Response> changePassword(oldPassword, newPassword) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    return await http
        .put(
          Uri.parse('${AppUrl.changePassword}'),
          headers: {
            "Content-type": "application/json",
            'authorization': 'Bearer $token',
          },
          body: jsonEncode({
            "new_password": newPassword,
            "current_password": oldPassword,
          }),
        )
        .catchError((e) => http.Response(jsonEncode({"message": "Error"}), 401))
        .timeout(
      const Duration(seconds: 8),
      onTimeout: () {
        return http.Response('Request Timeout', 408);
      },
    );
  }

  static Future<http.Response> existUserOrNot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mobileNo = prefs.getString('phoneNumber');
    var token = prefs.getString('token');

    return await http
        .get(
            Uri.parse(
                '${AppUrl.userExitORNot}?phone_number=$mobileNo&type=shop'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            })
        .catchError((e) => http.Response(jsonEncode({"message": "Error"}), 401))
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () {
            return http.Response(
                jsonEncode({"message": "Request Timeout"}), 408);
          },
        );
  }

  static Future<http.Response> updateUser(
      firstName,
      lastName,
      shopName,
      phoneNumber,
      longitude,
      latitude,
      shopNumber,
      landMark,
      postalCode,
      city,
      country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    return await http
        .put(
          Uri.parse('${AppUrl.updateShop}'),
          headers: {
            "Content-type": "application/json",
            'authorization': 'Bearer $token',
          },
          body: jsonEncode({
            "first_name": firstName.toString(),
            "last_name": lastName.toString(),
            "shop_name": shopName.toString(),
            "phone_number": phoneNumber.toString(),
            "latitude": latitude.toString(),
            "longitude": longitude.toString(),
            "shop_number": shopNumber.toString(),
            "land_mark": landMark.toString(),
            "postal_code": postalCode.toString(),
            "city": city.toString(),
            "country": country.toString()
          }),
        )
        .catchError((e) => http.Response(jsonEncode({"message": "Error"}), 401))
        .timeout(
      const Duration(seconds: 8),
      onTimeout: () {
        return http.Response(jsonEncode({"message": "Request Timeout"}), 408);
      },
    );
  }

  static Future<http.Response> questionList() async {
    return await http
        .get(Uri.parse('${AppUrl.shopQuestions}'),
            headers: {'Content-Type': 'application/json'})
        .catchError((e) => http.Response(jsonEncode({"message": "Error"}), 401))
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () {
            return http.Response(
                jsonEncode({"message": "Request Timeout"}), 408);
          },
        );
  }

  static Future<http.Response> questionAnswer(List answerList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    return await http
        .patch(Uri.parse('${AppUrl.shopQuestions}'),
            headers: {
              "Content-type": "application/json",
              'authorization': 'Bearer $token',
            },
            body: jsonEncode({
              "questions": answerList,
            }))
        .catchError((e) => http.Response(jsonEncode({"message": "Error"}), 401))
        .timeout(
      const Duration(seconds: 8),
      onTimeout: () {
        return http.Response(jsonEncode({"message": "Request Timeout"}), 408);
      },
    );
  }
}
