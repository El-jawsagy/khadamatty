import 'package:flutter/material.dart';
import 'package:khadamatty/controller/home_page/home_api.dart';
import 'package:khadamatty/controller/lang/applocate.dart';
import 'package:khadamatty/view/product/product_screen.dart';
import 'package:khadamatty/view/utilites/popular_widget.dart';
import 'package:khadamatty/view/utilites/theme.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  MarketAndCategoryApi homePage;

  TabController tabController;
  int currentIndex = 0;
  int position = 0;
  ProductBloc bloc;

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    bloc = ProductBloc();
    homePage = MarketAndCategoryApi();

    tabController =
        TabController(length: 0, vsync: this, initialIndex: position);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: homePage.getSingleCategory(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return emptyPage(context);
                break;
              case ConnectionState.waiting:
              case ConnectionState.active:
                return loading(context, 1);
                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  List list = snapshot.data;
                  bloc.categoryIdSink.add(list[position]["id"]);
                  tabController = TabController(
                      length: list.length, vsync: this, initialIndex: position);

                  return _screen(list);
                } else
                  return emptyPage(context);

                break;
            }
            return emptyPage(context);
          }),
    );
  }

  Widget _screen(List<dynamic> data) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldkey,
      body: Column(
        children: [
          Container(
            color: CustomColors.primary,
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: CustomColors.white,
              controller: tabController,
              labelStyle:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              labelPadding: EdgeInsets.only(left: 16, right: 12),
              unselectedLabelStyle: TextStyle(fontSize: 14),
              tabs: subCategoryTabs(data),
              isScrollable: true,
              onTap: (val) {
                position = val;
                currentIndex = data[position]["id"];
                bloc.categoryIdSink.add(currentIndex);

              },
            ),
          ),
          StreamBuilder(
              stream: bloc.productStream,
              builder:
                  (BuildContext context, AsyncSnapshot<List> snapshot) {

                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return emptyPage(context);
                    break;
                  case ConnectionState.waiting:
                    return loading(context, .7);
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasData) {


                      print(snapshot.data.length);
                      if (snapshot.data.length >= 1) {
                        return Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return getExpanded(
                                  size, snapshot.data[index]);
                            },
                            itemCount: snapshot.data.length,
                          ),
                        );
                      } else {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: size.height * 0.1),
                                Container(
                                  child: Image.asset(
                                    "assets/images/empty.png",
                                    width:
                                    MediaQuery.of(context).size.width,
                                    height:
                                    MediaQuery.of(context).size.height *
                                        0.3,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.05),
                                Text(
                                  AppLocale.of(context)
                                      .getTranslated("product_dis"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ],
                            ));
                      }
                    } else
                      return emptyPage(context);
                    break;
                }
                return emptyPage(context);
              }),
        ],
      ),
    );
  }

  List<Tab> subCategoryTabs(List ListTabs) {
    List<Tab> tabs = [];
    for (var i in ListTabs) {
      tabs.add(Tab(
        text: AppLocale.of(context).getTranslated("lang") == "En"
            ? i['name']
            : i['name_en'],
      ));
    }
    return tabs;
  }

  Widget getExpanded(
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
                            horizontal: 8.0, vertical: 2),
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
                                map["country"] == null ? "" : map["country"],
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
}
