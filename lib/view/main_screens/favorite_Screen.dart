import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khadamatty/controller/favorite/favorite_items_and_api.dart';
import 'package:khadamatty/controller/lang/applocate.dart';
import 'package:khadamatty/view/drawer.dart';
import 'package:khadamatty/view/product/product_screen.dart';
import 'package:khadamatty/view/utilites/popular_widget.dart';
import 'package:khadamatty/view/utilites/prefrences.dart';
import 'package:khadamatty/view/utilites/theme.dart';

import '../Auth/login_screen.dart';

class FavoriteScreen extends StatefulWidget {
  String token;

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  FavoriteMethodAPI favoriteMethodAPI;

  @override
  void initState() {
    favoriteMethodAPI = FavoriteMethodAPI();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: sameDrawer(context),
      body: FutureBuilder(
          future: Preference.getToken(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder(
                  future: favoriteMethodAPI.getFavoriteItems(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Center(
                            child: Text(
                          AppLocale.of(context).getTranslated("lang") == 'En'
                              ? "لم تختار أي عنصر حتى الآن"
                              : "You haven't taken any item yet",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ));
                        break;
                      case ConnectionState.waiting:
                        return loading(context, 1);

                        break;
                      case ConnectionState.active:
                      case ConnectionState.done:

                        if (snapshot.hasData) {
                          return snapshot.data.length > 0
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder: (context, pos) {
                                    return getExpanded(
                                        size, snapshot.data[pos]);
                                  },
                                  itemCount: snapshot.data.length,
                                )
                              : Center(
                                  child: Text(
                                    AppLocale.of(context)
                                                .getTranslated("lang") ==
                                            'En'
                                        ? "لم تختار أي عنصر حتى الآن"
                                        : "You haven't taken any item yet",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                );
                        }
                        else {
                          if (!snapshot.hasData) {
                            return emptyPage(context, () {
                              setState(() {});
                            });
                          } else {
                            return Center(
                                child: Text(
                              AppLocale.of(context).getTranslated("lang") ==
                                      'En'
                                  ? "لم تختار أي عنصر حتى الآن"
                                  : "You haven't taken any item yet",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: CustomColors.dark),
                            ));
                          }
                        }
                    }

                    return loading(context, 1);
                  });
            } else
              return Center(
                child: _drawLoginButton(size),
              );
          }),
    );
  }

  Widget _drawLoginButton(size) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.76,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image.asset(
              "assets/images/lock.png",
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.2,
            ),
          ),
          SizedBox(height: size.height * 0.1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FlatButton(
              height: MediaQuery.of(context).size.height * .06,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text(
                AppLocale.of(context).getTranslated("log"),
                style: TextStyle(
                  color: CustomColors.primary,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(
                  color: CustomColors.primary,
                  style: BorderStyle.solid,
                  width: 2,
                ),
              ),
              minWidth: MediaQuery.of(context).size.width,
            ),
          ),
        ],
      ),
    );
  }

  Widget getExpanded(
    Size size,
    Map map,
  ) {
    ValueNotifier<bool> stateOfRemove = ValueNotifier(false);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: size.width,
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailsScreen(map["listing"]),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2.0, vertical: 4),
                            child: Text(
                              map["listing"]["name"],
                              style: TextStyle(
                                fontSize: 20,
                                color: CustomColors.darkTow,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 4),
                            child: Container(
                              padding: EdgeInsets.all(3),
                              color: CustomColors.primary,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.map,
                                    color: CustomColors.white,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    map["listing"]["country"],
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: CustomColors.white),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: CustomColors.primary,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  map["listing"]["username"],
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: CustomColors.primary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: CustomColors.primary,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  map["listing"]["diff"],
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: CustomColors.primary),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2),
                            child: Row(
                              children: [
                                Text(
                                  AppLocale.of(context).getTranslated("lang") ==
                                          'En'
                                      ? "قسم :"
                                      : "section :",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: CustomColors.dark,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  width: size.width * 0.3,
                                  child: Text(
                                    AppLocale.of(context)
                                                .getTranslated("lang") ==
                                            "En"
                                        ? map["listing"]["category_ar"]
                                        : map["listing"]["category_en"],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: CustomColors.primary,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          width: size.width * 0.45,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                            child: Container(
                              height: size.height * .28,
                              width: size.width * .27,
                              child: map["listing"]['image'] == null
                                  ? Image.asset(
                                      "assets/images/car.jpg",
                                      fit: BoxFit.cover,
                                    )
                                  : Image(
                                      loadingBuilder: (context, image,
                                          ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null) {
                                          return image;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                      image: NetworkImage(
                                        map["listing"]['image'],
                                      ),
                                      fit: BoxFit.fitWidth,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(
                    color: CustomColors.gray,
                    height: 2,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: stateOfRemove,
                      builder:
                          (BuildContext context, bool value, Widget child) {
                        return stateOfRemove.value
                            ? SizedBox(
                                height: size.height * 0.05,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: CustomColors.white,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        CustomColors.redLightFont),
                                    strokeWidth: 2.0,
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  stateOfRemove.value = true;

                                  favoriteMethodAPI
                                      .removeFavorite(map["id"])
                                      .then((value) {
                                    setState(() {});
                                    final snackBar = SnackBar(
                                      backgroundColor:
                                          CustomColors.primaryHover,
                                      content: Text(
                                        AppLocale.of(context)
                                                    .getTranslated("lang") ==
                                                "En"
                                            ? "تمت إزالة إعلانك من قائمة المفضلة"
                                            : 'Your advertising removed from your favorites list',
                                        style: TextStyle(
                                            color: CustomColors.primary),
                                      ),
                                      duration: Duration(seconds: 3),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: CustomColors.red,
                                  ),
                                  height: size.height * 0.05,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.times,
                                          color: CustomColors.white,
                                          size: 22,
                                        ),
                                        SizedBox(
                                          width: size.width * 0.02,
                                        ),
                                        Text(
                                          AppLocale.of(context)
                                                      .getTranslated("lang") ==
                                                  "En"
                                              ? "ازالة من المفضلة"
                                              : "Remove from Favorites",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: CustomColors.white,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          width: size.width * 0.02,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
