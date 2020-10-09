import 'dart:io';

import 'package:epump/screens/attendants.dart';
import 'package:epump/screens/bankdeposits.dart';
import 'package:epump/screens/banksaccounts.dart';
import 'package:epump/screens/companybranches.dart';
import 'package:epump/screens/companydashboard.dart';
import 'package:epump/screens/dashboard.dart';
import 'package:epump/screens/expenses.dart';
import 'package:epump/screens/maintenance.dart';
import 'package:epump/screens/onboarding.dart';
import 'package:epump/screens/pricechange.dart';
import 'package:epump/screens/pumps.dart';
import 'package:epump/screens/settlementaccount.dart';
import 'package:epump/screens/shifts.dart';
import 'package:epump/screens/splash_screen.dart';
import 'package:epump/screens/login.dart';
import 'package:epump/screens/summary.dart';
import 'package:epump/screens/tanks.dart';
import 'package:epump/stores/accountstores/accountloginstore.dart';
import 'package:epump/stores/branchstores/addbankstore.dart';
import 'package:epump/stores/branchstores/addexpensestore.dart';
import 'package:epump/stores/branchstores/addshiftstore.dart';
import 'package:epump/stores/branchstores/bankaccountstore.dart';
import 'package:epump/stores/branchstores/bankdepositstore.dart';
import 'package:epump/stores/branchstores/branchwalletstore.dart';
import 'package:epump/stores/branchstores/daysaleandposandvouchersalesstore.dart';
import 'package:epump/stores/branchstores/expensestore.dart';
import 'package:epump/stores/branchstores/maintenancerequeststore.dart';
import 'package:epump/stores/branchstores/pumpstore.dart';
import 'package:epump/stores/branchstores/shiftstore.dart';
import 'package:epump/stores/branchstores/pumpdetailstore.dart';
import 'package:epump/stores/branchstores/tankstore.dart';
import 'package:epump/stores/companystores/companymybranchesstore.dart';
import 'package:epump/stores/companystores/companysalesstore.dart';
import 'package:epump/stores/companystores/pricechangestore.dart';
import 'package:epump/stores/staffstore/attendantstore.dart';
import 'package:epump/stores/tankstore/tankdippingstore.dart';
import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(MultiProvider(
      providers: [
        Provider<AccountLoginStore>(
          create: (_) => AccountLoginStore(),
        ),
        Provider<CompanyMyBranchesStore>(
            create: (_) => CompanyMyBranchesStore()),
        Provider<DaySaleAndPosStore>(create: (_) => DaySaleAndPosStore()),
        Provider<TankStore>(create: (_) => TankStore()),
        Provider<PumpStore>(create: (_) => PumpStore()),
        Provider<PumpDetailsStore>(create: (_) => PumpDetailsStore()),
        Provider<ShiftStore>(create: (_) => ShiftStore()),
        Provider<ExpenseStore>(create: (_) => ExpenseStore()),
        Provider<MaintenanceRequestStore>(
            create: (_) => MaintenanceRequestStore()),
        Provider<BankAccountStore>(create: (_) => BankAccountStore()),
        Provider<AddBankStore>(create: (_) => AddBankStore()),
        Provider<AddExpenseStore>(create: (_) => AddExpenseStore()),
        Provider<AddShiftStore>(create: (_) => AddShiftStore()),
        Provider<PriceChangeStore>(create: (_) => PriceChangeStore()),
        Provider<BranchWalletStore>(create: (_) => BranchWalletStore()),
        Provider<BankDepositStore>(create: (_) => BankDepositStore()),
        Provider<AttendantStore>(create: (_) => AttendantStore()),
        Provider<TankDippingStore>(create: (_) => TankDippingStore()),
        Provider<CompanySalesStore>(create: (_) => CompanySalesStore()),
      ],
      child: MaterialApp(
        title: 'Epump',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xff7C2DCB),
          accentColor: Color(0xff341453),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: navigateToNext(sharedPreferences),
        routes: {
          '/splash_screen': (context) => SplashScreen(),
          '/login': (context) => Login(),
          '/onboarding': (context) => Onboarding(),
          '/companydashboard': (context) => CompanyDashboard(),
          '/companybranches': (context) => CompanyBranches(),
          '/dashboard': (context) => Dashboard(),
          '/summary': (context) => Summary(),
          '/tanks': (context) => Tanks(),
          '/pumps': (context) => Pumps(),
          '/settlementaccount': (context) => SettlementAccount(),
          '/bankdeposits': (context) => BankDeposits(),
          '/expenses': (context) => Expenses(),
          '/shifts': (context) => Shifts(),
          '/attendants': (context) => Attendants(),
          '/bankaccounts': (context) => BankAccounts(),
          '/maintenance': (context) => Maintenance(),
          '/pricechange': (context) => PriceChange(),
        },
      )));
}

String navigateToNext(SharedPreferences sharedPreferences) {
  bool loggedIn = sharedPreferences.getBool("LOGGED_IN") ?? false;
  if (loggedIn) {
    String loggedInAs = sharedPreferences.getString("LOGGED_IN_AS") ?? "";
    if (loggedInAs.toUpperCase() == "COMPANYADMIN") {
      NetworkRequest.COMPANYID = sharedPreferences.getString("COMPANY_ID");
      NetworkRequest.header[HttpHeaders.authorizationHeader] =
          sharedPreferences.getString("TOKEN");
      return "/companydashboard";
    } else {
      NetworkRequest.BRANCHID = sharedPreferences.getString("BRANCH_ID");
      NetworkRequest.header[HttpHeaders.authorizationHeader] =
          sharedPreferences.getString("TOKEN");
      return "/dashboard";
    }
  } else {
    return "/onboarding";
  }
}

//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return
//  }
//}

//flutter packages pub run build_runner watch --delete-conflicting-outputs
