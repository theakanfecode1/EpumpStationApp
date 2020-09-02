import 'package:epump/customwidgets/wave_widget.dart';
import 'package:epump/screens/dashboard.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/screens/tankdetails.dart';
import 'package:epump/screens/tankdippings.dart';
import 'package:epump/stores/branchstores/tankstore.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Tanks extends StatefulWidget {
  @override
  _TanksState createState() => _TanksState();
}

class _TanksState extends State<Tanks> {
  double calculateWaveHeight(dynamic max, dynamic current) {
    double temp = ((max - current) / max) * 100;
    return (100 - temp);
  }

  Color setWaveColor(dynamic value){
    if(value <= 30.00){
      return CustomColors.REMIS_RED;
    }else if(value <= 40.00){
      return CustomColors.REMIS_WAVE_ORANGE;
    }else if(value < 70.00){
      return CustomColors.REMIS_WAVE_BLUE;
    }else{
      return CustomColors.REMIS_WAVE_GREEN;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tankStore = Provider.of<TankStore>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Navigator.of(context)
          .push(LoadingWidget.showLoadingScreen("Fetching Tanks"));
      await tankStore.getTanks();
      Navigator.of(context).pop();
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Tanks",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      drawer: DrawerOnly(),
      body: Observer(
        builder: (_) => ListView.builder(
          itemCount: tankStore.tanks.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 220,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ListTile(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => TankDetails(
                                              tank: tankStore.tanks[index],
                                            )),
                                  );
                                },
                                title: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    "View Details",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.black,
                                thickness: 0.4,
                              ),
                              ListTile(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => TankDippings(id: tankStore.tanks[index].id,)));
                                },
                                title: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    "Tank Dip",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.black,
                                thickness: 0.4,
                              ),
                              ListTile(
                                onTap: () => Navigator.of(context).pop(),
                                title: Center(
                                  child: Text(
                                    "Close",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top:5.0),
                  child: CustomListCard(
                    tankName: tankStore.tanks[index].name,
                    waveColor: setWaveColor(calculateWaveHeight(
                        tankStore.tanks[index].maxCapacity,
                        tankStore.tanks[index].currentVolume)),
                    productName: tankStore.tanks[index].productName,
                    maxCapacity: Constants.formatThisInput(tankStore.tanks[index].maxCapacity),
                    currentVolume:
                    Constants.formatThisInput(tankStore.tanks[index].currentVolume),
                    tankHeight: calculateWaveHeight(
                        tankStore.tanks[index].maxCapacity,
                        tankStore.tanks[index].currentVolume),
                  ),
                ));
          },
        ),
      ),
    );
  }
}

class CustomListCard extends StatelessWidget {
  final String tankName;
  final String productName;
  final String maxCapacity;
  final String currentVolume;
  final double tankHeight;
  final Color waveColor;

  CustomListCard(
      {this.tankName,
      this.productName,
      this.maxCapacity,
      this.currentVolume,
      this.tankHeight,this.waveColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 130,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.grey[200]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: 2,
            ),
            WaveWidget(
                80.0, CustomColors.REMIS_PURPLE, waveColor, tankHeight),

//            SizedBox(
//              width: 20,
//            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  tankName,
                  style: TextStyle(
                      color: CustomColors.REMIS_PURPLE,
                      fontWeight: FontWeight.w800,
                      fontSize: 16),
                ),
                Text(
                  "Product:",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
                Text(
                  "Max. Capacity:",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
                Text(
                  "Current Volume:",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Text(
                  productName,
                  style: TextStyle(
                      color: CustomColors.REMIS_GREY,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
                Text(
                  maxCapacity + " ltrs(s)",
                  style: TextStyle(
                      color: CustomColors.REMIS_GREY,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
                Text(
                  currentVolume + " ltrs(s)",
                  style: TextStyle(
                      color: CustomColors.REMIS_GREY,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.arrow_forward_ios,
                    color: CustomColors.REMIS_PURPLE,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
