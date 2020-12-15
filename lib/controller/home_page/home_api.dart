import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:khadamatty/controller/utilites/api_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarketAndCategoryApi {
  Future<List> getAllCategory() async {
    String url = ApiPaths.allCategory;
    var response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data'];
    }
    return null;
  }

  Future<List> getSingleCategory() async {
    String url = ApiPaths.categories();
    var response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data'];
    }
    return null;
  }

  Future<List> getSingleMarketSubcategory(categoryId) async {
    String url = ApiPaths.storeSubCategory(
      categoryId,
    );
    var response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data'];
    }
    return null;
  }

  Future<List> getSingleMarketCategoryProducts(categoryId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String url =
        ApiPaths.storeSubCategoryProduct(categoryId, pref.get("UserId"));
    var response = await http.get(
      url,
    );
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data'];
    }
    return null;
  }

  Future<Map> getSingleProduct(productId) async {
    String url = ApiPaths.singleAnnouncement(
      productId,
    );
    var response = await http.get(
      url,
    );
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data'];
    }
    return null;
  }
}

class ProductBloc {
  List products;

  int categoryId;

  final StreamController<List> _productsController =
      StreamController<List>.broadcast();

  final StreamController<int> _categoryController =
      StreamController<int>.broadcast();

  Stream<List> get productStream => _productsController.stream;

  StreamSink<int> get categoryIdSink => _categoryController.sink;

  Stream<int> get categoryIdStream => _categoryController.stream;
  MarketAndCategoryApi marketAndCategoryApi = MarketAndCategoryApi();

  ProductBloc() {
    products = [];
    _productsController.add(this.products);
    _categoryController.add(this.categoryId);
    _categoryController.stream.listen(_fetchProductsFromApi);
  }

  Future<void> _fetchProductsFromApi(int categoryId) async {
    this.products =
        await marketAndCategoryApi.getSingleMarketCategoryProducts(categoryId);
    _productsController.add(this.products);

  }

  void dispose() {
    _productsController.close();
    _categoryController.close();
  }
}
