import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lootfat_owner/api_provider/analytics_api.dart';
import 'package:lootfat_owner/model/analytics_model.dart';
import 'package:lootfat_owner/utils/colors.dart';
import 'package:lootfat_owner/utils/images.dart';
import 'package:lootfat_owner/utils/no_data.dart';
import 'package:lootfat_owner/utils/utils.dart';
import 'package:lootfat_owner/view/dashboard/home_screen.dart';
import 'package:lootfat_owner/view/dashboard/offer_details_screen.dart';
import 'package:lootfat_owner/view/widgets/app_loader.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool isLoading = false;
  bool isSalesChart = true;
  DateTime startDate = DateTime.now().subtract(Duration(days: 7));
  DateTime endDate = DateTime.now();
  AnalyticsModel? analyticsModel;
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    getChartData();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  getChartData() async {
    setState(() {
      isLoading = true;
    });
    try {
      AnalyticsAPI.getAnalytics(
        startDate.toString(),
        endDate.toString(),
      ).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          log(res.toString());
          analyticsModel = AnalyticsModel.fromJson(res);
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Analytics"),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? AppLoader()
          : RefreshIndicator(
              color: AppColors.main,
              onRefresh: () async {
                getChartData();
              },
              child: analyticsModel == null
                  ? NoDataFound(
                      onTap: () {
                        getChartData();
                      },
                    )
                  : SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15),
                          Row(
                            children: [
                              SizedBox(width: 15),
                              cardWidget(
                                AppColors.main,
                                SvgImages.coupon,
                                "Coupon Redeemed",
                                "${analyticsModel!.getTotalSalesAndRedeem.totalRedeem}",
                              ),
                              SizedBox(width: 15),
                              cardWidget(
                                AppColors.appColor,
                                SvgImages.bag,
                                "Total Sales",
                                "₹${analyticsModel!.getTotalSalesAndRedeem.totalSales}",
                              ),
                              SizedBox(width: 15),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(color: Colors.black12),
                              ],
                            ),
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    SizedBox(width: 6),
                                    isSalesChart
                                        ? Text(
                                            '₹',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          )
                                        : Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Icon(
                                              Icons.call_to_action_outlined,
                                              size: 20,
                                            ),
                                          ),
                                    Text(
                                      "${isSalesChart ? analyticsModel!.data.totalSalesThisMonth : analyticsModel!.data.totalRedeemThisMonth}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: AppColors.appColor,
                                      ),
                                    ),
                                    Text(
                                      "/${analyticsModel!.data.result.length} days",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: 120,
                                      decoration: BoxDecoration(
                                        color: Color(0xffEBF0F4),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: FittedBox(
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            padding: EdgeInsets.zero,
                                            value: isSalesChart
                                                ? "Total Sales"
                                                : "Total Redeem",
                                            items: [
                                              "Total Sales",
                                              "Total Redeem",
                                            ].map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                isSalesChart =
                                                    newValue == "Total Sales";
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        final picked =
                                            await showDateRangePicker(
                                          context: context,
                                          lastDate: DateTime.now(),
                                          firstDate: new DateTime(2021),
                                          builder: (context, child) {
                                            return Theme(
                                              data: ThemeData(
                                                colorScheme: ColorScheme.light(
                                                  primary: AppColors.main,
                                                  surface: AppColors.white,
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                        if (picked != null) {
                                          setState(() {
                                            startDate = picked.start;
                                            endDate = picked.end;
                                          });
                                          getChartData();
                                        }
                                      },
                                      padding: EdgeInsets.zero,
                                      icon: SvgPicture.asset(SvgImages.setting,
                                          height: 20),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Container(
                                  height: 200,
                                  child: SfCartesianChart(
                                    primaryXAxis: CategoryAxis(
                                      majorGridLines: MajorGridLines(width: 0),
                                      edgeLabelPlacement:
                                          EdgeLabelPlacement.shift,
                                      visibleMinimum: 0,
                                      interval: 1,
                                      labelIntersectAction:
                                          AxisLabelIntersectAction.hide,
                                      visibleMaximum: 4,
                                    ),
                                    zoomPanBehavior: ZoomPanBehavior(
                                      enablePanning: true,
                                    ),
                                    tooltipBehavior: _tooltip,
                                    series: <ChartSeries<Result, String>>[
                                      ColumnSeries<Result, String>(
                                        dataSource: analyticsModel!.data.result,
                                        xValueMapper: (Result data, _) =>
                                            data.date,
                                        width: 0.5,
                                        spacing: 0.2,
                                        yValueMapper: (Result data, _) =>
                                            isSalesChart
                                                ? data.totalSales
                                                : data.totalRedeem,
                                        name: '',
                                        color: Colors.blue,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          if (analyticsModel!.getMostRedeemedOffers.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "Most Redeemed offers",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.main,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          SizedBox(height: 10),
                          ...analyticsModel!.getMostRedeemedOffers
                              .asMap()
                              .map((key, value) {
                            return MapEntry(
                              key,
                              OffersItem(
                                  data: value,
                                  type: value.startDate.isAfter(DateTime.now())
                                      ? "new_arrival"
                                      : value.endDate.isBefore(DateTime.now())
                                          ? "expire"
                                          : "active",
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => OfferDetailsScreen(
                                          offerId: value.id,
                                        ),
                                      ),
                                    ).then(
                                      (val) => val ? getChartData() : null,
                                    );
                                  }),
                            );
                          }).values,
                        ],
                      ),
                    ),
            ),
    );
  }

  Widget cardWidget(
    Color color,
    String icon,
    String title,
    String numbers,
  ) =>
      Expanded(
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                height: 26,
              ),
              SizedBox(height: 10),
              FittedBox(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              FittedBox(
                child: Text(
                  numbers,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
