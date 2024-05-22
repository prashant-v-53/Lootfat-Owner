import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  final bool success;
  final String message;
  final Data data;

  LoginModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  final User user;
  final Tokens tokens;

  Data({
    required this.user,
    required this.tokens,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: User.fromJson(json["user"]),
        tokens: Tokens.fromJson(json["tokens"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "tokens": tokens.toJson(),
      };
}

class Tokens {
  final Access access;
  final Access refresh;

  Tokens({
    required this.access,
    required this.refresh,
  });

  factory Tokens.fromJson(Map<String, dynamic> json) => Tokens(
        access: Access.fromJson(json["access"]),
        refresh: Access.fromJson(json["refresh"]),
      );

  Map<String, dynamic> toJson() => {
        "access": access.toJson(),
        "refresh": refresh.toJson(),
      };
}

class Access {
  final String token;
  final DateTime expires;

  Access({
    required this.token,
    required this.expires,
  });

  factory Access.fromJson(Map<String, dynamic> json) => Access(
        token: json["token"],
        expires: DateTime.parse(json["expires"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "expires": expires.toIso8601String(),
      };
}

class User {
  final Location location;
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final dynamic dob;

  final String userImage;
  final bool isVerified;
  final bool isActive;
  final String deviceToken;
  final String deviceId;
  final String deviceType;
  final int offerRedeemed;
  final dynamic deletedAt;
  final String roleType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Shop shop;
  final bool isQuestionsFilled;

  User({
    required this.location,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.dob,
    required this.userImage,
    required this.isVerified,
    required this.isActive,
    required this.deviceToken,
    required this.deviceId,
    required this.deviceType,
    required this.offerRedeemed,
    required this.deletedAt,
    required this.roleType,
    required this.createdAt,
    required this.updatedAt,
    required this.shop,
    required this.isQuestionsFilled,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        location: Location.fromJson(json["location"]),
        id: json["_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        dob: json["dob"],
        userImage: json["user_image"],
        isVerified: json["isVerified"],
        isActive: json["isActive"],
        deviceToken: json["device_token"],
        deviceId: json["device_id"],
        deviceType: json["device_type"],
        offerRedeemed: json["offer_redeemed"] ?? 0,
        deletedAt: json["deletedAt"],
        roleType: json["role_type"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        shop: Shop.fromJson(json["shop"]),
        isQuestionsFilled: json["isQuestionsFilled"],
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "_id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone_number": phoneNumber,
        "dob": dob,
        "user_image": userImage,
        "isVerified": isVerified,
        "isActive": isActive,
        "device_token": deviceToken,
        "device_id": deviceId,
        "device_type": deviceType,
        "offer_redeemed": offerRedeemed,
        "deletedAt": deletedAt,
        "role_type": roleType,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "shop": shop.toJson(),
        "isQuestionsFilled": isQuestionsFilled,
      };
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates: List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}

class Shop {
  final Location location;
  final String id;
  final String user;
  final String shopName;
  final String shopNumber;
  final String landMark;
  final String city;
  final String country;
  final String postalCode;
  final String qrCode;
  final bool isActive;
  final dynamic deletedAt;
  final List<dynamic> registrationQuestions;
  final DateTime createdAt;
  final DateTime updatedAt;

  Shop({
    required this.location,
    required this.id,
    required this.user,
    required this.shopName,
    required this.shopNumber,
    required this.landMark,
    required this.city,
    required this.country,
    required this.postalCode,
    required this.qrCode,
    required this.isActive,
    required this.deletedAt,
    required this.registrationQuestions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        location: Location.fromJson(json["location"]),
        id: json["_id"],
        user: json["user"],
        shopName: json["shop_name"],
        shopNumber: json["shop_number"],
        landMark: json["land_mark"],
        city: json["city"],
        country: json["country"],
        postalCode: json["postal_code"],
        qrCode: json["qr_code"],
        isActive: json["isActive"],
        deletedAt: json["deletedAt"],
        registrationQuestions: List<dynamic>.from(json["registration_questions"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "_id": id,
        "user": user,
        "shop_name": shopName,
        "shop_number": shopNumber,
        "land_mark": landMark,
        "city": city,
        "country": country,
        "postal_code": postalCode,
        "qr_code": qrCode,
        "isActive": isActive,
        "deletedAt": deletedAt,
        "registration_questions": List<dynamic>.from(registrationQuestions.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
