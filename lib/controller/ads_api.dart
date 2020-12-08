import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:khadamatty/controller/utilites/api_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdsAPI {
  Future<Map> getInfo() async {
    print("i'm here get Items");
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = ApiPaths.getTagsAndCategory;
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.getString("token"),
    };
    var response = await http.get(url, headers: auth);
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
  }

  Future<String> UploadAnnouncement(
    name,
    shortDescription,
    country,
    tags,
    description,
    categoryId,
    subCategoryId,
    phone,
    File image,
    File imageOne,
    File imageTwo,
    File imageThree,
    File imageFour,
    File imageFive,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<MultipartFile> results = [];

    String url = ApiPaths.uploadAnnouncement;

    String fileName = image.path.split('/').last;
    if (imageOne != null) {
      String fileName = imageOne.path.split('/').last;
      results.add(await MultipartFile.fromFile(
        imageOne.path,
        filename: fileName,
      ));
    }
    if (imageTwo != null) {
      String fileName = imageTwo.path.split('/').last;
      results.add(await MultipartFile.fromFile(
        imageTwo.path,
        filename: fileName,
      ));
    }
    if (imageThree != null) {
      String fileName = imageThree.path.split('/').last;
      results.add(await MultipartFile.fromFile(
        imageThree.path,
        filename: fileName,
      ));
    }
    if (imageFour != null) {
      String fileName = imageFour.path.split('/').last;
      results.add(await MultipartFile.fromFile(
        imageFour.path,
        filename: fileName,
      ));
    }
    if (imageFive != null) {
      String fileName = imageFive.path.split('/').last;
      results.add(await MultipartFile.fromFile(
        imageFive.path,
        filename: fileName,
      ));
    }

    print("iam here");

    FormData formData = FormData.fromMap({
      'user_id': pref.get("UserId").toString(),
      'category': categoryId.toString(),
      'sub_category': subCategoryId,
      'country': country.toString(),
      'name': name,
      'phone': phone,
      'sm_description': shortDescription,
      'description': description,
      "tags": tags,
      "image": await MultipartFile.fromFile(image.path, filename: fileName),
      "images": results
    });

    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.getString("token"),
    };

    print(formData.fields);
    print(formData.files);
    Response response =
        await Dio().post(url, data: formData, options: Options(headers: auth));
    var data = response.data;
    print(data['data']);
    if (response.statusCode == 200) {
      return data['data'];
    }
  }

  Future<String> UpdateAnnouncement(
    id,
    categoryId,
    subCategoryId,
    name,
    phone,
    shortDescription,
    description,
    tags,
    country,
    List oldImages,
    File image,
    File imageOne,
    File imageTwo,
    File imageThree,
    File imageFour,
    File imageFive,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<MultipartFile> results = [];
    List editedImages = [];
    for (var i in oldImages) {
      editedImages.add(i.split('/').last);
    }
    print(editedImages);
    String url = ApiPaths.updataAnnouncement;
    String fileName;
    if (image != null) {
      fileName = image.path.split('/').last;
    }

    if (imageOne != null) {
      String fileName = imageOne.path.split('/').last;
      results.add(await MultipartFile.fromFile(
        imageOne.path,
        filename: fileName,
      ));
    }
    if (imageTwo != null) {
      String fileName = imageTwo.path.split('/').last;
      results.add(await MultipartFile.fromFile(
        imageTwo.path,
        filename: fileName,
      ));
    }
    if (imageThree != null) {
      String fileName = imageThree.path.split('/').last;
      results.add(await MultipartFile.fromFile(
        imageThree.path,
        filename: fileName,
      ));
    }
    if (imageFour != null) {
      String fileName = imageFour.path.split('/').last;
      results.add(await MultipartFile.fromFile(
        imageFour.path,
        filename: fileName,
      ));
    }
    if (imageFive != null) {
      String fileName = imageFive.path.split('/').last;
      results.add(await MultipartFile.fromFile(
        imageFive.path,
        filename: fileName,
      ));
    }
    FormData formData;
    print("iam here");
    if (image != null) {
      formData = FormData.fromMap({
        'listing_id': id,
        'user_id': pref.get("UserId").toString(),
        'category': categoryId.toString(),
        'sub_category': subCategoryId,
        'country': country,
        'name': name,
        'phone': phone,
        'sm_description': shortDescription,
        'description': description,
        "tags": tags,
        "old_images": editedImages,
        "image": await MultipartFile.fromFile(image.path, filename: fileName),
        "images": results
      });
    } else {
      formData = FormData.fromMap({
        'listing_id': id,
        'user_id': pref.get("UserId").toString(),
        'category': categoryId.toString(),
        'sub_category': subCategoryId,
        'country': country,
        'name': name,
        'phone': phone,
        'sm_description': shortDescription,
        'description': description,
        "tags": tags,
        "old_images": editedImages,
        "images": results
      });
    }
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.getString("token"),
    };

    print(formData.fields);
    print(formData.files);
    Response response =
        await Dio().post(url, data: formData, options: Options(headers: auth));
    var data = response.data;
    print(data['data']);
    if (response.statusCode == 200) {
      return data['data'];
    }
  }

  Future<List> searchListing(query) async {
    print("i'm here get Items");
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = ApiPaths.searchAdds(query);
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.getString("token"),
    };
    var response = await http.get(url, headers: auth);
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
    return null;
  }

  Future<String> removeListing(id) async {
    print("i'm here get Items");
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = ApiPaths.removeListing;

    Map<String, dynamic> body = {
      'listing_id': id.toString(),
    };

    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.getString("token"),
    };
    var response = await http.post(url, body: body, headers: auth);
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
    return null;
  }

  Future<String> addComment(listingId, listingUserId, massage) async {
    print("i'm here get Items");
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = ApiPaths.addStoreComment;
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.getString("token"),
    };
    Map<String, dynamic> body = {
      'listing_id': listingId.toString(),
      'user_id': pref.get("UserId").toString(),
      'listing_user': listingUserId.toString(),
      'comment': massage,
    };
    print(body);

    var response = await http.post(url, body: body, headers: auth);
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
    return null;
  }
}
