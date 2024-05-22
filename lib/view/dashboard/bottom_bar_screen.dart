import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lootfat_owner/utils/colors.dart';
import 'package:lootfat_owner/view/dashboard/analytics_screen.dart';
import 'package:lootfat_owner/view/dashboard/my_banners.dart';
import 'package:lootfat_owner/view/dashboard/profile_screen.dart';
import 'home_screen.dart';
import 'notification_screen.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;
  int selectedIndex = 0;
  CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Future.value(false),
      child: Scaffold(
        key: _scaffoldkey,
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          selectedFontSize: 16,
          onTap: (i) {
            setState(() {
              currentIndex = i;
            });
          },
          backgroundColor: AppColors.white,
          elevation: 10,
          selectedLabelStyle:
              TextStyle(color: AppColors.appColor, fontSize: 10.0),
          unselectedLabelStyle:
              TextStyle(color: AppColors.main, fontSize: 10.0),
          selectedItemColor: AppColors.appColor,
          unselectedItemColor: AppColors.main,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph_sharp),
              label: "Analytics",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.post_add_outlined),
              label: "Banners",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none_rounded),
              label: "Notification",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
        body: currentIndex == 0
            ? HomeScreen()
            : currentIndex == 1
                ? AnalyticsScreen()
                : currentIndex == 2
                    ? MyBannersScreen()
                    : currentIndex == 3
                        ? NotificationScreen()
                        : currentIndex == 4
                            ? ProfileScreen()
                            : HomeScreen(),
      ),
    );
  }
}
