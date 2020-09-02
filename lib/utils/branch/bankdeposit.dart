import 'package:intl/intl.dart';

class BankDeposit {
  dynamic amount;
  String account;
  String tellerNumber;
  String date;

  BankDeposit({this.amount, this.account, this.tellerNumber, this.date});

  factory BankDeposit.fromJson(Map<String, dynamic> json) {
    return BankDeposit(
      amount: json["amount"] == null ? 0.00 : json["amount"],
      tellerNumber: json["tellerNumber"] == null ? "" : json["tellerNumber"],
      account: json["account"] == null ? "" : json["account"],
      date: json["date"] == null
          ? ""
          : DateFormat.yMMMMEEEEd().format(DateTime.parse(json["date"])) +
              " " +
              DateFormat.jm().format(DateTime.parse(json["date"])),
    );
  }
}
