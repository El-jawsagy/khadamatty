import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khadamatty/controller/lang/applocate.dart';
import 'package:khadamatty/controller/notification/notification_api.dart';
import 'package:khadamatty/view/Auth/login_screen.dart';
import 'package:khadamatty/view/Auth/register_screen.dart';
import 'package:khadamatty/view/product/product_screen.dart';
import 'package:khadamatty/view/utilites/popular_widget.dart';
import 'package:khadamatty/view/utilites/prefrences.dart';
import 'package:khadamatty/view/utilites/theme.dart';

import '../drawer.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationMethodAPI notificationMethodAPI;

  @override
  void initState() {
    notificationMethodAPI = NotificationMethodAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          AppLocale.of(context).getTranslated("drawer_noti"),
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        centerTitle: true,
        actions: [
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )),
          ),
        ],
      ),
      drawer: sameDrawer(context),
      body: FutureBuilder(
          future: Preference.getToken(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder(
                  future: notificationMethodAPI.getFavoriteItems(),
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(map["listing"]),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            height: size.height * .16,
            width: size.width,
            margin: EdgeInsets.symmetric(
              horizontal: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        child: Icon(
                          FontAwesomeIcons.comments,
                          size: 16,
                          color: CustomColors.primary,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4),
                      child: Text(
                        map["created_at"],
                        style: TextStyle(
                          fontSize: 16,
                          color: CustomColors.darkTow,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2),
                  child: Row(
                    children: [
                      Container(
                        width: size.width * 0.85,
                        child: Text(
                          AppLocale.of(context).getTranslated("lang") == "En"
                              ? " استفسار عن ${map["listing_name"]} "
                              : " Inquire about ${map["listing_name"]}",
                          style: TextStyle(
                            fontSize: 18,
                            color: CustomColors.primary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
