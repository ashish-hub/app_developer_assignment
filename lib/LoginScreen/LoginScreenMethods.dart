import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

// EXTENDS CHANGENOTIFIER CLASS SO THAT OTHER WIDGETS CAN SUBSCRIBE TO IT FOR ANY CHANGES
class LoginScreenMethods extends ChangeNotifier {
  // STORE USERNAME TILL USER IS LOGGED IN AND FOR THE LIFECYCLE OF THE APP
  String? userName = null;

  // REMOVE USERNAME FROM SHARED PREFERENCES WHEN USER PRESSES LOGOUT
  void logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userName');
    userName = null;
    notifyListeners();
  }

  // SAVE USERS USERNAME IN SHARED PREFERENCES FOR LOGGING IN AUTOMATICALLY WHEN USER OPENS APP AGAIN
  void logIn(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', username);
    userName = username;
    notifyListeners();
  }

  // CHECK IF USERNAME ENTERED IS MATCHING THE GIVEN CONSTRAINTS
  String userNameCheck(String str) {
    if (str is! String) return "Username is empty";
    if (str.length < 3) return "Username must be atleast 3 character long";
    if (str.length > 10)
      return "Username must not be longer than 10 characters";
    return "true";
  }

  // CHECK IF PASSWORD ENTERED IS MATCHING THE GIVEN CONSTRAINTS
  String passwordCheck(String str) {
    if (str is! String) return "Password is empty";
    if (str.length < 3) return "Password must be atleast 3 character long";
    if (str.length > 11)
      return "Password must not be longer than 10 characters";
    return "true";
  }

  // FOR MOCKING USER DATABASE
  var userNamesAndPasswords = {
    '9898989898': 'password123',
    '9876543210': 'password123'
  };

  // CHECK IF USERNAME AND PASSWORD ENTERED ARE PRESENT IN OUR MOCK DATABASE
  String logInSubmit(String userName, String password) {
    if (!userNamesAndPasswords.containsKey(userName))
      return "Username Doesn't exists";
    if (userNamesAndPasswords[userName] != password)
      return "Wrong Password Entered";
    return "true";
  }
}
