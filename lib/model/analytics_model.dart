// To parse this JSON data, do
//
//     final analyticsModel = analyticsModelFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:lootfat_owner/model/offers_model.dart';

AnalyticsModel analyticsModelFromJson(String str) =>
    AnalyticsModel.fromJson(json.decode(str));

String analyticsModelToJson(AnalyticsModel data) => json.encode(data.toJson());

class AnalyticsModel {
  bool? success;
  String? message;
  Data data;
  GetTotalSalesAndRedeem getTotalSalesAndRedeem;
  List<MyOffersModel> getMostRedeemedOffers;

  AnalyticsModel({
    this.success,
    this.message,
    required this.data,
    required this.getTotalSalesAndRedeem,
    required this.getMostRedeemedOffers,
  });

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) => AnalyticsModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? Data(
                result: [], totalSalesThisMonth: 00, totalRedeemThisMonth: 00)
            : Data.fromJson(json["data"]),
        getTotalSalesAndRedeem: json["getTotalSalesAndRedeem"] == null
            ? GetTotalSalesAndRedeem(totalRedeem: 00, totalSales: 00)
            : GetTotalSalesAndRedeem.fromJson(json["getTotalSalesAndRedeem"]),
        getMostRedeemedOffers: json["getMostRedeemedOffers"] == null
            ? []
            : List<MyOffersModel>.from(json["getMostRedeemedOffers"]
                .map((x) => MyOffersModel.fromJson(x, 1, 1, 1, 1))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
        "getTotalSalesAndRedeem": getTotalSalesAndRedeem.toJson(),
        "getMostRedeemedOffers":
            List<dynamic>.from(getMostRedeemedOffers.map((x) => x.toJson())),
      };
}

class Data {
  List<Result> result;
  int totalSalesThisMonth;
  int totalRedeemThisMonth;

  Data({
    required this.result,
    required this.totalSalesThisMonth,
    required this.totalRedeemThisMonth,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"] == null
            ? []
            : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
        totalSalesThisMonth: json["total_sales_this_month"] ?? 00,
        totalRedeemThisMonth: json["total_redeem_this_month"] ?? 00,
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "total_sales_this_month": totalSalesThisMonth,
        "total_redeem_this_month": totalRedeemThisMonth,
      };
}

class Result {
  String? date;
  int totalRedeem;
  int totalSales;

  Result({
    required this.date,
    required this.totalRedeem,
    required this.totalSales,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        date: json["date"] == null
            ? null
            : DateFormat("dd/MM").format(DateTime.parse(json["date"])),
        totalRedeem: json["total_redeem"] ?? 00,
        totalSales: json["total_sales"] ?? 00,
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "total_redeem": totalRedeem,
        "total_sales": totalSales,
      };
}

class GetMostRedeemedOffer {
  String? id;
  String? createdBy;
  String? shop;
  String? title;
  String? offerType;
  String? description;
  String? offerImage;
  DateTime? startDate;
  String? startTime;
  DateTime? endDate;
  String? endTime;
  int? price;
  int? offerPrice;
  dynamic offerPercentage;
  String? qrCode;
  bool? isActive;
  int? redeemedCount;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  GetMostRedeemedOffer({
    this.id,
    this.createdBy,
    this.shop,
    this.title,
    this.offerType,
    this.description,
    this.offerImage,
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    this.price,
    this.offerPrice,
    this.offerPercentage,
    this.qrCode,
    this.isActive,
    this.redeemedCount,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory GetMostRedeemedOffer.fromJson(Map<String, dynamic> json) =>
      GetMostRedeemedOffer(
        id: json["_id"],
        createdBy: json["created_by"],
        shop: json["shop"],
        title: json["title"],
        offerType: json["offer_type"],
        description: json["description"],
        offerImage: json["offer_image"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        price: json["price"],
        offerPrice: json["offer_price"],
        offerPercentage: json["offer_percentage"],
        qrCode: json["qr_code"],
        isActive: json["is_active"],
        redeemedCount: json["redeemed_count"],
        deletedAt: json["deletedAt"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "created_by": createdBy,
        "shop": shop,
        "title": title,
        "offer_type": offerType,
        "description": description,
        "offer_image": offerImage,
        "start_date": startDate?.toIso8601String(),
        "start_time": startTime,
        "end_date": endDate?.toIso8601String(),
        "end_time": endTime,
        "price": price,
        "offer_price": offerPrice,
        "offer_percentage": offerPercentage,
        "qr_code": qrCode,
        "is_active": isActive,
        "redeemed_count": redeemedCount,
        "deletedAt": deletedAt,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class GetTotalSalesAndRedeem {
  int totalRedeem;
  int totalSales;

  GetTotalSalesAndRedeem({
    required this.totalRedeem,
    required this.totalSales,
  });

  factory GetTotalSalesAndRedeem.fromJson(Map<String, dynamic> json) =>
      GetTotalSalesAndRedeem(
        totalRedeem: json["totalRedeem"] ?? 00,
        totalSales: json["totalSales"] ?? 00,
      );

  Map<String, dynamic> toJson() => {
        "totalRedeem": totalRedeem,
        "totalSales": totalSales,
      };
}
