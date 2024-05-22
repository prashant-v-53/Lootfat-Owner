class ReviewModel {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final DateTime createdAt;
  final Reviews reviews;
  final String userImage;
  int? current;
  int? last;
  int? totalResults;
  int? limit;

  ReviewModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.createdAt,
    required this.reviews,
    required this.userImage,
    this.current,
    this.last,
    this.totalResults,
    this.limit,
  });

  factory ReviewModel.fromJson(
    Map<String, dynamic> json,
    int currentPage,
    int lastPage,
    int totalResults,
    int limit,
  ) =>
      ReviewModel(
        id: json["_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phoneNumber: json["phone_number"],
        createdAt: DateTime.parse(json["createdAt"]),
        reviews: Reviews.fromJson(json["reviews"]),
        userImage: json["user_image"],
        current: currentPage,
        last: lastPage,
        totalResults: totalResults,
        limit: limit,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "createdAt": createdAt.toIso8601String(),
        "reviews": reviews.toJson(),
        "user_image": userImage,
        "current": current,
        "last": last,
        "totalResults": totalResults,
        "limit": limit,
      };
}

class Reviews {
  final String id;
  final Offer offer;
  final String description;
  final int star;

  Reviews({
    required this.id,
    required this.offer,
    required this.description,
    required this.star,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
        id: json["_id"],
        offer: Offer.fromJson(json["offer"]),
        description: json["description"],
        star: json["star"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "offer": offer.toJson(),
        "description": description,
        "star": star,
      };
}

class Offer {
  final String id;
  final String title;
  final String offerType;
  final int price;
  final int offerPrice;
  final dynamic offerPercentage;
  final String offerImage;

  Offer({
    required this.id,
    required this.title,
    required this.offerType,
    required this.price,
    required this.offerPrice,
    required this.offerPercentage,
    required this.offerImage,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: json["_id"],
        title: json["title"],
        offerType: json["offer_type"],
        price: json["price"],
        offerPrice: json["offer_price"],
        offerPercentage: json["offer_percentage"],
        offerImage: json["offer_image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "offer_type": offerType,
        "price": price,
        "offer_price": offerPrice,
        "offer_percentage": offerPercentage,
        "offer_image": offerImage,
      };
}
