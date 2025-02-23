import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCupertinoAlertDialog extends StatefulWidget {
  final String title;
  final String content;
  final VoidCallback yesButtonOnTap;
  final VoidCallback? noButtonOnTap;
  final String? yesButonText;
  final String? noButonText;

  const CustomCupertinoAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.yesButtonOnTap,
    this.noButtonOnTap,
    this.yesButonText,
    this.noButonText,
  }) : super(key: key);

  @override
  State createState() => _CustomCupertinoAlertDialogState();
}

class _CustomCupertinoAlertDialogState
    extends State<CustomCupertinoAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      
      title: Text(
        widget.title,
        style: TextStyle(color: Colors.black, fontSize: 20.sp),
      ),
      content: Text(
        widget.content,
        style: TextStyle(fontSize: 15.sp, color: Colors.black),
      ),
      actions: [
        if (widget.noButtonOnTap != null && widget.noButonText != null)
          CupertinoDialogAction(
            onPressed: widget.noButtonOnTap,
            child: Text(
              widget.noButonText ?? "cancel",
              style: TextStyle(
                color: CupertinoColors.systemBlue,  
              ),
            ),
          ),
        CupertinoDialogAction(
          onPressed: widget.yesButtonOnTap,
          child: Text(
            widget.yesButonText ?? "ok",
            style: TextStyle(
              color: CupertinoColors.destructiveRed,  
            ),
          ),
        ),
      ],
    );
  }
}
