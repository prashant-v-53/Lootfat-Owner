import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lootfat_owner/res/url.dart';
import "dart:convert";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class MyOffersAPI {
  static Future<http.Response> myOffersList(offerType, page, limit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    return await http
        .get(
          Uri.parse('${AppUrl.offer}?offer_type=$offerType&page=$page&limit=$limit'),
          headers: {
            "Content-type": "application/json",
            'authorization': 'Bearer $token',
          },
        )
        .catchError((e) => http.Response(jsonEncode({"message": "Error"}), 401))
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () {
            return http.Response(jsonEncode({"message": "Request Timeout"}), 408);
          },
        );
  }

  static Future<http.Response> myOffersDetails(offerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    return await http
        .get(
          Uri.parse('${AppUrl.offer}/$offerId'),
          headers: {
            "Content-type": "application/json",
            'authorization': 'Bearer $token',
          },
        )
        .catchError((e) => http.Response(jsonEncode({"message": "Error"}), 401))
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () {
            return http.Response(jsonEncode({"message": "Request Timeout"}), 408);
          },
        );
  }

  static Future<http.Response> deleteOffer(offerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    return await http
        .delete(
          Uri.parse('${AppUrl.offer}/$offerId'),
          headers: {
            "Content-type": "application/json",
            'authorization': 'Bearer $token',
          },
        )
        .catchError((e) => http.Response(jsonEncode({"message": "Error"}), 401))
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () {
            return http.Response(jsonEncode({"message": "Request Timeout"}), 408);
          },
        );
  }

  static Future createOffer(
      {String? title,
      String? description,
      String? startDate,
      String? endDate,
      String? offerType,
      String? price,
      String? offerPrice,
      String? offerPercentage,
      File? fileData}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var request = new http.MultipartRequest("POST", Uri.parse(AppUrl.offer));
      request.headers.addAll({
        "Content-Type": "application/json",
        'authorization': 'Bearer $token',
      });

      request.fields['title'] = title.toString();
      request.fields['description'] = description.toString();
      request.fields['start_date'] = startDate.toString();
      // request.fields['start_time'] = startTime.toString();
      request.fields['end_date'] = endDate.toString();
      // request.fields['end_time'] = endTime.toString();
      request.fields['price'] = price.toString();
      request.fields['offer_price'] = offerPrice.toString();
      request.fields['offer_percentage'] = offerPercentage.toString();
      request.fields['offer_type'] = offerType.toString();

      if (fileData!.path != '') {
        var pic = await http.MultipartFile.fromPath(
          "offer_image",
          fileData.path,
          contentType: MediaType("image", "jpeg"),
        );
        request.files.add(pic);
      }
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      return http.Response(responseString, response.statusCode);
    } catch (e) {
      return null;
    }
  }

  static Future editOffer(
      {String? title,
      description,
      startDate,
      endDate,
      offerType,
      offerId,
      String? price,
      String? offerPrice,
      String? offerPercentage,
      File? fileData}) async {
    try {
      String url = "${AppUrl.offer}/$offerId";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var request = new http.MultipartRequest("PUT", Uri.parse(url));
      request.headers.addAll({
        "Content-Type": "application/json",
        'authorization': 'Bearer $token',
      });

      request.fields['title'] = title.toString();
      request.fields['description'] = description.toString();
      request.fields['start_date'] = startDate.toString();
      // request.fields['start_time'] = startTime.toString();
      request.fields['end_date'] = endDate.toString();
      // request.fields['end_time'] = endTime.toString();
      request.fields['price'] = price.toString();
      request.fields['offer_price'] = offerPrice.toString();
      request.fields['offer_percentage'] = offerPercentage.toString();
      request.fields['offer_type'] = offerType.toString();

      if (fileData!.path != '') {
        var pic = await http.MultipartFile.fromPath(
          "offer_image",
          fileData.path,
          contentType: MediaType("image", "jpeg"),
        );
        request.files.add(pic);
      }
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      return http.Response(responseString, response.statusCode);
    } catch (e) {
      return null;
    }
  }

  static Future<http.Response> manageStatus(offerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    return await http
        .patch(
          Uri.parse('${AppUrl.offerStatus}/$offerId'),
          headers: {
            "Content-type": "application/json",
            'authorization': 'Bearer $token',
          },
        )
        .catchError((e) => http.Response(jsonEncode({"message": "Error"}), 401))
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () {
            return http.Response(jsonEncode({"message": "Request Timeout"}), 408);
          },
        );
  }
}
