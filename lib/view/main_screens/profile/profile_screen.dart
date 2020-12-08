import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khadamatty/controller/Authentication_api.dart';
import 'package:khadamatty/controller/ads_api.dart';
import 'package:khadamatty/controller/contriesApi.dart';
import 'package:khadamatty/controller/lang/applocate.dart';
import 'package:khadamatty/view/Auth/login_screen.dart';
import 'package:khadamatty/view/drawer.dart';
import 'package:khadamatty/view/main_screens/profile/editProfile.dart';
import 'package:khadamatty/view/product/edit_ads.dart';
import 'package:khadamatty/view/product/product_screen.dart';
import 'package:khadamatty/view/utilites/painter.dart';
import 'package:khadamatty/view/utilites/popular_widget.dart';
import 'package:khadamatty/view/utilites/prefrences.dart';
import 'package:khadamatty/view/utilites/theme.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  Authentication authentication;
  AdsAPI adsAPI;
  CountriesAPI countriesAPI;

  @override
  void initState() {
    countriesAPI = CountriesAPI();
    authentication = Authentication();
    adsAPI = AdsAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Colors.transparent,
      drawer: sameDrawer(context),
      body: FutureBuilder(
          future: Preference.getToken(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder(
                  future: authentication.getUser(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
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
                          print("i'm here waiting");
                          return loading(context, 1);

                          break;
                        case ConnectionState.active:
                        case ConnectionState.done:
                          print("i'm here done");

                          if (snapshot.hasData) {
                            print(snapshot.data);

                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    height: size.height * 0.17,
                                    width: size.width,
                                    child: Stack(
                                      children: [
                                        CustomPaint(
                                          painter: AppLocale.of(context)
                                                      .getTranslated("lang") ==
                                                  "En"
                                              ? BackGround()
                                              : BackGroundEn(),
                                          child: Container(
                                            height: size.height,
                                            width: size.width,
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: size.height * 0.025,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children: [
                                                    IconButton(
                                                        icon: FaIcon(
                                                          FontAwesomeIcons.cog,
                                                          color: CustomColors
                                                              .white,
                                                        ),
                                                        onPressed: () async {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => EditProfileScreen(
                                                                      snapshot
                                                                          .data,
                                                                      AppLocale.of(
                                                                              context)
                                                                          .getTranslated(
                                                                              "lang"))));
                                                        })
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          snapshot
                                                              .data["username"],
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: CustomColors
                                                                .white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: size.height *
                                                              0.008,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              AppLocale.of(context)
                                                                          .getTranslated(
                                                                              "lang") ==
                                                                      "En"
                                                                  ? "تاريخ الانضمام :"
                                                                  : "The date of join :",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color:
                                                                    CustomColors
                                                                        .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.01,
                                                            ),
                                                            Text(
                                                              snapshot.data[
                                                                  "created_at"],
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color:
                                                                    CustomColors
                                                                        .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: size.width * 0.01,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors
                                                              .transparent),
                                                      child: ClipOval(
                                                        child: (snapshot.data[
                                                                        "image"] ==
                                                                    null ||
                                                                snapshot.data[
                                                                        "image"] ==
                                                                    '')
                                                            ? Image.asset(
                                                                'assets/images/person.png',
                                                                width:
                                                                    size.width *
                                                                        .3,
                                                                height:
                                                                    size.height *
                                                                        .1,
                                                              )
                                                            : Image(
                                                                loadingBuilder:
                                                                    (context,
                                                                        image,
                                                                        ImageChunkEvent
                                                                            loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null) {
                                                                    return image;
                                                                  }
                                                                  return Center(
                                                                    child:
                                                                        CircularProgressIndicator(),
                                                                  );
                                                                },
                                                                image: NetworkImage(
                                                                    snapshot.data[
                                                                        "image"],
                                                                    scale: 1.0),
                                                                width:
                                                                    size.width *
                                                                        .3,
                                                                height:
                                                                    size.height *
                                                                        .1,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppLocale.of(context)
                                                    .getTranslated("lang") ==
                                                "En"
                                            ? "الأعلانات المضافه"
                                            : "Added ads",
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: CustomColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, pos) {
                                      return getExpanded(
                                          size, snapshot.data['listings'][pos]);
                                    },
                                    itemCount: snapshot.data['listings'].length,
                                  ),
                                ],
                              ),
                            );
                          }
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
    ValueNotifier<bool> stateOfEdit = ValueNotifier(false);

    return Container(
      width: size.width,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                      builder: (context) => ProductDetailsScreen(map),
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
                            map["name"],
                            style: TextStyle(
                              fontSize: 18,
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
                              horizontal: 4.0, vertical: 2),
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
                                  map["country"],
                                  style: TextStyle(
                                      fontSize: 14, color: CustomColors.white),
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
                                map["username"],
                                style: TextStyle(
                                    fontSize: 14, color: CustomColors.primary),
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
                                map["diff"],
                                style: TextStyle(
                                    fontSize: 14, color: CustomColors.primary),
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
                                  AppLocale.of(context).getTranslated("lang") ==
                                          "En"
                                      ? map["category_ar"]
                                      : map["category_en"],
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
                      height: 5,
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
                            child: map['image'] == null
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
                                      map['image'],
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
                    valueListenable: stateOfEdit,
                    builder: (BuildContext context, value, Widget child) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: CustomColors.warning,
                        ),
                        height: size.height * 0.05,
                        width: size.width * 0.32,
                        child: stateOfEdit.value
                            ? SizedBox(
                                height: size.height * 0.025,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: CustomColors.white,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        CustomColors.ratingLightFont),
                                    strokeWidth: 2.0,
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () async {
                                  stateOfEdit.value = true;

                                  final snackBar = SnackBar(
                                      duration: Duration(
                                          seconds: 1, milliseconds: 500),
                                      backgroundColor:
                                          CustomColors.primaryHover,
                                      content: Text(
                                        AppLocale.of(context)
                                                    .getTranslated("lang") ==
                                                'En'
                                            ? "يتم تحميل الاقسام الرئيسية برجاء الانتظار.."
                                            : "Main sections are loaded, please wait ...",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: CustomColors.primary),
                                      ));

                                  _scaffoldkey.currentState
                                      .showSnackBar(snackBar);
                                  await adsAPI.getInfo().then((value) {
                                    print(value);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditAddAnnouncementScreen(
                                                    map,
                                                    value,
                                                    AppLocale.of(context)
                                                        .getTranslated(
                                                            "lang"))));
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.cog,
                                        color: CustomColors.white,
                                        size: 24,
                                      ),
                                      SizedBox(
                                        width: size.width * 0.01,
                                      ),
                                      Text(
                                        AppLocale.of(context)
                                                    .getTranslated("lang") ==
                                                "En"
                                            ? "تعديل"
                                            : "Edit",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: CustomColors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: stateOfRemove,
                    builder: (BuildContext context, value, Widget child) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: CustomColors.red,
                        ),
                        height: size.height * 0.05,
                        width: size.width * 0.32,
                        child: stateOfRemove.value
                            ? SizedBox(
                                height: size.height * 0.025,
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
                                  adsAPI.removeListing(map["id"]).then((value) {
                                    if (value == "true") {
                                      setState(() {});
                                      final snackBar = SnackBar(
                                        backgroundColor:
                                            CustomColors.primaryHover,
                                        content: Text(
                                          AppLocale.of(context)
                                                      .getTranslated("lang") ==
                                                  "En"
                                              ? "تمت إزالة إعلانك "
                                              : 'Your advertising removed',
                                          style: TextStyle(
                                              color: CustomColors.primary),
                                        ),
                                        duration: Duration(
                                            seconds: 1, milliseconds: 500),
                                      );
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      final snackBar = SnackBar(
                                        backgroundColor:
                                            CustomColors.ratingLightBG,
                                        content: Text(
                                          AppLocale.of(context)
                                                      .getTranslated("lang") ==
                                                  "En"
                                              ? "لم يكتمل عملية إزالة إعلانك من فضلك تاكد من الاتصال بالانترنت و حاول مجدد.."
                                              : "The process of removing your ad did not complete. Please make sure that you are connected to the Internet and try again ..",
                                          style: TextStyle(
                                            color: CustomColors.ratingLightFont,
                                          ),
                                        ),
                                        duration: Duration(seconds: 3),
                                      );
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.times,
                                        color: CustomColors.white,
                                        size: 24,
                                      ),
                                      SizedBox(
                                        width: size.width * 0.01,
                                      ),
                                      Text(
                                        AppLocale.of(context)
                                                    .getTranslated("lang") ==
                                                "En"
                                            ? "ازالة"
                                            : "Remove",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: CustomColors.white,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
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
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
