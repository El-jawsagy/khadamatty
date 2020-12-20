import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:khadamatty/controller/utilites/api_paths.dart';

class CountriesAPI {
  Future<List> getCountries() async {
    String url = ApiPaths.getAllCountries;

    var response = await http.get(
      url,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
  }
}
