import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';

import 'dart:io' show Platform;
class PriceScreen extends StatefulWidget {

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String SelectedCurrency='AUD';
  String bitCoinValue='?';
  DropdownButton<String> androidDropDownButton(){
    List<DropdownMenuItem<String>> dropDownItems=[];
    for(String Currency in currenciesList) {
      var newitem = DropdownMenuItem(
          child: Text(Currency),
          value: Currency);
      dropDownItems.add(newitem);
    }

   return DropdownButton<String>(
value:SelectedCurrency,
items: dropDownItems,
onChanged: (value){
setState(() {
SelectedCurrency = value;
print(SelectedCurrency) ;
getData();
});

},);
  }
 CupertinoPicker iOSPicker(){
   List<Text> PickerList=[];
   for(String Currency in currenciesList){
     PickerList.add(Text(Currency));
   }

  return CupertinoPicker(
     backgroundColor: Colors.lightBlue,
     itemExtent: 32.0,
     onSelectedItemChanged: (selectedIndex){
       print(selectedIndex);
       setState(() {
         SelectedCurrency=currenciesList[selectedIndex];
         getData();
       });
     }, children: PickerList,);
 }
  CoinData coinData=CoinData();
  Map<String, String> coinValues = {};
  bool isWaiting = false;
 void getData() async{
   isWaiting = true;
   try{
 var data= await coinData.getCoinData(SelectedCurrency);
   isWaiting = false;
   setState(() {
     coinValues = data;
   });

   }
   catch(e){
    print(e);
   }
 }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {





    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                reusableCard(bitCoinValue: isWaiting ? '?' : coinValues['BTC'], SelectedCurrency: SelectedCurrency,cryptoCurrency: 'BTC'),
                reusableCard(bitCoinValue: isWaiting ? '?' : coinValues['ETH'], SelectedCurrency: SelectedCurrency,cryptoCurrency: 'ETH'),
                reusableCard(bitCoinValue:  isWaiting ? '?' : coinValues['LTC'], SelectedCurrency: SelectedCurrency,cryptoCurrency: 'LTC'),
              ],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child:Platform.isIOS?iOSPicker():androidDropDownButton(),
          ),
        ],
      ),
    );
  }
}

class reusableCard extends StatelessWidget {
  const reusableCard({@required this.bitCoinValue, @required this.SelectedCurrency,@required this.cryptoCurrency}) ;
  final String cryptoCurrency;
  final String bitCoinValue;
  final String SelectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $cryptoCurrency =$bitCoinValue  $SelectedCurrency',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
