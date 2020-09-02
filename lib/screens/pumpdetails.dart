import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:epump/stores/branchstores/pumpdetailstore.dart';


class PumpDetails extends StatefulWidget {
  final id;
  final currentReading;


  PumpDetails({this.id,this.currentReading});

  @override
  _PumpDetailsState createState() => _PumpDetailsState();
}

class _PumpDetailsState extends State<PumpDetails> {
  @override
  Widget build(BuildContext context) {
    final pumpDetailStore = Provider.of<PumpDetailsStore>(context);
    print(widget.id);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      Navigator.of(context).push(LoadingWidget.showLoadingScreen("Fetching Details"));
      await pumpDetailStore.getPumpDetails(widget.id);
      Navigator.of(context).pop();
    });
    return Scaffold(
      appBar: Constants.showCustomAppBar("Pump Details"),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 10),
        child: Observer(
          builder:(_) => Column(

            children: <Widget>[
              Container(
                constraints: BoxConstraints.expand(height: 310),
                child: Stack(
                  fit: StackFit.loose,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      decoration: BoxDecoration(
                          color: CustomColors.REMIS_PURPLE,
                          ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 30,),
                          SvgPicture.asset(Constants.getAssetGeneralName("drop", "svg"),color: Colors.white,width: 50,height: 80,),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            pumpDetailStore.pumpDetails.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 190,
                      left: 10,
                      right: 10,
                      child: Card(
                        elevation: 2,
                        child: Container(
                          height: 100,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(height: 5,),
                                    Text(
                                      "Total Volume",
                                      style: TextStyle(
                                          color: Colors.grey[400],
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20),
                                    ),
                                    SizedBox(height: 13,),

                                    Text(
                                      Constants.formatThisInput(pumpDetailStore.pumpDetails.totalVolume),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 5,),

                                    Text(
                                      "Litres",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(height: 5,),
                                    Text(
                                      "Total Sale",
                                      style: TextStyle(
                                          color: Colors.grey[400],
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20),
                                    ),
                                    SizedBox(height: 13,),

                                    Text(
                                        Constants.formatThisInput(pumpDetailStore.pumpDetails.totalSale),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 5,),

                                    Text(
                                      "Naira",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:10.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.calendar_today,color: CustomColors.REMIS_DARK_PURPLE,size: 25),
                      title: Text("Last Transaction Date",style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400

                      ),),
                      subtitle: Text(pumpDetailStore.pumpDetails.lastTransactionTime.toString(),style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                    ListTile(
                      leading:Icon(Icons.format_color_fill,color: CustomColors.REMIS_DARK_PURPLE,size: 25,),
                      title: Text("Last Transaction Volume",style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400

                      ),),
                      subtitle: Text(Constants.formatThisInput(pumpDetailStore.pumpDetails.lastTransactionVolume),
                          style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                    ListTile(
                      leading:SvgPicture.asset(Constants.getAssetGeneralName("battery", "svg"),color:Colors.black,width: 25,)
                      ,
                      title: Text("Current Pump Reading",style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400

                      ),),
                      subtitle: Text(Constants.formatThisInput(widget.currentReading),style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                    ListTile(
                      leading:SvgPicture.asset(Constants.getAssetGeneralName("battery", "svg"),color:Colors.black,width: 25,),
                      title: Text("Opening Reading",style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400

                      ),),
                      subtitle: Text(Constants.formatThisInput(pumpDetailStore.pumpDetails.openingReading),style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                  ],
                ),
              ),


            ],

          ),
        ),
      ),
    );
  }
}
