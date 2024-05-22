import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lootfat_owner/utils/colors.dart';
import 'package:lootfat_owner/utils/no_data.dart';
import 'package:lootfat_owner/view/widgets/are_you_sure_widget.dart';
import 'package:lootfat_owner/view/widgets/expansion.dart';
import 'package:lootfat_owner/view/widgets/image_zoom.dart';
import '../../api_provider/offers_api.dart';
import '../../model/myoffers_details_model.dart';
import '../../utils/images.dart';
import '../../utils/utils.dart';
import '../widgets/app_loader.dart';
import '../widgets/loading_overlay.dart';
import 'create_offers_screen.dart';

class OfferDetailsScreen extends StatefulWidget {
  final String offerId;

  OfferDetailsScreen({
    super.key,
    required this.offerId,
  });

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  bool returnStatus = false;
  bool isExpanded = false;
  bool isExpandedDetailsByType = false;
  bool isLoading = true;
  MyOffersDetailsModel? offerDetails;
  String offerId = '';
  String type = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      offerId = widget.offerId;
    });
    myOffersDetailsApi();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  myOffersDetailsApi() {
    try {
      setState(() {
        isLoading = true;
      });
      MyOffersAPI.myOffersDetails(offerId).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          setState(() {
            offerDetails = MyOffersDetailsModel.fromJson(res['data']);
            type = offerDetails!.startDate.isAfter(DateTime.now())
                ? "new_arrival"
                : offerDetails!.endDate.isBefore(DateTime.now())
                    ? "expire"
                    : "active";
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

  myOfferDeleteApi() {
    onMenuClicked(
      context: context,
      title: 'Delete Offer!!!',
      isLogout: false,
      description: 'Are you sure want to remove this offer?',
      onTap: () {
        Navigator.pop(context);
        LoadingOverlay.of(context).show();
        try {
          MyOffersAPI.deleteOffer(offerId).then((response) {
            if (response.statusCode == 200 || response.statusCode == 201) {
              var res = json.decode(response.body);
              LoadingOverlay.of(context).hide();
              Utils.toastMessage(res['message']);
              Navigator.pop(context, true);
            } else {
              LoadingOverlay.of(context).hide();
              Utils.errorHandling(response);
            }
          });
        } catch (e) {
          LoadingOverlay.of(context).hide();
        }
      },
    );
  }

  Future<bool> back(status) async {
    Navigator.pop(context, status);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => back(returnStatus),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          actions: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 5),
              child: Material(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (value) =>
                                CreateOffersScreen(offerDetails: offerDetails!),
                          ),
                        )
                        .then((val) => val
                            ? {
                                setState(() {
                                  returnStatus = val;
                                }),
                                myOffersDetailsApi()
                              }
                            : null);
                  },
                  focusColor: Colors.black,
                  highlightColor: AppColors.white.withOpacity(0.4),
                  splashColor: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(100),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 5),
              child: Material(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100),
                child: InkWell(
                  onTap: () {
                    myOfferDeleteApi();
                  },
                  focusColor: Colors.black,
                  highlightColor: AppColors.white.withOpacity(0.4),
                  splashColor: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(100),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: isLoading == true
            ? AppLoader()
            : RefreshIndicator(
                color: AppColors.main,
                onRefresh: () async {
                  myOffersDetailsApi();
                },
                child: offerDetails == null
                    ? NoDataFound(
                        onTap: () {
                          myOffersDetailsApi();
                        },
                      )
                    : SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (type == 'new_arrival' || type == 'active')
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ImageZoomScreen(
                                        url: offerDetails!.offerImage,
                                      ),
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: offerDetails!.offerImage,
                                  child: Image.network(
                                    offerDetails!.offerImage,
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) =>
                                            Utils.loadingBuilder(
                                      context,
                                      child,
                                      loadingProgress,
                                    ),
                                    errorBuilder:
                                        (context, child, loadingProgress) =>
                                            Utils.errorBuilder(
                                      context,
                                      child,
                                      loadingProgress,
                                    ),
                                  ),
                                ),
                              ),
                            if (type == 'expire')
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ImageZoomScreen(
                                        url: offerDetails!.offerImage,
                                      ),
                                    ),
                                  );
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Hero(
                                      tag: offerDetails!.offerImage,
                                      child: Image.network(
                                        offerDetails!.offerImage,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) =>
                                                Utils.loadingBuilder(
                                          context,
                                          child,
                                          loadingProgress,
                                        ),
                                        errorBuilder:
                                            (context, child, loadingProgress) =>
                                                Utils.errorBuilder(
                                          context,
                                          child,
                                          loadingProgress,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 200,
                                      height: 200,
                                      child: SvgPicture.asset(
                                        SvgImages.expire,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Container(
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 6,
                                top: 10,
                                bottom: 10,
                              ),
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    offerDetails!.title,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.main,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        'Redeem Coupon',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff48526c),
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      SvgPicture.asset(
                                        SvgImages.person,
                                        height: 14,
                                        width: 14,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        offerDetails!.redeemedCount.toString(),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.main,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        overflow: TextOverflow.clip,
                                        softWrap: true,
                                        maxLines: 1,
                                        textScaleFactor: 1,
                                        text: TextSpan(
                                          text: '₹',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Colors.black),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    '${offerDetails!.offerPrice.toString()} ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 20,
                                                    color: AppColors.appColor)),
                                            TextSpan(
                                                text:
                                                    '/ ${offerDetails!.price.toString()}',
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                    color: Color(0xff8c93a3))),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Flexible(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: AppColors.appColor,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            offerDetails!.offerType,
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Description',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.main,
                                      ),
                                    ),
                                  ),
                                  Material(
                                    borderRadius: BorderRadius.circular(100),
                                    color: isExpanded
                                        ? AppColors.appColor
                                        : AppColors.main,
                                    child: InkWell(
                                        onTap: () {
                                          setState(
                                              () => isExpanded = !isExpanded);
                                        },
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        highlightColor:
                                            AppColors.white.withOpacity(0.4),
                                        splashColor:
                                            AppColors.white.withOpacity(0.2),
                                        child: Ink(
                                          padding: EdgeInsets.all(2),
                                          child: Icon(
                                            isExpanded
                                                ? Icons
                                                    .keyboard_arrow_up_rounded
                                                : Icons
                                                    .keyboard_arrow_down_rounded,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            ExpandedSection(
                              expand: isExpanded,
                              child: AnimatedContainer(
                                duration: Duration(seconds: 1),
                                padding: EdgeInsets.only(
                                    left: 16, right: 16, top: 6),
                                child: Text(
                                  offerDetails!.description,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.6,
                                    height: 1.4,
                                    color: Color(0xff627477),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Details By Type',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.main,
                                      ),
                                    ),
                                  ),
                                  Material(
                                    borderRadius: BorderRadius.circular(100),
                                    color: isExpandedDetailsByType
                                        ? AppColors.appColor
                                        : AppColors.main,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() =>
                                              isExpandedDetailsByType =
                                                  !isExpandedDetailsByType);
                                        },
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        highlightColor:
                                            AppColors.white.withOpacity(0.4),
                                        splashColor:
                                            AppColors.white.withOpacity(0.2),
                                        child: Ink(
                                          padding: EdgeInsets.all(2),
                                          child: Icon(
                                            isExpandedDetailsByType
                                                ? Icons
                                                    .keyboard_arrow_up_rounded
                                                : Icons
                                                    .keyboard_arrow_down_rounded,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            ExpandedSection(
                              expand: isExpandedDetailsByType,
                              child: AnimatedContainer(
                                duration: Duration(seconds: 1),
                                padding: EdgeInsets.only(
                                    left: 16, right: 16, top: 6),
                                child: Column(
                                  children: [
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          color: AppColors.appColor,
                                          size: 20,
                                        ),
                                        SizedBox(width: 6),
                                        RichText(
                                          overflow: TextOverflow.clip,
                                          softWrap: true,
                                          maxLines: 1,
                                          textScaleFactor: 1,
                                          text: TextSpan(
                                            text: 'Start Date : ',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppColors.main,
                                                fontWeight: FontWeight.w600),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: Utils.convertDate(
                                                    offerDetails!.startDate,
                                                    'dd MMM, yyyy'),
                                                style: TextStyle(
                                                  color: Color(0xff627477),
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          color: AppColors.appColor,
                                          size: 20,
                                        ),
                                        SizedBox(width: 6),
                                        RichText(
                                          overflow: TextOverflow.clip,
                                          softWrap: true,
                                          maxLines: 1,
                                          textScaleFactor: 1,
                                          text: TextSpan(
                                            text: 'End Date : ',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppColors.main,
                                                fontWeight: FontWeight.w600),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: Utils.convertDate(
                                                    offerDetails!.endDate,
                                                    'dd MMM, yyyy'), //' 6 Jan, 2021 '
                                                style: TextStyle(
                                                    color: Color(0xff627477),
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.percent,
                                          color: AppColors.appColor,
                                          size: 20,
                                        ),
                                        SizedBox(width: 6),
                                        RichText(
                                          overflow: TextOverflow.clip,
                                          softWrap: true,
                                          maxLines: 1,
                                          textScaleFactor: 1,
                                          text: TextSpan(
                                            text: 'Offer Percentage : ',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppColors.main,
                                                fontWeight: FontWeight.w600),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: offerDetails!
                                                    .offerPercentage
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Color(0xff627477),
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
      ),
    );
  }

  userInfoView({required String title, required Function() onTap}) {
    return Material(
      child: InkWell(
        onTap: onTap,
        highlightColor: AppColors.white.withOpacity(0.4),
        splashColor: AppColors.appColor.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.main),
                ),
              ),
              SizedBox(height: 5),
              Container(
                  padding: EdgeInsets.all(6),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.main,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 14,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
