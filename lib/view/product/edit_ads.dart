import 'dart:io';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khadamatty/controller/ads_api.dart';
import 'package:khadamatty/controller/lang/applocate.dart';
import 'package:khadamatty/view/drawer.dart';
import 'package:khadamatty/view/utilites/theme.dart';

ValueNotifier<File> _image = ValueNotifier(null);
ValueNotifier<File> _imageOne = ValueNotifier(null);
ValueNotifier<File> _imageTwo = ValueNotifier(null);
ValueNotifier<File> _imageThree = ValueNotifier(null);
ValueNotifier<File> _imageFour = ValueNotifier(null);
ValueNotifier<File> _imageFive = ValueNotifier(null);
ValueNotifier<List<dynamic>> oldImages = ValueNotifier([]);

ValueNotifier<String> featuredImage;

// File _imageOne;
// File _imageTwo;
// File _imageThree;
// File _imageFour;
// File _imageFive;

final picker = ImagePicker();

class EditAddAnnouncementScreen extends StatefulWidget {
  final Map ads;
  final Map allOption;
  final String lang;

  EditAddAnnouncementScreen(this.ads, this.allOption, this.lang);

  @override
  _EditAddAnnouncementScreenState createState() =>
      _EditAddAnnouncementScreenState();
}

final GlobalKey<ScaffoldState> _addAdsScaffoldKey =
    new GlobalKey<ScaffoldState>();

class _EditAddAnnouncementScreenState extends State<EditAddAnnouncementScreen> {
  PageController _imagesController = PageController(
    initialPage: 0,
  );

  TextEditingController _adsNameEditingText;
  TextEditingController _shortDescriptionEditingText;
  TextEditingController _descriptionEditingText;
  TextEditingController _phoneEditingText;
  TextEditingController _countryEditingText;
  List<String> tempTags;
  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  ValueNotifier<String> editCategory;
  ValueNotifier<String> editSubCategory;
  List<String> editSubCategories;
  List<String> editCategories;
  ValueNotifier<int> pos;
  ValueNotifier<double> posOfImage;
  ValueNotifier<List<String>> _tags;
  AdsAPI adsAPI = AdsAPI();
  final _addAnnouncementKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.lang == "En") {
      editCategory = ValueNotifier(
        "كل الاقسام الرئيسية",
      );
    } else {
      editCategory = ValueNotifier(
        "All Main Categories",
      );
    }
    if (widget.lang == "En") {
      editSubCategory = ValueNotifier(
        "كل الاقسام الفرعية",
      );
    } else {
      editSubCategory = ValueNotifier(
        "All SubCategories",
      );
    }
    featuredImage = ValueNotifier(widget.ads["image"]);
    pos = ValueNotifier(1);
    posOfImage = ValueNotifier(0);
    tempTags = [];
    oldImages.value = widget.ads["old_images"];

    _tags = ValueNotifier([]);
    for (var i in widget.ads["tags"]) {
      _tags.value.add(i["name"]);
    }
    _adsNameEditingText = TextEditingController();
    _shortDescriptionEditingText = TextEditingController();
    _descriptionEditingText = TextEditingController();
    _phoneEditingText = TextEditingController();
    _countryEditingText = TextEditingController();

    _adsNameEditingText.text = widget.ads['name'];
    _shortDescriptionEditingText.text = widget.ads['small_description'];
    _descriptionEditingText.text = widget.ads['description'];
    _phoneEditingText.text = widget.ads['phone'];
    _countryEditingText.text = widget.ads['country'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    editCategories = [];
    editSubCategories = [];

    if (AppLocale.of(context).getTranslated("lang") == "En") {
      editCategories.add(
        "كل الاقسام الرئيسية",
      );
    } else {
      editCategories.add(
        "All Main Categories",
      );
    }
    for (var i in widget.allOption["categories"]) {
      if (AppLocale.of(context).getTranslated("lang") == "En") {
        editCategories.add(i["name"]);
      } else {
        editCategories.add(i["name_en"]);
      }
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _addAdsScaffoldKey,
      appBar: AppBar(
        title: Text(AppLocale.of(context).getTranslated("lang") == 'En'
            ? "تعديل الاعلان"
            : "Edit ad"),
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
                FeatureImageTaker(_image, networkImage: featuredImage.value),
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
                _drawTextHeader(
                    AppLocale.of(context).getTranslated("lang") == 'En'
                        ? "علامات المنتج :"
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
                      ? "الوصف :"
                      : "description :",
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
    return ValueListenableBuilder(
      valueListenable: oldImages,
      builder: (BuildContext context, List<dynamic> value, Widget child) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.22,
          child: PageView.builder(
            controller: _imagesController,
            itemBuilder: (BuildContext context, int index) {
              switch (index) {
                case 0:
                  return index < oldImages.value.length
                      ? ImageTaker(_imageOne, networkIm: oldImages.value[index])
                      : ImageTaker(
                          _imageOne,
                        );

                  break;
                case 1:
                  return index < oldImages.value.length
                      ? ImageTaker(_imageTwo, networkIm: oldImages.value[index])
                      : ImageTaker(
                          _imageTwo,
                        );
                  break;
                case 2:
                  return index < oldImages.value.length
                      ? ImageTaker(_imageThree,
                          networkIm: oldImages.value[index])
                      : ImageTaker(
                          _imageThree,
                        );

                  break;
                case 3:
                  return index < oldImages.value.length
                      ? ImageTaker(_imageFour,
                          networkIm: oldImages.value[index])
                      : ImageTaker(
                          _imageFour,
                        );
                  break;
                case 4:
                  return index < oldImages.value.length
                      ? ImageTaker(_imageFive,
                          networkIm: oldImages.value[index])
                      : ImageTaker(
                          _imageFive,
                        );

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
      },
    );
  }

  Widget _drawChooseCountry() {
    return ValueListenableBuilder(
      valueListenable: editCategory,
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
              value: editCategory.value,
              icon: Icon(Icons.arrow_drop_down_outlined),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: CustomColors.gray),
              underline: Container(
                color: CustomColors.white,
              ),
              onChanged: (String newValue) {
                editCategory.value = newValue;
                pos.value = editCategories.indexOf(newValue);
                if (widget.lang == "En") {
                  editSubCategory.value = "كل الاقسام الفرعية";
                } else {
                  editSubCategory.value = "All SubCategories";
                }
              },
              items:
                  editCategories.map<DropdownMenuItem<String>>((String value) {
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
        editSubCategories = [];

        if (AppLocale.of(context).getTranslated("lang") == "En") {
          editSubCategories.add(
            "كل الاقسام الفرعية",
          );
        } else {
          editSubCategories.add(
            "All SubCategories",
          );
        }
        for (var i in widget.allOption["sub_categories"]) {
          if (pos.value == i["product_category_id"]) {
            if (AppLocale.of(context).getTranslated("lang") == "En") {
              editSubCategories.add(i["name"]);
            } else {
              editSubCategories.add(i["name_en"]);
            }
          }
        }
        return ValueListenableBuilder(
          valueListenable: editSubCategory,
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
                  value: editSubCategory.value,
                  icon: Icon(Icons.arrow_drop_down_outlined),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: CustomColors.gray),
                  underline: Container(
                    color: CustomColors.white,
                  ),
                  onChanged: (String newValue) {
                    editSubCategory.value = newValue;
                  },
                  items: editSubCategories
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
                    child: Center(
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
                    ValueNotifier<int> catId = ValueNotifier(null);
                    ValueNotifier<int> subCatId = ValueNotifier(null);
                    state.value = true;
                    if (_addAnnouncementKey.currentState.validate()) {
                      if (_image != null || featuredImage == (null)) {
                        if (editCategory.value != "كل الاقسام الرئيسية" &&
                            editCategory.value != "All Main Categories") {
                          final snackBar = SnackBar(
                            duration: Duration(seconds: 1,milliseconds: 500),
                              backgroundColor: CustomColors.primaryHover,
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
                          for (Map i in widget.allOption["categories"]) {
                            if (i.containsValue(editCategory.value)) {
                              catId.value = i["id"];
                            }
                          }
                          for (Map i in widget.allOption["sub_categories"]) {
                            if (i.containsValue(editSubCategory.value)) {
                              subCatId.value = i["id"];
                            }
                          }
                          adsAPI.updateAnnouncement(
                            widget.ads["id"],
                            catId.value,
                            subCatId.value,
                            _adsNameEditingText.text,
                            _phoneEditingText.text,
                            _shortDescriptionEditingText.text,
                            _descriptionEditingText.text,
                            _tags.value,
                            _countryEditingText.text,
                            oldImages.value,
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
                                      ? "تم تعديل اعلانك بنجاح .."
                                      : "Your ad has been modified successfully ..",
                                  style: TextStyle(
                                      color: CustomColors.greenLightFont),
                                ),
                                duration: Duration(seconds: 3),
                              );
                              _addAdsScaffoldKey.currentState
                                  .showSnackBar(snackBar);
                            } else {
                              final snackBar = SnackBar(
                                backgroundColor: CustomColors.redLightBG,
                                content: Text(
                                  AppLocale.of(context).getTranslated("lang") ==
                                          "En"
                                      ? "لم يكتمل ارسال التعديل من فضلك تاكد من الاتصال بالانترنت و حاول مجدد.."
                                      : "The update has not been sent. Please check your internet connection and try again ...",
                                  style: TextStyle(
                                      color: CustomColors.redLightFont),
                                ),
                                duration: Duration(seconds: 3),
                              );
                              _addAdsScaffoldKey.currentState
                                  .showSnackBar(snackBar);
                            }
                          });
                        } else {
                          state.value = false;

                          final snackBar = SnackBar(
                              backgroundColor: CustomColors.ratingLightBG,
                              content: Text(
                                AppLocale.of(context).getTranslated("lang") ==
                                        'En'
                                    ? "يجب اختيار قسم من الاقسام الرئيسية"
                                    : "One of the main departments must be selected",
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

class FeatureImageTaker extends StatefulWidget {
  final ValueNotifier<File> image;
  final String networkImage;

  FeatureImageTaker(this.image, {this.networkImage});

  @override
  _FeatureImageTakerState createState() => _FeatureImageTakerState();
}

class _FeatureImageTakerState extends State<FeatureImageTaker> {
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
                              child: (widget.networkImage == null ||
                                      widget.networkImage == '')
                                  ? Image.asset(
                                      'assets/images/khadamatty.png',
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
                                      image: NetworkImage(widget.networkImage,
                                          scale: 1.0),
                                      fit: BoxFit.cover,
                                    ),
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
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      widget.image.value = File(pickedFile.path);
    } else {
      widget.image.value = null;
    }
  }
}

class ImageTaker extends StatefulWidget {
  ValueNotifier<File> image;
  ValueNotifier<String> networkImage;

  ImageTaker(file, {networkIm}) {
    this.image = file;
    networkImage = ValueNotifier(networkIm);
  }

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
            ? Row(
                children: [
                  InkWell(
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
                            ValueListenableBuilder(
                              valueListenable: widget.networkImage,
                              builder:
                                  (BuildContext context, value, Widget child) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * .2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Center(
                                    child: ClipRect(
                                      child: (widget.networkImage.value ==
                                                  null ||
                                              widget.networkImage.value == '')
                                          ? Image.asset(
                                              'assets/images/khadamatty.png',
                                            )
                                          : Image(
                                              loadingBuilder: (context,
                                                  image,
                                                  ImageChunkEvent
                                                      loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return image;
                                                }
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              },
                                              image: NetworkImage(
                                                  widget.networkImage.value,
                                                  scale: 1.0),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Opacity(
                              opacity: 0.45,
                              child: Container(
                                height: MediaQuery.of(context).size.height * .2,
                                width: MediaQuery.of(context).size.width * 0.7,
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
                                width: MediaQuery.of(context).size.width * 0.7,
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
                  ),
                  IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.trash,
                        color: CustomColors.primaryHover,
                      ),
                      onPressed: () {
                        if (oldImages.value
                            .contains(widget.networkImage.value)) {
                          oldImages.value.remove(widget.networkImage.value);
                          widget.networkImage.value = null;
                        } else if (oldImages.value
                                .contains(widget.networkImage.value) ==
                            false) {
                          final snackBar = SnackBar(
                              backgroundColor: CustomColors.ratingLightBG,
                              content: Text(
                                AppLocale.of(context).getTranslated("lang") ==
                                        'En'
                                    ? "لا يوجد صورة بالفعل"
                                    : "There is really no picture",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.ratingLightFont),
                              ));

                          _addAdsScaffoldKey.currentState
                              .showSnackBar(snackBar);
                        }
                      })
                ],
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
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      widget.image.value = File(pickedFile.path);
      if (oldImages.value.contains(widget.networkImage.value)) {
        widget.networkImage.value = null;
        oldImages.value.remove(widget.networkImage.value);
      }
    } else {
      widget.image.value = null;
      if (!oldImages.value.contains(widget.networkImage.value)) {
        oldImages.value.add(widget.networkImage.value);
      }
    }
  }
}
