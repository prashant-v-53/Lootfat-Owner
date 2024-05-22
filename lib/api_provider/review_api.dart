import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:lootfat_owner/res/url.dart';
import "dart:convert";
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ReviewAPI {
  static Future<http.Response> reviewList(page, limit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token =
    // 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2NDkwM2U0ZjE1MjllOWEzODBiODY1MTgiLCJpYXQiOjE2ODcxNzQ3MzUsImV4cCI6MTY4OTc2NjczNSwidHlwZSI6ImFjY2VzcyIsInJvbGUiOiJhZG1pbiJ9.U8umvTdiD2QwRaPWpuHv8JDVR7dNbLMlq1gzkJFPh9o';
    var token = prefs.getString('token');
    return await http
        .get(
          Uri.parse('${AppUrl.shopReview}?page=$page&limit=$limit'),
          headers: {
            "Content-type": "application/json",
            'authorization': 'Bearer $token',
          },
        )
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
