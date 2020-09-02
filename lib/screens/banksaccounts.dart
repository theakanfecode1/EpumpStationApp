import 'dart:math';

import 'package:epump/screens/addbankaccount.dart';
import 'package:epump/screens/dashboard.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/stores/branchstores/bankaccountstore.dart';
import 'package:epump/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class BankAccounts extends StatefulWidget {
  @override
  _BankAccountsState createState() => _BankAccountsState();
}

class _BankAccountsState extends State<BankAccounts> {
  List<Color> colors = [
    Color(0xff982062),
    Color(0xffFFA646),
    Color(0xff33A9AC),
    Color(0xffF86041),
    CustomColors.REMIS_DARK_PURPLE
  ];

  @override
  Widget build(BuildContext context) {
    final bankAccountStore = Provider.of<BankAccountStore>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      Navigator.of(context).push(LoadingWidget.showLoadingScreen("Fetching Accounts"));
      await bankAccountStore.getBankAccounts();
      Navigator.of(context).pop();
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Bank Accounts",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      drawer: DrawerOnly(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => AddBankAccount())),
        backgroundColor: CustomColors.REMIS_PURPLE,
        child: Icon(
          Icons.add,
          size: 20,
        ),
      ),
      body: Observer(
        builder:(_)=> ListView.builder(
          itemCount: bankAccountStore.accounts.length,
            itemBuilder: (context, index) {
          return AtmCard(
            color: colors[Random().nextInt(5)],
            bankName: bankAccountStore.accounts[index].name,
            accountName: bankAccountStore.accounts[index].accountName,
            accountNumber: bankAccountStore.accounts[index].accountNumber,

          );
        }),
      ),
    );
  }
}

class AtmCard extends StatelessWidget {
  final color;
  final bankName;
  final accountNumber;
  final accountName;


  AtmCard({this.color, this.bankName, this.accountNumber, this.accountName});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Container(
        height: 210,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Text(
                 bankName,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  "Account Number",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                Text(
                  accountNumber,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Account Name",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                    Text(
                      accountName,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
