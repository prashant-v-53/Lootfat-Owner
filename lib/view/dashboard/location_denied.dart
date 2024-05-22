import 'package:flutter/material.dart';

class LocationDenied extends StatefulWidget {
  const LocationDenied({super.key});

  @override
  State<LocationDenied> createState() => _LocationDeniedState();
}

class _LocationDeniedState extends State<LocationDenied> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Permission!"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 50,
              ),
              SizedBox(height: 10),
              Text(
                "You need to give first\nlocation permisson for your store\nlocation after that restart the app.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
