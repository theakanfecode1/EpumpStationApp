import 'package:epump/customwidgets/feedbackwidget.dart';
import 'package:epump/customwidgets/singletextfielddialog.dart';
import 'package:epump/customwidgets/structureddialog.dart';
import 'package:epump/screens/companydashboard.dart';
import 'package:epump/screens/dashboard.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/stores/companystores/pricechangestore.dart';
import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PriceChange extends StatefulWidget {
  @override
  _PriceChangeState createState() => _PriceChangeState();
}

class _PriceChangeState extends State<PriceChange> {
  TextEditingController _productController = TextEditingController();
  TextEditingController _pricePerController = TextEditingController();
  TextEditingController _newPriceController = TextEditingController();

  bool dataIsLoaded = false;
  String productId = "";
  Map data = {};
  String role = "";

  void getRole() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      role = sharedPreferences.getString("ROLE");

    });
  }

  textFromConfirmationDialog(String password) async {
    if (password != NetworkRequest.PASSWORD || password.isEmpty) {
      showDialog(
          context: context,
          builder: (_) {
            return StructuredDialog(
              giveRadius: true,
              child: FeedbackWidget(
                message: "Password Mismatch",
                status: false,
                title: "Error",
              ),
            );
          });
    } else {
      Navigator.of(context)
          .push(LoadingWidget.showLoadingScreen("Changing price"));
      final priceChangeStore =
          Provider.of<PriceChangeStore>(context, listen: false);
      String result = await priceChangeStore.priceChange(
         NetworkRequest.BRANCHID,
          productId,
          double.parse(_newPriceController.text),
          password);
      Navigator.of(context).pop();
      if (result == NetworkStrings.SUCCESSFUL) {
        showDialog(
            context: context,
            builder: (_) {
              return StructuredDialog(
                giveRadius: true,
                child: FeedbackWidget(
                  title: "Success",
                  status: true,
                  message: "Price successfully changed",
                ),
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (_) {
              return StructuredDialog(
                giveRadius: true,
                child: FeedbackWidget(
                  title: "Error",
                  status: false,
                  message: result,
                ),
              );
            });
      }
    }
  }

  @override
  void dispose() {
    _productController.dispose();
    _pricePerController.dispose();
    _newPriceController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    final priceChangeStore = Provider.of<PriceChangeStore>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!dataIsLoaded) {
        Navigator.of(context)
            .push(LoadingWidget.showLoadingScreen("Fetching Products"));
        String result = await priceChangeStore.getProducts();
        Navigator.of(context).pop();
        if (result == NetworkStrings.SUCCESSFUL) {
          setState(() {
            dataIsLoaded = true;
            productId = priceChangeStore.products[0].productId;
            _pricePerController.text = Constants.formatThisInput(
                priceChangeStore.products[0].currentSellingPrice);
            _productController.text = priceChangeStore.products[0].productName;
          });
        }
      }
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Price Change",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      drawer: data["fromCompany"] ? CompanyDrawerOnly() : DrawerOnly(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          children: <Widget>[
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              color: CustomColors.REMIS_PURPLE,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SvgPicture.asset(
                    Constants.getAssetGeneralName("cross", "svg"),
                    color: Colors.white,
                    width: 80,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return StructuredDialog(
                          giveRadius: false,
                          child: Observer(
                            builder: (_) => ListView.builder(
                                shrinkWrap: true,
                                itemCount: priceChangeStore.products.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: () {
                                      setState(() {
                                        productId = priceChangeStore
                                            .products[index].productId;

                                        _productController.text =
                                            "${priceChangeStore.products[index].productName}";
                                        _pricePerController.text =
                                            Constants.formatThisInput(
                                                priceChangeStore.products[index]
                                                    .currentSellingPrice);
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    title: Text(
                                        "${priceChangeStore.products[index].productName}"),
                                  );
                                }),
                          ),
                        );
                      });
                },
                child: TextField(
                  enabled: false,
                  controller: _productController,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Product",
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: CustomColors.REMIS_PURPLE,
                      fontWeight: FontWeight.w400,
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.all(20),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: CustomColors.REMIS_PURPLE,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: CustomColors.REMIS_PURPLE,
                        )),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: CustomColors.REMIS_PURPLE,
                        )),
                  ),
                  onSubmitted: (text) {
                    FocusScope.of(context).nextFocus();
                  },
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextField(
                controller: _pricePerController,
                enabled: false,
                keyboardType: TextInputType.number,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Price per Litre",
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: CustomColors.REMIS_PURPLE,
                    fontWeight: FontWeight.w400,
                  ),
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: CustomColors.REMIS_PURPLE,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: CustomColors.REMIS_PURPLE,
                      )),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: CustomColors.REMIS_PURPLE,
                      )),
                ),
                onSubmitted: (text) {
                  FocusScope.of(context).nextFocus();
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextField(
                controller: _newPriceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: "New Price",
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: CustomColors.REMIS_PURPLE,
                    fontWeight: FontWeight.w400,
                  ),
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: CustomColors.REMIS_PURPLE,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: CustomColors.REMIS_PURPLE,
                      )),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: CustomColors.REMIS_PURPLE,
                      )),
                ),
                onSubmitted: (text) {
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    onPressed: () {
                      if (_newPriceController.text.isEmpty ||
                          _productController.text.isEmpty ||
                          _newPriceController.text.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return StructuredDialog(
                                giveRadius: true,
                                child: FeedbackWidget(
                                  title: "Error",
                                  status: false,
                                  message: "All fields must be filled",
                                ),
                              );
                            });
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                insetPadding: EdgeInsets.all(10.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: SingleTextFieldDialog(
                                  title: "CONFIRM PASSWORD",
                                  inputType: TextInputType.text,
                                  hint: "password",
                                  notShowText: true,
                                  function: textFromConfirmationDialog,
                                ),
                              );
                            });
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    color: CustomColors.REMIS_PURPLE,
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
