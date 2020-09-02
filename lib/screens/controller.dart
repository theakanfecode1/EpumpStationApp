//import 'package:epump/screens/attendants.dart';
//import 'package:epump/screens/bankdeposits.dart';
//import 'package:epump/screens/banksaccounts.dart';
//import 'package:epump/screens/dashboard.dart';
//import 'package:epump/screens/expenses.dart';
//import 'package:epump/screens/maintenance.dart';
//import 'package:epump/screens/pricechange.dart';
//import 'package:epump/screens/pumps.dart';
//import 'package:epump/screens/settlementaccount.dart';
//import 'package:epump/screens/shifts.dart';
//import 'package:epump/screens/summary.dart';
//import 'package:epump/screens/tanks.dart';
//import 'package:epump/stores/accountstores/accountloginstore.dart';
//import 'package:epump/values/colors.dart';
//import 'package:epump/values/constants.dart';
//import 'package:epump/values/gradientcontainer.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_mobx/flutter_mobx.dart';
//import 'package:flutter_svg/flutter_svg.dart';
//import 'package:provider/provider.dart';
//
//class Controller extends StatefulWidget {
//  @override
//  _ControllerState createState() => _ControllerState();
//}
//
//class _ControllerState extends State<Controller> {
//
//
//
//
//  dynamic getMenus(){
//
//    final accountlogin = Provider.of<AccountLoginStore>(context,listen: false);
//
//    List<dynamic> menus = [
//      Container(
//        height: 140,
//        child: Column(
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//        children: <Widget>[
//          Image.asset(Constants.getAssetGeneralName("drawerheader", "png"),height: 70,),
//          Observer(
//            builder:(_) => Text(accountlogin.loginDetails.firstName+" "+accountlogin.loginDetails.lastName,style: TextStyle(
//                color: Colors.white,
//                fontSize: 15,
//              fontWeight: FontWeight.w400,
//            ),),
//          ),
//
//          Observer(
//            builder:(_) => Text(accountlogin.loginDetails.email,style: TextStyle(
//                color: Colors.white,
//                fontSize: 15,
//              fontWeight: FontWeight.w400,
//            ),),
//          ),
//        ],
//      ),decoration: BoxDecoration(
//        color: CustomColors.REMIS_DARK_PURPLE,
//      ),),
//      Container(
//        child: ListTile(
//          onTap: (){
//            Navigator.of(context).pop();
//            setState(() {
//              _page = Dashboard();
//              _index = 0;
//            });
//          },
//          leading: SvgPicture.asset(Constants.getAssetGeneralName("dashboard", "svg"),color: Colors.white,width: 22),
//          title: Text("Dashboard",style: TextStyle(
//              color: Colors.white,
//              fontSize: 15,
//            fontWeight: FontWeight.bold,
//          ),),
//        ),
//      ),
//      Container(
//        child: ListTile(
//          onTap: (){
//            Navigator.of(context).pop();
//            setState(() {
//              _page = Summary();
//              _index = 1;
//            });
//          },
//          leading: SvgPicture.asset(Constants.getAssetGeneralName("statistics", "svg"),color: Colors.white,width: 22,height: 17,),
//          title: Text("Summary",style: TextStyle(
//              color: Colors.white,
//              fontSize: 16,
//            fontWeight: FontWeight.bold,
//          ),),
//        ),
//      ),
//      Container(
//        child: ListTile(
//          onTap: (){
//            Navigator.of(context).pop();
//            setState(() {
//              _page = Tanks();
//              _index = 2;
//            });
//          },
//          leading: SvgPicture.asset(Constants.getAssetGeneralName("tankdrawer", "svg"),color: Colors.white,width: 22),
//          title: Text("Tanks",style: TextStyle(
//              color: Colors.white,
//              fontSize: 16,
//            fontWeight: FontWeight.bold,
//          ),),
//        ),
//      ),
//      Container(
//        child: ListTile(
//          onTap: (){
//            Navigator.of(context).pop();
//            setState(() {
//              _page = Pumps();
//              _index = 3;
//            });
//          },
//          leading: SvgPicture.asset(Constants.getAssetGeneralName("fueldrawer", "svg"),color: Colors.white,width: 22),
//          title: Text("Pumps",style: TextStyle(
//              color: Colors.white,
//              fontSize: 16,
//            fontWeight: FontWeight.bold,
//          ),),
//        ),
//      ),
//      Container(
//        child: ListTile(
//          onTap: (){
//            Navigator.of(context).pop();
//            setState(() {
//              _page = SettlementAccount();
//              _index = 4;
//            });
//          },
//          leading: SvgPicture.asset(Constants.getAssetGeneralName("money", "svg"),color: Colors.white,width: 22),
//          title: Text("Settlement",style: TextStyle(
//            color: Colors.white,
//            fontSize: 16,
//            fontWeight: FontWeight.bold,
//          ),),
//        ),
//      ),
//      Container(
//        child: ListTile(
//          onTap: (){
//            setState(() {
//              showManagement = !showManagement;
//            });
//          },
//          leading: SvgPicture.asset(Constants.getAssetGeneralName("dashboard", "svg"),color: Colors.white,width: 22),
//          title: Text("Management",style: TextStyle(
//              color: Colors.white,
//              fontSize: 16,
//            fontWeight: FontWeight.bold,
//          ),
//          ),
//        ),
//      ),
//    ];
//    if(showManagement){
//      menus.add(Padding(
//        padding: EdgeInsets.only(left: 25),
//        child: Container(
//          child: ListTile(
//            onTap: (){
//              Navigator.of(context).pop();
//              setState(() {
//                _page = BankDeposits();
//                _index = 6;
//              });
//            },
//            leading: SvgPicture.asset(Constants.getAssetGeneralName("bankdash", "svg"),color: Colors.white,width: 22),
//            title: Text("Bank Deposits",style: TextStyle(
//              color: Colors.white,
//              fontSize: 16,
//              fontWeight: FontWeight.w400,
//            ),),
//          ),
//        ),
//      ));
//      menus.add(Padding(
//        padding: EdgeInsets.only(left: 25),
//        child: Container(
//          child: ListTile(
//            onTap: (){
//              Navigator.of(context).pop();
//              setState(() {
//                _page = Expenses();
//                _index = 7;
//              });
//            },
//            leading: SvgPicture.asset(Constants.getAssetGeneralName("expenses", "svg"),color: Colors.white,width: 22,),
//            title: Text("Expenses",style: TextStyle(
//                color: Colors.white,
//                fontSize: 16,
//              fontWeight: FontWeight.w400,
//            ),),
//          ),
//        ),
//      ));
//      menus.add(Padding(
//        padding: EdgeInsets.only(left: 25),
//        child: Container(
//          child: ListTile(
//            onTap: (){
//              Navigator.of(context).pop();
//              setState(() {
//                _page = Shifts();
//                _index = 8;
//              });
//            },
//            leading: SvgPicture.asset(Constants.getAssetGeneralName("stopwatchdrawer", "svg"),color: Colors.white,width: 22),
//            title: Text("Shifts",style: TextStyle(
//                color: Colors.white,
//                fontSize: 16,
//              fontWeight: FontWeight.w400,
//            ),),
//          ),
//        ),
//      ));
//      menus.add(Padding(
//        padding: EdgeInsets.only(left: 25),
//        child: Container(
//          child: ListTile(
//            onTap: (){
//              Navigator.of(context).pop();
//              setState(() {
//                _page = Attendants();
//                _index = 9;
//              });
//            },
//            leading: SvgPicture.asset(Constants.getAssetGeneralName("userdrawer", "svg"),color: Colors.white,width: 22),
//            title: Text("Attendants",style: TextStyle(
//                color: Colors.white,
//                fontSize: 16,
//              fontWeight: FontWeight.w400,
//            ),),
//          ),
//        ),
//      ));
//      menus.add(Padding(
//        padding: EdgeInsets.only(left: 25),
//        child: Container(
//          child: ListTile(
//            onTap: (){
//              Navigator.of(context).pop();
//              setState(() {
//                _page = BankAccounts();
//                _index = 10;
//              });
//            },
//            leading: SvgPicture.asset(Constants.getAssetGeneralName("banktwo", "svg"),color: Colors.white,width: 22),
//            title: Text("Bank Accounts",style: TextStyle(
//              color: Colors.white,
//              fontSize: 16,
//              fontWeight: FontWeight.w400,
//            ),),
//          ),
//        ),
//      ));
//      menus.add(Padding(
//        padding: EdgeInsets.only(left: 25),
//        child: Container(
//          child: ListTile(
//            onTap: (){
//              Navigator.of(context).pop();
//              setState(() {
//                _page = Maintenance();
//                _index = 11;
//              });
//            },
//            leading: SvgPicture.asset(Constants.getAssetGeneralName("maintenance", "svg"),color: Colors.white,width: 22),
//            title: Text("Maintenance",style: TextStyle(
//                color: Colors.white,
//                fontSize: 16,
//              fontWeight: FontWeight.w400,
//            ),),
//          ),
//        ),
//      ));
//      menus.add(Padding(
//        padding: EdgeInsets.only(left: 25),
//        child: Container(
//          child: ListTile(
//            onTap: (){
//              Navigator.of(context).pop();
//              setState(() {
//                _page = PriceChange();
//                _index = 12;
//              });
//            },
//            leading: SvgPicture.asset(Constants.getAssetGeneralName("cross", "svg"),color: Colors.white,width: 22),
//            title: Text("Price Change",style: TextStyle(
//                color: Colors.white,
//                fontSize: 15,
//              fontWeight: FontWeight.w400,
//            ),),
//          ),
//        ),
//      ));
//    }
//    menus.add(ListTile(
//      onTap: (){
//        Navigator.of(context).pop();
//        Navigator.of(context).pushReplacementNamed("/login");
//
//      },
//      leading: Icon(Icons.power_settings_new,color: Colors.white,size: 25,),
//      title: Text("Sign Out",style: TextStyle(
//          color: Colors.white,
//          fontSize: 16,
//        fontWeight: FontWeight.bold,
//      ),),
//    ));
//    return menus;
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: _page,
//      drawer: Drawer(
//        child: GradientContainer(
//          body: ListView.builder(
//            itemCount: getMenus().length,
//            itemBuilder: (context,index){
//              return getMenus()[index];
//            },
//          ),
//        ),
//      ),
//    );
//  }
//}
