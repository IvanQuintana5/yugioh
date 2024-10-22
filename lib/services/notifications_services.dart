import 'package:flutter/material.dart';

class NotificationsServices {
  static GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackbar (String message) {
    final snackBar = SnackBar(
      content: Text(
        message, 
        style: const TextStyle(
          color: Colors.cyan, 
          fontSize: 20
        ),
      ),
    );
    messengerKey.currentState!.showSnackBar(snackBar);
  }
}