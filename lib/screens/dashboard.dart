import 'package:epump/customwidgets/datefilter.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/stores/accountstores/accountloginstore.dart';
import 'package:epump/stores/branchstores/daysaleandposandvouchersalesstore.dart';
import 'package:epump/stores/branchstores/expensestore.dart';
import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:epump/values/gradientcontainer.dart';
import 'package:epump/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isDataFetched = false;
  String startDate;
  String endDate;
  int loadingDialogFlag  = 0;
  Map data = {};


  @override
  void initState() {
    startDate = DateFormat.yMMMd().format(DateTime.now());
    endDate = DateFormat.yMMMd().format(DateTime.now());
    super.initState();
  }


  void getDaySale(String startDate,String endDate)async {
    final branchStore = Provider.of<DaySaleAndPosStore>(context, listen: false);
    String resultOne = await branchStore.getDaySale(
        Strings.DASHBOARD_REQUEST, startDate, endDate);
    setState(() {
        loadingDialogFlag++;
        if(loadingDialogFlag == 4){
          Navigator.of(context).pop();
        }
    });
  }
  void getPosAndVoucherSales(String startDate) async {
    final branchStore = Provider.of<DaySaleAndPosStore>(context, listen: false);
    String resultTwo = await branchStore.getPosAndVoucherSales(startDate);
    setState(() {
      loadingDialogFlag++;
      if(loadingDialogFlag == 4){
        Navigator.of(context).pop();
      }
    });

  }
  void getBankTransactions(String startDate,String endDate) async {
    final branchStore = Provider.of<DaySaleAndPosStore>(context, listen: false);
    String resultFour = await branchStore.getBankTransactions(startDate,endDate);
    setState(() {
      loadingDialogFlag++;
      if(loadingDialogFlag == 4){
        Navigator.of(context).pop();
      }
    });

  }

  void getExpenses(String startDate,String endDate) async {
    final expenseStore = Provider.of<ExpenseStore>(context, listen: false);
    String resultThree = await expenseStore.getExpenses(startDate,endDate);
    setState(() {
      loadingDialogFlag++;
      if(loadingDialogFlag == 4){
        Navigator.of(context).pop();
      }
    });

  }

  filteredData(String startDate,String endDate) async{
    setState(() {
      loadingDialogFlag = 0;
    });
    Navigator.of(context)
        .push(LoadingWidget.showLoadingScreen("Fetching Transaction"));
    getDaySale(startDate,endDate);
    getPosAndVoucherSales(startDate);
    getBankTransactions(startDate,endDate);
    getExpenses(startDate,endDate);
  }



  @override
  Widget build(BuildContext context) {


    final branchStore = Provider.of<DaySaleAndPosStore>(context);
    final expenseStore = Provider.of<ExpenseStore>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(!isDataFetched){
        Navigator.of(context).push(LoadingWidget.showLoadingScreen("Fetching Transaction"));
        getDaySale(startDate,endDate);
        getPosAndVoucherSales(startDate);
        getBankTransactions(startDate,endDate);
        getExpenses(startDate,endDate);
        setState(() {
          isDataFetched=true;
        });
      }
//      dashBoardData();
    });
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: DrawerOnly(),
        appBar: AppBar(
          elevation: 1,
          title: Text(
            "Dashboard",
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
                          child: DateFilter(function: filteredData,),
                        );
                      });
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(height: 330),
              color: Colors.grey[200],
              child: Stack(
                fit: StackFit.loose,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 215,
                    decoration: BoxDecoration(
                        color: CustomColors.REMIS_PURPLE,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(35),
                            bottomRight: Radius.circular(35))),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              Constants.getAssetGeneralName("naira", "svg"),
                              color: Colors.white,
                              width: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Observer(
                              builder: (_) => Text(
                                  Constants.formatThisInput(branchStore.totalSales),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Total Sales",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 160,
                    left: 10,
                    right: 10,
                    child: Card(
                      elevation: 0,
                      child: Container(
                        height: 150,
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    Constants.getAssetGeneralName(
                                        "dropdash", "svg"),
                                    color: CustomColors.REMIS_LIGHT_BLUE,
                                    width: 25,
                                  ),
                                  SizedBox(
                                    height: 10,
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
                                  Observer(
                                    builder: (_) => SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          Constants.formatThisInput(branchStore.pms),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Litres",
                                    style: TextStyle(
                                      color: CustomColors.REMIS_GREY,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    Constants.getAssetGeneralName(
                                        "dropdash", "svg"),
                                    color: CustomColors.REMIS_RED,
                                    width: 25,
                                  ),
                                  SizedBox(
                                    height: 10,
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
                                  Observer(
                                    builder: (_) => SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          Constants.formatThisInput(branchStore.dpk),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Litres",
                                    style: TextStyle(
                                      color: CustomColors.REMIS_GREY,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    Constants.getAssetGeneralName(
                                        "dropdash", "svg"),
                                    color: CustomColors.REMIS_GREEN,
                                    width: 25,
                                  ),
                                  SizedBox(
                                    height: 10,
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
                                  Observer(
                                    builder: (_) => SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                            Constants.formatThisInput(branchStore.ago),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Litres",
                                    style: TextStyle(
                                      color: CustomColors.REMIS_GREY,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Table(
                  border: TableBorder.symmetric(
                      inside: BorderSide(
                          color: Colors.grey[200].withOpacity(
                    0.9,
                  ))),
                  children: [
                    TableRow(children: [
                      TableCell(
                        child: Observer(
                          builder: (_) => GridList(
                            image: Constants.getAssetGeneralName(
                                "agreementdash", "svg"),
                            amount: Constants.formatThisInput(branchStore.totalSales -(branchStore.epumpSales + branchStore.retainershipSales)),
                            title: "Cash sales",
                            size: 30,
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) => GridList(
                          image: Constants.getAssetGeneralName("epsaless", "svg"),
                          amount: Constants.formatThisInput(branchStore.epumpSales),
                          title: "Epump sales",
                          size: 29,
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: Observer(
                          builder: (_) => GridList(
                            image: Constants.getAssetGeneralName(
                                "cycledash", "svg"),
                            amount: Constants.formatThisInput(branchStore.retainershipSales),
                            title: "Retainership sales",
                            size: 30,
                          ),
                        ),
                      ),
                      TableCell(
                        child: Observer(
                          builder:(_)=> GridList(
                            image: Constants.getAssetGeneralName(
                              "expenses",
                              "svg",
                            ),
                            amount: Constants.formatThisInput(expenseStore.totalExpenses),
                            title: "Expense",
                            size: 30,
                          ),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: Observer(
                          builder:(_) => GridList(
                            image: Constants.getAssetGeneralName(
                                "rttank", "svg"),
                            amount:Constants.formatThisInput(branchStore.rtt),
                            title: "Return to tank",
                            size: 28,
                          ),
                        ),
                      ),
                      TableCell(
                        child: Observer(
                          builder:(_)=> GridList(
                            image:
                                Constants.getAssetGeneralName("bankdash", "svg"),
                            amount: Constants.formatThisInput(branchStore.cashToBank),
                            title: "Cash to bank",
                            size: 28,
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }
}

class GridList extends StatelessWidget {
  final String amount;
  final String title;
  final String image;
  final double size;

  GridList({this.amount, this.title, this.image, this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        height: 120,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            SvgPicture.asset(
              image,
              color: CustomColors.REMIS_PURPLE,
              width: size,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      amount,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: CustomColors.REMIS_GREY,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
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

class DrawerOnly extends StatefulWidget {


  @override
  _DrawerOnlyState createState() => _DrawerOnlyState();
}

class _DrawerOnlyState extends State<DrawerOnly> {
  bool showManagement = false;
  String name="";
  String email="";
  String location;
  bool role = false;
  void getName()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      name = (sharedPreferences.get("FIRST_NAME")??"") + " " +(sharedPreferences.get("LAST_NAME")??"");
      String prefRole = sharedPreferences.getString("ROLE")??"";
      email = sharedPreferences.get("EMAIL")??"";
      location = (sharedPreferences.get("LOCATION")??"");
      if(prefRole.toLowerCase() != "companyadmin"){
        role = false;
      }else{
        role = true;
      }
    });

  }

  dynamic getMenus(){
    List<dynamic> menus = [
      Container(
        height: role ? 180: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset(
              Constants.getAssetGeneralName("pumpalone", "png"),
              height: 70,
              width: 60,

            ),
            Text(name,
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
            if(role)
              Text(
                location,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

          ],
        ),
        decoration: BoxDecoration(
          color: CustomColors.REMIS_DARK_PURPLE,
        ),
      ),


      Container(
        child: role? ListTile(
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          leading: Icon(Icons.arrow_back,color: Colors.white,size: 25,),
          title: Text(
            "Back to Company",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ):null,
      ),

      Container(
        child: ListTile(
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed("/dashboard");
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
            Navigator.of(context).pushReplacementNamed("/summary");
          },
          leading: SvgPicture.asset(
            Constants.getAssetGeneralName("statistics", "svg"),
            color: Colors.white,
            height: 17,
          ),
          title: Text(
            "Summary",
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
            Navigator.of(context).pushReplacementNamed("/tanks");
          },
          leading: SvgPicture.asset(
              Constants.getAssetGeneralName("tankfilled", "svg"),
              color: Colors.white,
            width: 25,
             ),
          title: Text(
            "Tanks",
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
            Navigator.of(context).pushReplacementNamed("/pumps");
          },
          leading: SvgPicture.asset(
              Constants.getAssetGeneralName("pumpneww", "svg"),
              color: Colors.white,
              width: 30),
          title: Text(
            "Pumps",
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
            Navigator.of(context).pushReplacementNamed("/settlementaccount");
          },
          leading: SvgPicture.asset(
              Constants.getAssetGeneralName("money", "svg"),
              color: Colors.white,
              width: 22),
          title: Text(
            "Settlement",
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
            setState(() {
              showManagement = !showManagement;
            });
          },
          leading: SvgPicture.asset(
              Constants.getAssetGeneralName("dashboard", "svg"),
              color: Colors.white,
              width: 22),
          title: Text(
            "Management",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ];
    if (showManagement) {
      menus.add(Padding(
        padding: EdgeInsets.only(left: 25),
        child: Container(
          child: ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/bankdeposits");
            },
            leading: SvgPicture.asset(
                Constants.getAssetGeneralName("bankdash", "svg"),
                color: Colors.white,
                width: 22),
            title: Text(
              "Bank Deposits",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ));
      menus.add(Padding(
        padding: EdgeInsets.only(left: 25),
        child: Container(
          child: ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/expenses");
            },
            leading: SvgPicture.asset(
              Constants.getAssetGeneralName("expenses", "svg"),
              color: Colors.white,
              width: 22,
            ),
            title: Text(
              "Expenses",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ));
      menus.add(Padding(
        padding: EdgeInsets.only(left: 25),
        child: Container(
          child: ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/shifts");
            },
            leading: SvgPicture.asset(
                Constants.getAssetGeneralName("stopwatchdrawer", "svg"),
                color: Colors.white,
                width: 22),
            title: Text(
              "Shifts",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ));
      menus.add(Padding(
        padding: EdgeInsets.only(left: 25),
        child: Container(
          child: ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/attendants");
            },
            leading: SvgPicture.asset(
                Constants.getAssetGeneralName("userdrawer", "svg"),
                color: Colors.white,
                width: 22),
            title: Text(
              "Attendants",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ));
      menus.add(Padding(
        padding: EdgeInsets.only(left: 25),
        child: Container(
          child: ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/bankaccounts");
            },
            leading: SvgPicture.asset(
                Constants.getAssetGeneralName("banktwo", "svg"),
                color: Colors.white,
                width: 22),
            title: Text(
              "Bank Accounts",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ));
      menus.add(Padding(
        padding: EdgeInsets.only(left: 25),
        child: Container(
          child: ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/maintenance");
            },
            leading: SvgPicture.asset(
                Constants.getAssetGeneralName("maintenance", "svg"),
                color: Colors.white,
                width: 22),
            title: Text(
              "Maintenance Requests",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ));
      menus.add(Padding(
        padding: EdgeInsets.only(left: 25),
        child: Container(
          child: ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/pricechange",arguments: {
                "fromCompany":false
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
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ));
    }
    menus.add(ListTile(
      onTap: () async {
        SharedPreferences sharedPref = await SharedPreferences.getInstance();
        sharedPref.clear();
        NetworkRequest.BRANCHID = "";
        NetworkRequest.COMPANYID = "";
        NetworkRequest.TOKEN = "";
        Navigator.of(context).pop();
        Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
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
    ));
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
