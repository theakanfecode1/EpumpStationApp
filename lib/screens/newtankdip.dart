import 'package:epump/customwidgets/feedbackwidget.dart';
import 'package:epump/customwidgets/structureddialog.dart';
import 'package:epump/stores/tankstore/tankdippingstore.dart';
import 'package:epump/utils/networkcalls/networkstrings.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'loadingscreen.dart';

class NewTankDip extends StatefulWidget {

  final id;

  NewTankDip({this.id});

  @override
  _NewTankDipState createState() => _NewTankDipState();
}
class _NewTankDipState extends State<NewTankDip> {

  TextEditingController _dipDateController = TextEditingController();
  TextEditingController _volumeController = TextEditingController();

  @override
  void dispose() {
    _dipDateController.dispose();
    _volumeController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final tankDippingStore = Provider.of<TankDippingStore>(context);
    return Scaffold(
      appBar: Constants.showCustomAppBar("New Tank Dip"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _volumeController,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w400
              ),
              decoration: Constants.getInputDecoration("Volume(ltrs)",true),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10,),
            InkWell(
              onTap: (){
                showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(3000)).then((value) {
                  if(value != null){
                    var result = DateFormat.yMMMd().format(value);
                    setState(() {
                      _dipDateController.text = result;
                    });

                    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value){
                      setState(() {
                        _dipDateController.text += " "+DateFormat.jm().format(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,value.hour,value.minute));
                      });
                    });
                  }

                });
              },
              child: TextField(

                controller: _dipDateController,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w400
                ),
                decoration: Constants.getInputDecoration("Dip Date(mm/dd/yyyy)",false),
              ),
            ),
            SizedBox(height: 20,),
            SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(onPressed: () async {
                  if(_dipDateController.text.isNotEmpty && _volumeController.text.isNotEmpty){
                    Navigator.of(context).push(LoadingWidget.showLoadingScreen("Submitting Tank Dipping"));
                    String result = await tankDippingStore.postTankDipping(widget.id, _dipDateController.text, double.parse(_volumeController.text));
                    Navigator.of(context).pop();
                    if(result == NetworkStrings.SUCCESSFUL){
                      await showDialog(context: context,builder: (_){
                         return StructuredDialog(
                          giveRadius: true,
                          child: FeedbackWidget(
                            title: "Success",
                            status: true,
                            message: "Tank dip successful",
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
                          title: "Invaild Input",
                          status: false,
                          message: "All fields are required",
                        ),);
                    });
                  }
                },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(bottomRight:Radius.circular(10),bottomLeft:Radius.circular(10))
                  ),
                  color: CustomColors.REMIS_PURPLE,child: Text("SUBMIT",style: TextStyle(
                      color: Colors.white,
                      fontFamily: "NunitoSemiBold",
                      fontSize: 20
                  ),),))

          ],
        ),
      ),
    );
  }
}
