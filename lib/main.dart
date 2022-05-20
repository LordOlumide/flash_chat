import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      initialRoute: WelcomeScreen.screen_id,
      routes: {
        WelcomeScreen.screen_id: (context) => WelcomeScreen(),
        RegistrationScreen.screen_id: (context) => RegistrationScreen(),
        LoginScreen.screen_id: (context) => LoginScreen(),
        ChatScreen.screen_id: (context) => ChatScreen(),
      },
    );
  }
}
