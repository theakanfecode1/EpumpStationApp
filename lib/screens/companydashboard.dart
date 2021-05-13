import 'package:epump/customwidgets/datefilter.dart';
import 'package:epump/screens/dashboard.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/stores/branchstores/daysaleandposandvouchersalesstore.dart';
import 'package:epump/stores/companystores/companysalesstore.dart';
import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:epump/values/gradientcontainer.dart';
import 'package:epump/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyDashboard extends StatefulWidget {
  @override
  _CompanyDashboardState createState() => _CompanyDashboardState();
}

class _CompanyDashboardState extends State<CompanyDashboard> {
  String yesterday = "";
  String thisMonth = "";
  String today = "";
  bool isDataFetched = false;
  bool dataIsFiltered = false;
  int loadingDialogFlag = 0;
  String headerToday = "Today";

  void fetchToday(String startDate, String endDate) async {
    final companySaleStore =
        Provider.of<CompanySalesStore>(context, listen: false);
    await companySaleStore.getCompanySales(
        Strings.TODAY_REQUEST, startDate, endDate);
    setState(() {
      loadingDialogFlag++;
      if (loadingDialogFlag == 3) {
        Navigator.of(context).pop();
      }
    });
  }

  void fetchYesterday(String startDate, String endDate) async {
    final companySaleStore =
        Provider.of<CompanySalesStore>(context, listen: false);
    await companySaleStore.getCompanySales(
        Strings.YESTERDAY_REQUEST, startDate, endDate);
    setState(() {
      loadingDialogFlag++;
      if (loadingDialogFlag == 3) {
        Navigator.of(context).pop();
      }
    });
  }

  void fetchMonth(String startDate, String endDate) async {
    final companySaleStore =
        Provider.of<CompanySalesStore>(context, listen: false);
    await companySaleStore.getCompanySales(
        Strings.MONTH_REQUEST, startDate, endDate);
    setState(() {
      loadingDialogFlag++;
      if (loadingDialogFlag == 3) {
        Navigator.of(context).pop();
      }
    });
  }

  void generateDate() {
    today = DateFormat.yMMMd().format(DateTime.now());
//    year/month/day
    DateTime startOfMonth =
    DateTime.parse("${DateTime.now().year}-${DateTime.now().month.toString().length == 2 ?DateTime.now().month : "0${DateTime.now().month}"}-01");
    thisMonth = DateFormat.yMMMd().format(startOfMonth);
    var tempYesterday = DateTime.now().subtract(Duration(days: 1));
    yesterday = DateFormat.yMMMd().format(tempYesterday);
  }

  filteredData(String startDate, String endDate) async {
    Navigator.of(context)
        .push(LoadingWidget.showLoadingScreen("Fetching Transactions"));
    final companySaleStore =
        Provider.of<CompanySalesStore>(context, listen: false);
    await companySaleStore.getCompanySales(
        Strings.TODAY_REQUEST, startDate, endDate);
    Navigator.of(context).pop();
    setState(() {
      dataIsFiltered = true;
      today = startDate + " - " + endDate;
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
    final companySaleStore = Provider.of<CompanySalesStore>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!isDataFetched) {
        Navigator.of(context)
            .push(LoadingWidget.showLoadingScreen("Fetching Transactions"));
        fetchToday(today, today);
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
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          insetPadding: EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: DateFilter(
                            function: filteredData,
                          ),
                        );
                      });
                })
          ],
        ),
        drawer: CompanyDrawerOnly(),
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
                          pmsAmount: Constants.formatThisInput(
                              companySaleStore.todayPmsAmount),
                          pmsVolume: Constants.formatThisInput(
                              companySaleStore.todayPmsVolume),
                          dpkAmount: Constants.formatThisInput(
                              companySaleStore.todayDpkAmount),
                          dpkVolume: Constants.formatThisInput(
                              companySaleStore.todayDpkVolume),
                          agoAmount: Constants.formatThisInput(
                              companySaleStore.todayAgoAmount),
                          agoVolume: Constants.formatThisInput(
                              companySaleStore.todayAgoVolume),
                      lpgAmount: Constants.formatThisInput(
                          companySaleStore.todayLpgAmount),
                      lpgVolume: Constants.formatThisInput(
                          companySaleStore.todayLpgVolume),
                        )),
                if (!dataIsFiltered)
                  Column(
                    children: <Widget>[
                      Observer(
                        builder: (_) => DetailsCard(
                          headerColor: CustomColors.REMIS_ORANGE,
                          headerTitle: "Yesterday",
                          headerSubtitle: "($yesterday)",
                          pmsAmount: Constants.formatThisInput(
                              companySaleStore.yesterdayPmsAmount),
                          pmsVolume: Constants.formatThisInput(
                              companySaleStore.yesterdayPmsVolume),
                          dpkAmount: Constants.formatThisInput(
                              companySaleStore.yesterdayDpkAmount),
                          dpkVolume: Constants.formatThisInput(
                              companySaleStore.yesterdayDpkVolume),
                          agoAmount: Constants.formatThisInput(
                              companySaleStore.yesterdayAgoAmount),
                          agoVolume: Constants.formatThisInput(
                              companySaleStore.yesterdayAgoVolume),
                          lpgAmount: Constants.formatThisInput(
                              companySaleStore.yesterdayLpgAmount),
                          lpgVolume: Constants.formatThisInput(
                              companySaleStore.yesterdayLpgVolume),
                        ),
                      ),
                      Observer(
                        builder: (_) => DetailsCard(
                          headerColor: CustomColors.REMIS_LIGHT_ORGANGE,
                          headerTitle: "This Month",
                          headerSubtitle: "($thisMonth - $today)",
                          pmsAmount: Constants.formatThisInput(
                              companySaleStore.monthPmsAmount),
                          pmsVolume: Constants.formatThisInput(
                              companySaleStore.monthPmsVolume),
                          dpkAmount: Constants.formatThisInput(
                              companySaleStore.monthDpkAmount),
                          dpkVolume: Constants.formatThisInput(
                              companySaleStore.monthDpkVolume),
                          agoAmount: Constants.formatThisInput(
                              companySaleStore.monthAgoAmount),
                          agoVolume: Constants.formatThisInput(
                              companySaleStore.monthAgoVolume),
                          lpgAmount: Constants.formatThisInput(
                              companySaleStore.monthLpgAmount),
                          lpgVolume: Constants.formatThisInput(
                              companySaleStore.monthLpgVolume),
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
  final String lpgAmount;
  final String lpgVolume;

  DetailsCard(
      {this.headerColor,
      this.headerTitle,
      this.headerSubtitle,
      this.pmsAmount,
      this.pmsVolume,
      this.dpkAmount,
      this.dpkVolume,
      this.agoAmount,
      this.agoVolume,this.lpgVolume,this.lpgAmount});

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
                    SizedBox(width: 5,),
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
                    SizedBox(width: 5,),
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
                    SizedBox(width: 5,),
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
                    SizedBox(width: 5,),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SvgPicture.asset(
                            Constants.getAssetGeneralName("dropdash", "svg"),
                            color: CustomColors.REMIS_DARK_PURPLE,
                            width: 27,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "LPG",
                            style: TextStyle(
                                color: CustomColors.REMIS_DARK_PURPLE,
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
                                  lpgAmount,
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
                              lpgVolume + "ltr(s)",
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5,),

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

class CompanyDrawerOnly extends StatefulWidget {
  @override
  _CompanyDrawerOnlyState createState() => _CompanyDrawerOnlyState();
}

class _CompanyDrawerOnlyState extends State<CompanyDrawerOnly> {
  bool showManagement = false;
  String name = "";
  String email = "";

  void getName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      name = (sharedPreferences.get("FIRST_NAME") ?? "") +
          " " +
          (sharedPreferences.get("LAST_NAME") ?? "");
      print(sharedPreferences.get("LAST_NAME"));
      email = sharedPreferences.get("EMAIL") ?? "";
    });
  }

  dynamic getMenus()  {
    List<dynamic> menus = [
      Container(
        height: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset(
              Constants.getAssetGeneralName("pumpalone", "png"),
              height: 70,
              width: 60,
            ),
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              email,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: CustomColors.REMIS_DARK_PURPLE,
        ),
      ),
      Container(
        child: ListTile(
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed("/companydashboard");
          },
          leading: SvgPicture.asset(
              Constants.getAssetGeneralName("dashboard", "svg"),
              color: Colors.white,
              width: 22),
          title: Text(
            "Dashboard",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Container(
        child: ListTile(
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed("/companybranches");
          },
          leading: Icon(
            Icons.business,
            color: Colors.white,
            size: 25,
          ),
          title: Text(
            "Branches",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Container(
        child: ListTile(
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context)
                .pushReplacementNamed("/pricechange", arguments: {
              "fromCompany": true,
            });
          },
          leading: SvgPicture.asset(
              Constants.getAssetGeneralName("cross", "svg"),
              color: Colors.white,
              width: 22),
          title: Text(
            "Price Change",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      ListTile(
        onTap: () async {
          SharedPreferences sharedPref = await SharedPreferences.getInstance();
          sharedPref.clear();
          Navigator.of(context).pop();
          Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
          NetworkRequest.BRANCHID = "";
          NetworkRequest.COMPANYID = "";
          NetworkRequest.TOKEN = "";


        },
        leading: Icon(
          Icons.power_settings_new,
          color: Colors.white,
          size: 25,
        ),
        title: Text(
          "Sign Out",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ];
    return menus;
  }
  @override
  void initState() {
    getName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: GradientContainer(
        body: ListView.builder(
          itemCount: getMenus().length,
          itemBuilder: (context, index) {
            return getMenus()[index];
          },
        ),
      ),
    );
  }
}
