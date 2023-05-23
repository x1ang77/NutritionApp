import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
GlobalKey<ScaffoldMessengerState>();

void showSnackbar(String message, Color color) {
  _scaffoldKey.currentState?.showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: Text(message),
    ),
  );
}