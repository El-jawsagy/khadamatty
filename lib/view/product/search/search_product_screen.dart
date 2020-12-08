import 'package:flutter/material.dart';
import 'package:khadamatty/controller/ads_api.dart';
import 'package:khadamatty/controller/lang/applocate.dart';
import 'package:khadamatty/view/product/product_screen.dart';
import 'package:khadamatty/view/utilites/popular_widget.dart';
import 'package:khadamatty/view/utilites/theme.dart';

class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AdsAPI adsAPI = AdsAPI();
    return FutureBuilder(
      future: adsAPI.searchListing(
        query,
      ),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return emptyPage(context);
            break;
          case ConnectionState.waiting:
          case ConnectionState.active:
            return loading(
              context,
            );
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              print(snapshot.data.length);
              return snapshot.data.length >= 1
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, pos) {
                        return getExpanded(context, size, snapshot.data[pos]);
                      },
                      itemCount: snapshot.data.length,
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Image.asset(
                                "assets/images/empty.png",
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                              ),
                            ),
                            Text(
                              AppLocale.of(context)
                                  .getTranslated("product_dis"),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    );
            } else
              return emptyPage(context);
            break;
        }
        return emptyPage(context);
      },
    );

    throw UnimplementedError();
  }

  Widget getExpanded(
    BuildContext context,
    Size size,
    Map map,
  ) {
    print(map);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(map),
          ),
        );
      },
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: size.height * .28,
                  child: Column(
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
                              )
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
                              "قسم:",
                              style: TextStyle(
                                  fontSize: 12,
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
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions3
    return loading(context);
  }

  Widget loading(
    BuildContext context,
  ) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocale.of(context).getTranslated("wait"),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              CircularProgressIndicator(
                backgroundColor: CustomColors.primary,
              ),
            ],
          ),
        ));
  }
}
