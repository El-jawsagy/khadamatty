import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khadamatty/controller/ads_api.dart';
import 'package:khadamatty/controller/favorite/favorite_items_and_api.dart';
import 'package:khadamatty/controller/lang/applocate.dart';
import 'package:khadamatty/view/Auth/login_screen.dart';
import 'package:khadamatty/view/Auth/register_screen.dart';
import 'package:khadamatty/view/drawer.dart';
import 'package:khadamatty/view/utilites/prefrences.dart';
import 'package:khadamatty/view/utilites/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsScreen extends StatefulWidget {
  Map singleAnnouncement;

  ProductDetailsScreen(this.singleAnnouncement);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  PageController _controller;
  ValueNotifier<double> posOfProducts;
  ValueNotifier<bool> fav;

  IconData icon;

  FavoriteMethodAPI favoriteMethodAPI;
  final GlobalKey<ScaffoldState> _productScreenScaffoldkey =
      new GlobalKey<ScaffoldState>();
  AdsAPI adsAPI;

  @override
  void initState() {
    fav = ValueNotifier(widget.singleAnnouncement["favourite"]);
    posOfProducts = ValueNotifier(1);
    _controller = PageController(
      initialPage: posOfProducts.value.floor(),
    );
    favoriteMethodAPI = FavoriteMethodAPI();
    adsAPI = AdsAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _productScreenScaffoldkey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.singleAnnouncement["name"],
          style: TextStyle(color: CustomColors.primary, fontSize: 24),
        ),
        iconTheme: IconThemeData(color: CustomColors.primary),
        actions: [
          ValueListenableBuilder(
            valueListenable: fav,
            builder: (BuildContext context, value, Widget child) {
              icon = fav.value ? Icons.favorite : Icons.favorite_border;

              return IconButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var token = prefs.getString("token");
                  if (token == null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  } else {
                    final snackBar = SnackBar(
                      backgroundColor: CustomColors.primaryHover,
                      content: Text(
                        AppLocale.of(context).getTranslated("lang") == "En"
                            ? "يتم التواصل مع السيرفر الان. برجاء الانتظار.."
                            : "We are communicating with the server now. Please wait ...",
                        style: TextStyle(color: CustomColors.primary),
                      ),
                      duration: Duration(seconds: 1, milliseconds: 500),
                    );
                    _productScreenScaffoldkey.currentState
                        .showSnackBar(snackBar);
                    if (!fav.value) {
                      favoriteMethodAPI
                          .addToFavorite(
                        widget.singleAnnouncement['id'],
                      )
                          .then((value) {
                        final snackBar = SnackBar(
                          backgroundColor: CustomColors.primaryHover,
                          content: Text(
                            AppLocale.of(context).getTranslated("lang") == "En"
                                ? "تمت اضافة إعلانك الي المفضلة بنجاح.."
                                : "Your ad has been successfully added to your favorites ..",
                            style: TextStyle(color: CustomColors.primary),
                          ),
                          duration: Duration(seconds: 1, milliseconds: 500),
                        );
                        _productScreenScaffoldkey.currentState
                            .showSnackBar(snackBar);
                      });
                      fav.value = true;
                    } else if (fav.value) {
                      favoriteMethodAPI
                          .removeFavoriteFromProduct(
                              widget.singleAnnouncement["id"])
                          .then((value) {
                        print(value);
                        final snackBar = SnackBar(
                          backgroundColor: CustomColors.primaryHover,
                          content: Text(
                            AppLocale.of(context).getTranslated("lang") == "En"
                                ? "تمت إزالة إعلانك من المفضلة بنجاح.."
                                : "Your ad has been removed from your favorites successfully..",
                            style: TextStyle(color: CustomColors.primary),
                          ),
                          duration: Duration(seconds: 1, milliseconds: 500),
                        );
                        _productScreenScaffoldkey.currentState
                            .showSnackBar(snackBar);
                      });
                      fav.value = false;
                    }
                  }
                },
                icon: Icon(
                  icon,
                  color: CustomColors.primary,
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: InkWell(
                onTap: () async {
                  String lang = await Preference.getLanguage();
                  if (lang == 'ar') {
                    setState(() {
                      setLang('en');
                      Phoenix.rebirth(context);
                    });
                  } else {
                    setState(() {
                      setLang('ar');
                      Phoenix.rebirth(context);
                    });
                  }
                },
                child: Center(
                  child: Text(
                    AppLocale.of(context).getTranslated('lang'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.primary),
                  ),
                )),
          ),
        ],
      ),
      drawer: sameDrawer(context),
      body: ListView(
        children: [
          _drawItemImage(widget.singleAnnouncement['images']),
          widget.singleAnnouncement["images"].length >= 1
              ? ValueListenableBuilder(
                  valueListenable: posOfProducts,
                  builder: (BuildContext context, double value, Widget child) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: DotsIndicator(
                        dotsCount: widget.singleAnnouncement['images'].length,
                        position: posOfProducts.value,
                        decorator: DotsDecorator(
                          color: Colors.grey,
                          activeColor: CustomColors.primary,
                          size: const Size.square(8.0),
                          activeSize: const Size(20.0, 10.0),
                          activeShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    );
                  },
                )
              : Container(),
          Container(
            margin: EdgeInsets.all(4),
            color: CustomColors.primaryHover,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 28,
                        color: CustomColors.primary,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        widget.singleAnnouncement["username"],
                        style: TextStyle(
                            fontSize: 18,
                            color: CustomColors.primary,
                            fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.0),
                        color: CustomColors.primary,
                        child: Row(
                          children: [
                            Icon(
                              Icons.map,
                              color: CustomColors.white,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              widget.singleAnnouncement["country"] == null
                                  ? ""
                                  : widget.singleAnnouncement["country"],
                              style: TextStyle(
                                  fontSize: 18, color: CustomColors.white),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
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
                              widget.singleAnnouncement["diff"],
                              style: TextStyle(
                                  fontSize: 18, color: CustomColors.primary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        AppLocale.of(context).getTranslated("lang") == 'En'
                            ? "قسم :"
                            : "section :",
                        style: TextStyle(
                            fontSize: 22,
                            color: CustomColors.dark,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          AppLocale.of(context).getTranslated("lang") ==
                                  "English"
                              ? widget.singleAnnouncement["category_ar"]
                              : widget.singleAnnouncement["category_en"],
                          style: TextStyle(
                              fontSize: 18,
                              color: CustomColors.primary,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
            child: Container(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 4,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            AppLocale.of(context).getTranslated("lang") == 'En'
                                ? "الوصف السريع :"
                                : "Short description :",
                            style: TextStyle(
                                fontSize: 22,
                                color: CustomColors.primary,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        widget.singleAnnouncement["small_description"],
                        style: TextStyle(
                            fontSize: 18,
                            color: CustomColors.dark,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocale.of(context).getTranslated("lang") == 'En'
                              ? "الوصف :"
                              : "description :",
                          style: TextStyle(
                              fontSize: 22,
                              color: CustomColors.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    widget.singleAnnouncement["description"],
                    style: TextStyle(
                        fontSize: 18,
                        color: CustomColors.dark,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
            child: Container(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 4,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            AppLocale.of(context).getTranslated("lang") == 'En'
                                ? "رقم التواصل :"
                                : "Phone Number :",
                            style: TextStyle(
                                fontSize: 22,
                                color: CustomColors.dark,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.singleAnnouncement["phone"],
                          style: TextStyle(
                              fontSize: 18, color: CustomColors.primary),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        IconButton(
                          onPressed: _callNumber,
                          icon: Icon(
                            Icons.phone,
                            color: CustomColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocale.of(context).getTranslated("lang") == "En"
                            ? "التعليقات"
                            : "Comments",
                        style: TextStyle(
                            fontSize: 22,
                            color: CustomColors.primary,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.plus,
                          color: CustomColors.primary,
                        ),
                        onPressed: showMaterialDialog,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                widget.singleAnnouncement["comments"].length > 0
                    ? Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, pos) {
                            return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.singleAnnouncement["comments"]
                                              [pos]["username"],
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: CustomColors.dark,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.singleAnnouncement["comments"]
                                              [pos]["created_at"],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: CustomColors.dark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      widget.singleAnnouncement["comments"][pos]
                                          ["comment"],
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: CustomColors.dark,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount:
                              widget.singleAnnouncement["comments"].length,
                        ),
                      )
                    : Container(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            AppLocale.of(context).getTranslated("lang") == "En"
                                ? "لا توجد تعليقات فى الوقت الحالي"
                                : "There are no comments at the moment",
                            style: TextStyle(
                                fontSize: 18,
                                color: CustomColors.dark,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawItemImage(List imagePath) {
    return Container(
      child: ValueListenableBuilder(
        valueListenable: posOfProducts,
        builder: (BuildContext context, value, Widget child) {
          return Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 8, left: 4, right: 4),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .3,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                  child: PageView.builder(
                    controller: _controller,
                    onPageChanged: (val) {
                      posOfProducts.value = val.floorToDouble();
                    },
                    itemBuilder: (BuildContext context, int index) {
                      print(widget.singleAnnouncement["images"].length);
                      return Container(
                        child: widget.singleAnnouncement["images"].length >= 1
                            ? (imagePath[index] == null)
                                ? Image.asset(
                                    "assets/images/boxImage.png",
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
                                      imagePath[index],
                                    ),
                                    fit: BoxFit.contain,
                                  )
                            : Image.asset(
                                widget.singleAnnouncement["images"][index],
                                fit: BoxFit.cover,
                              ),
                      );
                    },
                    itemCount: imagePath.length,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Opacity(
                          opacity: 0.7,
                          child: InkWell(
                            onTap: () {
                              if (posOfProducts.value >=
                                  widget.singleAnnouncement["images"].length -
                                      1) {
                                _controller.jumpToPage(0);
                                posOfProducts.value = 0;
                              } else {
                                _controller.jumpToPage(
                                    posOfProducts.value.floor() + 1);
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.08,
                              height: MediaQuery.of(context).size.height * .06,
                              decoration: BoxDecoration(
                                color: CustomColors.primary,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: CustomColors.white,
                                  )),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: 0.7,
                          child: InkWell(
                            onTap: () {
                              if (posOfProducts.value <= 0) {
                                _controller.jumpToPage(
                                    widget.singleAnnouncement["images"].length -
                                        1);
                                posOfProducts.value = widget
                                        .singleAnnouncement["images"].length
                                        .ceilToDouble() -
                                    1;
                              } else {
                                _controller.jumpToPage(
                                    posOfProducts.value.floor() - 1);
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.08,
                              height: MediaQuery.of(context).size.height * .06,
                              decoration: BoxDecoration(
                                color: CustomColors.primary,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: CustomColors.white,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  showMaterialDialog() {
    TextEditingController massageController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocale.of(context).getTranslated("lang") == "En"
            ? "قم بالتعليق علي الاعلان"
            : "Comment on the ad"),
        content: contentOfShowDialog(massageController),
        actions: <Widget>[
          Row(
            children: [
              FlatButton(
                child: Text(AppLocale.of(context).getTranslated("lang") == "En"
                    ? "تراجع"
                    : "Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(AppLocale.of(context).getTranslated("send")),
                onPressed: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  if (pref.getString("token") == null ||
                      pref.getString("token") == "null") {
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                      duration: Duration(
                        seconds: 3,
                      ),
                      backgroundColor: CustomColors.ratingLightBG,
                      content: Text(
                        AppLocale.of(context).getTranslated("lang") == 'En'
                            ? "يجب تسجيل الدخول اولا حتي يمكن المتابعة.."
                            : "You must be logged in first to be able to continue..",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.ratingLightFont),
                      ),
                      action: SnackBarAction(
                        label: AppLocale.of(context).getTranslated("log"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        textColor: CustomColors.ratingLightFont,
                      ),
                    );
                    _productScreenScaffoldkey.currentState
                        .showSnackBar(snackBar);
                  } else {
                    adsAPI
                        .addComment(
                      widget.singleAnnouncement["id"],
                      widget.singleAnnouncement["user_id"],
                      massageController.text,
                    )
                        .then(
                      (value) {
                        if (value == "true") {
                          Navigator.pop(context);
                          final snackBar = SnackBar(
                              backgroundColor: CustomColors.greenLightBG,
                              content: Text(
                                AppLocale.of(context).getTranslated("lang") ==
                                        'En'
                                    ? "تم اضافه التعليق ."
                                    : "Comment added.",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.greenLightFont),
                              ));

                          _productScreenScaffoldkey.currentState
                              .showSnackBar(snackBar);
                        } else {
                          Navigator.pop(context);

                          final snackBar = SnackBar(
                              backgroundColor: CustomColors.ratingLightBG,
                              content: Text(
                                AppLocale.of(context).getTranslated("lang") ==
                                        'En'
                                    ? "حدث خطأ من فضلك تاكد من الاتصال بالانترنت وحاول مرة اخري"
                                    : "An error occurred. Please check your internet connection and try again",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.ratingLightFont),
                              ));

                          _productScreenScaffoldkey.currentState
                              .showSnackBar(snackBar);
                        }
                      },
                    );
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget contentOfShowDialog(massageController) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextFormField(
              controller: massageController,
              autofocus: false,
              onChanged: (value) {},
              maxLines: 10,
              cursorColor: Colors.black,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                hintText: AppLocale.of(context).getTranslated("lang") == "En"
                    ? "اكتب تعليقك"
                    : "Write your comment",
                hintStyle: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _callNumber() async {
    String url = "tel://" + widget.singleAnnouncement["phone"];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not call ${widget.singleAnnouncement["phone"]}';
    }
  }
}
