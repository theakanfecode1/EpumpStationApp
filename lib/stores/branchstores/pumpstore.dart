import 'package:epump/utils/branch/pump.dart';
import 'package:epump/utils/branch/pumptransaction.dart';
import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:mobx/mobx.dart';

part 'pumpstore.g.dart';

class PumpStore = _PumpStore with _$PumpStore;

abstract class _PumpStore with Store{

  @observable
  List<Pump> pumps = [];

  @observable
  List<PumpTransaction> pumpTransactions = [];

  @observable
  dynamic totalPumpTransaction = 0.00;

  @action
  Future<String> getPumps() async {
    pumps=[];
    dynamic response = await NetworkRequest.getPumps();

    switch(response["statusCode"]){
      case 200:
        pumps = response["object"];
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
  Future<String> postRecordPumpTransaction(dynamic rtt,String pumpId,dynamic closingReading) async {
    dynamic response = await NetworkRequest.postRecordPumpTransaction(rtt, pumpId, closingReading);

    switch(response["statusCode"]){
      case 200:
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
  Future<String> getPumpTransactions(String pumpId,String startDate,String endDate,bool eSales) async {
    pumpTransactions=[];
    totalPumpTransaction = 0.00;
    dynamic response = await NetworkRequest.getPumpTransactions(pumpId, startDate, endDate, eSales);

    switch(response["statusCode"]){
      case 200:
        pumpTransactions = response["object"];
        pumpTransactions.forEach((element) {
          totalPumpTransaction += element.priceSoldCash;
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

  @action
  Future<String> postRtt(String pumpId,String comment) async {
    dynamic response = await NetworkRequest.postRtt(pumpId, comment);
    switch(response["statusCode"]){
      case 200:
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
