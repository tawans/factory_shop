import 'package:factory_shop/common/const/colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final String? errorText;
  final ValueChanged<String> onChanged;
  final bool obscureText;
  final bool autofocus;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.errorText,
    required this.onChanged,
    this.obscureText = false,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1.0,
      ),
    );

    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      autofocus: autofocus,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(20),
          hintText: hintText,
          errorText: errorText,
          hintStyle: TextStyle(
            color: BODY_TEXT_COLOR,
            fontSize: 14.0,
          ),
          fillColor: INPUT_BG_COLOR,
          filled: true,
          border: baseBorder,
          focusedBorder: baseBorder.copyWith(
            borderSide: BorderSide(
              color: PRIMARY_COLOR,
              width: 2.0,
            ),
          )),
    );
  }
}
