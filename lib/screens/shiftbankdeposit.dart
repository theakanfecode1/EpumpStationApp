import 'package:epump/customwidgets/feedbackwidget.dart';
import 'package:epump/customwidgets/structureddialog.dart';
import 'package:epump/stores/branchstores/bankaccountstore.dart';
import 'package:epump/stores/branchstores/shiftstore.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'loadingscreen.dart';

class ShiftBankDeposit extends StatefulWidget {

  final shiftId;


  ShiftBankDeposit({this.shiftId});

  @override
  _ShiftBankDepositState createState() => _ShiftBankDepositState();
}

class _ShiftBankDepositState extends State<ShiftBankDeposit> {



  bool _bankAccountIsFetched = false;

  TextEditingController _bankAccountController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _tellerController = TextEditingController();

  @override
  void dispose() {
    _bankAccountController.dispose();
    _amountController.dispose();
    _tellerController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final shiftStore = Provider.of<ShiftStore>(context);
    final bankAccountStore = Provider.of<BankAccountStore>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!_bankAccountIsFetched) {
        Navigator.of(context).push(LoadingWidget.showLoadingScreen("Fetching Accounts"));
        String result = await bankAccountStore.getBankAccounts();
        Navigator.of(context).pop();
        setState(() {
          _bankAccountIsFetched = true;
          if(result == NetworkStrings.SUCCESSFUL){
            _bankAccountController.text = "${bankAccountStore.accounts[0].name}  (${bankAccountStore.accounts[0].accountNumber})";
          }
        });
      }
    });
    return Scaffold(
      appBar: Constants.showCustomAppBar("Shift Bank Deposit"),
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
                    Constants.getAssetGeneralName("stopwatchdrawer", "svg"),
                    color: Colors.white,
                    width: 80,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Amount (e.g 1000)",
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: CustomColors.REMIS_PURPLE,
                    fontWeight: FontWeight.w400,),
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
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: InkWell(
                onTap: (){
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
                  controller: _bankAccountController,
                  enabled: false,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Account",
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: CustomColors.REMIS_PURPLE,
                      fontWeight: FontWeight.w400,),
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
                        borderSide: BorderSide(color: CustomColors.REMIS_PURPLE,)
                    ),
                  ),
                  onSubmitted: (text) {
                    FocusScope.of(context).nextFocus();
                  },
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextField(
                controller: _tellerController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: "Teller No (e.g 0123456)",
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: CustomColors.REMIS_PURPLE,
                    fontWeight: FontWeight.w400,),
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
                ),
                onSubmitted: (text) {
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(onPressed: () async {
                    if(_amountController.text.isNotEmpty && _tellerController.text.isNotEmpty && _bankAccountController.text.isNotEmpty){
                      if(double.parse(_amountController.text) > 0.00){
                        Navigator.of(context).push(LoadingWidget.showLoadingScreen("Recording deposit"));
                        String result = await shiftStore.postShiftDeposit(double.parse(_amountController.text), (_bankAccountController.text.split("  "))[0], _tellerController.text,widget.shiftId);
                        Navigator.of(context).pop();
                        if(result == NetworkStrings.SUCCESSFUL){
                          await showDialog(context: context,builder: (_){
                            return StructuredDialog(
                              giveRadius: true,
                              child: FeedbackWidget(
                                title: "Success",
                                status: true,
                                message: "Shift deposit successfully submitted",
                              ),);
                            
                          });
                          Navigator.of(context).pop();
                        }
                        else{
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
                      }else{
                        showDialog(context: context,builder: (_){
                          return StructuredDialog(
                            giveRadius: true,
                            child: FeedbackWidget(
                              title: "Invaild Amount",
                              status: false,
                              message: "The amount must be greater than zero",
                            ),);
                        });
                      }
                    }else{
                      showDialog(context: context,builder: (_){
                        return StructuredDialog(
                          giveRadius: true,
                          child: FeedbackWidget(
                            title: "Invaild Input",
                            status: false,
                            message: "All fields are required",
                          ),);
                      });
                    }
                  },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(bottomRight:Radius.circular(10),bottomLeft:Radius.circular(10))
                    ),
                    color: CustomColors.REMIS_PURPLE,child: Text("SUBMIT",style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20
                    ),),)),
            )



          ],
        ),
      ),
    );
  }
}
