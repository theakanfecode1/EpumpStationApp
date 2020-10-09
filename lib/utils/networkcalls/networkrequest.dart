import 'dart:convert';
import 'dart:io';
import 'package:epump/utils/branch/bank.dart';
import 'package:epump/utils/branch/bankaccount.dart';
import 'package:epump/utils/branch/bankdeposit.dart';
import 'package:http_parser/http_parser.dart';

import 'package:epump/utils/branch/banktransaction.dart';
import 'package:epump/utils/branch/branchwallet.dart';
import 'package:epump/utils/branch/expense.dart';
import 'package:epump/utils/branch/maintenancerequest.dart';
import 'package:epump/utils/branch/pump.dart';
import 'package:epump/utils/branch/pumptransaction.dart';
import 'package:epump/utils/branch/shift.dart';
import 'package:epump/utils/branch/shiftassignment.dart';
import 'package:epump/utils/branch/staff.dart';
import 'package:epump/utils/branch/tank.dart';
import 'package:epump/utils/account/logindetails.dart';
import 'package:epump/utils/branch/daysale.dart';
import 'package:epump/utils/branch/posandvouchersales.dart';
import 'package:epump/utils/branch/pumpdetail.dart';
import 'package:epump/utils/company/company.dart';
import 'package:epump/utils/company/mybranches.dart';
import 'package:epump/utils/company/productprice.dart';
import 'package:epump/utils/staff/branchstaff.dart';
import 'package:epump/utils/tank/tankdipping.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NetworkRequest {
  static const EPUMP_BASE_URL = "https://api.epump.com.ng/";
  static const EPUMP_BRANCH = EPUMP_BASE_URL + "Branch/";
  static const EPUMP_COMPANY = EPUMP_BASE_URL + "Company/";
  static const EPUMP_ACCOUNT = EPUMP_BASE_URL + "Account/";
  static const EPUMP_STAFF = EPUMP_BASE_URL + "Staff/";
  static const EPUMP_TANK = EPUMP_BASE_URL + "Tank/";

  static String BRANCHID = "";
  static String COMPANYID = "";
  static SharedPreferences sharedPreferences;

  static String TOKEN = "";
  static String PASSWORD = "";

  static var loginInHeader = {
    HttpHeaders.contentTypeHeader: 'application/json'
  };
  static var header = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.authorizationHeader: ""
  };

  //  ------------------------------------------ACCOUNT REQUESTS------------------------------------------------------------------

  static Future<dynamic> loginUser(String username, String password) async {
    try {
      http.Response response = await http.post(EPUMP_ACCOUNT + "login",
          headers: loginInHeader,
          body: jsonEncode(
              <String, String>{"userName": username, "password": password}));
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        sharedPreferences = await SharedPreferences.getInstance();
        PASSWORD = password;
        Map body = jsonDecode(response.body);
        AccountLogin accountLogin = AccountLogin.fromJson(body);
        header[HttpHeaders.authorizationHeader] =
            "Bearer " + accountLogin.token;
        sharedPreferences.setString("PASSWORD", password);
        sharedPreferences.setString("TOKEN", "Bearer " + accountLogin.token);
        sharedPreferences.setString("FIRST_NAME", accountLogin.firstName);
        sharedPreferences.setString("LAST_NAME", accountLogin.lastName);
        sharedPreferences.setString("ROLE", accountLogin.role);
        sharedPreferences.setString("EMAIL", accountLogin.email);
        return {"statusCode": 200, "object": accountLogin};
      }
    } on SocketException {
//      lets assume socket exception will throw 600
      return {"statusCode": 600, "object": null};
    }
  }

  //  ------------------------------------------COMPANY REQUESTS------------------------------------------------------------------

  static Future<dynamic> getMyBranchesFromCompany() async {
    try {
      http.Response response = await http.get(
        EPUMP_COMPANY + "MyBranches",
        headers: header,
      );
      print(response.statusCode);
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        List<dynamic> body = jsonDecode(response.body);
        if (body.length > 0) {
          MyBranches branch = MyBranches.fromJson(body[0]);
          BRANCHID = branch.branchId;
          sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString("BRANCH_ID", branch.branchId);
          return {"statusCode": 200, "object": branch};
        } else {
          return {"statusCode": 400, "object": null};
        }
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> getBranchesForCompany() async {
    try {
      http.Response response = await http.get(
        EPUMP_COMPANY + "Branches/" + COMPANYID,
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        List<dynamic> body = jsonDecode(response.body);
        List<MyBranches> branches =
            body.map((e) => MyBranches.fromJson(e)).toList();
        return {"statusCode": 200, "object": branches};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> getCompany() async {
    print(header);
    try {
      http.Response response = await http.get(
        EPUMP_COMPANY + "MyCompanies",
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        List<dynamic> body = jsonDecode(response.body);
        if (body.length > 0) {
          Company company = Company.fromJson(body[0]);
          COMPANYID = company.id;
          sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString("COMPANY_ID", company.id);
          return {"statusCode": 200, "object": company};
        } else {
          return {"statusCode": 400, "object": null};
        }
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> getCompanySales(
      String startDate, String endDate) async {
    try {
      http.Response response = await http.get(
        EPUMP_COMPANY +
            "CompanyBranchSales/" +
            COMPANYID +
            "/" +
            startDate +
            "/" +
            endDate,
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        List<dynamic> body = jsonDecode(response.body);
        List<DaySale> branches = body.map((e) => DaySale.fromJson(e)).toList();
        return {"statusCode": 200, "object": branches};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> getProductPrice() async {
    try {
      http.Response response = await http.get(
        EPUMP_COMPANY +
            "ProductPrices/" +
            (COMPANYID == "" ? BRANCHID : COMPANYID),
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        List<dynamic> body = jsonDecode(response.body);
        List<ProductPrice> prices =
            body.map((e) => ProductPrice.fromJson(e)).toList();
        return {"statusCode": 200, "object": prices};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> changePrice(
      String id, String productId, dynamic price, String password) async {
    try {
      http.Response response = await http.post(EPUMP_COMPANY + "UpdatePrice",
          headers: header,
          body: jsonEncode(<String, dynamic>{
            "branchId": (BRANCHID == "" ? null : BRANCHID),
            "id": id.toString(),
            "productId": productId,
            "price": price,
            "password": password,
          }));
      dynamic responseStatus = _checkResponseStatusCode(response);
      return responseStatus;
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

//  ------------------------------------------BRANCH REQUESTS------------------------------------------------------------------

  static Future<dynamic> resolveRequest(String id, dynamic amount) async {
    try {
      http.Response response = await http.put(
        EPUMP_BRANCH + "ResolveRequest",
        body: jsonEncode(
            <String, dynamic>{"id": id, "amount": amount, "comment": ""}),
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        return {"statusCode": 200, "object": null};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> getPosAndVoucherSales(String startDate) async {
    try {
      http.Response response = await http.get(
        EPUMP_BRANCH +
            "POSandVoucherSales/" +
            BRANCHID +
            "?startDate=" +
            startDate,
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        List<dynamic> body = jsonDecode(response.body);
        List<PosAndVoucherSales> posVoucherSales =
            body.map((e) => PosAndVoucherSales.fromJson(e)).toList();
        return {"statusCode": 200, "object": posVoucherSales};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> getTanks() async {
    try {
      http.Response response = await http.get(
        EPUMP_BRANCH + "Tanks/" + BRANCHID,
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        List<dynamic> body = jsonDecode(response.body);
        List<Tank> tanks = body.map((e) => Tank.fromJson(e)).toList();
        return {"statusCode": 200, "object": tanks};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> getBranchWallet() async {
    try {
      http.Response response = await http.get(
        EPUMP_BRANCH + "BranchWallet/" + BRANCHID,
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        dynamic body = jsonDecode(response.body);
        BranchWallet branchWallet = BranchWallet.fromJson(body);
        return {"statusCode": 200, "object": branchWallet};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> getPumps() async {
    try {
      http.Response response = await http.get(
        EPUMP_BRANCH + "Pumps/" + BRANCHID,
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        List<dynamic> body = jsonDecode(response.body);
        List<Pump> pumps = body.map((e) => Pump.fromJson(e)).toList();
        return {"statusCode": 200, "object": pumps};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> postImage(filename) async {
    String imageString;
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(EPUMP_BRANCH + "RequestImage"),
      );
      request.files.add(await http.MultipartFile.fromPath("picture", filename,
          contentType: MediaType("image", "jpg")));
      request.headers[HttpHeaders.authorizationHeader] =
          header["authorization"];

      var res = await request.send();
      res.stream.transform(utf8.decoder).listen((value) {
        imageString = value;
      });
      switch (res.statusCode) {
        case 200:
          return {"statusCode": 200, "object": imageString};
        case 401:
          return {"statusCode": 401, "object": null};
        case 400:
          return {"statusCode": 400, "object": null};
        case 404:
          return {"statusCode": 404, "object": null};
        case 500:
          return {"statusCode": 500, "object": null};
        default:
          return {"statusCode": 600, "object": null};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }

  }

  static Future<dynamic> postRecordPumpTransaction(
      dynamic rtt, String pumpId, dynamic closingReading) async {
    try {
      http.Response response = await http.post(
        EPUMP_BRANCH + "Pumps/" + "RecordTransaction",
        headers: header,
        body: jsonEncode(<String, dynamic>{
          "branchId": BRANCHID,
          "RTT": rtt,
          "pumpId": pumpId,
          "closingReading": closingReading,
        }),
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      return responseStatus;
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> getPumpDetails(String id) async {
    try {
      http.Response response = await http.get(
        EPUMP_BRANCH + "Pumps/Detail/" + id,
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        dynamic body = jsonDecode(response.body);
        PumpDetail tankDetails = PumpDetail.fromJson(body);
        return {"statusCode": 200, "object": tankDetails};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> getDaySale(String startDate, String endDate) async {
    try {
      http.Response response = await http.get(
        EPUMP_BRANCH +
            "DaySale/" +
            BRANCHID +
            "?startDate=" +
            startDate +
            "&endDate=" +
            endDate,
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        List<dynamic> body = jsonDecode(response.body);
        List<DaySale> branches = body.map((e) => DaySale.fromJson(e)).toList();
        return {"statusCode": 200, "object": branches};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> getPumpTransactions(
      String pumpId, String startDate, String endDate, bool eSales) async {
    try {
      http.Response response = await http.get(
        EPUMP_BRANCH +
            "PumpTransactions?branchId=" +
            BRANCHID +
            "&pumpId=" +
            pumpId +
            "&strtDate=" +
            startDate +
            "&endDate=" +
            endDate +
            "&esales" +
            eSales.toString(),
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        List<dynamic> body = jsonDecode(response.body);
        List<PumpTransaction> transactions =
            body.map((e) => PumpTransaction.fromJson(e)).toList();

        return {"statusCode": 200, "object": transactions};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> postRtt(String pumpId, String comment) async {
    try {
      http.Response response = await http.post(
        EPUMP_BRANCH + "Pumps/rtt",
        body: jsonEncode(<String, dynamic>{
          "id": pumpId,
          "branchId": BRANCHID,
          "Description": comment
        }),
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      return responseStatus;
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> getBankTransactions(
      String startDate, String endDate) async {
    try {
      http.Response response = await http.get(
        EPUMP_BRANCH +
            "BankTransaction/" +
            BRANCHID +
            "?startDate=" +
            startDate +
            "&endDate=" +
            endDate,
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        List<dynamic> body = jsonDecode(response.body);
        List<BankTransaction> transactions =
            body.map((e) => BankTransaction.fromJson(e)).toList();
        return {"statusCode": 200, "object": transactions};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> getExpenses(String startDate, String endDate) async {
    try {
      http.Response response = await http.get(
        EPUMP_BRANCH +
            "Expenses/" +
            BRANCHID +
            "?startDate=" +
            startDate +
            "&endDate=" +
            endDate,
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        List<dynamic> body = jsonDecode(response.body);
        List<Expense> expenses = body.map((e) => Expense.fromJson(e)).toList();
        return {"statusCode": 200, "object": expenses};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> getShifts() async {
    try {
      http.Response response = await http.get(
        EPUMP_BRANCH + "StaffShifts/" + BRANCHID,
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        List<dynamic> body = jsonDecode(response.body);
        List<Shift> shifts = body.map((e) => Shift.fromJson(e)).toList();
        return {"statusCode": 200, "object": shifts};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> getShiftAssignment(String shiftId) async {
    try {
      http.Response response = await http.get(
        EPUMP_BRANCH + "ShiftAssignments/" + shiftId,
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        List<dynamic> body = jsonDecode(response.body);
        List<ShiftAssignment> shifts =
            body.map((e) => ShiftAssignment.fromJson(e)).toList();
        return {"statusCode": 200, "object": shifts};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> postCloseShift(
      String shiftId, String description) async {
    try {
      http.Response response = await http.post(EPUMP_BRANCH + "CloseShift",
          headers: header,
          body: jsonEncode(<String, dynamic>{
            "shiftId": shiftId,
            "description": description
          }));
      dynamic responseStatus = _checkResponseStatusCode(response);
      return responseStatus;
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> getBanks() async {
    try {
      http.Response response = await http.get(
        EPUMP_BRANCH + "Banks",
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        List<dynamic> body = jsonDecode(response.body);
        List<Bank> banks = body.map((e) => Bank.fromJson(e)).toList();
        return {"statusCode": 200, "object": banks};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> getStates() async {
    try {
      http.Response response = await http.get(
        EPUMP_BRANCH + "States",
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        List<dynamic> body = jsonDecode(response.body);
        List<State> states = body.map((e) => State.fromJson(e)).toList();
        return {"statusCode": 200, "object": states};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> getBankAccounts() async {
    try {
      http.Response response = await http.get(
        EPUMP_BRANCH + "BankAccounts/" + BRANCHID,
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        List<dynamic> body = jsonDecode(response.body);
        List<BankAccount> accounts =
            body.map((e) => BankAccount.fromJson(e)).toList();
        return {"statusCode": 200, "object": accounts};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> postCashOut(double amount) async {
    try {
      http.Response response = await http.post(
          EPUMP_BRANCH + "Settlement/" + BRANCHID,
          headers: header,
          body: jsonEncode(<String, dynamic>{"amount": amount}));
      dynamic responseStatus = _checkResponseStatusCode(response);
      return responseStatus;
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> postDeposit(
      dynamic amount, String account, String tellerNumber) async {
    try {
      http.Response response = await http.post(
          EPUMP_BRANCH + "bankDeposit/" + BRANCHID,
          headers: header,
          body: jsonEncode(<String, dynamic>{
            "amount": amount,
            "account": account,
            "tellerNumber": tellerNumber
          }));
      dynamic responseStatus = _checkResponseStatusCode(response);
      return responseStatus;
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> postShiftDeposit(dynamic amount, String account,
      String tellerNumber, String shiftId) async {
     Map map = {
      "branchId": BRANCHID,
      "shiftId": shiftId,
      "amount": amount,
      "bank": account,
      "teller_Number": tellerNumber
    };
     print(map);
    try {
      http.Response response =
          await http.post(EPUMP_BRANCH + "MakeShiftDeposit",
              headers: header,
              body: jsonEncode(<String, dynamic>{
                "branchId": BRANCHID,
                "shiftId": shiftId,
                "amount": amount,
                "bank": account,
                "teller_Number": tellerNumber
              }));


      print(response.statusCode);
      print(response.body);
      dynamic responseStatus = _checkResponseStatusCode(response);
      return responseStatus;
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> postSubmitMaintenanceRequest(String description,
      String type, String typeName, String imageString) async {
    try {
      http.Response response = await http.post(EPUMP_BRANCH + "RecordRequest",
          headers: header,
          body: jsonEncode(<String, dynamic>{
            "branchId": BRANCHID,
            "Description": description,
            "type": type,
            "typeName": typeName,
            "ImageString": imageString
          }));
      print(response.reasonPhrase);
      dynamic responseStatus = _checkResponseStatusCode(response);
      return responseStatus;
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> getMProperties() async {
    try {
      http.Response response = await http.get(
        EPUMP_BRANCH + "MProperties",
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        List<dynamic> body = jsonDecode(response.body);
        List<String> properties = body.map((e) => e.toString()).toList();
        return {"statusCode": 200, "object": properties};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> getMaintenanceRequest() async {
    try {
      http.Response response = await http.get(
        EPUMP_BRANCH +
            "MaintenanceRequests/" +
            (COMPANYID == "" ? BRANCHID : COMPANYID),
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        List<dynamic> body = jsonDecode(response.body);
        List<MaintenanceRequest> requests =
            body.map((e) => MaintenanceRequest.fromJson(e)).toList();
        return {"statusCode": 200, "object": requests};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> getBankDeposits(
      String startDate, String endDate) async {
    try {
      http.Response response = await http.get(
        EPUMP_BRANCH +
            "bankDeposits/" +
            BRANCHID +
            "?startDate=" +
            startDate +
            "&endDate=" +
            endDate,
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        List<dynamic> body = jsonDecode(response.body);
        List<BankDeposit> deposits =
            body.map((e) => BankDeposit.fromJson(e)).toList();
        return {"statusCode": 200, "object": deposits};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> postExpense(String description, int amount,
      String paymentMode, String accountNumber) async {
    try {
      http.Response response = await http.post(
        EPUMP_BRANCH + "RecordExpense",
        headers: header,
        body: jsonEncode(<String, dynamic>{
          "description": description,
          "branchId": BRANCHID,
          "amount": amount,
          "paymentMode": paymentMode,
          "accountNumber": accountNumber
        }),
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      return responseStatus;
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> postBankAccount(String bankName, String accountName,
      String bankCode, String accountNumber) async {
    try {
      http.Response response = await http.post(
        EPUMP_BRANCH + "AddBankAccount",
        headers: header,
        body: jsonEncode(<String, dynamic>{
          "bankName": bankName,
          "branchId": BRANCHID,
          "accountName": accountName,
          "bankCode": bankCode,
          "accountNumber": accountNumber
        }),
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      return responseStatus;
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> postBranchWallet(String bankName, String accountName,
      String bankCode, String payTime, String accountNumber) async {
    try {
      http.Response response = await http.post(
        EPUMP_BRANCH + "AddBranchAccount",
        headers: header,
        body: jsonEncode(<String, dynamic>{
          "bank": bankName,
          "branchId": BRANCHID,
          "accountName": accountName,
          "bankCode": bankCode,
          "payTime": payTime,
          "accountNumber": accountNumber
        }),
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      return responseStatus;
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> postCreateStaffShift(String shiftName) async {
    try {
      http.Response response = await http.post(
        EPUMP_BRANCH + "CreateStaffShift",
        headers: header,
        body: jsonEncode(<String, dynamic>{
          "staffId": BRANCHID,
          "branchId": BRANCHID,
          "shiftName": shiftName,
        }),
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      return responseStatus;
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> postAssignShift(String shiftName, String staffId,
      String pumpId, String shiftId, dynamic openingRead) async {
    try {
      http.Response response = await http.post(
        EPUMP_BRANCH + "AssignShift",
        headers: header,
        body: jsonEncode(<String, dynamic>{
          "staffId": staffId,
          "branchId": BRANCHID,
          "shiftName": shiftName,
          "pumpId": pumpId,
          "openingRead": openingRead,
          "shiftId": shiftId,
        }),
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      return responseStatus;
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

//  ----------------------------------------------------STAFF REQUEST--------------------------------------------------------------------------

  static Future<dynamic> getBranchStaffs() async {
    try {
      http.Response response = await http.get(
        EPUMP_STAFF + "BranchStaff/" + BRANCHID,
        headers: header,
      );
      print(response.body);
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        List<dynamic> body = jsonDecode(response.body);
        List<BranchStaff> staffs =
            body.map((e) => BranchStaff.fromJson(e)).toList();
        return {"statusCode": 200, "object": staffs};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> postCreateStaff(
      String firstName,
      String lastName,
      String gender,
      String phoneNumber,
      String email,
      String streetAddress,
      String state) async {
    try {
      http.Response response = await http.post(
        EPUMP_STAFF + "CreateStaff/" + BRANCHID,
        headers: header,
        body: jsonEncode(<String, dynamic>{
          "firstName": firstName,
          "lastName": lastName,
          "gender": gender,
          "phone": phoneNumber,
          "email": email,
          "street": streetAddress,
          "state": state,
          "cardName": "N/A"
        }),
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      return responseStatus;
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

//  ---------------------------------------------------------TANK REQUEST--------------------------------------------------------------

  static Future<dynamic> getTankDippings(
      String tankId, String startDate, String endDate) async {
    try {
      http.Response response = await http.get(
        EPUMP_TANK +
            "TankDip/" +
            BRANCHID +
            "/" +
            tankId +
            "?startDate=" +
            startDate +
            "&endDate=" +
            endDate,
        headers: header,
      );
      dynamic responseStatus = _checkResponseStatusCode(response);
      if (responseStatus["statusCode"] != 200) {
        return responseStatus;
      } else {
        List<dynamic> body = jsonDecode(response.body);
        List<TankDipping> dippings =
            body.map((e) => TankDipping.fromJson(e)).toList();
        return {"statusCode": 200, "object": dippings};
      }
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> postDipTank(
      String tankId, String start, dynamic currentVolume) async {
    try {
      http.Response response = await http.post(EPUMP_TANK + "TankDip",
          headers: header,
          body: jsonEncode(<String, dynamic>{
            "tankId": tankId,
            "start": start,
            "currentVolume": currentVolume,
            "branchId": BRANCHID,
          }));
      dynamic responseStatus = _checkResponseStatusCode(response);
      return responseStatus;
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static Future<dynamic> postStartFill(
      String plateNumber, String tankId, dynamic dipVolume) async {
    try {
      http.Response response = await http.post(
        EPUMP_TANK + "StartFill",
        headers: header,
        body: jsonEncode(<String, dynamic>{
          "plateNumber": plateNumber,
          "dipVolume": dipVolume,
          "tankId": tankId,
          "branchId": BRANCHID,
        }),
      );
      print(response.statusCode);
      print(response.body);
      dynamic responseStatus = _checkResponseStatusCode(response);
      return responseStatus;
    } on SocketException {
      return {"statusCode": 600, "object": null};
    }
  }

  static dynamic _checkResponseStatusCode(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return {
          "statusCode": 200,
        };
      case 401:
        return {"statusCode": 401, "object": null};
      case 400:
        return {"statusCode": 400, "object": null};
      case 404:
        return {"statusCode": 404, "object": null};
      case 500:
        return {"statusCode": 500, "object": null};
      case 405:
        return {"statusCode": 405, "object": null};
      default:
        return {"statusCode": 600, "object": null};
    }
  }
}
