
import 'package:intl/intl.dart';

class PumpTransaction{
  String id;
  dynamic priceSoldCash;
  String salesType;
  dynamic totalSale;
  String date;
  String voucherCardNumber;
  String uniqueId;

  PumpTransaction({this.id, this.priceSoldCash, this.salesType, this.totalSale,
      this.date, this.voucherCardNumber, this.uniqueId});

  factory PumpTransaction.fromJson(Map<String,dynamic> json){
    return PumpTransaction(
      id: json["id"] == null ? "" : json["id"],
      priceSoldCash:
      json["priceSoldCash"] == null ? 0.00 : json["priceSoldCash"],
      salesType: json["salesType"] == null ? "" : json["salesType"],
      totalSale:
      json["totalSale"] == null ? 0.00 : json["totalSale"],
      date: json["date"] == null?"":DateFormat.yMMMMEEEEd().format(DateTime.parse(json["date"]))+" "+DateFormat.jm().format(DateTime.parse(json["date"])),
      voucherCardNumber: json["voucherCardNumber"] == null ? "" : json["voucherCardNumber"],
      uniqueId: json["uniqueId"] == null ? "" : json["uniqueId"],
    );
  }


}