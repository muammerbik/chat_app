import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/custom_text/custom_text.dart';
import 'package:flutter_firebase_crashlytics_usage/constants/app_strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButtonView extends StatelessWidget {
  final String text;
  final Color color;
  final Color? textColor;
  final Color? borderColor;
  final Function() onTop;

  const CustomElevatedButtonView({
    required this.text,
    required this.color,
    this.textColor,
    this.borderColor,
    required this.onTop,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: onTop,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: borderColor != null ? 0 : 4,
          shadowColor: customRed.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 2)
                : BorderSide.none,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
