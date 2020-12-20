import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khadamatty/controller/commission_api.dart';
import 'package:khadamatty/controller/lang/applocate.dart';
import 'package:khadamatty/view/utilites/popular_widget.dart';
import 'package:khadamatty/view/utilites/theme.dart';

class AllBanksScreen extends StatefulWidget {
  @override
  _AllBanksScreenState createState() => _AllBanksScreenState();
}

class _AllBanksScreenState extends State<AllBanksScreen> {
  CommissionAPI commissionAPI;

  @override
  void initState() {
    commissionAPI = CommissionAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocale.of(context).getTranslated("lang") == "En"
              ? "كل البنوك"
              : "All Banks",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textWidthBasis: TextWidthBasis.parent,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocale.of(context).getTranslated("lang") == "En"
                    ? "جميع حسابتنا في البنوك"
                    : "All of Our accounts in Banks",
                style: TextStyle(color: CustomColors.dark, fontSize: 18),
              ),
            ),
            FutureBuilder(
                future: commissionAPI.getAllBanks(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return emptyPage(context, () {
                        setState(() {});
                      });
                      break;
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return loading(context, .75);
                      break;
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return _drawBankFormPay(snapshot.data[index]);
                          },
                          itemCount: snapshot.data.length,
                        );
                      } else
                        return emptyPage(context, () {
                          setState(() {});
                        });
                      break;
                  }
                  return emptyPage(context, () {
                    setState(() {});
                  });
                }),
          ],
        ),
      ),
    );
  }

  Widget _drawBankFormPay(map) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  map["bank"],
                  style: TextStyle(color: CustomColors.primary, fontSize: 18),
                ),
                Divider(
                  color: CustomColors.gray,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .4,
                        child: Text(
                          AppLocale.of(context).getTranslated("lang") == "En"
                              ? "اسم الحساب :"
                              : "Account Name:",
                          style: TextStyle(
                            color: CustomColors.dark,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .4,
                        child: Text(
                          map["acc_name"],
                          style: TextStyle(
                            color: CustomColors.dark,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .4,
                        child: Text(
                          AppLocale.of(context).getTranslated("lang") == "En"
                              ? "الايبان :"
                              : "IBAN :",
                          style: TextStyle(
                            color: CustomColors.dark,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .4,
                        child: SelectableText(
                          map["ebyan"],
                          style: TextStyle(
                            color: CustomColors.dark,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .4,
                        child: Text(
                          AppLocale.of(context).getTranslated("lang") == "En"
                              ? "رقم الحساب :"
                              : "Account Number :",
                          style: TextStyle(
                            color: CustomColors.dark,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .4,
                        child: SelectableText(
                          map["acc_num"],
                          style: TextStyle(
                            color: CustomColors.dark,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Future<bool> _onBackPressed() {
//   Navigator.pushReplacement(
//       context, MaterialPageRoute(builder: (context) => ChooseCommissionWayScreen()));
// }
}
