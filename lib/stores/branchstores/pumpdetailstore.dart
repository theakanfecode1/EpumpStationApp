import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:epump/utils/branch/pumpdetail.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';

import 'package:mobx/mobx.dart';

part 'pumpdetailstore.g.dart';

class PumpDetailsStore = _PumpDetailsStore with _$PumpDetailsStore;

abstract class _PumpDetailsStore with Store{

  @observable
  PumpDetail pumpDetails = PumpDetail(name: "",totalSale: 0.00,totalVolume: 0.00,lastTransactionTime: "",lastTransactionVolume: 0.00,openingReading: 0.00,currentReading: 0.00);

  @action
  Future<String> getPumpDetails(String id) async {
    pumpDetails = PumpDetail(name: "",totalSale: 0.00,totalVolume: 0.00,lastTransactionTime: "",lastTransactionVolume: 0.00,openingReading: 0.00,currentReading: 0.00);
    dynamic response = await NetworkRequest.getPumpDetails(id);

    switch(response["statusCode"]){
      case 200:
        pumpDetails = response["object"];
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
