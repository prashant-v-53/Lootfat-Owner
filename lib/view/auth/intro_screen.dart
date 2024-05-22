import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lootfat_owner/utils/colors.dart';
import 'package:lootfat_owner/utils/images.dart';
import 'package:lootfat_owner/utils/utils.dart';
import 'package:lootfat_owner/view/auth/login_screen.dart';

class Introduction {
  final String title;
  final String subTitle;
  final String image;

  Introduction({
    required this.title,
    required this.subTitle,
    required this.image,
  });
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int currentCarouselIndex = 0;
  int selectedIndex = 0;
  CarouselController carouselController = CarouselController();

  onTap(index) {
    currentCarouselIndex = index;
  }

  List<Introduction> introductionList = [
    Introduction(
      title: "Welcome to LootFat Merchant",
      subTitle:
          "Increase your Productivity & Create the\nBest Deals for Food Lovers",
      image: AppImages.banner1,
    ),
    Introduction(
      title: "Discounts",
      subTitle: "Give Exclusive online offers to your\nvaluable Customers",
      image: AppImages.banner2,
    ),
    Introduction(
      title: "Reward",
      subTitle:
          "Get More Revenue & More Visitors from\nCreate the more Offers.",
      image: AppImages.banner3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Future.value(false),
      child: Scaffold(
        backgroundColor: AppColors.main,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SafeArea(
                bottom: true,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LoginScreen(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                "Skip",
                                style: const TextStyle(
                                  color: AppColors.appColor,
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                size: 16,
                                color: AppColors.appColor,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: CarouselSlider(
                        carouselController: carouselController,
                        options: CarouselOptions(
                          height: Utils.height(context),
                          enlargeCenterPage: true,
                          viewportFraction: 1.0,
                          pauseAutoPlayOnTouch: true,
                          enableInfiniteScroll: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                        ),
                        items: List.generate(
                          introductionList.length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 15),
                                Text(
                                  introductionList[index].title,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  introductionList[index].subTitle,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    height: 1.5,
                                    fontSize: 14,
                                  ),
                                ),
                                Spacer(),
                                Center(
                                  child: Image.asset(
                                    introductionList[index].image,
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: selectedIndex == 0
                        ? null
                        : () {
                            carouselController.previousPage();
                          },
                    child: Text(
                      selectedIndex == 0 ? '' : 'BACK',
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      introductionList.length,
                      (index) => indicator(index, currentCarouselIndex),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (selectedIndex == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LoginScreen(),
                          ),
                        );
                      } else {
                        carouselController.nextPage();
                      }
                    },
                    child: Text(
                      'NEXT',
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  indicator(
    int? index,
    int? value,
  ) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index == selectedIndex
            ? AppColors.appColor
            : const Color(0xffD9DAEB),
      ),
    );
  }
}
