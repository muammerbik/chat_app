// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/constants/app_strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSingInButton extends StatefulWidget {
  final Color? textColor;
  final String text;
  final Function() onTop;
  final Color color;
  final Widget? iconWidget;
  const CustomSingInButton({super.key, 
    this.textColor,
    required this.text,
    required this.onTop,
    required this.color,
    this.iconWidget,
  });

  @override
  State<CustomSingInButton> createState() => _CustomSingInButtonState();
}

class _CustomSingInButtonState extends State<CustomSingInButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: GestureDetector(
        onTap: widget.onTop,
        child: Container(
          width: double.infinity,
          height: 70.h,
          decoration: ShapeDecoration(
            color: widget.color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.r),
            ),
            shadows: const [
              BoxShadow(
                color: grey,
                blurRadius: 3,
                offset: Offset(0, 2),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Align(
            alignment: Alignment.center,
            child: ListTile(
              title: Text(
                widget.text,
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: 24.sp,
                ),
              ),
              leading: widget.iconWidget,
            ),
          ),
        ),
      ),
    );
  }
}
