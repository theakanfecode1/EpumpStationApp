import 'package:epump/customwidgets/feedbackwidget.dart';
import 'package:epump/customwidgets/structureddialog.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/stores/branchstores/addexpensestore.dart';
import 'package:epump/stores/branchstores/bankaccountstore.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AddExpenses extends StatefulWidget {
  @override
  _AddExpensesState createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  String _paymentMethodName = "Cash";

  TextEditingController _paymentMode = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _bankAccountController = TextEditingController();
  bool _bankAccountIsFetched = false;

  @override
  void dispose() {
    _paymentMode.dispose();
    _bankAccountController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _paymentMode.text = "Cash";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bankAccountStore = Provider.of<BankAccountStore>(context);
    final addExpenseStore = Provider.of<AddExpenseStore>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!_bankAccountIsFetched) {
        String result = await bankAccountStore.getBankAccounts();
        setState(() {
          _bankAccountIsFetched = true;
          if(result == NetworkStrings.SUCCESSFUL){
            _bankAccountController.text = "${bankAccountStore.accounts[0].name}  (${bankAccountStore.accounts[0].accountNumber})";
          }
        });
      }
    });
    return Scaffold(
      appBar: Constants.showCustomAppBar("Record Expense"),
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
                    Constants.getAssetGeneralName("expenses", "svg"),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextField(
                controller: _amountController,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Amount",
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
                keyboardType: TextInputType.number,
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
              child: PopupMenuButton(
                initialValue: _paymentMethodName,
                onSelected: (index) {
                  setState(() {
                    _paymentMethodName = index;
                    _paymentMode.text = index;
                  });
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        value: "Cash",
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text("Cash"),
                        )),
                    PopupMenuItem(
                      value: "Cheque",
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text("Cheque"),
                      ),
                    ),
                    PopupMenuItem(
                        value: "Transfer",
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text("Transfer"),
                        ))
                  ];
                },
                child: TextField(
                  enabled: false,
                  controller: _paymentMode,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Payment Mode",
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
                    contentPadding: EdgeInsets.all(20),
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
            if (_paymentMethodName != "Cash")
              Column(
                children: <Widget>[
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
                                      itemCount:
                                          bankAccountStore.accounts.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          onTap: () {
                                            setState(() {
                                              _bankAccountController.text =
                                                  "${bankAccountStore.accounts[index].name}  (${bankAccountStore.accounts[index].accountNumber})";
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          title: Text(
                                              "${bankAccountStore.accounts[index].name}  (${bankAccountStore.accounts[index].accountNumber})"),
                                        );
                                      }),
                                ),
                              );
                            });
                      },
                      child: TextField(
                        enabled: false,
                        controller: _bankAccountController,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 18),
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: "Account",
                          labelStyle: TextStyle(
                              fontSize: 18,
                              color: CustomColors.REMIS_PURPLE,
                              fontWeight: FontWeight.w400),
                          isDense: true,
                          disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                color: CustomColors.REMIS_PURPLE,
                              )),
                        ),
                        onSubmitted: (text) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextField(
                maxLines: 5,
                controller: _descriptionController,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: "Descripiton",
                  labelStyle: TextStyle(
                      fontSize: 18,
                      color: CustomColors.REMIS_PURPLE,
                      fontWeight: FontWeight.w400),
                  isDense: true,
                  contentPadding: EdgeInsets.all(24),
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
                    onPressed: () async {
                      String account ="";
                      Navigator.of(context).push(
                          LoadingWidget.showLoadingScreen("Recording Expense"));
                      if (_paymentMethodName != "Cash") {
                        var temp = _bankAccountController.text.split("  ");
                        account =
                            temp[1].replaceAll("(", "").replaceAll(")", "");
                      }

                      String result = await addExpenseStore.addExpense(
                          _descriptionController.text,
                          _amountController.text.isEmpty?0:int.parse(_amountController.text),
                          _paymentMode.text,
                          account);
                      Navigator.of(context).pop();
                      if(result == NetworkStrings.SUCCESSFUL){
                        await showDialog(context: context,builder: (_){
                          return StructuredDialog(
                            giveRadius: true,
                            child: FeedbackWidget(
                            title: "Record Successful",
                            status: true,
                            message: "Expense has been recorded successful",
                          ),);
                        });
                        Navigator.of(context).pop();
                      }else{
                        showDialog(context: context,builder: (_){
                          return StructuredDialog(
                            giveRadius: true,
                            child: FeedbackWidget(
                            title: "Error",
                            status: false,
                            message: result,
                          ),);
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
