// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crashlytics_usage/companent/custom_text/custom_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomAppbarView extends StatefulWidget implements PreferredSizeWidget {
  final String? appBarTitle;
  final bool? centerTitle;
  final IconButton? actionIcon;
  final Color? appbarColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final Color? iconColor;

  const CustomAppbarView({
    Key? key,
    this.appBarTitle,
    this.centerTitle,
    this.actionIcon,
    this.appbarColor,
    this.textColor,
    this.onTap,
    this.iconColor,
  }) : super(key: key);

  @override
  State<CustomAppbarView> createState() => _CustomAppbarViewState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppbarViewState extends State<CustomAppbarView> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.white,
      centerTitle: widget.centerTitle,
      backgroundColor: widget.appbarColor ?? Colors.white,
      leading: IconButton(
        onPressed: widget.onTap,
        icon: Icon(
          Icons.arrow_back,
          color: widget.iconColor ?? Colors.black,
        ),
      ),
      title: TextWidgets(
        text: widget.appBarTitle!,
        size: 27.sp,
        color: widget.textColor ?? Colors.black,
      ),
      actions: widget.actionIcon != null ? [widget.actionIcon!] : [],
    );
  }
}
