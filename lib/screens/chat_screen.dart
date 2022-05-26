import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/message_bubble.dart';
import 'package:intl/intl.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static String screen_id = "chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String messageText;
  TextEditingController controller = TextEditingController();

  void getCurrentUser() async {
    // get the currently logged-in user
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      } else {
        Navigator.popUntil(
            context, ModalRoute.withName(WelcomeScreen.screen_id));
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessages() async {
  //   final messages = await _firestore.collection('messages').get();
  //   for (var message in messages.docs) {
  //     print(message.data());
  //   }
  // }

  // void messagesStream() async {
  //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //     for (var message in snapshot.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.popUntil(
                    context, ModalRoute.withName(WelcomeScreen.screen_id));
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        messageText = value;
                      },
                      controller: controller,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                        "timestamp": FieldValue.serverTimestamp(),
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {

  getTime(unitMessage) {
    // Gets exact time in HOUR-MINUTE format
    Timestamp createdAt = unitMessage['timestamp'];
    if (createdAt == null) {
      return '';
    }
    DateTime createdAtDateTime = createdAt.toDate();
    var dayTimeFormat = DateFormat("yMMMd"); // 'jm' is HOUR-MINUTE format
    var exactTimeFormat = DateFormat("jm"); // 'jm' is HOUR-MINUTE format
    String dayDisplayTime =
    dayTimeFormat.format(createdAtDateTime); // 'May, 26, 2022'
    String hourMinuteDisplayTime =
    exactTimeFormat.format(createdAtDateTime); // Example: 12:31 PM

    return '$dayDisplayTime, $hourMinuteDisplayTime';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _firestore.collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        List<MessageBubble> messageBubbles = [];

        // TODO: Separate messages by day.
        final messages = snapshot.data.docs.reversed;
        for (var message in messages) {
          Map unitMessage = message.data();

          String text = unitMessage['text'];
          String sender = unitMessage['sender'];

          // Sets isMe property
          bool isMe = false;
          if (sender == loggedInUser.email) {
            isMe = true;
          }

          String exactDisplayTime = getTime(unitMessage);

          messageBubbles.add(MessageBubble(
              text: text, sender: sender, isMe: isMe, time: exactDisplayTime));
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}
