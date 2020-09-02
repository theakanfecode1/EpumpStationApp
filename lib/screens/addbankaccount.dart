import 'package:epump/customwidgets/feedbackwidget.dart';
import 'package:epump/customwidgets/structureddialog.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/stores/branchstores/addbankstore.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AddBankAccount extends StatefulWidget {
  @override
  _AddBankAccountState createState() => _AddBankAccountState();
}

class _AddBankAccountState extends State<AddBankAccount> {
  TextEditingController _bankNameController = TextEditingController();
  TextEditingController _accountNameController = TextEditingController();
  TextEditingController _accountNumberController = TextEditingController();
  bool _bankAccountIsFetched = false;
  String _bankCode = "";

  @override
  void dispose() {
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addBankStore = Provider.of<AddBankStore>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if(!_bankAccountIsFetched){
        Navigator.of(context).push(LoadingWidget.showLoadingScreen("Fetching Banks"));
        String result = await addBankStore.getBanks();
        Navigator.of(context).pop();
        setState(() {
          _bankAccountIsFetched = true;
          if(result == NetworkStrings.SUCCESSFUL){
            _bankNameController.text = addBankStore.banks[0].bankName;
            _bankCode = addBankStore.banks[0].bankCode;
          }

        });

      }
    });
    return Scaffold(
      appBar: Constants.showCustomAppBar("Add Bank Account"),
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
                    Constants.getAssetGeneralName("bankdash", "svg"),
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
                                addBankStore.banks.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: () {
                                      setState(() {
                                        _bankCode = addBankStore.banks[index].bankCode;
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
                  keyboardType: TextInputType.text,
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
                  labelText: "Account Number (e.g 0123456789)",
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
                      Navigator.of(context).push(LoadingWidget.showLoadingScreen("Adding Account"));
                      String result = await addBankStore.addBank(_bankNameController.text, _accountNameController.text, _bankCode, _accountNumberController.text);
                      Navigator.of(context).pop();
                      if(result == NetworkStrings.SUCCESSFUL){
                        await showDialog(context: context,builder: (_){
                          return StructuredDialog(
                            giveRadius: true,
                            child: FeedbackWidget(
                            title: "Success",
                            status: true,
                            message: result,
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
