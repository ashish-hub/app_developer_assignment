import 'package:app_developer_assignment/LoginScreen/LoginScreenMethods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // variable to pass username and password to login function
  String _userName = "";
  String _password = "";

  // variables for managing color and text of button and textfield
  bool isUserNameCorrect = false;
  bool isPasswordCorrect = false;

  String userError = "Fill Username and Password to Continue";
  String passError = "Fill Username and Password to Continue";
  String submitError = "Submit";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Image(
                image: AssetImage('assets/game_tv_Logo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: TextField(
                onChanged: (str) {
                  String checkUserName =
                      Provider.of<LoginScreenMethods>(context, listen: false)
                          .userNameCheck(str);
                  if (checkUserName == "true")
                    setState(() {
                      isUserNameCorrect = true;
                      _userName = str;
                      submitError = "Submit";
                    });
                  else
                    setState(() {
                      isUserNameCorrect = false;
                      _userName = str;
                      userError = checkUserName;
                      submitError = "Submit";
                    });
                },
                decoration: InputDecoration(
                  hintText: "Enter Username",
                  icon: Icon(
                    Icons.verified,
                    color: isUserNameCorrect ? Colors.green : Colors.grey,
                  ),
                ),
                style: TextStyle(
                    color: isUserNameCorrect ? Colors.black : Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: TextField(
                onChanged: (str) {
                  String checkPassword =
                      Provider.of<LoginScreenMethods>(context, listen: false)
                          .passwordCheck(str);
                  if (checkPassword == "true")
                    setState(() {
                      isPasswordCorrect = true;
                      _password = str;
                      submitError = "Submit";
                    });
                  else
                    setState(() {
                      isPasswordCorrect = false;
                      _password = str;
                      passError = checkPassword;
                      submitError = "Submit";
                    });
                },
                obscureText: true,
                obscuringCharacter: "*",
                decoration: InputDecoration(
                  hintText: "Enter Password",
                  icon: Icon(
                    Icons.lock,
                    color: isPasswordCorrect ? Colors.green : Colors.grey,
                  ),
                ),
                style: TextStyle(
                    color: isPasswordCorrect ? Colors.black : Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
              child: ElevatedButton(
                onPressed: () {
                  if (!(isUserNameCorrect && isPasswordCorrect)) return;
                  String checkSubmit =
                      Provider.of<LoginScreenMethods>(context, listen: false)
                          .logInSubmit(_userName, _password);

                  if (checkSubmit == "true")
                    Provider.of<LoginScreenMethods>(context, listen: false)
                        .logIn(_userName, _password);

                  setState(() {
                    submitError = checkSubmit;
                    return;
                  });
                },
                child: Text(isUserNameCorrect
                    ? (isPasswordCorrect ? submitError : passError)
                    : userError),
                style: ElevatedButton.styleFrom(
                  primary: isPasswordCorrect && isUserNameCorrect
                      ? Colors.green
                      : Colors.grey,
                  onPrimary: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
