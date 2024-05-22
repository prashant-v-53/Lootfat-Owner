import 'package:flutter/material.dart';
import 'package:lootfat_owner/utils/colors.dart';

class InkWrapper extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onTap;

  InkWrapper({
    @required this.child,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child!,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              highlightColor: AppColors.white.withOpacity(0.4),
              splashColor: AppColors.appColor.withOpacity(0.2),
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}
