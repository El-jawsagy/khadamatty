import 'dart:io';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khadamatty/controller/ads_api.dart';
import 'package:khadamatty/controller/lang/applocate.dart';
import 'package:khadamatty/view/drawer.dart';
import 'package:khadamatty/view/main_screens/main_screen.dart';
import 'package:khadamatty/view/utilites/theme.dart';

ValueNotifier<File> _image = ValueNotifier(null);
ValueNotifier<File> _imageOne = ValueNotifier(null);
ValueNotifier<File> _imageTwo = ValueNotifier(null);
ValueNotifier<File> _imageThree = ValueNotifier(null);
ValueNotifier<File> _imageFour = ValueNotifier(null);
ValueNotifier<File> _imageFive = ValueNotifier(null);

class AddAnnouncementScreen extends StatefulWidget {
  final Map data;
  final String lang;

  AddAnnouncementScreen(this.data, this.lang);

  @override
  _AddAnnouncementScreenState createState() => _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  PageController _imagesController = PageController(
    initialPage: 0,
  );
  static final GlobalKey<ScaffoldState> _addAdsScaffoldKey =
      new GlobalKey<ScaffoldState>();
  TextEditingController _adsNameEditingText;
  TextEditingController _shortDescriptionEditingText;
  TextEditingController _countryEditingText;
  TextEditingController _descriptionEditingText;
  TextEditingController _phoneEditingText;
  List<String> tempTags;
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  ValueNotifier<String> category;
  ValueNotifier<String> subCategory;
  List<String> subCategories;
  List<String> categories;
  ValueNotifier<int> pos;
  ValueNotifier<double> posOfImage;
  ValueNotifier<List<String>> _tags;
  AdsAPI adsAPI = AdsAPI();
  final _addAnnouncementKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.lang == "En") {
      category = ValueNotifier(
        "كل الاقسام الرئيسية",
      );
    } else {
      category = ValueNotifier(
        "All Main Categories",
      );
    }
    if (widget.lang == "En") {
      subCategory = ValueNotifier(
        "كل الاقسام الفرعية",
      );
    } else {
      subCategory = ValueNotifier(
        "All SubCategories",
      );
    }
    pos = ValueNotifier(1);
    posOfImage = ValueNotifier(0);

    tempTags = [];
    _tags = ValueNotifier([]);
    _adsNameEditingText = TextEditingController();
    _shortDescriptionEditingText = TextEditingController();
    _descriptionEditingText = TextEditingController();
    _phoneEditingText = TextEditingController();
    _countryEditingText = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    categories = [];
    subCategories = [];

    if (AppLocale.of(context).getTranslated("lang") == "En") {
      categories.add(
        "كل الاقسام الرئيسية",
      );
    } else {
      categories.add(
        "All Main Categories",
      );
    }
    for (var i in widget.data["categories"]) {
      if (AppLocale.of(context).getTranslated("lang") == "En") {
        categories.add(i["name"]);
      } else {
        categories.add(i["name_en"]);
      }
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _addAdsScaffoldKey,
      appBar: AppBar(
        title: Text(AppLocale.of(context).getTranslated("lang") == 'En'
            ? "اضافة اعلان"
            : "Add ad"),
      ),
      drawer: sameDrawer(context),
      body: SingleChildScrollView(
        child: Form(
          key: _addAnnouncementKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              children: [
                _drawTextHeader(
                    AppLocale.of(context).getTranslated("lang") == 'En'
                        ? "اسم الاعلان :"
                        : "Ad name :",
                    18),
                SizedBox(
                  height: size.height * 0.01,
                ),
                _drawTextFormField(
                  AppLocale.of(context).getTranslated("lang") == 'En'
                      ? "اسم الاعلان"
                      : "Ad name",
                  1,
                  18,
                  _adsNameEditingText,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                _drawTextHeader(
                    AppLocale.of(context).getTranslated("lang") == 'En'
                        ? "الصورة الرئيسية :"
                        : "Main picture:",
                    18),
                ImageTaker(_image),
                _drawTextHeader(
                    AppLocale.of(context).getTranslated("lang") == 'En'
                        ? "معرض الصور :"
                        : "Photo Gallery :",
                    18),
                _drawImages(),
                ValueListenableBuilder(
                  builder: (BuildContext context, value, Widget child) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: DotsIndicator(
                        dotsCount: 5,
                        position: posOfImage.value,
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
                  valueListenable: posOfImage,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                _drawTextHeader(
                    AppLocale.of(context).getTranslated("lang") == 'En'
                        ? "الوصف السريع :"
                        : "Short description :",
                    18),
                SizedBox(
                  height: size.height * 0.01,
                ),
                _drawTextField(
                  AppLocale.of(context).getTranslated("lang") == 'En'
                      ? "الوصف السريع "
                      : "Short description ",
                  1,
                  18,
                  _shortDescriptionEditingText,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                _drawTextHeader(
                    "${AppLocale.of(context).getTranslated("country")} :", 18),
                SizedBox(
                  height: size.height * 0.01,
                ),
                _drawTextFormField(
                  AppLocale.of(context).getTranslated("country"),
                  1,
                  18,
                  _countryEditingText,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                _drawTextHeader(
                    AppLocale.of(context).getTranslated("lang") == 'En'
                        ? "علامات الاعلان  :"
                        : "ad tags :",
                    18),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Tags(
                    key: _tagStateKey,
                    textField: TagsTextField(
                      textStyle: TextStyle(fontSize: 14),
                      constraintSuggestion: true,
                      inputDecoration: InputDecoration(
                        hintText:
                            AppLocale.of(context).getTranslated("lang") == 'En'
                                ? "اضف علامتك"
                                : "Add you tag",
                        hintStyle: TextStyle(
                          fontSize: 18,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: CustomColors.primaryHover,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: CustomColors.primaryHover,
                          ),
                        ),
                      ),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      onSubmitted: (str) {
                        _tags.value.add(str);
                        tempTags.add(str);
                      },
                    ),
                    itemCount: _tags.value.length,
                    itemBuilder: (int index) {
                      return ValueListenableBuilder(
                          valueListenable: _tags,
                          builder: (BuildContext context, value, Widget child) {
                            return Tooltip(
                                message: _tags.value[index],
                                child: ItemTags(
                                  padding: EdgeInsets.all(10),
                                  title: _tags.value[index],
                                  index: index,
                                  active: true,
                                  activeColor: CustomColors.primary,
                                  onPressed: (value) {
                                    if (value.active) {
                                      tempTags.add(value.title);
                                    } else {
                                      tempTags.remove(value.title);
                                    }
                                  },
                                  removeButton: ItemTagsRemoveButton(
                                    onRemoved: () {
                                      setState(() {
                                        _adsNameEditingText.text =
                                            _adsNameEditingText.text;
                                        _shortDescriptionEditingText.text =
                                            _shortDescriptionEditingText.text;
                                        _descriptionEditingText.text =
                                            _descriptionEditingText.text;
                                        _phoneEditingText.text =
                                            _phoneEditingText.text;
                                        _countryEditingText.text =
                                            _countryEditingText.text;
                                        pos = pos;

                                        _tags.value.removeAt(index);
                                      });

                                      return true;
                                    },
                                  ),
                                ));
                          });
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                _drawTextHeader(
                    AppLocale.of(context).getTranslated("lang") == 'En'
                        ? "الوصف :"
                        : "description :",
                    18),
                SizedBox(
                  height: size.height * 0.01,
                ),
                _drawTextField(
                  AppLocale.of(context).getTranslated("lang") == 'En'
                      ? "الوصف"
                      : "description",
                  10,
                  18,
                  _descriptionEditingText,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                _drawTextHeader(
                    AppLocale.of(context).getTranslated("lang") == 'En'
                        ? "القسم الرئيسي للاعلان :"
                        : "main section of the ad :",
                    18),
                _drawChooseCountry(),
                SizedBox(
                  height: size.height * 0.01,
                ),
                _drawTextHeader(
                    AppLocale.of(context).getTranslated("lang") == 'En'
                        ? "القسم الفرعي للاعلان :"
                        : "Subsection for the ad :",
                    18),
                _drawSubCategory(),
                SizedBox(
                  height: size.height * 0.01,
                ),
                _drawTextHeader(
                    AppLocale.of(context).getTranslated("lang") == 'En'
                        ? "رقم التواصل :"
                        : "Phone Number :",
                    18),
                _drawTextFormField(
                  AppLocale.of(context).getTranslated("lang") == 'En'
                      ? "مثال +561 xxx xxx xxx"
                      : "Ex +561 xxx xxx xxx",
                  1,
                  18,
                  _phoneEditingText,
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                _drawUploadButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawTextHeader(string, double fontSize) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            string,
            style: TextStyle(
              fontSize: fontSize,
              color: CustomColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawTextField(
      string, lines, double textSize, TextEditingController controller) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.name,
        maxLines: lines,
        decoration: InputDecoration(
          hintText: string,
          hintStyle: TextStyle(
            fontSize: textSize,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: CustomColors.primaryHover,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: CustomColors.primaryHover,
            ),
          ),
        ),
        onChanged: (vaue) {},
      ),
    );
  }

  Widget _drawTextFormField(
      string, lines, double textSize, TextEditingController controller) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.name,
        maxLines: lines,
        decoration: InputDecoration(
          hintText: string,
          hintStyle: TextStyle(
            fontSize: textSize,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: CustomColors.primaryHover,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: CustomColors.primaryHover,
            ),
          ),
        ),
        onChanged: (vaue) {},
        validator: (onValue) {
          if (onValue.isEmpty) {
            return AppLocale.of(context).getTranslated("wrong");
          }
          return null;
        },
      ),
    );
  }

  Widget _drawImages() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.22,
      child: PageView.builder(
        controller: _imagesController,
        itemBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return MultiImageTaker(_imageOne);
              break;
            case 1:
              return MultiImageTaker(_imageTwo);
              break;
            case 2:
              return MultiImageTaker(_imageThree);
              break;
            case 3:
              return MultiImageTaker(_imageFour);
              break;
            case 4:
              return MultiImageTaker(_imageFive);
              break;
          }
          return Container();
        },
        itemCount: 5,
        onPageChanged: (val) {
          posOfImage.value = val.floorToDouble();
        },
      ),
    );
  }

  Widget _drawChooseCountry() {

    return ValueListenableBuilder(
      valueListenable: category,
      builder: (BuildContext context, value, Widget child) {
        return Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: CustomColors.gray,
              ),
              borderRadius: BorderRadius.circular(3)),
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * .08,
          child: Center(
            child: DropdownButton<String>(
              value: category.value,
              icon: Icon(Icons.arrow_drop_down_outlined),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: CustomColors.gray),
              underline: Container(
                color: CustomColors.white,
              ),
              onChanged: (String newValue) {
                category.value = newValue;
                pos.value = categories.indexOf(newValue);
                if (widget.lang == "En") {
                  subCategory.value = "كل الاقسام الفرعية";
                } else {
                  subCategory.value = "All SubCategories";
                }
              },
              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _drawSubCategory() {
    return ValueListenableBuilder(
      valueListenable: pos,
      builder: (BuildContext context, value, Widget child) {
        subCategories = [];

        if (AppLocale.of(context).getTranslated("lang") == "En") {
          subCategories.add(
            "كل الاقسام الفرعية",
          );
        } else {
          subCategories.add(
            "All SubCategories",
          );
        }
        for (var i in widget.data["sub_categories"]) {
          if (pos.value == i["product_category_id"]) {
            if (AppLocale.of(context).getTranslated("lang") == "En") {
              subCategories.add(i["name"]);
            } else {
              subCategories.add(i["name_en"]);
            }
          }
        }
        return ValueListenableBuilder(
          valueListenable: subCategory,
          builder: (BuildContext context, String v, Widget c) {
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: CustomColors.gray,
                  ),
                  borderRadius: BorderRadius.circular(3)),
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * .08,
              child: Center(
                child: DropdownButton<String>(
                  value: subCategory.value,
                  icon: Icon(Icons.arrow_drop_down_outlined),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: CustomColors.gray),
                  underline: Container(
                    color: CustomColors.white,
                  ),
                  onChanged: (String newValue) {
                    subCategory.value = newValue;
                  },
                  items: subCategories
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _drawUploadButton() {
    ValueNotifier<bool> state = ValueNotifier(false);
    return ValueListenableBuilder(
      valueListenable: state,
      builder: (BuildContext context, bool value, Widget child) {
        return Container(
          width: MediaQuery.of(context).size.width * .85,
          child: state.value
              ? Container(
                  height: MediaQuery.of(context).size.height * .06,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: CustomColors.primary)),
                  child: Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(
                        backgroundColor: CustomColors.primaryHover,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(CustomColors.primary),
                      ),
                    ),
                  ),
                )
              : FlatButton(
                  height: MediaQuery.of(context).size.height * .06,
                  onPressed: () {
                    state.value = true;

                    ValueNotifier<int> catId = ValueNotifier(null);
                    ValueNotifier<int> subCatId = ValueNotifier(null);
                    if (_addAnnouncementKey.currentState.validate()) {
                      if (_image.value != null) {
                        if (category.value != "كل الاقسام الرئيسية" &&
                            category.value != "All Main Categories") {
                          final snackBar = SnackBar(
                              backgroundColor: CustomColors.primaryHover,
                              duration: Duration(seconds: 1, milliseconds: 500),
                              content: Text(
                                AppLocale.of(context).getTranslated("lang") ==
                                        'En'
                                    ? "يتم الان رفع الاعلان برجاء الانتظار.."
                                    : "The advertisement is being uploaded, please wait ...",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.primary),
                              ));

                          _addAdsScaffoldKey.currentState
                              .showSnackBar(snackBar);
                          state.value = true;
                          for (Map i in widget.data["categories"]) {
                            if (i.containsValue(category.value)) {
                              catId.value = i["id"];
                            }
                          }
                          for (Map i in widget.data["sub_categories"]) {
                            if (i.containsValue(subCategory.value)) {
                              subCatId.value = i["id"];
                            }
                          }
                          adsAPI.uploadAnnouncement(
                            _adsNameEditingText.text,
                            _shortDescriptionEditingText.text,
                            _countryEditingText.text,
                            _tags.value,
                            _descriptionEditingText.text,
                            catId.value,
                            subCatId.value,
                            _phoneEditingText.text,
                            _image.value,
                            _imageOne.value,
                            _imageTwo.value,
                            _imageThree.value,
                            _imageFour.value,
                            _imageFive.value,
                          ).then((value) {
                            state.value = false;
                            if (value == "true") {
                              final snackBar = SnackBar(
                                backgroundColor: CustomColors.greenLightBG,
                                content: Text(
                                  AppLocale.of(context).getTranslated("lang") ==
                                          "En"
                                      ? "تم ارسال طلبك بنجاح .."
                                      : "Your order has been sent successfully ..",
                                  style: TextStyle(
                                      color: CustomColors.greenLightFont),
                                ),
                                duration: Duration(seconds: 3),
                              );
                              mainPageScaffoldKey.currentState
                                  .showSnackBar(snackBar);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainScreen(0)));
                            } else {
                              final snackBar = SnackBar(
                                backgroundColor: CustomColors.ratingLightBG,
                                content: Text(
                                  AppLocale.of(context).getTranslated("lang") ==
                                          "En"
                                      ? "لم يكتمل ارسال الاعلان من فضلك تاكد من الاتصال بالانترنت و حاول مجدد.."
                                      : "The update has not been sent. Please check your internet connection and try again ...",
                                  style: TextStyle(
                                      color: CustomColors.redLightFont),
                                ),
                                duration: Duration(seconds: 1),
                              );
                              _addAdsScaffoldKey.currentState
                                  .showSnackBar(snackBar);
                            }
                          });
                        } else {
                          state.value = false;

                          final snackBar = SnackBar(
                              duration: Duration(seconds: 2),
                              backgroundColor: CustomColors.ratingLightBG,
                              content: Text(
                                AppLocale.of(context).getTranslated("lang") ==
                                        'En'
                                    ? "يجب اختيار قسم من الاقسام الرئيسية"
                                    : "One of the main sections must be selected",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.ratingLightFont),
                              ));

                          _addAdsScaffoldKey.currentState
                              .showSnackBar(snackBar);
                        }
                      } else {
                        state.value = false;

                        final snackBar = SnackBar(
                            duration: Duration(seconds: 2),
                            backgroundColor: CustomColors.ratingLightBG,
                            content: Text(
                              AppLocale.of(context).getTranslated("lang") ==
                                      'En'
                                  ? "يجب ادخال الصورة الرئيسية"
                                  : "The main image must be entered",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.ratingLightFont),
                            ));

                        _addAdsScaffoldKey.currentState.showSnackBar(snackBar);
                      }
                    }
                  },
                  child: Text(
                    AppLocale.of(context).getTranslated("send"),
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
        );
      },
    );
  }

  @override
  void dispose() {
    _image.value = null;
    _imageOne.value = null;
    _imageTwo.value = null;
    _imageThree.value = null;
    _imageFour.value = null;
    _imageFive.value = null;
    super.dispose();
  }
}

class ImageTaker extends StatefulWidget {
  final ValueNotifier<File> image;

  ImageTaker(this.image);

  @override
  _ImageTakerState createState() => _ImageTakerState();
}

class _ImageTakerState extends State<ImageTaker> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.image,
      builder: (BuildContext context, File value, Widget child) {
        return widget.image.value == null
            ? InkWell(
                onTap: getImageGallery,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(width: 0.5, color: CustomColors.white),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * .2,
                          child: Center(
                            child: ClipRect(
                              child: Image.asset(
                                'assets/images/car.jpg',
                              ),
                              // child: (widget.data["image"] == null ||
                              //     widget.data["image"] == '')
                              //     ? Image.asset(
                              //   'assets/images/image_2.jpg',
                              // )
                              //     : Image(
                              //   loadingBuilder: (context, image,
                              //       ImageChunkEvent loadingProgress) {
                              //     if (loadingProgress == null) {
                              //       return image;
                              //     }
                              //     return Center(
                              //       child:
                              //       CircularProgressIndicator(),
                              //     );
                              //   },
                              //   image: NetworkImage(
                              //       widget.data["image"],
                              //       scale: 1.0),
                              //   fit: BoxFit.cover,
                              // ),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: 0.45,
                          child: Container(
                            height: MediaQuery.of(context).size.height * .2,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                  width: 0.5, color: CustomColors.white),
                              gradient: LinearGradient(colors: [
                                CustomColors.gray,
                                CustomColors.gray
                              ]),
                            ),
                          ),
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height * .2,
                            child: Center(
                                child: Icon(
                              Icons.add,
                              color: CustomColors.white,
                              size: 36,
                            ))),
                      ],
                    ),
                  ),
                ),
              )
            : InkWell(
                onTap: getImageGallery,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border:
                            Border.all(width: 0.5, color: CustomColors.white),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .2,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                  width: 0.5, color: CustomColors.white),
                            ),
                            child: Center(
                              child: ClipRect(
                                  child: Image.file(
                                widget.image.value,
                                fit: BoxFit.cover,
                              )),
                            ),
                          ),
                        ],
                      )),
                ),
              );
      },
    );
  }

  Future getImageGallery() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      widget.image.value = File(pickedFile.path);
    } else {
      widget.image.value = null;
    }
  }
}

class MultiImageTaker extends StatefulWidget {
  final ValueNotifier<File> image;

  MultiImageTaker(this.image);

  @override
  _MultiImageTakerState createState() => _MultiImageTakerState();
}

class _MultiImageTakerState extends State<MultiImageTaker> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.image,
      builder: (BuildContext context, File value, Widget child) {
        return widget.image.value == null
            ? InkWell(
                onTap: getImageGallery,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(width: 0.5, color: CustomColors.white),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * .2,
                          child: Center(
                            child: ClipRect(
                              child: Image.asset(
                                'assets/images/car.jpg',
                              ),
                              // child: (widget.data["image"] == null ||
                              //     widget.data["image"] == '')
                              //     ? Image.asset(
                              //   'assets/images/image_2.jpg',
                              // )
                              //     : Image(
                              //   loadingBuilder: (context, image,
                              //       ImageChunkEvent loadingProgress) {
                              //     if (loadingProgress == null) {
                              //       return image;
                              //     }
                              //     return Center(
                              //       child:
                              //       CircularProgressIndicator(),
                              //     );
                              //   },
                              //   image: NetworkImage(
                              //       widget.data["image"],
                              //       scale: 1.0),
                              //   fit: BoxFit.cover,
                              // ),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: 0.45,
                          child: Container(
                            height: MediaQuery.of(context).size.height * .2,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                  width: 0.5, color: CustomColors.white),
                              gradient: LinearGradient(colors: [
                                CustomColors.gray,
                                CustomColors.gray
                              ]),
                            ),
                          ),
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height * .2,
                            child: Center(
                                child: Icon(
                              Icons.add,
                              color: CustomColors.white,
                              size: 36,
                            ))),
                      ],
                    ),
                  ),
                ),
              )
            : InkWell(
                onTap: getImageGallery,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border:
                            Border.all(width: 0.5, color: CustomColors.white),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .2,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                  width: 0.5, color: CustomColors.white),
                            ),
                            child: Center(
                              child: ClipRect(
                                  child: Image.file(
                                widget.image.value,
                                fit: BoxFit.cover,
                              )),
                            ),
                          ),
                        ],
                      )),
                ),
              );
      },
    );
  }

  Future getImageGallery() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      widget.image.value = File(pickedFile.path);
    } else {
      widget.image.value = null;
    }
  }
}
