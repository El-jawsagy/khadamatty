import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:khadamatty/controller/utilites/api_paths.dart';

class AboutAndTermsOfUseAPI {
  Future<String> getInformationAboutUs(lang) async {
    String url = ApiPaths.aboutUs(lang);
    var response = await http.get(
      url,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var map = data['data'];
      return map;
    }
    return null;
  }

  Future<List> getTermsOfUse(lang) async {
    String url = ApiPaths.termsOfUse(lang);
    var response = await http.get(
      url,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data'];
    }
    return null;
  }

  Future<String> sendContactUs(name, phone, message, email) async {
    String url = ApiPaths.contactUs;
    Map<String, dynamic> body = {
      'name': name,
      'phone': phone,
      'message': message,
      'email': email,
      "title": "Contact us",
    };
    print(body);
    var response = await http.post(url, body: body);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var map = data['data'];
      return map;
    }
    return null;
  }

  Future<List> getDiscount(lang) async {
    String url = ApiPaths.discount(lang);
    var response = await http.get(
      url,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(response.body);
      return data['data'];
    }
    return null;
  }
}
