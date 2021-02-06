import 'package:epump/customwidgets/datefilter.dart';
import 'package:epump/screens/dashboard.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/stores/branchstores/daysaleandposandvouchersalesstore.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:epump/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:epump/stores/branchstores/daysaleandposandvouchersalesstore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Summary extends StatefulWidget {
  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  String yesterday = "";
  String thisMonth = "";
  String today = "";
  bool  isDataFetched = false;
  bool dataIsFiltered = false;
  int loadingDialogFlag = 0;
  String headerToday = "Today";

  void fetchToday(String startDate,String endDate) async {
      final daySaleStore =
      Provider.of<DaySaleAndPosStore>(context, listen: false);
      await daySaleStore.getDaySale(Strings.TODAY_REQUEST, startDate, endDate);
      setState(() {
        loadingDialogFlag++;
        if(loadingDialogFlag == 3){
          Navigator.of(context).pop();
        }
      });
  }

  void fetchYesterday(String startDate,String endDate) async {
      final daySaleStore =
      Provider.of<DaySaleAndPosStore>(context, listen: false);
      await daySaleStore.getDaySale(Strings.YESTERDAY_REQUEST, startDate, endDate);
      setState(() {
        loadingDialogFlag++;
        if(loadingDialogFlag == 3){
          Navigator.of(context).pop();
        }
      });
  }
  void fetchMonth(String startDate,String endDate) async {
      final daySaleStore =
      Provider.of<DaySaleAndPosStore>(context, listen: false);
      await daySaleStore.getDaySale(Strings.MONTH_REQUEST, startDate, endDate);
      setState(() {
        loadingDialogFlag++;
        if(loadingDialogFlag == 3){
          Navigator.of(context).pop();
        }
      });
  }

  void generateDate() {
    today = DateFormat.yMMMd().format(DateTime.now());
//    year/month/day
    DateTime startOfMonth =
        DateTime.parse("${DateTime.now().year}-${DateTime.now().month.toString().length == 2 ? DateTime.now().month : "0${DateTime.now().month}"}-01");
    thisMonth = DateFormat.yMMMd().format(startOfMonth);
    var tempYesterday = DateTime.now().subtract(Duration(days: 1));
    yesterday = DateFormat.yMMMd().format(tempYesterday);

  }

  filteredData(String startDate,String endDate) async {
    Navigator.of(context)
        .push(LoadingWidget.showLoadingScreen("Fetching Transactions"));
    final daySaleStore =
    Provider.of<DaySaleAndPosStore>(context, listen: false);
    await daySaleStore.getDaySale(Strings.TODAY_REQUEST, startDate, endDate);
    Navigator.of(context).pop();
    setState(() {
      dataIsFiltered = true;
      today = startDate+" - "+endDate;
      headerToday = "Filtered Date";
    });
  }

  @override
  void initState() {
    generateDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    final daySaleStore = Provider.of<DaySaleAndPosStore>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      if(!isDataFetched){
        Navigator.of(context)
            .push(LoadingWidget.showLoadingScreen("Fetching Transactions"));
        fetchToday( today, today);
        fetchYesterday(yesterday, yesterday);
        fetchMonth(thisMonth, today);
        setState(() {
          isDataFetched = true;
        });
      }
    });
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text(
            "Summary",
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
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          insetPadding: EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: DateFilter(function: filteredData,),
                        );
                      });
                })
          ],
        ),
        drawer: DrawerOnly(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Observer(
                    builder: (_) => DetailsCard(
                          headerColor: CustomColors.REMIS_LIGHT_BLUE,
                          headerTitle: headerToday,
                          headerSubtitle: "($today)",
                          pmsAmount:
                          Constants.formatThisInput(daySaleStore.todayPmsAmount),
                          pmsVolume:
                          Constants.formatThisInput(daySaleStore.todayPmsVolume),
                          dpkAmount:
                          Constants.formatThisInput(daySaleStore.todayDpkAmount),
                          dpkVolume:
                          Constants.formatThisInput(daySaleStore.todayDpkVolume),
                          agoAmount:
                          Constants.formatThisInput(daySaleStore.todayAgoAmount),
                          agoVolume:
                          Constants.formatThisInput(daySaleStore.todayAgoVolume),
                        )),
                if(!dataIsFiltered)
                  Column(
                    children: <Widget>[
                      Observer(
                        builder: (_) => DetailsCard(
                          headerColor: CustomColors.REMIS_ORANGE,
                          headerTitle: "Yesterday",
                          headerSubtitle: "($yesterday)",
                          pmsAmount:
                          Constants.formatThisInput(daySaleStore.yesterdayPmsAmount),
                          pmsVolume:
                          Constants.formatThisInput(daySaleStore.yesterdayPmsVolume),
                          dpkAmount:
                          Constants.formatThisInput(daySaleStore.yesterdayDpkAmount),
                          dpkVolume:
                          Constants.formatThisInput(daySaleStore.yesterdayDpkVolume),
                          agoAmount:
                          Constants.formatThisInput(daySaleStore.yesterdayAgoAmount),
                          agoVolume:
                          Constants.formatThisInput(daySaleStore.yesterdayAgoVolume),
                        ),
                      ),
                      Observer(
                        builder: (_) => DetailsCard(
                          headerColor: CustomColors.REMIS_LIGHT_ORGANGE,
                          headerTitle: "This Month",
                          headerSubtitle: "($thisMonth - $today)",
                          pmsAmount:
                          Constants.formatThisInput(daySaleStore.monthPmsAmount),
                          pmsVolume:
                          Constants.formatThisInput(daySaleStore.monthPmsVolume),
                          dpkAmount:
                          Constants.formatThisInput(daySaleStore.monthDpkAmount),
                          dpkVolume:
                          Constants.formatThisInput(daySaleStore.monthDpkVolume),
                          agoAmount:
                          Constants.formatThisInput(daySaleStore.monthAgoAmount),
                          agoVolume:
                          Constants.formatThisInput(daySaleStore.monthAgoVolume),
                        ),
                      ),
                    ],
                  ),


              ],
            ),
          ),
        ));
  }
}

class DetailsCard extends StatelessWidget {
  final Color headerColor;
  final String headerTitle;
  final String headerSubtitle;
  final String pmsAmount;
  final String pmsVolume;
  final String dpkAmount;
  final String dpkVolume;
  final String agoAmount;
  final String agoVolume;

  DetailsCard(
      {this.headerColor,
        this.headerTitle,
        this.headerSubtitle,
        this.pmsAmount,
        this.pmsVolume,
        this.dpkAmount,
        this.dpkVolume,
        this.agoAmount,
        this.agoVolume});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          height: 220,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: headerColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      headerTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      headerSubtitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SvgPicture.asset(
                            Constants.getAssetGeneralName("dropdash", "svg"),
                            color: CustomColors.REMIS_LIGHT_BLUE,
                            width: 27,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "PMS",
                            style: TextStyle(
                                color: CustomColors.REMIS_LIGHT_BLUE,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  Constants.getAssetGeneralName("naira", "svg"),
                                  color: Colors.grey[700],
                                  width: 12,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  pmsAmount,
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              pmsVolume + "ltr(s)",
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SvgPicture.asset(
                            Constants.getAssetGeneralName("dropdash", "svg"),
                            color: CustomColors.REMIS_RED,
                            width: 27,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "DPK",
                            style: TextStyle(
                                color: CustomColors.REMIS_RED,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  Constants.getAssetGeneralName("naira", "svg"),
                                  color: Colors.grey[700],
                                  width: 12,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  dpkAmount,
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              dpkVolume + "ltr(s)",
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SvgPicture.asset(
                            Constants.getAssetGeneralName("dropdash", "svg"),
                            color: CustomColors.REMIS_GREEN,
                            width: 27,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "AGO",
                            style: TextStyle(
                                color: CustomColors.REMIS_GREEN,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                  Constants.getAssetGeneralName("naira", "svg"),
                                  color: Colors.grey[700],
                                  width: 12,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  agoAmount,
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              agoVolume + "ltr(s)",
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),
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
