import 'dart:developer';
import 'dart:ui';

import 'package:app_developer_assignment/HomeScreen/HomeScreenMethods.dart';
import 'package:app_developer_assignment/LoginScreen/LoginScreenMethods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = "";
  String _profileURL = "";
  String _score = "";
  String _played = "";
  String _won = "";
  String _prcnt = "";

  @override
  void initState() {
    var list =
        Provider.of<HomeScreenMethods>(context, listen: false).getUserInfo();
    _username = list[0];
    _profileURL = list[1];
    _score = list[2];
    _played = list[3];
    _won = list[4];
    _prcnt = list[5];

    Provider.of<HomeScreenMethods>(context, listen: false).fetchData();
    super.initState();
  }

  bool isLogout = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenMethods>(builder: (context, home, child) {
      bool isDataLoading =
          Provider.of<HomeScreenMethods>(context, listen: false).isDataLoading;
      return Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTapDown: (tap) {
              isLogout = !isLogout;
              setState(() {});
            },
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationX(math.pi),
              child: Icon(
                Icons.short_text_rounded,
                color: Colors.black,
                size: 40,
              ),
            ),
          ),
          title: Center(
              child: Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Text(
              'Flyingwolf',
              style: TextStyle(color: Colors.black),
            ),
          )),
        ),
        body: Stack(
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * .9,
                child: NotificationListener(
                  onNotification: (ScrollEndNotification t) {
                    if (t.metrics.pixels > 0 && t.metrics.atEdge) {
                      // IF YOU ARE AT THE END THEN LOAD DATA
                      Provider.of<HomeScreenMethods>(context, listen: false)
                          .isDataLoading = true;
                      setState(() {});
                      Provider.of<HomeScreenMethods>(context, listen: false)
                          .fetchData();
                    }
                    return true;
                  },
                  child: ListView.builder(
                    itemCount:
                        Provider.of<HomeScreenMethods>(context, listen: false)
                            .tournamentList
                            .length,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          children: [
                            UserInfo(
                              _username,
                              _profileURL,
                              _score,
                              _played,
                              _won,
                              _prcnt,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: TournamentCard(
                                Provider.of<HomeScreenMethods>(context,
                                        listen: false)
                                    .tournamentList[index]
                                    .name,
                                Provider.of<HomeScreenMethods>(context,
                                        listen: false)
                                    .tournamentList[index]
                                    .game_name,
                                Provider.of<HomeScreenMethods>(context,
                                        listen: false)
                                    .tournamentList[index]
                                    .cover_url,
                              ),
                            ),
                          ],
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: TournamentCard(
                          Provider.of<HomeScreenMethods>(context, listen: false)
                              .tournamentList[index]
                              .name,
                          Provider.of<HomeScreenMethods>(context, listen: false)
                              .tournamentList[index]
                              .game_name,
                          Provider.of<HomeScreenMethods>(context, listen: false)
                              .tournamentList[index]
                              .cover_url,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // CICULAR INDICATOR FOR DATA LOADING
            isDataLoading
                ? Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SizedBox(),

            // LOGOUT WIDGET
            isLogout
                ? Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: ClipRect(
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200.withOpacity(0.5)),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Provider.of<LoginScreenMethods>(context,
                                            listen: false)
                                        .logOut();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      border: Border.all(
                                          width: 3, color: Colors.black),
                                    ),
                                    child: Text('    Logout    ',
                                        style: TextStyle(
                                            fontSize: 40, color: Colors.black)
                                        //Theme.of(context).textTheme.display3
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      );
    });
  }
}

// IDEALLY BELOW WIDGETS SHOULD BE IN SEPERATE DART FILES OF GROUPED IN DIFFERENT FILES
// BUT SINCE THERE ARE ONLY TWO SCREENS THEREFORE MADE HERE ONLY

// MAKING A WIDGET FOR USER INFO
class UserInfo extends StatelessWidget {
//  const UserInfo({Key? key}) : super(key: key);

  String _name = "";
  String _profileURL = "";
  String _rating = "";
  String _played = "";
  String _won = "";
  String _prcnt = "";

  // DEFINING CONSTRUCTOR FOR USERINFO CLASS
  UserInfo(String name, String profileURL, String rating, String played,
      String won, String percentage) {
    _name = name;
    _profileURL = profileURL;
    _rating = rating;
    _played = played;
    _won = won;
    _prcnt = percentage;
  }

  @override
  Widget build(BuildContext context) {
    double _contextWidth = MediaQuery.of(context).size.width;

    // WHOLE PROFILE CONTAINER
    return Container(
      width: _contextWidth * .9,
      child: Column(
        children: [
          // PROFILE IMAGE, NAME, RATING BOX
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
            child: Row(
              children: [
                // PROFILE IMAGE BOX
                SizedBox(
                  width: _contextWidth * .25,
                  height: _contextWidth * .25,
                  child: ClipOval(
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/game_tv_Logo.jpg',
                      image: _profileURL,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                ),

                // NAME AND RATING COLUMN
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    children: [
                      // NAME
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _name,
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Text(""),

                      // RATING
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(40),
                          ),
                          border: Border.all(
                            color: Colors.blueAccent,
                            width: 2,
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(
                              _rating,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            Text("  Elo rating       "),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // RESULT CARDS BELOW
          SizedBox(
            width: MediaQuery.of(context).size.width * .9,
            child: Row(
              children: [
                ClipPath(
                  clipper: RoundedCorners(30, 0, 0, 30),
                  child: ResultCard(Colors.yellow, _played,
                      "Tournaments played", _contextWidth / 3.4),
                ),
                Spacer(),
                ResultCard(Colors.purple, _won, "Tournaments won",
                    _contextWidth / 3.4),
                Spacer(),
                ClipPath(
                  clipper: RoundedCorners(0, 30, 30, 0),
                  child: ResultCard(Colors.orange, _prcnt, "Winning percentage",
                      _contextWidth / 3.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// WIDGET FOR RESULT CARDS
class ResultCard extends StatelessWidget {
  //const ResultCard({Key? key}) : super(key: key);

  var _color = Colors.yellow;
  String _result = "";
  String _title = "";
  double _width = 0;
  double _height = 0;

  ResultCard(var color, String result, String title, double width) {
    _color = color;
    _result = result;
    _title = title;
    _width = width;
    _height = width * .8;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[_color.shade900, _color.shade400],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      width: _width,
      height: _height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: _height * .27,
              width: _width,
              child: Center(
                child: Text(
                  _result,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: _height * .55,
              width: _width,
              child: Center(
                child: Text(
                  _title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// MAKING A WIDGET FOR TOURNAMENT AND THEN POPULATE IT WITH GIVEN DATA
class TournamentCard extends StatelessWidget {
  String _name = "";
  String _game_name = "";
  String _cover_url = "";
  double _width = .9;
  double _height = .24;

  TournamentCard(String name, String game_name, String coverURL) {
    _name = name;
    _game_name = game_name;
    _cover_url = coverURL;
    _height = _width * .24 / .9;
  }

  @override
  Widget build(BuildContext context) {
    double contextHeight = MediaQuery.of(context).size.height;
    double contextWidth = MediaQuery.of(context).size.width;

    return ClipPath(
      clipper: RoundedCorners(30, 30, 30, 30),

      // WHOLE CONTAINER
      child: Container(
        color: Colors.white,
        height: contextHeight * _height,
        width: contextWidth * _width,
        child: Column(
          children: [
            // IMAGE CONTAINER
            SizedBox(
              //color: Colors.orange,
              height: contextHeight * _height * .6,
              width: contextWidth * _width,
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/game_tv_Logo.jpg',
                image: _cover_url,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),

            // NAME, GAME NAME AND ARROW CONTAINER
            GestureDetector(
              onTap: () {
                print("Tounamentcard tapped");
              },
              child: SizedBox(
                height: contextHeight * _height * .4,
                child: Row(
                  children: [
                    // NAME AND GAME NAME CONTAINER
                    SizedBox(
                      width: contextWidth * _width * .8,
                      child: Column(
                        children: [
                          // TOURNAMENT NAME CONTAINER
                          SizedBox(
                            //color: Colors.indigo,
                            height: contextHeight * _height * .4 * .5,
                            width: contextWidth * _width * .8,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 9, 15, 0),
                                child: Text(
                                  _name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // GAME NAME CONTAINER
                          SizedBox(
                            //color: Colors.yellow,
                            height: contextHeight * _height * .4 * .5,
                            width: contextWidth * _width * .8,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 9),
                                child: Text(
                                  _game_name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Spacer(),

                    // RIGHT ARROW CONTAINER
                    SizedBox(
                      //color: Colors.pink,
                      height: contextHeight * _height * .4,
                      width: contextWidth * _width * .1,
                      child: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// CREATE A CUSTOM WIDGET TO MAKE INDIVIDUAL CORNERS ROUNDED
class RoundedCorners extends CustomClipper<Path> {
  // VARIABLE FOR CHANGING CORNERS RADIUS
  double _upperLeft = 5;
  double _upperRight = 10;
  double _lowerRight = 15;
  double _lowerLeft = 20;

  // ASSIGINING CORENER VARIABLES THEIR VALUES IN CONSTRUCTOR
  RoundedCorners(double upperLeft, double upperRight, double lowerRight,
      double lowerLeft) {
    _upperLeft = upperLeft;
    _upperRight = upperRight;
    _lowerRight = lowerRight;
    _lowerLeft = lowerLeft;
  }
  @override
  getClip(Size size) {
    // MAKING A CUSTOM WITH VARIABLES TO CHANGE RADIUS OF CORNERS INDIVIDUALLY
    Path path = Path()
      ..moveTo(_upperLeft, 0)
      ..lineTo(size.width - _upperRight, 0)
      ..quadraticBezierTo(size.width, 0, size.width, _upperRight)
      ..lineTo(size.width, size.height - _lowerRight)
      ..quadraticBezierTo(
          size.width, size.height, size.width - _lowerRight, size.height)
      ..lineTo(_lowerLeft, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - _lowerLeft)
      ..lineTo(0, _upperLeft)
      ..quadraticBezierTo(0, 0, _upperLeft, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}
