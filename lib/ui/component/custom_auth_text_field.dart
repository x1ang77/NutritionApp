import 'package:flutter/material.dart';

class AuthTextField {
  Widget passwordTextField(
      TextEditingController controller, FocusNode node, bool showPass, String label,
      Widget prefixIcon, Widget suffixIcon, String errorText, BorderRadius borderRadius
      ) {
    return TextField(
      focusNode: node,
      obscureText: showPass,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}