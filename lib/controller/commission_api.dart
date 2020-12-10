import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:khadamatty/controller/utilites/api_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommissionAPI {
  Future<List> getAllBanks() async {
    String url = ApiPaths.allBanks;
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

  Future<String> getCommissionValue(lang) async {
    String url = ApiPaths.commissionValue(lang);
    var response = await http.get(
      url,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data'][0]["title"];
    }
    return null;
  }

  Future<String> sendBankTransfer(
    userName,
    amount,
    bankName,
    data,
    transferName,
    transferPhone,
    adName,
    notes,
    File image,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String url = ApiPaths.commission;
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.getString("token"),
    };
    FormData formData;

    if (image != null) {
      String fileName = image.path.split('/').last;

      formData = FormData.fromMap({
        'user_id': pref.get("UserId"),
        'username': userName,
        'cost': amount,
        'bank': bankName,
        'date': data,
        'transfer_username': transferName,
        'transfer_number': transferPhone,
        'ad_name': adName,
        'notes': notes,
        "image": await MultipartFile.fromFile(image.path, filename: fileName),
      });
    } else {
      formData = FormData.fromMap({
        'user_id': pref.get("UserId"),
        'username': userName,
        'cost': amount,
        'bank': bankName,
        'date': data,
        'transfer_username': transferName,
        'transfer_number': transferPhone,
        'ad_name': adName,
        'notes': notes,
      });
    }
    print(formData.files);
    print(formData.fields);

    var response =
        await Dio().post(url, data: formData, options: Options(headers: auth));
    print(response.data);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = response.data;
      var map = data['data'];
      return map;
    }
    return null;
  }
}
