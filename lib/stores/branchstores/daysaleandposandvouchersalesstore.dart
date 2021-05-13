
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
  dynamic lpg = 0.00;

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
  dynamic todayLpgAmount = 0.00;

  @observable
  dynamic yesterdayPmsAmount = 0.00;

  @observable
  dynamic yesterdayAgoAmount = 0.00;

  @observable
  dynamic yesterdayDpkAmount = 0.00;

  @observable
  dynamic yesterdayLpgAmount = 0.00;

  @observable
  dynamic monthPmsAmount = 0.00;

  @observable
  dynamic monthAgoAmount = 0.00;

  @observable
  dynamic monthDpkAmount = 0.00;

  @observable
  dynamic monthLpgAmount = 0.00;

  @observable
  dynamic todayPmsVolume = 0.00;

  @observable
  dynamic todayAgoVolume = 0.00;

  @observable
  dynamic todayDpkVolume = 0.00;

  @observable
  dynamic todayLpgVolume = 0.00;

  @observable
  dynamic yesterdayPmsVolume = 0.00;

  @observable
  dynamic yesterdayAgoVolume = 0.00;

  @observable
  dynamic yesterdayDpkVolume = 0.00;

  @observable
  dynamic yesterdayLpgVolume = 0.00;

  @observable
  dynamic monthPmsVolume = 0.00;

  @observable
  dynamic monthAgoVolume = 0.00;

  @observable
  dynamic monthDpkVolume = 0.00;

  @observable
  dynamic monthLpgVolume = 0.00;



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
    totalSales = 0;
    ago=0;
    pms=0;
    dpk=0;
    lpg=0;
    rtt=0;
    monthAgoAmount=0;
    monthDpkAmount=0;
    monthPmsAmount=0;
    monthLpgAmount=0;
    monthAgoVolume=0;
    monthDpkVolume=0;
    monthPmsVolume=0;
    monthLpgVolume=0;
    todayAgoAmount=0;
    todayDpkAmount=0;
    todayPmsAmount=0;
    todayLpgAmount=0;
    todayAgoVolume=0;
    todayDpkVolume=0;
    todayPmsVolume=0;
    todayLpgVolume=0;
    yesterdayAgoAmount=0;
    yesterdayDpkAmount=0;
    yesterdayPmsAmount=0;
    yesterdayLpgAmount=0;
    yesterdayAgoVolume=0;
    yesterdayDpkVolume=0;
    yesterdayPmsVolume=0;
    yesterdayLpgVolume=0;
    dynamic response = await NetworkRequest.getDaySale(startDate, endDate);

    switch(response["statusCode"]){

      case 200:
        switch(typeOfRequest){
          case Strings.DASHBOARD_REQUEST:

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
              else if(daySale.product == "PMS"){
                pms+=daySale.volume;
              }else if(daySale.product == "LPG"){
                lpg+=daySale.volume;
              }
              else{}
            });
            break;

          case Strings.MONTH_REQUEST:

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
              else if(daySale.product == "PMS"){
                monthPmsAmount+=daySale.amount;
                monthPmsVolume+=daySale.volume;
              }else if(daySale.product == "LPG"){
                monthLpgAmount+=daySale.amount;
                monthLpgVolume+=daySale.volume;
              }else{}
            });
            break;

          case Strings.TODAY_REQUEST:

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
              else if(daySale.product == "PMS"){
                todayPmsAmount+=daySale.amount;
                todayPmsVolume+=daySale.volume;

              }else if(daySale.product == "LPG"){
                todayLpgAmount+=daySale.amount;
                todayLpgVolume+=daySale.volume;

              }else{}
            });
            break;

          case Strings.YESTERDAY_REQUEST:

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
              else if(daySale.product == "PMS"){
                yesterdayPmsAmount+=daySale.amount;
                yesterdayPmsVolume+=daySale.volume;
              }
              else if(daySale.product == "LPG"){
                yesterdayLpgAmount+=daySale.amount;
                yesterdayLpgVolume+=daySale.volume;
              }else{}
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
    totalSales = 0;
    ago=0;
    pms=0;
    dpk=0;
    rtt=0;
    monthAgoAmount=0;
    monthDpkAmount=0;
    monthPmsAmount=0;
    monthLpgAmount=0;
    monthAgoVolume=0;
    monthDpkVolume=0;
    monthPmsVolume=0;
    monthLpgVolume=0;
    todayAgoAmount=0;
    todayDpkAmount=0;
    todayPmsAmount=0;
    todayLpgAmount=0;
    todayAgoVolume=0;
    todayDpkVolume=0;
    todayPmsVolume=0;
    todayLpgVolume=0;
    yesterdayAgoAmount=0;
    yesterdayDpkAmount=0;
    yesterdayPmsAmount=0;
    yesterdayLpgAmount=0;
    yesterdayAgoVolume=0;
    yesterdayDpkVolume=0;
    yesterdayPmsVolume=0;
    yesterdayLpgVolume=0;
    dynamic response = await NetworkRequest.getCompanySales(startDate, endDate);

    switch(response["statusCode"]){

      case 200:
        switch(typeOfRequest){
          case Strings.DASHBOARD_REQUEST:

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
              else if(daySale.product == "PMS"){
                pms+=daySale.volume;
              }else if(daySale.product == "LPG"){
                lpg+=daySale.volume;
              }
              else{}
            });
            break;

          case Strings.MONTH_REQUEST:

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
              else if(daySale.product == "PMS"){
                monthPmsAmount+=daySale.amount;
                monthPmsVolume+=daySale.volume;
              }else if(daySale.product == "LPG"){
                monthLpgAmount+=daySale.amount;
                monthLpgVolume+=daySale.volume;
              }else{}
            });
            break;

          case Strings.TODAY_REQUEST:

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
              else if(daySale.product == "PMS"){
                todayPmsAmount+=daySale.amount;
                todayPmsVolume+=daySale.volume;

              }else if(daySale.product == "LPG"){
                todayLpgAmount+=daySale.amount;
                todayLpgVolume+=daySale.volume;

              }else{}
            });
            break;

          case Strings.YESTERDAY_REQUEST:

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
              else if(daySale.product == "PMS"){
                yesterdayPmsAmount+=daySale.amount;
                yesterdayPmsVolume+=daySale.volume;
              }
              else if(daySale.product == "LPG"){
                yesterdayLpgAmount+=daySale.amount;
                yesterdayLpgVolume+=daySale.volume;
              }else{}
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
    epumpSales=0;
    cashSales=0;
    retainershipSales=0;
    dynamic response = await NetworkRequest.getPosAndVoucherSales(startDate);

    switch(response["statusCode"]){
      case 200:


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
    cashToBank = 0;
    dynamic response = await NetworkRequest.getBankTransactions(startDate,endDate);

    switch(response["statusCode"]){
      case 200:
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