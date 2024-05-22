import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lootfat_owner/utils/colors.dart';
import 'package:lootfat_owner/utils/images.dart';
import 'package:lootfat_owner/utils/no_data.dart';
import 'package:lootfat_owner/view/dashboard/create_offers_screen.dart';
import 'package:lootfat_owner/view/dashboard/offer_details_screen.dart';
import 'package:lootfat_owner/view/widgets/ink_wrapper.dart';

import '../../api_provider/offers_api.dart';
import '../../model/offers_model.dart';
import '../../utils/utils.dart';
import '../widgets/app_loader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Widget> myTabs = [
    Tab(text: 'Active'),
    Tab(text: 'Expire'),
    Tab(text: 'New Arrival'),
  ];

  List<MyOffersModel> activeOffers = [];
  List<MyOffersModel> expireOffers = [];
  List<MyOffersModel> newArrivalOffers = [];
  ScrollController activeScrollController = ScrollController();
  ScrollController expireScrollController = ScrollController();
  ScrollController newArrivalScrollController = ScrollController();
  bool isPerformingRequest = false;
  bool isActiveLoading = false;
  bool isExpireLoading = false;
  bool isNewArrivalLoading = false;
  int lastActivePage = 1, firstAcvtivePage = 1;
  int firstExpirePage = 1, lastExpirePage = 1;
  int firstNewArrivalPage = 1, lastNewArrivalPage = 1;
  bool noMoreActiveData = false;
  bool noMoreExpireData = false;
  bool noMoreNewArrivalData = false;
  bool activePageLoading = false;
  bool expirePageLoading = false;
  bool newArrivalPageLoading = false;
  int pagination = 10;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: myTabs.length);
    myActiveOffersApi();
    myExpireOffersApi();
    newArrivalOffersApi();
    activeScrollController.addListener(() {
      getActiveOffersPagination();
    });
    expireScrollController.addListener(() {
      getExpireOffersPagination();
    });
    newArrivalScrollController.addListener(() {
      getNewArrivalOffersPagination();
    });
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    activeScrollController.dispose();
    expireScrollController.dispose();
    newArrivalScrollController.dispose();
    super.dispose();
  }

  myActiveOffersApi() {
    setState(() {
      activeOffers.clear();
      isActiveLoading = true;
      lastActivePage = 1;
      firstAcvtivePage = 1;
    });
    try {
      MyOffersAPI.myOffersList("active", firstAcvtivePage, pagination)
          .then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          List<MyOffersModel> offers = [];
          res['data']['results'].forEach((json) {
            offers.add(
              MyOffersModel.fromJson(
                json,
                res['data']['page'],
                res['data']['totalPages'],
                res['data']['totalResults'],
                res['data']['limit'],
              ),
            );
          });
          setState(() {
            activeOffers = offers;
            firstAcvtivePage = res['data']['page'];
            lastActivePage = res['data']['totalPages'];
            isActiveLoading = false;
          });
        } else {
          setState(() {
            isActiveLoading = false;
          });
          Utils.errorHandling(response);
        }
      });
    } catch (e) {
      setState(() {
        isActiveLoading = false;
      });
    }
  }

  myExpireOffersApi() {
    setState(() {
      expireOffers.clear();
      isExpireLoading = true;
      lastExpirePage = 1;
      firstExpirePage = 1;
    });
    try {
      MyOffersAPI.myOffersList("expire", firstExpirePage, pagination)
          .then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          List<MyOffersModel> offers = [];
          res['data']['results'].forEach((json) {
            offers.add(
              MyOffersModel.fromJson(
                json,
                res['data']['page'],
                res['data']['totalPages'],
                res['data']['totalResults'],
                res['data']['limit'],
              ),
            );
          });
          setState(() {
            expireOffers = offers;
            firstExpirePage = res['data']['page'];
            lastExpirePage = res['data']['totalPages'];
            isExpireLoading = false;
          });
        } else {
          setState(() {
            isExpireLoading = false;
          });
          Utils.errorHandling(response);
        }
      });
    } catch (e) {
      setState(() {
        isExpireLoading = false;
      });
    }
  }

  newArrivalOffersApi() {
    setState(() {
      newArrivalOffers.clear();
      isNewArrivalLoading = true;
      lastNewArrivalPage = 1;
      firstNewArrivalPage = 1;
    });
    try {
      MyOffersAPI.myOffersList("new_arrival", firstNewArrivalPage, pagination)
          .then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          List<MyOffersModel> offers = [];
          res['data']['results'].forEach((json) {
            offers.add(
              MyOffersModel.fromJson(
                json,
                res['data']['page'],
                res['data']['totalPages'],
                res['data']['totalResults'],
                res['data']['limit'],
              ),
            );
          });
          setState(() {
            newArrivalOffers = offers;
            firstNewArrivalPage = res['data']['page'];
            lastNewArrivalPage = res['data']['totalPages'];
            isNewArrivalLoading = false;
          });
        } else {
          setState(() {
            isNewArrivalLoading = false;
          });
          Utils.errorHandling(response);
        }
      });
    } catch (e) {
      setState(() {
        isNewArrivalLoading = false;
      });
    }
  }

  void getActiveOffersPagination() async {
    try {
      if (activeScrollController.position.pixels ==
          activeScrollController.position.maxScrollExtent) {
        setState(() {
          activePageLoading = true;
        });
        if (firstAcvtivePage < lastActivePage) {
          MyOffersAPI.myOffersList("active", firstAcvtivePage + 1, pagination)
              .then((response) {
            if (response.statusCode == 200) {
              var decoded = json.decode(response.body);
              decoded['data']['results'].forEach((json) {
                activeOffers.add(
                  MyOffersModel.fromJson(
                    json,
                    decoded['data']['page'],
                    decoded['data']['totalPages'],
                    decoded['data']['totalResults'],
                    decoded['data']['limit'],
                  ),
                );
              });
              setState(() {
                firstAcvtivePage = decoded['data']['page'];
                activePageLoading = false;
                pagination = decoded['data']['totalPages'];
              });
            } else {
              setState(() {
                activePageLoading = false;
                noMoreActiveData = false;
              });
              Utils.errorHandling(response);
            }
          });
        } else if (firstAcvtivePage == lastActivePage) {
          setState(() {
            activePageLoading = false;
            noMoreActiveData = true;
          });
        }
      }
    } catch (e) {
      Utils.toastMessage("$e");
    }
  }

  void getExpireOffersPagination() async {
    try {
      if (expireScrollController.position.pixels ==
          expireScrollController.position.maxScrollExtent) {
        setState(() {
          expirePageLoading = true;
        });
        if (firstExpirePage < lastExpirePage) {
          MyOffersAPI.myOffersList("expire", firstExpirePage + 1, pagination)
              .then((response) {
            if (response.statusCode == 200) {
              var decoded = json.decode(response.body);
              decoded['data']['results'].forEach((json) {
                expireOffers.add(
                  MyOffersModel.fromJson(
                    json,
                    decoded['data']['page'],
                    decoded['data']['totalPages'],
                    decoded['data']['totalResults'],
                    decoded['data']['limit'],
                  ),
                );
              });
              setState(() {
                firstExpirePage = decoded['data']['page'];
                expirePageLoading = false;
                pagination = decoded['data']['totalPages'];
              });
            } else {
              setState(() {
                expirePageLoading = false;
                noMoreExpireData = false;
              });
              Utils.errorHandling(response);
            }
          });
        } else if (firstExpirePage == lastExpirePage) {
          setState(() {
            expirePageLoading = false;
            noMoreExpireData = true;
          });
        }
      }
    } catch (e) {
      Utils.toastMessage("$e");
    }
  }

  void getNewArrivalOffersPagination() async {
    try {
      if (newArrivalScrollController.position.pixels ==
          newArrivalScrollController.position.maxScrollExtent) {
        setState(() {
          newArrivalPageLoading = true;
        });
        if (firstNewArrivalPage < lastNewArrivalPage) {
          MyOffersAPI.myOffersList(
                  "new_arrival", firstNewArrivalPage + 1, pagination)
              .then((response) {
            if (response.statusCode == 200) {
              var decoded = json.decode(response.body);
              decoded['data']['results'].forEach((json) {
                newArrivalOffers.add(
                  MyOffersModel.fromJson(
                    json,
                    decoded['data']['page'],
                    decoded['data']['totalPages'],
                    decoded['data']['totalResults'],
                    decoded['data']['limit'],
                  ),
                );
              });
              setState(() {
                firstNewArrivalPage = decoded['data']['page'];
                newArrivalPageLoading = false;
                pagination = decoded['data']['totalPages'];
              });
            } else {
              setState(() {
                newArrivalPageLoading = false;
                noMoreNewArrivalData = false;
              });
              Utils.errorHandling(response);
            }
          });
        } else if (firstNewArrivalPage == lastNewArrivalPage) {
          setState(() {
            newArrivalPageLoading = false;
            noMoreNewArrivalData = true;
          });
        }
      }
    } catch (e) {
      Utils.toastMessage("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Offers"),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.appColor,
            labelColor: AppColors.white,
            dividerColor: AppColors.appColor,
            unselectedLabelColor: Colors.white,
            tabs: myTabs,
          ),
        ),
        floatingActionButton: SizedBox(
          height: 40,
          width: Utils.width(context) / 1.1,
          child: Center(
            child: ElevatedButton(
              onPressed: () async {
                var val = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateOffersScreen(),
                  ),
                );
                if (val == true) {
                  myActiveOffersApi();
                  myExpireOffersApi();
                  newArrivalOffersApi();
                }
              },
              child: const Center(
                child: Text(
                  'Add Offer',
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Column(
              children: [
                Expanded(
                  child: isActiveLoading
                      ? AppLoader()
                      : RefreshIndicator(
                          color: AppColors.main,
                          onRefresh: () async {
                            myActiveOffersApi();
                          },
                          child: activeOffers.isEmpty
                              ? NoDataFound(
                                  onTap: () {
                                    myActiveOffersApi();
                                  },
                                )
                              : ListView.builder(
                                  controller: activeScrollController,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemCount: activeOffers.length,
                                  padding: padding(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index == activeOffers.length) {
                                      return Center(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            top: 6,
                                            bottom: 10,
                                          ),
                                          child: noMoreActiveData
                                              ? Container()
                                              : buildProgressIndicator(
                                                  activePageLoading,
                                                ),
                                        ),
                                      );
                                    } else {
                                      return OffersItem(
                                          data: activeOffers[index],
                                          type: 'active',
                                          onTap: () {
                                            onOfferDetail(
                                                oID: activeOffers[index].id);
                                          });
                                    }
                                  }),
                        ),
                ),
              ],
            ),
            isExpireLoading
                ? AppLoader()
                : RefreshIndicator(
                    color: AppColors.main,
                    onRefresh: () async {
                      myExpireOffersApi();
                    },
                    child: expireOffers.isEmpty
                        ? NoDataFound(
                            onTap: () {
                              myExpireOffersApi();
                            },
                          )
                        : ListView.builder(
                            itemCount: expireOffers.length,
                            physics: AlwaysScrollableScrollPhysics(),
                            controller: expireScrollController,
                            padding: padding(),
                            itemBuilder: (BuildContext context, int index) {
                              if (index == expireOffers.length) {
                                return Center(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: 6,
                                      bottom: 10,
                                    ),
                                    child: noMoreExpireData
                                        ? Container()
                                        : buildProgressIndicator(
                                            expirePageLoading,
                                          ),
                                  ),
                                );
                              } else {
                                return OffersItem(
                                    data: expireOffers[index],
                                    type: 'expire',
                                    onTap: () {
                                      onOfferDetail(
                                          oID: expireOffers[index].id);
                                    });
                              }
                            }),
                  ),
            isNewArrivalLoading
                ? AppLoader()
                : RefreshIndicator(
                    color: AppColors.main,
                    onRefresh: () async {
                      newArrivalOffersApi();
                    },
                    child: newArrivalOffers.isEmpty
                        ? NoDataFound(
                            onTap: () {
                              newArrivalOffersApi();
                            },
                          )
                        : ListView.builder(
                            itemCount: newArrivalOffers.length,
                            physics: AlwaysScrollableScrollPhysics(),
                            controller: newArrivalScrollController,
                            padding: padding(),
                            itemBuilder: (context, index) {
                              if (index == newArrivalOffers.length) {
                                return Center(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: 6,
                                      bottom: 10,
                                    ),
                                    child: noMoreNewArrivalData
                                        ? Container(child: Text("NoData"))
                                        : buildProgressIndicator(
                                            newArrivalPageLoading,
                                          ),
                                  ),
                                );
                              } else {
                                return OffersItem(
                                    data: newArrivalOffers[index],
                                    type: 'new_arrival',
                                    onTap: () {
                                      onOfferDetail(
                                          oID: newArrivalOffers[index].id);
                                    });
                              }
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }

  onOfferDetail({oID}) async {
    var val = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OfferDetailsScreen(
          offerId: oID,
        ),
      ),
    );
    if (val == true) {
      myActiveOffersApi();
      myExpireOffersApi();
      newArrivalOffersApi();
    }
  }

  padding() => const EdgeInsets.only(
        right: 10.0,
        left: 10,
        top: 5,
        bottom: 60,
      );
}

class OffersItem extends StatelessWidget {
  final MyOffersModel data;
  final String type;
  final Function()? onTap;

  const OffersItem({
    Key? key,
    required this.type,
    required this.data,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWrapper(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (type == 'new_arrival' || type == 'active')
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: Image.network(
                          data.offerImage,
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
                    if (type == 'expire')
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 90,
                            height: 90,
                            child: Image.network(
                              data.offerImage,
                              fit: BoxFit.fill,
                              loadingBuilder:
                                  (context, child, loadingProgress) =>
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
                          Container(
                            width: 80,
                            height: 80,
                            child: SvgPicture.asset(SvgImages.expire),
                          ),
                        ],
                      ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
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
                                    text: '${data.offerPrice} ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: AppColors.appColor)),
                                TextSpan(
                                    text: '/ ₹${data.price}',
                                    style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: Color(0xff8c93a3))),
                              ],
                            ),
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                'Redeem Coupon',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff8c93a3)),
                              ),
                              SizedBox(width: 6),
                              SvgPicture.asset(
                                SvgImages.person,
                                height: 14,
                                width: 14,
                              ),
                              SizedBox(width: 6),
                              Text(
                                data.redeemedCount.toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.main,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.appColor,
                            ),
                            child: Text(data.offerType,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: AppColors.white,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
