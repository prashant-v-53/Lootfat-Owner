import 'package:lootfat_owner/data/network/base_api_services.dart';
import 'package:lootfat_owner/data/network/network_api_services.dart';
import 'package:lootfat_owner/res/url.dart';

class AuthRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> loginApi(dynamic data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(AppUrl.login, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> signUpApi(dynamic data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(AppUrl.register, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
