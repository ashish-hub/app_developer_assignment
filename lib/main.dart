import 'package:app_developer_assignment/HomeScreen/HomeScreenMethods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'LoginScreen/LoginScreenUI.dart';
import 'LoginScreen/LoginScreenMethods.dart';
import 'HomeScreen/HomeScreenUI.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(
    // using Provider for login state management
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginScreenMethods()),
        ChangeNotifierProvider(create: (context) => HomeScreenMethods()),
      ],
      //create: (context) => LoginScreenMethods(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // variable for helping in login process
  String? _userName = null;

  // to get username from shared preferences
  void autoLogIn() async {
    if (_userName != null) return;

    final prefs = await SharedPreferences.getInstance();
    final String? user = prefs.getString('userName');

    // if user is found in shared preferences reload the widget with _userName varibale set to username
    if (user != null) {
      setState(() {
        _userName = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // subscribe to changes in LoginScreenMethods class and reload widget when notifylisteners is called from LoginScreenMethods class members
    return Consumer<LoginScreenMethods>(builder: (context, login, child) {
      // check if user is stored in shared preferences
      autoLogIn();

      // if user is not logged in then go to login screen
      if (_userName == null)
        return MaterialApp(
          home: LoginScreen(),
        );

      // so that user can login again after logout without closing the app
      // username gets stored in LoginScreenMethods class till user is logged in for app lifecycle
      _userName = null;

      // if user is logged in go to home screen
      return MaterialApp(
        home: HomeScreen(),
      );
    });
  }
}
