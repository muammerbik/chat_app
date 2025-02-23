import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatefulWidget {
  final String? labelText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final String? hintText;
  final int? maxLines;
  final Color? borderColor;
  final TextCapitalization? textCapitalization;
  final int? maxLength;

  const CustomTextFormField({
    Key? key,
    this.labelText,
    required this.controller,
    this.validator,
    this.onTap,
    this.keyboardType,
    this.maxLength,
    this.hintText,
    this.maxLines,
    this.borderColor,
    this.textCapitalization,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h, // Set height to 56
      child: TextFormField(
        maxLength: widget.maxLength,
        textInputAction: TextInputAction.done,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.words,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        onTap: widget.onTap,
        maxLines: widget.maxLines ?? 1,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: widget.labelText,
          hintText: widget.hintText,
          contentPadding: EdgeInsets.symmetric(
              vertical: 16.h, horizontal: 12.w), // Adjust padding
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }
}
