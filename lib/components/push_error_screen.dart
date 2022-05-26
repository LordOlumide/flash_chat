import 'package:flutter/material.dart';
import 'package:flash_chat/screens/error_screen.dart';

PushErrorScreen({
  context,
  error,
  screen_id,
}) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => ErrorScreen(
        error: error.toString(),
        predecessor_id: screen_id,
      ),
    ),
  );
}