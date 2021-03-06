import 'package:epump/utils/branch/bank.dart';
import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:mobx/mobx.dart';

part 'addshiftstore.g.dart';

class AddShiftStore = _AddShiftStore with _$AddShiftStore;

abstract class _AddShiftStore with Store{

  @action
  Future<String> addShift(String shiftName) async {
    dynamic response = await NetworkRequest.postCreateStaffShift(shiftName);

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
