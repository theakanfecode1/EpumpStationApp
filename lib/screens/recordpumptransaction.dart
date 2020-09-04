import 'package:epump/customwidgets/feedbackwidget.dart';
import 'package:epump/customwidgets/structureddialog.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/stores/branchstores/pumpstore.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class RecordPumpTransaction extends StatefulWidget {
  final id;
  final name;
  final manualReading;

  RecordPumpTransaction({this.id, this.name, this.manualReading});

  @override
  _RecordPumpTransactionState createState() => _RecordPumpTransactionState();
}

class _RecordPumpTransactionState extends State<RecordPumpTransaction> {
  TextEditingController _closingReadController = TextEditingController();
  TextEditingController _rttController = TextEditingController();

  @override
  void dispose() {
    _closingReadController.dispose();
    _rttController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _closingReadController.text = Constants.formatThisInput(widget.manualReading);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final pumpStore = Provider.of<PumpStore>(context);
    return Scaffold(
      appBar:
          Constants.showCustomAppBar("Record Pump Transaction(${widget.name})"),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          children: <Widget>[
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              color: CustomColors.REMIS_PURPLE,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(
                    Constants.getAssetGeneralName("pumpwhite", "png"),
                    width: 100,
                    height: 100,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextField(
                controller: _closingReadController,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Closing Read(e.g 0.0)",
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: CustomColors.REMIS_PURPLE,
                    fontWeight: FontWeight.w400,
                  ),
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: CustomColors.REMIS_PURPLE,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: CustomColors.REMIS_PURPLE,
                      )),
//        enabledBorder: OutlineInputBorder(
//            borderRadius: BorderRadius.all(Radius.circular(10.0)),
//            borderSide: BorderSide(color: Colors.white,)
//        ),
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (text) {
                  FocusScope.of(context).nextFocus();
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextField(
                controller: _rttController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: "Return To Tank(RTT)",
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: CustomColors.REMIS_PURPLE,
                    fontWeight: FontWeight.w400,
                  ),
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: CustomColors.REMIS_PURPLE,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        color: CustomColors.REMIS_PURPLE,
                      )),
//        enabledBorder: OutlineInputBorder(
//            borderRadius: BorderRadius.all(Radius.circular(10.0)),
//            borderSide: BorderSide(color: Colors.white,)
//        ),
                ),
                onSubmitted: (text) {
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    onPressed: () async {
                      if(_closingReadController.text.isNotEmpty){
                        int closingReading = int.parse(_closingReadController.text.replaceAll(",", "").replaceAll(".", ""));
                        double rtt = _rttController.text.isEmpty ? 0 :double.parse(_rttController.text);
                        if(closingReading > 0){
                          Navigator.of(context).push(LoadingWidget.showLoadingScreen("Recording Transaction"));
                          String result = await pumpStore.postRecordPumpTransaction(rtt, widget.id, closingReading);
                          Navigator.of(context).pop();
                          if(result == NetworkStrings.SUCCESSFUL){
                           await showDialog(context: context,builder: (_){
                              return StructuredDialog(
                                giveRadius: true,
                                child: FeedbackWidget(
                                  title: "Record Successful",
                                  status: true,
                                  message: "Transaction has been recorded for " + widget.name,
                                ),);
                            });
                           Navigator.of(context).pop();
                          }
                          else{
                            showDialog(context: context,builder: (_){
                              return StructuredDialog(
                                giveRadius: true,
                                child: FeedbackWidget(
                                  title: "Error",
                                  status: false,
                                  message: result,
                                ),);
                            });
                          }
                        }
                        else{
                          showDialog(context: context,builder: (_){
                            return StructuredDialog(
                              giveRadius: true,
                              child: FeedbackWidget(
                                title: "Invaild Value",
                                status: false,
                                message: "The closing reading must be greater than 0",
                              ),);
                          });
                        }

                      }else{
                        showDialog(context: context,builder: (_){
                          return StructuredDialog(
                            giveRadius: true,
                            child: FeedbackWidget(
                              title: "Invaild Input",
                              status: false,
                              message: "All fields are required",
                            ),);
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    color: CustomColors.REMIS_PURPLE,
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
