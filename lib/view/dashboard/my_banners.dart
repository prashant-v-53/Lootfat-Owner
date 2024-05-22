import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lootfat_owner/api_provider/banner_api.dart';
import 'package:lootfat_owner/model/banner_model.dart';
import 'package:lootfat_owner/utils/colors.dart';
import 'package:lootfat_owner/utils/no_data.dart';
import 'package:lootfat_owner/utils/utils.dart';
import 'package:lootfat_owner/view/dashboard/add_banners.dart';
import 'package:lootfat_owner/view/widgets/app_loader.dart';
import 'package:lootfat_owner/view/widgets/are_you_sure_widget.dart';

class MyBannersScreen extends StatefulWidget {
  const MyBannersScreen({super.key});

  @override
  State<MyBannersScreen> createState() => _MyBannersScreenState();
}

class _MyBannersScreenState extends State<MyBannersScreen> {
  BannerModel? bannerModel;
  bool isLoading = false;

  @override
  void initState() {
    // GET BANNERS
    getBanners();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void getBanners() {
    setState(() {
      isLoading = true;
    });
    try {
      BannerApi.getBanners().then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var res = json.decode(response.body);
          bannerModel = BannerModel.fromJson(res);
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
        title: Text("My Banners"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              var isAdded = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CreateBannerScreen(
                    data: null,
                  ),
                ),
              );
              if (isAdded == true) {
                getBanners();
              }
            },
            icon: Icon(
              Icons.add_photo_alternate_outlined,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.main,
        onRefresh: () async {
          getBanners();
        },
        child: isLoading == true
            ? AppLoader()
            : bannerModel == null || bannerModel!.data.results.isEmpty
                ? NoDataFound(
                    onTap: () {
                      getBanners();
                    },
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: bannerModel!.data.results.length,
                    itemBuilder: (context, index) {
                      return BannerItem(
                        data: bannerModel!.data.results[index],
                        onDelete: () => onDelete(bannerModel!.data.results[index].id),
                        onEdit: () => onEdit(bannerModel!.data.results[index]),
                        onStatusChange: (i) => manageOfferStatus(i),
                      );
                    },
                  ),
      ),
    );
  }

  void onEdit(value) async {
    var data = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreateBannerScreen(
          data: value,
        ),
      ),
    );
    if (data == true) {
      getBanners();
    }
  }

  void onDelete(id) {
    onMenuClicked(
      context: context,
      title: 'Delete Banner!!!',
      isLogout: false,
      description: 'Are you sure want to remove this banner?',
      onTap: () {
        Navigator.pop(context);
        setState(() {
          isLoading = true;
        });
        try {
          BannerApi.deleteBanner(id).then((response) {
            if (response.statusCode == 200 || response.statusCode == 201) {
              getBanners();
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
      },
    );
  }

  manageOfferStatus(offerId) {
    try {
      BannerApi.updateStatus(
        offerId,
      ).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          getBanners();
        } else {
          Utils.errorHandling(response);
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class BannerItem extends StatelessWidget {
  final BannerViewModel data;
  final Function() onDelete;
  final Function() onEdit;
  final Function(String) onStatusChange;
  BannerItem({
    required this.data,
    required this.onDelete,
    required this.onEdit,
    required this.onStatusChange,
  });
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
        onTap: onEdit,
        highlightColor: AppColors.white.withOpacity(0.4),
        splashColor: AppColors.appColor.withOpacity(0.2),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                data.bannerImage,
                width: Utils.width(context),
                loadingBuilder: (context, child, loadingProgress) => Utils.loadingBuilder(
                  context,
                  child,
                  loadingProgress,
                ),
                errorBuilder: (context, child, loadingProgress) => Utils.errorBuilder(
                  context,
                  child,
                  loadingProgress,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      data.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.main,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Switch(
                    activeColor: AppColors.appColor,
                    activeTrackColor: AppColors.appColor.withOpacity(0.3),
                    inactiveThumbColor: AppColors.main,
                    inactiveTrackColor: AppColors.main.withOpacity(0.2),
                    splashRadius: 50.0,
                    value: data.isActive,
                    onChanged: (value) {
                      onStatusChange(data.id);
                    },
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                data.description,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: Color(0xff8D93A3),
                  fontWeight: FontWeight.normal,
                ),
              ),
              Divider(
                thickness: 1,
                color: AppColors.appColor.withOpacity(0.2),
              ),
              Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: Color(0xff8D93A3),
                    size: 20,
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${DateFormat('dd-MM-yyyy').format(data.fromDate)} - ${DateFormat('dd-MM-yyyy').format(data.toDate)}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff8D93A3),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete_outlined,
                      color: Colors.red,
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
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 5,
              ),
              child: Text(
                "View All",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: AppColors.orange,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
