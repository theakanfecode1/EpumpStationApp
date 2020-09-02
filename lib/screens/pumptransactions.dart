import 'package:epump/customwidgets/datefilter.dart';
import 'package:epump/customwidgets/feedbackwidget.dart';
import 'package:epump/customwidgets/singletextfielddialog.dart';
import 'package:epump/customwidgets/structureddialog.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/stores/branchstores/pumpstore.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PumpTransactions extends StatefulWidget {

  final id;
  final displayName;


  PumpTransactions({this.id, this.displayName});

  @override
  _PumpTransactionsState createState() => _PumpTransactionsState();
}

class _PumpTransactionsState extends State<PumpTransactions> {
  String startDate;
  String endDate;
  String pumpId;
  bool isDataFetched = false;

  filteredData(String startDate,String endDate) async{
    Navigator.of(context)
        .push(LoadingWidget.showLoadingScreen("Fetching Transaction"));
    final pumpStore = Provider.of<PumpStore>(context, listen: false);
    String resultOne = await pumpStore.getPumpTransactions(widget.id, startDate, endDate, true);
    Navigator.of(context).pop();
    if (resultOne != NetworkStrings.SUCCESSFUL) {
      showDialog(
          context: context,
          builder: (context) {
            return StructuredDialog(
              giveRadius: true,
              child: FeedbackWidget(title: "ERROR",status: false,message: resultOne,),
            );
          });
    }

  }


  textFromConfirmationDialog(String comment) async {
    final pumpStore = Provider.of<PumpStore>(context,listen: false);
    Navigator.of(context).push(LoadingWidget.showLoadingScreen("Returning to Tank"));
    String result = await pumpStore.postRtt(pumpId, comment);
    Navigator.of(context).pop();
    if(result == NetworkStrings.SUCCESSFUL){
      showDialog(context: context,builder: (_){
        return StructuredDialog(
          giveRadius: true,
          child: FeedbackWidget(
            title: "Success",
            status: true,
            message: result,
          ),);
      });
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

  }
  @override
  void initState() {
    startDate = DateFormat.yMMMd().format(DateTime.now());
    endDate = DateFormat.yMMMd().format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pumpStore = Provider.of<PumpStore>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if(!isDataFetched){
        Navigator.of(context).push(LoadingWidget.showLoadingScreen("Fetching Transactions"));
        await pumpStore.getPumpTransactions(widget.id, startDate, endDate, true);
        Navigator.of(context).pop();
        setState(() {
          isDataFetched = true;
        });
      }

    });
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          widget.displayName,
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
                    child: DateFilter(function: filteredData,),
                  );
                });
              })
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 180,
            width: MediaQuery.of(context).size.width,
            color: CustomColors.REMIS_PURPLE,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SvgPicture.asset(
                  Constants.getAssetGeneralName("hand", "svg"),
                  color: Colors.white,
                  width: 60,
                ),
                Text(
                  "Total Sales",
                  style: TextStyle(
                      color: Colors.white, fontFamily: "Nunito", fontSize: 18),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      Constants.getAssetGeneralName("naira", "svg"),
                      color: Colors.white,
                      width: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Observer(
                      builder:(_) => Text(
                        Constants.formatThisInput(pumpStore.totalPumpTransaction),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 23),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Observer(
              builder:(_) => ListView.builder(
                itemCount: pumpStore.pumpTransactions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 220,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  ListTile(
                                    onTap: () {
                                      setState(() {
                                        pumpId = pumpStore.pumpTransactions[index].id;
                                      });
                                      Navigator.of(context).pop();
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return StructuredDialog(
                                              giveRadius: true,
                                              child: SingleTextFieldDialog(title: "Input Comment",inputType: TextInputType.text,hint: "Comment",notShowText: false,function: textFromConfirmationDialog,),
                                            );
                                          });
                                    },
                                    title: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        "Return to Tank",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.black,
                                    thickness: 0.4,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    title: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        "Print",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.black,
                                    thickness: 0.4,
                                  ),
                                  ListTile(
                                    onTap: () => Navigator.of(context).pop(),
                                    title: Center(
                                      child: Text(
                                        "Close",
                                        style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top:3.0),
                      child: CustomListCard(
                        amount: Constants.formatThisInput(pumpStore.pumpTransactions[index].priceSoldCash),
                        volume: Constants.formatThisInput(pumpStore.pumpTransactions[index].totalSale),
                        date: pumpStore.pumpTransactions[index].date,
                        staffType: pumpStore.pumpTransactions[index].salesType,
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomListCard extends StatelessWidget {
  final amount;
  final date;
  final volume;
  final staffType;

  CustomListCard({this.amount, this.date, this.volume, this.staffType});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 120,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: CustomColors.REMIS_LIGHT_GREY),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SvgPicture.asset(
              Constants.getAssetGeneralName("gas_station", "svg"),
              width: 40,
              color: CustomColors.REMIS_PURPLE,
            ),
//            SizedBox(
//              width: 20,
//            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      Constants.getAssetGeneralName("naira", "svg"),
                      color: Colors.black,
                      width: 15,
                    ),
                    SizedBox(
                      width: 5,
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
                Text(
                  "$volume ltr(s)",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
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
            Padding(
              padding: const EdgeInsets.only(right: 5.0, top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    staffType,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
