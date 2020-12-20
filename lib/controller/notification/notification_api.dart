import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:khadamatty/controller/utilites/api_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationMethodAPI {
  Future<List> getFavoriteItems() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = ApiPaths.notificationUser(pref.get("UserId"));
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.getString("token"),
    };
    var response = await http.get(url, headers: auth);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
  }
}
