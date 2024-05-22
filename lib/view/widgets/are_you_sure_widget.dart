import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lootfat_owner/utils/colors.dart';

onMenuClicked({
  required String? title,
  required String? description,
  required bool? isLogout,
  required Function() onTap,
  context,
}) =>
    Platform.isIOS
        ? showCupertinoDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: TextStyleExample(
                name: title!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              content: TextStyleExample(
                name: description!,
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  child: TextStyleExample(
                    name: isLogout == true ? 'Cancel' : "No",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                  ),
                  onPressed: () {
                    finish(context);
                  },
                ),
                CupertinoDialogAction(
                    child: TextStyleExample(
                      name: isLogout == true ? 'Logout' : "Yes",
                      style: TextStyle(
                        color: AppColors.appColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                      ),
                    ),
                    onPressed: onTap),
              ],
            ),
          )
        : showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) => AlertDialog(
              title: TextStyleExample(
                name: title!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              content: TextStyleExample(
                name: description!,
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                    isLogout == true ? 'Cancel' : "No",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                  ),
                  onPressed: () {
                    finish(context);
                  },
                ),
                TextButton(
                  child: Text(
                    isLogout == true ? 'Logout' : "Yes",
                    style: TextStyle(
                      color: AppColors.appColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                  ),
                  onPressed: onTap,
                ),
              ],
            ),
          );

class TextStyleExample extends StatelessWidget {
  const TextStyleExample({
    super.key,
    required this.name,
    required this.style,
  });

  final String name;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(1.0),
      child: Text(name, style: style.copyWith(letterSpacing: 1.0)),
    );
  }
}

void finish(BuildContext context, [Object? result]) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context, result);
  }
}
