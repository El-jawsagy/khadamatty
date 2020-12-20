import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:khadamatty/controller/utilites/api_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteMethodAPI {
  Future<String> addToFavorite(
    listingId,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String url = ApiPaths.addFavoriteItem(pref.get("UserId"), listingId);
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.get("token"),
    };

    var response = await http.get(url, headers: auth);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
    return null;
  }

  Future<List> getFavoriteItems() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = ApiPaths.favoriteUser(pref.get("UserId"));
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.getString("token"),
    };
    var response = await http.get(url, headers: auth);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
  }

  Future<String> removeFavorite(
    favoriteId,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = ApiPaths.removeFavoriteItem;
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.getString("token"),
    };

    Map<String, dynamic> body = {
      "id": favoriteId.toString(),
    };

    var response = await http.post(url, body: body, headers: auth);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
    return null;
  }

  Future<String> removeFavoriteFromProduct(
    favoriteId,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = ApiPaths.removeFavoriteItem;
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.getString("token"),
    };

    Map<String, dynamic> body = {
      "listing_id": favoriteId.toString(),
      "user_id": pref.get("UserId").toString(),
    };

    var response = await http.post(url, body: body, headers: auth);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
    return null;
  }
}
