import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lootfat_owner/utils/colors.dart';
import 'package:lootfat_owner/utils/no_data.dart';
import 'package:lootfat_owner/utils/utils.dart';
import '../../api_provider/notification_api.dart';
import '../../model/notification_model.dart';

import 'package:flutter/foundation.dart';
import '../widgets/app_loader.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  List<NotificationModel> notificationList = [];
  ScrollController scrollController = ScrollController();
  bool noMoreData = false;
  bool isPerformingRequest = false;
  bool isLoading = true;
  int numberOfPostsPerRequest = 10;
  int lastPage = 1;
  int firstPage = 1;

  @override
  void initState() {
    super.initState();
    notificationListApi();
    scrollController.addListener(() {
      getNotificationListScrollController();
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  notificationListApi() {
    try {
      setState(() {
        notificationList.clear();
        isLoading = true;
        firstPage = 1;
        lastPage = 1;
      });
      NotificationAPI.notification(firstPage, numberOfPostsPerRequest)
          .then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          if (res['data']['results'].isNotEmpty) {
            List<NotificationModel> newNotificationList = [];
            res['data']['results'].forEach((json) {
              newNotificationList.add(
                NotificationModel.fromJson(
                  json,
                  res['data']['page'],
                  res['data']['totalPages'],
                  res['data']['totalResults'],
                  res['data']['limit'],
                ),
              );
            });
            setState(() {
              notificationList = newNotificationList;
              firstPage = res['data']['page'];
              lastPage = res['data']['totalPages'];
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
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

  void getNotificationListScrollController() async {
    try {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isPerformingRequest = true;
          isLoading = false;
        });
        if (firstPage < lastPage) {
          NotificationAPI.notification(firstPage + 1, numberOfPostsPerRequest)
              .then((response) {
            if (response.statusCode == 200) {
              var decoded = json.decode(response.body);
              decoded['data']['results'].forEach((json) {
                notificationList.add(
                  NotificationModel.fromJson(
                    json,
                    decoded['data']['page'],
                    decoded['data']['totalPages'],
                    decoded['data']['totalResults'],
                    decoded['data']['limit'],
                  ),
                );
              });
              setState(() {
                isPerformingRequest = false;
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
      setState(() {
        isLoading = false;
      });
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? AppLoader()
          : notificationList.isEmpty
              ? NoDataFound(
                  onTap: () {
                    notificationListApi();
                  },
                )
              : RefreshIndicator(
                  color: AppColors.main,
                  onRefresh: () async {
                    notificationListApi();
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    itemCount: notificationList.length,
                    itemBuilder: (context, index) {
                      if (index == notificationList.length) {
                        return Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 6, bottom: 10),
                            child: noMoreData
                                ? Container()
                                : buildProgressIndicator(
                                    isPerformingRequest,
                                  ),
                          ),
                        );
                      } else {
                        var item = notificationList[index];
                        return NotificationItem(
                          title: item.title,
                          date: Utils.convertDate(item.date, 'dd MMM yyyy'),
                          body: item.body,
                          onTap: null,
                        );
                      }
                    },
                  ),
                ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String title;
  final String body;
  final String date;
  final Function()? onTap;
  const NotificationItem({
    Key? key,
    required this.title,
    required this.body,
    required this.date,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: onTap,
        highlightColor: AppColors.white.withOpacity(0.4),
        splashColor: AppColors.appColor.withOpacity(0.2),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.main,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                body,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: Color(0xff8D93A3),
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 4),
              Divider(
                thickness: 1,
                color: AppColors.appColor.withOpacity(0.2),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: Color(0xff8D93A3),
                    size: 20,
                  ),
                  SizedBox(width: 6),
                  Text(
                    date,
                    overflow: TextOverflow.clip,
                    softWrap: true,
                    maxLines: 1,
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff8D93A3),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TitleView extends StatelessWidget {
  final String? title;
  final Function()? onTap;
  const TitleView({
    Key? key,
    this.title,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Text(
            title!,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.main,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          InkWell(
              onTap: onTap,
              highlightColor: AppColors.white.withOpacity(0.4),
              splashColor: AppColors.appColor.withOpacity(0.2),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                child: Text(
                  "View All",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: AppColors.orange,
                  ),
                ),
              )),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
