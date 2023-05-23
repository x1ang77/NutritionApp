import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showSnackbar(GlobalKey<ScaffoldMessengerState> scaffoldKey, String message, Color color) {
  scaffoldKey.currentState?.showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: Text(message),
    ),
  );
}