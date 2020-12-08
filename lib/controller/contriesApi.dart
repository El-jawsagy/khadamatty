import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:khadamatty/controller/utilites/api_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountriesAPI {
  Future<List> getCountries() async {
    print("i'm here get Items");
    String url = ApiPaths.getAllCountries;

    var response = await http.get(
      url,
    );
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
  }
}
