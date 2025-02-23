import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/constants/app_strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSingInButton extends StatefulWidget {
  final Color? textColor;
  final String text;
  final Function() onTop;
  final Color color;
  final Widget? iconWidget;

  const CustomSingInButton({
    super.key,
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
    return GestureDetector(
      onTap: widget.onTop,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        width: double.infinity,
        height: 56.h,
        decoration: ShapeDecoration(
          color: widget.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.iconWidget != null) ...[
              widget.iconWidget!,
            ],
            Expanded(
              child: Text(
                widget.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: 18.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
