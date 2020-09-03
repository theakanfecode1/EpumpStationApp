import 'package:epump/customwidgets/cashoutdialog.dart';
import 'package:epump/customwidgets/feedbackwidget.dart';
import 'package:epump/customwidgets/structureddialog.dart';
import 'package:epump/screens/dashboard.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/stores/branchstores/addbankstore.dart';
import 'package:epump/stores/branchstores/bankaccountstore.dart';
import 'package:epump/stores/branchstores/branchwalletstore.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettlementAccount extends StatefulWidget {
  @override
  _SettlementAccountState createState() => _SettlementAccountState();
}

class _SettlementAccountState extends State<SettlementAccount> {
  String _bankCode = "";
  bool _bankDataFetched = false;
  int loadingDialogFlag = 0;
  String role = "";

  TextEditingController _bankNameController = TextEditingController();
  TextEditingController _accountNameController = TextEditingController();
  TextEditingController _accountNumberController = TextEditingController();

  void getRole() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      role = sharedPreferences.getString("ROLE");
    });
  }

  textFromCashOutDialog(String amount) async {
    Navigator.of(context)
        .push(LoadingWidget.showLoadingScreen("Processing cash out request"));
    double cashOutAmount = double.parse(amount);
    final branchWalletStore =
        Provider.of<BranchWalletStore>(context, listen: false);
    double branchAmount =
        double.parse(branchWalletStore.branchWallet.balance.toStringAsFixed(2));
    if (branchAmount > 0.00 &&
        cashOutAmount <= branchAmount &&
        cashOutAmount != 0.00) {
      String result = await branchWalletStore.postCashOut(cashOutAmount);
      Navigator.of(context).pop();
      if (result == NetworkStrings.SUCCESSFUL) {
        showDialog(
            context: context,
            builder: (_) {
              return StructuredDialog(
                giveRadius: true,
                child: FeedbackWidget(
                  title: "Successful",
                  status: true,
                  message:
                      "Cash out request successfully submitted and is being processed",
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
    } else {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (_) {
            return StructuredDialog(
              giveRadius: true,
              child: FeedbackWidget(
                title: "Error",
                status: false,
                message: "Insufficent Funds",
              ),
            );
          });
    }
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountNameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  void getBanks() async {
    final addBankStore = Provider.of<AddBankStore>(context, listen: false);
    String result = await addBankStore.getBanks();

    setState(() {
      loadingDialogFlag++;
      if (loadingDialogFlag == 2) {
        Navigator.of(context).pop();
        if (result == NetworkStrings.SUCCESSFUL) {
          _bankCode = addBankStore.banks[0].bankCode;
        }
      }
    });
  }

  void getBranchWallet() async {
    final branchWalletStore =
        Provider.of<BranchWalletStore>(context, listen: false);
    String result = await branchWalletStore.getBranchWallet();
    if (result == NetworkStrings.SUCCESSFUL) {
      _bankNameController.text = branchWalletStore.branchWallet.bank == ""
          ? ""
          : branchWalletStore.branchWallet.bank;
      _accountNameController.text = branchWalletStore.branchWallet.accountName;
      _accountNumberController.text =
          branchWalletStore.branchWallet.accountNumber;
    }
    setState(() {
      loadingDialogFlag++;
      if (loadingDialogFlag == 2) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void initState() {
    getRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final addBankStore = Provider.of<AddBankStore>(context);
    final branchWalletStore = Provider.of<BranchWalletStore>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!_bankDataFetched) {
        Navigator.of(context)
            .push(LoadingWidget.showLoadingScreen("Fetching Banks"));
        getBanks();
        getBranchWallet();
        setState(() {
          _bankDataFetched = true;
        });
      }
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Settlement Account",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      drawer: DrawerOnly(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          children: <Widget>[
            Container(
              height: 190,
              width: MediaQuery.of(context).size.width,
              color: CustomColors.REMIS_PURPLE,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SvgPicture.asset(
                    Constants.getAssetGeneralName("money", "svg"),
                    color: Colors.white,
                    width: 90,
                  ),
                  Text(
                    "Wallet Balance",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                  Observer(
                    builder: (_) => Text(
                      Constants.formatThisInput(
                          branchWalletStore.branchWallet.balance),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  )
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
                                itemCount: addBankStore.banks.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: () {
                                      setState(() {
                                        _bankCode =
                                            addBankStore.banks[index].bankCode;
                                        _bankNameController.text =
                                            "${addBankStore.banks[index].bankName}";
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    title: Text(
                                        "${addBankStore.banks[index].bankName}"),
                                  );
                                }),
                          ),
                        );
                      });
                },
                child: TextField(
                  controller: _bankNameController,
                  enabled: false,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Bank Name",
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: CustomColors.REMIS_PURPLE,
                      fontWeight: FontWeight.w400,
                    ),
                    isDense: true,
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
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextField(
                controller: _accountNameController,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Account Name",
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
//        enabledBorder: OutlineInputBorder(
//            borderRadius: BorderRadius.all(Radius.circular(10.0)),
//            borderSide: BorderSide(color: Colors.white,)
//        ),
                ),
                onSubmitted: (text) {
                  FocusScope.of(context).nextFocus();
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextField(
                controller: _accountNumberController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: "Account Number",
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
//        enabledBorder: OutlineInputBorder(
//            borderRadius: BorderRadius.all(Radius.circular(10.0)),
//            borderSide: BorderSide(color: Colors.white,)
//        ),
                ),
                onSubmitted: (text) {
                  FocusScope.of(context).nextFocus();
                },
              ),
            ),
            SizedBox(
              height: 70,
            ),
            if (role.toLowerCase() != "supervisor")
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.of(context).push(
                                LoadingWidget.showLoadingScreen(
                                    "Updating Wallet"));
                            String result =
                                await branchWalletStore.addBranchWallet(
                                    _bankNameController.text,
                                    _accountNameController.text,
                                    _bankCode,
                                    "endOfDay",
                                    _accountNumberController.text);
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
                                        message: "Account successful updated",
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
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10)),
                              color: Colors.white,
                            ),
                            height: 70,
                            child: Text(
                              "UPDATE",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: CustomColors.REMIS_PURPLE),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                    insetPadding: EdgeInsets.all(10.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Observer(
                                        builder: (_) => CashOutDialog(
                                              amount: Constants.formatThisInput(
                                                  branchWalletStore
                                                      .branchWallet.balance),
                                              bankName: branchWalletStore
                                                  .branchWallet.bank,
                                              accountNumber: branchWalletStore
                                                  .branchWallet.accountNumber,
                                              accountName: branchWalletStore
                                                  .branchWallet.accountName,
                                              callbackFunction:
                                                  textFromCashOutDialog,
                                            )));
                              },
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10)),
                              color: CustomColors.REMIS_PURPLE,
                            ),
                            child: Text(
                              "CASH OUT",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
