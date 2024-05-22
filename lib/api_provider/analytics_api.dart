import "dart:convert";

import "package:http/http.dart" as http;
import "package:lootfat_owner/res/url.dart";
import "package:shared_preferences/shared_preferences.dart";

class AnalyticsAPI {
  static Future<http.Response> getAnalytics(
      String startDate, String endDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    return await http
        .get(
            Uri.parse(
                '${AppUrl.analytics}?startDate=$startDate&endDate=$endDate'),
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
