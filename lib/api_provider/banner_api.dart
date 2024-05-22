import 'dart:io';
import "dart:convert";

import 'package:http/http.dart' as http;
import 'package:lootfat_owner/res/url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BannerApi {
  static Future<http.Response> createBanner(
    String title,
    description,
    File image,
    startDate,
    endDate,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppUrl.createBanner}'),
    );
    request.headers.addAll({'Authorization': 'Bearer $token'});
    request.files.add(
      await http.MultipartFile.fromPath(
        'banner_image',
        image.path,
      ),
    );
    request.fields.addAll({
      "title": title,
      "description": description,
      "from_date": startDate,
      "to_date": endDate,
    });
    var response = await request.send();
    var res = await http.Response.fromStream(response);
    return res;
  }

  static Future<http.Response> getBanners() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    return await http
        .get(Uri.parse('${AppUrl.getBanners}'), headers: {
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

  static Future<http.Response> deleteBanner(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    return await http
        .delete(Uri.parse('${AppUrl.deleteBanner}/$id'), headers: {
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

  static Future<http.Response> updateBanner(
    String id,
    String title,
    description,
    File? image,
    startDate,
    endDate,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('${AppUrl.updateBanner}/$id'),
    );
    request.headers.addAll({'Authorization': 'Bearer $token'});
    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'banner_image',
          image.path,
        ),
      );
    }
    request.fields.addAll({
      "title": title,
      "description": description,
      "from_date": startDate,
      "to_date": endDate,
    });
    var response = await request.send();
    var res = await http.Response.fromStream(response);
    return res;
  }

  static Future<http.Response> updateStatus(bannerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    return await http
        .patch(
            Uri.parse(
              '${AppUrl.updateBannerStatus}/$bannerId',
            ),
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
}
