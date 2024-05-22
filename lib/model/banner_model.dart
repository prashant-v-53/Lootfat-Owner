import 'dart:convert';

BannerModel bannerModelFromJson(String str) =>
    BannerModel.fromJson(json.decode(str));

String bannerModelToJson(BannerModel data) => json.encode(data.toJson());

class BannerModel {
  bool success;
  String message;
  Data data;

  BannerModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
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
  List<BannerViewModel> results;
  int page;
  int limit;
  int totalPages;
  int totalResults;

  Data({
    required this.results,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalResults,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        results:
            List<BannerViewModel>.from(json["results"].map((x) => BannerViewModel.fromJson(x))),
        page: json["page"],
        limit: json["limit"],
        totalPages: json["totalPages"],
        totalResults: json["totalResults"],
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "page": page,
        "limit": limit,
        "totalPages": totalPages,
        "totalResults": totalResults,
      };
}

class BannerViewModel {
  String id;
  String createdBy;
  String title;
  String description;
  bool verifiedByAdmin;
  String bannerImage;
  DateTime fromDate;
  DateTime toDate;
  dynamic index;
  bool isActive;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  BannerViewModel({
    required this.id,
    required this.createdBy,
    required this.title,
    required this.description,
    required this.verifiedByAdmin,
    required this.bannerImage,
    required this.fromDate,
    required this.toDate,
    required this.index,
    required this.isActive,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BannerViewModel.fromJson(Map<String, dynamic> json) => BannerViewModel(
        id: json["_id"],
        createdBy: json["created_by"],
        title: json["title"],
        description: json["description"],
        verifiedByAdmin: json["verified_by_admin"],
        bannerImage: json["banner_image"],
        fromDate: DateTime.parse(json["from_date"]),
        toDate: DateTime.parse(json["to_date"]),
        index: json["index"],
        isActive: json["is_active"],
        deletedAt: json["deletedAt"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "created_by": createdBy,
        "title": title,
        "description": description,
        "verified_by_admin": verifiedByAdmin,
        "banner_image": bannerImage,
        "from_date": fromDate.toIso8601String(),
        "to_date": toDate.toIso8601String(),
        "index": index,
        "is_active": isActive,
        "deletedAt": deletedAt,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
