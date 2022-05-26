import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  static String screen_id = 'error_screen';
  final String error;
  final String predecessor_id;

  ErrorScreen({this.error = '', this.predecessor_id});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.blue[800],
            image: DecorationImage(
              image: AssetImage('images/error_image.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    padding: EdgeInsets.all(40),
                    color: Colors.blueGrey.withOpacity(0.8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Something went wrong. \nError: $error'
                          '\n\nThe email or password you provided may be wrong.'
                          '\n\nCheck Your internet and try again.',
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, predecessor_id);
                          },
                          child: Text('Go Back and Retry',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                              )),
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(10),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white70),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
