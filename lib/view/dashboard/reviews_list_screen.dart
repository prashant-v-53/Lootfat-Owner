import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lootfat_owner/utils/no_data.dart';
import 'package:lootfat_owner/view/dashboard/offer_details_screen.dart';
import '../../api_provider/review_api.dart';
import '../../model/review_model.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';
import '../widgets/app_loader.dart';
import '../widgets/star_rating.dart';

class ReviewListScreen extends StatefulWidget {
  const ReviewListScreen({super.key});

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen>
    with SingleTickerProviderStateMixin {
  List<ReviewModel> reviewList = [];
  ScrollController scrollController = ScrollController();
  bool noMoreData = false;
  bool isPerformingRequest = false;
  bool isLoading = true;
  int numberOfPostsPerRequest = 6;
  int lastPage = 1;
  int firstPage = 1;
  @override
  void initState() {
    super.initState();
    reviewListApi();
    scrollController.addListener(() {
      getReviewListScrollController();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  reviewListApi() {
    try {
      setState(() {
        reviewList.clear();
        isLoading = true;
        firstPage = 1;
        lastPage = 1;
      });

      ReviewAPI.reviewList(firstPage, numberOfPostsPerRequest).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          List<ReviewModel> newReviewList = [];
          res['data']['results'].forEach((json) {
            newReviewList.add(
              ReviewModel.fromJson(
                json,
                res['data']['page'],
                res['data']['totalPages'],
                res['data']['totalResults'],
                res['data']['limit'],
              ),
            );
          });
          setState(() {
            reviewList = newReviewList;
            firstPage = res['data']['page'] ?? 0;
            lastPage = res['data']['totalPages'] ?? 0;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          Utils.errorHandling(response);
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void getReviewListScrollController() async {
    try {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isPerformingRequest = true;
        });

        if (firstPage < lastPage) {
          ReviewAPI.reviewList(firstPage + 1, numberOfPostsPerRequest)
              .then((response) {
            if (response.statusCode == 200) {
              var decoded = json.decode(response.body);
              decoded['data']['results'].forEach((json) {
                reviewList.add(
                  ReviewModel.fromJson(
                    json,
                    decoded['data']['page'],
                    decoded['data']['totalPages'],
                    decoded['data']['totalResults'],
                    decoded['data']['limit'],
                  ),
                );
              });
              setState(() {
                firstPage = decoded['data']['page'];
                lastPage = decoded['data']['totalPages'];
              });
            } else {
              setState(() {
                isLoading = false;
                noMoreData = false;
                isPerformingRequest = false;
              });
              Utils.errorHandling(response);
            }
          });
        } else if (firstPage == lastPage) {
          setState(() {
            isPerformingRequest = false;
            noMoreData = true;
          });
        }
      }
    } catch (e) {
      Utils.toastMessage("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reviews"),
      ),
      body: isLoading
          ? AppLoader()
          : reviewList.isEmpty
              ? NoDataFound(
                  onTap: () {
                    reviewListApi();
                  },
                )
              : RefreshIndicator(
                  color: AppColors.main,
                  onRefresh: () async {
                    reviewListApi();
                  },
                  child: ListView.builder(
                    itemCount: reviewList.length,
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(4.0),
                    itemBuilder: (context, index) {
                      if (index == reviewList.length) {
                        return Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 6, bottom: 10),
                            child: noMoreData
                                ? Container()
                                : buildProgressIndicator(isPerformingRequest),
                          ),
                        );
                      } else {
                        return ReviewItem(
                            data: reviewList,
                            itemNo: index,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OfferDetailsScreen(
                                    offerId: reviewList[index].reviews.offer.id,
                                  ),
                                ),
                              );
                            });
                      }
                    },
                  ),
                ),
    );
  }
}

class ReviewItem extends StatelessWidget {
  final int itemNo;
  final List<ReviewModel> data;
  final Function()? onTap;

  const ReviewItem({
    Key? key,
    required this.data,
    required this.itemNo,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColors.main,
                    ),
                    child: Text(
                      (data[itemNo].firstName[0] + data[itemNo].lastName[0])
                          .toUpperCase(),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white),
                    )),
                SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        data[itemNo].firstName + ' ' + data[itemNo].lastName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.main),
                      ),
                      SizedBox(height: 6),
                      RichText(
                        overflow: TextOverflow.clip,
                        softWrap: true,
                        maxLines: 1,
                        textScaleFactor: 1,
                        text: TextSpan(
                          text: Utils.convertDate(
                              data[itemNo].createdAt, 'dd MMM yyyy'),
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff8D93A3),
                              fontWeight: FontWeight.w600),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' at ',
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                                text: Utils.convertTime(
                                    data[itemNo].createdAt.toString())),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                StarRating(
                  onRatingChanged: null,
                  color: Colors.amber,
                  rating: data[itemNo].reviews.star.toDouble(),
                ),
              ],
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffF4F6FA),
                ),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          data[itemNo].reviews.offer.offerImage,
                          height: 70,
                          width: 70,
                          fit: BoxFit.fill,
                          loadingBuilder: (context, child, loadingProgress) =>
                              Utils.loadingBuilder(
                            context,
                            child,
                            loadingProgress,
                          ),
                          errorBuilder: (context, child, loadingProgress) =>
                              Utils.errorBuilder(
                            context,
                            child,
                            loadingProgress,
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data[itemNo].reviews.offer.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.main),
                              ),
                              SizedBox(height: 4),
                              RichText(
                                overflow: TextOverflow.clip,
                                softWrap: true,
                                maxLines: 1,
                                textScaleFactor: 1,
                                text: TextSpan(
                                  text: '₹',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          '${data[itemNo].reviews.offer.offerPrice} ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: AppColors.appColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '/ ₹${data[itemNo].reviews.offer.price}',
                                      style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: Color(0xff8c93a3),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.appColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  data[itemNo].reviews.offer.offerType,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
            SizedBox(height: 10),
            Text(data[itemNo].reviews.description,
                style: TextStyle(
                  fontSize: 13,
                  letterSpacing: 0.3,
                  wordSpacing: 1,
                  height: 1.4,
                  color: AppColors.main,
                )),
          ],
        ),
      ),
    );
  }
}
