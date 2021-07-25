import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class HomeScreenMethods extends ChangeNotifier {
  bool isDataLoading = true;

  // MOCKING GET USER INGO API
  getUserInfo() {
    return [
      "Simon Barker",
      "https://cdn.game.tv/game-tv-content/images_3/6d4fbbed2afe8b4ac3c54eb0552cf69b/Banners.jpg",
      "2250",
      "34",
      "09",
      "26%"
    ];
  }

  String url =
      'http://tournaments-dot-game-tv-prod.uc.r.appspot.com/tournament/api/tournaments_list_v2?limit=10&status=all';

  List<Tournament> tournamentList = [];
  String cursor = "";

  fetchData() async {
    var response;
    if (cursor == "")
      response = await http.get(Uri.parse(url));
    else
      response = await http.get(Uri.parse(url + '&cursor=$cursor'));

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      // UPDATE CURSOR WITH NEW VALUE OF CURSOR
      this.cursor = json['data']['cursor'];
      print(cursor);
      for (int i = 0; i < 10; i++) {
        tournamentList.add(Tournament(json['data']['tournaments'][i]));
      }

      // AFTER ADDING DATA TO TOURNAMENT LIST CALL WIDGET
      this.isDataLoading = false;
      notifyListeners();
    } else {
      throw Exception('Failed to load Data');
    }
  }
}

// TOURNAMENT CLASS TO ADD TO LIST
class Tournament {
  String name = "";
  String cover_url = "";
  String game_name = "";

  Tournament(json) {
    this.name = json['name'];
    this.cover_url = json['cover_url'];
    this.game_name = json['game_name'];
  }
}
