import 'package:epump/customwidgets/datefilter.dart';
import 'package:epump/customwidgets/structureddialog.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/screens/newtankdip.dart';
import 'package:epump/stores/tankstore/tankdippingstore.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TankDippings extends StatefulWidget {
  final String id;

  TankDippings({this.id});

  @override
  _TankDippingsState createState() => _TankDippingsState();
}

class _TankDippingsState extends State<TankDippings> {

  String startDate;
  String endDate;

  @override
  void initState() {
    startDate = DateFormat.yMMMd().format(DateTime.now());
    endDate = DateFormat.yMMMd().format(DateTime.now());
    super.initState();
  }

  filteredData(String startDate,String endDate) async{
    Navigator.of(context)
        .push(LoadingWidget.showLoadingScreen("Fetching Tank Dippings"));
    final tankDippingStore = Provider.of<TankDippingStore>(context, listen: false);
    String resultOne = await tankDippingStore.getTankDippings(widget.id,startDate, endDate);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final tankDippingStore = Provider.of<TankDippingStore>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Navigator.of(context).push(LoadingWidget.showLoadingScreen("Fetching Tank Dippings"));
      await tankDippingStore.getTankDippings(widget.id, startDate, endDate);
      Navigator.of(context).pop();

    });
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Tank Dippings",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 30,
              ),
              onPressed: (){
                showDialog(context: context,builder: (_){
                  return StructuredDialog(
                    giveRadius: true,
                    child: DateFilter(
                      function: filteredData,
                    ),
                  );
                }
                );
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => NewTankDip(id: widget.id,))),
          backgroundColor: CustomColors.REMIS_PURPLE,
          child: Icon(Icons.add, size: 20)),
      body: Observer(
        builder:(_) => ListView.builder(
          itemCount: tankDippingStore.dippings.length,
          itemBuilder: (context, index) {
            return CustomListCard(
              volume: Constants.formatThisInput(tankDippingStore.dippings[index].actualVolume),
              date: tankDippingStore.dippings[index].date,
            );
          },
        ),
      ),
    );
  }
}

class CustomListCard extends StatelessWidget {

  final volume;
  final date;


  CustomListCard({this.volume, this.date});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 90,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: CustomColors.REMIS_LIGHT_GREY),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  volume,
                  style: TextStyle(
                      color: CustomColors.REMIS_PURPLE,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  date,
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                      fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
