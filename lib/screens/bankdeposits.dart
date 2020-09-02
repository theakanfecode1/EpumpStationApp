import 'package:epump/customwidgets/datefilter.dart';
import 'package:epump/customwidgets/structureddialog.dart';
import 'package:epump/screens/dashboard.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/screens/recorddeposit.dart';
import 'package:epump/stores/branchstores/bankdepositstore.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BankDeposits extends StatefulWidget {
  @override
  _BankDepositsState createState() => _BankDepositsState();
}

class _BankDepositsState extends State<BankDeposits> {
  String startDate;
  String endDate;

  @override
  void initState() {
    startDate = DateFormat.yMMMd().format(DateTime.now());
    endDate = DateFormat.yMMMd().format(DateTime.now());
    super.initState();
  }

  filteredData(String startDate,String endDate) async{
    Navigator.of(context)
        .push(LoadingWidget.showLoadingScreen("Fetching Deposits"));
    final bankDepositStore = Provider.of<BankDepositStore>(context, listen: false);
    String resultOne = await bankDepositStore.getBankDeposits(startDate, endDate);
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    final bankDepositStore = Provider.of<BankDepositStore>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Navigator.of(context)
          .push(LoadingWidget.showLoadingScreen("Fetching Deposits"));
      await bankDepositStore.getBankDeposits(startDate, endDate);
      Navigator.of(context).pop();
    });

    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text(
            "Bank Deposits",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: (){
                  showDialog(context: context,builder: (_){
                    return StructuredDialog(
                      giveRadius: true,
                      child: DateFilter(
                        function: filteredData,
                      ),
                    );
                  }
                  );
                })
          ],
        ),
        drawer: DrawerOnly(),
        body: Observer(
          builder: (_) => ListView.builder(
              itemCount: bankDepositStore.deposits.length,
              itemBuilder: (context, index) {
                return CustomListCard(
                  amount: Constants.formatThisInput(
                      bankDepositStore.deposits[index].amount),
                  account: Constants.formatThisInput(bankDepositStore.deposits[index].amount),
                  teller: bankDepositStore.deposits[index].tellerNumber,
                  date: bankDepositStore.deposits[index].date,
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => RecordDeposit())),
            backgroundColor: CustomColors.REMIS_PURPLE,
            child: Icon(Icons.add, size: 20)));
  }
}

class CustomListCard extends StatelessWidget {
  final amount;
  final account;
  final teller;
  final date;

  CustomListCard({this.amount, this.account, this.teller, this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:5.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 130,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: CustomColors.REMIS_LIGHT_GREY),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              SvgPicture.asset(
                Constants.getAssetGeneralName("bankdash", "svg"),
                width: 40,
                color: CustomColors.REMIS_PURPLE,
              ),
              SizedBox(
                width: 25,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          Constants.getAssetGeneralName("naira", "svg"),
                          color: Colors.black,
                          width: 18,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          amount,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 19),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      account,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      teller,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 13),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      date,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
