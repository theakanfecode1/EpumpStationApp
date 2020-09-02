
import 'package:epump/utils/branch/banktransaction.dart';
import 'package:epump/utils/branch/daysale.dart';
import 'package:epump/utils/branch/posandvouchersales.dart';
import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:epump/values/strings.dart';
import 'package:mobx/mobx.dart';

part 'daysaleandposandvouchersalesstore.g.dart';

class DaySaleAndPosStore = _DaySaleAndPosStore with _$DaySaleAndPosStore;

abstract class _DaySaleAndPosStore with Store{

  @observable
  dynamic pms = 0.00;

  @observable
  dynamic ago = 0.00;

  @observable
  dynamic dpk = 0.00;

  @observable
  dynamic rtt = 0.00;

  @observable
  dynamic cashToBank = 0.00;

  @observable
  dynamic todayPmsAmount = 0.00;

  @observable
  dynamic todayAgoAmount = 0.00;

  @observable
  dynamic todayDpkAmount = 0.00;

  @observable
  dynamic yesterdayPmsAmount = 0.00;

  @observable
  dynamic yesterdayAgoAmount = 0.00;

  @observable
  dynamic yesterdayDpkAmount = 0.00;

  @observable
  dynamic monthPmsAmount = 0.00;

  @observable
  dynamic monthAgoAmount = 0.00;

  @observable
  dynamic monthDpkAmount = 0.00;

  @observable
  dynamic todayPmsVolume = 0.00;

  @observable
  dynamic todayAgoVolume = 0.00;

  @observable
  dynamic todayDpkVolume = 0.00;

  @observable
  dynamic yesterdayPmsVolume = 0.00;

  @observable
  dynamic yesterdayAgoVolume = 0.00;

  @observable
  dynamic yesterdayDpkVolume = 0.00;

  @observable
  dynamic monthPmsVolume = 0.00;

  @observable
  dynamic monthAgoVolume = 0.00;

  @observable
  dynamic monthDpkVolume = 0.00;

  @observable
  dynamic totalSales = 0.00;

  @observable
  dynamic retainershipSales = 0.00;

  @observable
  dynamic epumpSales = 0.00;

  @observable
  dynamic cashSales = 0.00;


  @action
  Future<String> getDaySale(String typeOfRequest, String startDate,String endDate) async {

    dynamic response = await NetworkRequest.getDaySale(startDate, endDate);

    switch(response["statusCode"]){

      case 200:
        switch(typeOfRequest){
          case Strings.DASHBOARD_REQUEST:
            totalSales = 0;
            ago=0;
            pms=0;
            dpk=0;
            rtt=0;
            List<DaySale> daySales = response["object"];
            daySales.forEach((daySale) {
              totalSales+=daySale.amount;
              rtt+=daySale.rttAmount;

              if(daySale.product == "AGO"){
                ago+=daySale.volume;
              }
              else if(daySale.product == "DPK"){
                dpk+=daySale.volume;
              }
              else{
                pms+=daySale.volume;
              }
            });
            break;

          case Strings.MONTH_REQUEST:
            monthAgoAmount=0;
            monthDpkAmount=0;
            monthPmsAmount=0;
            monthAgoVolume=0;
            monthDpkVolume=0;
            monthPmsVolume=0;
            List<DaySale> daySales = response["object"];
            daySales.forEach((daySale) {
              if(daySale.product == "AGO"){
                monthAgoAmount+=daySale.amount;
                monthAgoVolume+=daySale.volume;
              }
              else if(daySale.product == "DPK"){
                monthDpkAmount+=daySale.amount;
                monthDpkVolume+=daySale.volume;
              }
              else{
                monthPmsAmount+=daySale.amount;
                monthPmsVolume+=daySale.volume;
              }
            });
            break;

          case Strings.TODAY_REQUEST:
            todayAgoAmount=0;
            todayDpkAmount=0;
            todayPmsAmount=0;
            todayAgoVolume=0;
            todayDpkVolume=0;
            todayPmsVolume=0;
            List<DaySale> daySales = response["object"];
            daySales.forEach((daySale) {
              if(daySale.product == "AGO"){
                todayAgoAmount+=daySale.amount;
                todayAgoVolume+=daySale.volume;
              }
              else if(daySale.product == "DPK"){
                todayDpkAmount+=daySale.amount;
                todayDpkVolume+=daySale.volume;
              }
              else{
                todayPmsAmount+=daySale.amount;
                todayPmsVolume+=daySale.volume;

              }
            });
            break;

          case Strings.YESTERDAY_REQUEST:
            yesterdayAgoAmount=0;
            yesterdayDpkAmount=0;
            yesterdayPmsAmount=0;
            yesterdayAgoVolume=0;
            yesterdayDpkVolume=0;
            yesterdayPmsVolume=0;
            List<DaySale> daySales = response["object"];
            daySales.forEach((daySale) {
              if(daySale.product == "AGO"){
                yesterdayAgoAmount+=daySale.amount;
                yesterdayAgoVolume+=daySale.volume;
              }
              else if(daySale.product == "DPK"){
                yesterdayDpkAmount+=daySale.amount;
                yesterdayDpkVolume+=daySale.volume;
              }
              else{
                yesterdayPmsAmount+=daySale.amount;
                yesterdayPmsVolume+=daySale.volume;
              }
            });
            break;

        }
        return NetworkStrings.SUCCESSFUL;
        break;
      case 401:
        return NetworkStrings.UNAUTHORIZED;
        break;
      case 400:
        return NetworkStrings.BAD_REQUEST;
        break;
      case 500:
        return NetworkStrings.SERVER_ERROR;
        break;
      case 600:
        return NetworkStrings.CONNECTION_ERROR;
        break;
      default:
        return NetworkStrings.UNKNOWN_ERROR;
        break;
    }

  }



  @action
  Future<String> getCompanySales(String typeOfRequest, String startDate,String endDate) async {

    dynamic response = await NetworkRequest.getCompanySales(startDate, endDate);

    switch(response["statusCode"]){

      case 200:
        switch(typeOfRequest){
          case Strings.DASHBOARD_REQUEST:
            totalSales = 0;
            ago=0;
            pms=0;
            dpk=0;
            rtt=0;
            List<DaySale> daySales = response["object"];
            daySales.forEach((daySale) {
              totalSales+=daySale.amount;
              rtt+=daySale.rttAmount;

              if(daySale.product == "AGO"){
                ago+=daySale.volume;
              }
              else if(daySale.product == "DPK"){
                dpk+=daySale.volume;
              }
              else{
                pms+=daySale.volume;
              }
            });
            break;

          case Strings.MONTH_REQUEST:
            monthAgoAmount=0;
            monthDpkAmount=0;
            monthPmsAmount=0;
            monthAgoVolume=0;
            monthDpkVolume=0;
            monthPmsVolume=0;
            List<DaySale> daySales = response["object"];
            daySales.forEach((daySale) {
              if(daySale.product == "AGO"){
                monthAgoAmount+=daySale.amount;
                monthAgoVolume+=daySale.volume;
              }
              else if(daySale.product == "DPK"){
                monthDpkAmount+=daySale.amount;
                monthDpkVolume+=daySale.volume;
              }
              else{
                monthPmsAmount+=daySale.amount;
                monthPmsVolume+=daySale.volume;
              }
            });
            break;

          case Strings.TODAY_REQUEST:
            todayAgoAmount=0;
            todayDpkAmount=0;
            todayPmsAmount=0;
            todayAgoVolume=0;
            todayDpkVolume=0;
            todayPmsVolume=0;
            List<DaySale> daySales = response["object"];
            daySales.forEach((daySale) {
              if(daySale.product == "AGO"){
                todayAgoAmount+=daySale.amount;
                todayAgoVolume+=daySale.volume;
              }
              else if(daySale.product == "DPK"){
                todayDpkAmount+=daySale.amount;
                todayDpkVolume+=daySale.volume;
              }
              else{
                todayPmsAmount+=daySale.amount;
                todayPmsVolume+=daySale.volume;

              }
            });
            break;

          case Strings.YESTERDAY_REQUEST:
            yesterdayAgoAmount=0;
            yesterdayDpkAmount=0;
            yesterdayPmsAmount=0;
            yesterdayAgoVolume=0;
            yesterdayDpkVolume=0;
            yesterdayPmsVolume=0;
            List<DaySale> daySales = response["object"];
            daySales.forEach((daySale) {
              if(daySale.product == "AGO"){
                yesterdayAgoAmount+=daySale.amount;
                yesterdayAgoVolume+=daySale.volume;
              }
              else if(daySale.product == "DPK"){
                yesterdayDpkAmount+=daySale.amount;
                yesterdayDpkVolume+=daySale.volume;
              }
              else{
                yesterdayPmsAmount+=daySale.amount;
                yesterdayPmsVolume+=daySale.volume;
              }
            });
            break;

        }
        return NetworkStrings.SUCCESSFUL;
        break;
      case 401:
        return NetworkStrings.UNAUTHORIZED;
        break;
      case 400:
        return NetworkStrings.BAD_REQUEST;
        break;
      case 500:
        return NetworkStrings.SERVER_ERROR;
        break;
      case 600:
        return NetworkStrings.CONNECTION_ERROR;
        break;
      default:
        return NetworkStrings.UNKNOWN_ERROR;
        break;
    }

  }



  @action
  Future<String> getPosAndVoucherSales(String startDate) async {
    dynamic response = await NetworkRequest.getPosAndVoucherSales(startDate);

    switch(response["statusCode"]){
      case 200:
        epumpSales=0;
        cashSales=0;
        retainershipSales=0;

        List<PosAndVoucherSales> posAndVoucherSales = response["object"];
        posAndVoucherSales.forEach((sale) {
          epumpSales+= sale.amountSoldRemis + sale.amountSoldVoucher;
          retainershipSales+= sale.amountSoldRetainership;
        });
        cashSales = totalSales - (epumpSales+retainershipSales);
        return NetworkStrings.SUCCESSFUL;
        break;
      case 401:
        return NetworkStrings.UNAUTHORIZED;
        break;
      case 400:
        return NetworkStrings.BAD_REQUEST;
        break;
      case 500:
        return NetworkStrings.SERVER_ERROR;
        break;
      case 600:
        return NetworkStrings.CONNECTION_ERROR;
        break;
      default:
        return NetworkStrings.UNKNOWN_ERROR;
        break;
    }

  }

  @action
  Future<String> getBankTransactions(String startDate,String endDate) async {
    dynamic response = await NetworkRequest.getBankTransactions(startDate,endDate);

    switch(response["statusCode"]){
      case 200:
        cashToBank = 0;
        List<BankTransaction> transactions = response["object"];
        transactions.forEach((sale) {
          cashToBank += sale.amount;
        });
        return NetworkStrings.SUCCESSFUL;
        break;
      case 401:
        return NetworkStrings.UNAUTHORIZED;
        break;
      case 400:
        return NetworkStrings.BAD_REQUEST;
        break;
      case 500:
        return NetworkStrings.SERVER_ERROR;
        break;
      case 600:
        return NetworkStrings.CONNECTION_ERROR;
        break;
      default:
        return NetworkStrings.UNKNOWN_ERROR;
        break;
    }

  }


}