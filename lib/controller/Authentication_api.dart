import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:khadamatty/controller/utilites/api_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  Future<String> login(email, password) async {
    String url = ApiPaths.login;
    Map<String, dynamic> postBody = {
      'email': email,
      'password': password,
    };
    var response = await http.post(url, body: postBody);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      switch (data['data']) {
        case "email wrong":
        case "password wrong":
          return data['data'];
          break;

        default:
          if (data['data']['token'].length > 50) {
            setEmail(email);
            setName(data['data']['name']);
            setPhoto(data['data']['image']);
            setId(data['data']["id"]);
            setToken(data['data']['token']);
            setCountry(data['data']["country"]);
          }
          return data['data']['token'];

          break;
      }
    }
  }

  Future<String> signUp(
      countryId, name, phone, email, password, File image) async {
    String url = ApiPaths.signUp;
    FormData formData;
    if (image != null) {
      String fileName = image.path.split('/').last;

      formData = FormData.fromMap({
        'country': countryId,
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        "image": await MultipartFile.fromFile(image.path, filename: fileName),
      });
    } else {
      formData = FormData.fromMap({
        'country': countryId,
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      });
    }
    Response response = await Dio().post(
      url,
      data: formData,
    );

    if (response.statusCode == 200) {
      var data = response.data;

      switch (data['data']) {
        case "email exist":
        case "name exist":
          return data['data'];
          break;

        default:
          if (data['data']['token'].length > 50) {
            setEmail(email);
            setName(data['data']['name']);
            setPhoto(data['data']['image']);
            setId(data['data']["id"]);
            setToken(data['data']['token']);
            setCountry(data['data']["country"]);
          }
          return data['data']['token'];

          break;
      }
    }
  }

  Future<String> updateUser(
    id,
    country,
    name,
    email,
    phone,
    oldPassword,
    newPassword,
    File image,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String url = ApiPaths.updateProfile;
    FormData formData;
    Map<String, String> auth = {
      'Authorization': "Bearer " + preferences.getString("token"),
    };
    if (image != null) {
      String fileName = image.path.split('/').last;

      formData = FormData.fromMap({
        'country': country,
        'name': name,
        'email': email,
        'old_password': oldPassword,
        'new_password': newPassword,
        'phone': phone,
        "image": await MultipartFile.fromFile(image.path, filename: fileName),
      });
    } else {
      formData = FormData.fromMap({
        'country': country,
        'name': name,
        'email': email,
        'old_password': oldPassword,
        'new_password': newPassword,
        'phone': phone,
      });
    }
    var response =
        await Dio().post(url, data: formData, options: Options(headers: auth));
    if (response.statusCode == 200) {
      var data = response.data;
      switch (data['data']) {
        case "email exist":
          return "email exist";
          break;
        case "phone exist":
          return "phone exist";
          break;
        case "old password wrong":
          return "old password wrong";
          break;
        case "user not exist":
          return "user not exist";
          break;
        default:
          setEmail(email);
          setName(data['data']['name']);
          setPhoto(data['data']['image']);
          setCountry(data['data']['country']);
          return "true";
          break;
      }
    }
  }

  Future<Map> getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = ApiPaths.getUser;
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.getString("token"),
    };

    var response = await http.get(url, headers: auth);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return data['data'];
    }
  }
}

setToken(String token) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("token", token);
}

setId(int id) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setInt("UserId", id);
}

setEmail(String email) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("email", email);
}

setName(String name) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("name", name);
}

setPhoto(String image) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("photo", image);
}

setCountry(String country) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("categoryId", country);
}
