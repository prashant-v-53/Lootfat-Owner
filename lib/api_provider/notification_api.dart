import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:lootfat_owner/res/url.dart';
import "dart:convert";
import 'package:shared_preferences/shared_preferences.dart';

class NotificationAPI {
  static Future<http.Response> notification(page, limit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    return await http
        .get(
          Uri.parse('${AppUrl.notification}'),
          headers: {
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
