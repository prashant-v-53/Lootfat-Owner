import 'package:flutter/material.dart';
import 'package:lootfat_owner/utils/utils.dart';

import '../../utils/images.dart';

class NoDataFound extends StatelessWidget {
  final Function() onTap;
  const NoDataFound({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            AppImages.noData,
            height: 120,
          ),
          SizedBox(height: 25),
          Text(
            'No Data Found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'There is no data to show you right now.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: Utils.width(context) * 0.3,
            child: ElevatedButton(
              onPressed: onTap,
              child: const Center(
                child: Text(
                  'Try Again',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
