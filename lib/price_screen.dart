import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  DropdownButton<String> androidButtomdownList() {
    List<DropdownMenuItem<String>> listItem = [];
    for (int i = 0; i < currenciesList.length; i++) {
      var items = DropdownMenuItem(
        child: Text(currenciesList[i]),
        value: currenciesList[i],
      );
      listItem.add(items);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: listItem,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iosGetPickerItem() {
    List<Widget> listItem = [];
    for (String string in currenciesList) {
      listItem.add(Text(string));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedItem) {
        print(selectedItem);
      },
      children: listItem,
    );
  }

  Widget getDeviceType() {
    if (Platform.isIOS) {
      return iosGetPickerItem();
    }
    if (Platform.isAndroid) {
      return androidButtomdownList();
    }
  }

  Map<String, String> coinPriceInSelectedCurrency = {};
  bool iswaiting = false;
  void getData() async {
    iswaiting = true;
    try {
      var data = await CoinData().getCoinData(
        selectedCurrency,
      );
      iswaiting = false;
      setState(() {
        coinPriceInSelectedCurrency = data;
      });
    } catch (e) {
      print(e);
      print('Hello');
    }
  }

  Column coinData() {
    List<CoinContainers> coins = [];
    for (String bitcoin in cryptoList) {
      coins.add(
        CoinContainers(
          value: iswaiting ? '?' : coinPriceInSelectedCurrency[bitcoin],
          bitcoinName: bitcoin,
          selectedCurrency: selectedCurrency,
        ),
      );
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: coins);
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
          coinData(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: androidButtomdownList(),
          ),
        ],
      ),
    );
  }
}

class CoinContainers extends StatelessWidget {
  CoinContainers({this.value, this.bitcoinName, this.selectedCurrency});
  final String value;
  final String bitcoinName;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $bitcoinName = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
