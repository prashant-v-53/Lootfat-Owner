class MyOffersModel {
  final String id;
  final String createdBy;
  final String shop;
  final String title;
  final String offerType;
  final String description;
  final String offerImage;
  final DateTime startDate;
  final DateTime endDate;
  final int price;
  final int offerPrice;
  final dynamic offerPercentage;
  final String qrCode;
  final bool isActive;
  final int redeemedCount;
  final dynamic deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  int? current;
  int? last;
  int? totalResults;
  int? limit;

  MyOffersModel({
    required this.id,
    required this.createdBy,
    required this.shop,
    required this.title,
    required this.offerType,
    required this.description,
    required this.offerImage,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.offerPrice,
    required this.offerPercentage,
    required this.qrCode,
    required this.isActive,
    required this.redeemedCount,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    this.current,
    this.last,
    this.totalResults,
    this.limit,
  });

  factory MyOffersModel.fromJson(
    Map<String, dynamic> json,
    int currentPage,
    int lastPage,
    int totalResults,
    int limit,
  ) =>
      MyOffersModel(
        id: json["_id"],
        createdBy: json["created_by"],
        shop: json["shop"],
        title: json["title"],
        offerType: json["offer_type"],
        description: json["description"],
        offerImage: json["offer_image"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        price: json["price"],
        offerPrice: json["offer_price"],
        offerPercentage: json["offer_percentage"],
        qrCode: json["qr_code"],
        isActive: json["is_active"],
        redeemedCount: json["redeemed_count"],
        deletedAt: json["deletedAt"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        current: currentPage,
        last: lastPage,
        totalResults: totalResults,
        limit: limit,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "created_by": createdBy,
        "shop": shop,
        "title": title,
        "offer_type": offerType,
        "description": description,
        "offer_image": offerImage,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "price": price,
        "offer_price": offerPrice,
        "offer_percentage": offerPercentage,
        "qr_code": qrCode,
        "is_active": isActive,
        "redeemed_count": redeemedCount,
        "deletedAt": deletedAt,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "current": current,
        "last": last,
        "totalResults": totalResults,
        "limit": limit,
      };
}
