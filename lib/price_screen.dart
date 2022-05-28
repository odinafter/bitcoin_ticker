import 'package:flutter/material.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:bitcoin_ticker/test.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  // var ETHData;
  // Future<dynamic> getETHData() async {
  //   CoinData coinData = CoinData();
  //   var exchangeData = await coinData.getCoinData(
  //     Uri.tryParse('$coinExchangeDataURL/ETH/$selectedCurrency?apikey=$apiKey'),
  //   );
  //   ETHData = exchangeData;
  //   return exchangeData;
  // }

  String selectedCurrency = 'USD';

  DropdownButton<String> currencyDropdown() {
    List<DropdownMenuItem<String>> dropdownItem = [];
    for (String currency in currenciesList) {
      // for (int i = 0; i < currenciesList.length; i++) {
      //   String currency = currenciesList[i];
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItem.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItem,
      onChanged: (value) {
        setState(
          () {
            selectedCurrency = value!;
            getCoinData();
            // getBTCData();
            // getETHData();
          },
        );
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItem = [];
    for (String currency in currenciesList) {
      pickerItem.add(
        Text(currency),
      );
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getCoinData();
        });
        print(selectedIndex);
      },
      children: pickerItem,
    );
  }

  Map<String, String> coinValue = {};
  bool isWaiting = false;

  void getCoinData() async {
    isWaiting = true;
    try {
      // for (String crypto in cryptoList) {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValue = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getCoinData();
    super.initState();
  }

  Column valueCard() {
    List<CoinCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CoinCard(
          coinData: crypto,
          selectedCurrency: selectedCurrency,
          value: isWaiting ? '?' : coinValue[crypto],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
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
          valueCard(),
          // CoinCard(
          //   coinData: BTCData,
          //   selectedCurrency: selectedCurrency,
          //   coinCurrency: 'ETH',
          // ),
          // CoinCard(
          //   coinData: BTCData,
          //   selectedCurrency: selectedCurrency,
          //   coinCurrency: cryptoList[2],
          // ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : currencyDropdown(),
          ),
        ],
      ),
    );
  }
}

class CoinCard extends StatelessWidget {
  CoinCard({
    Key? key,
    this.coinData,
    this.selectedCurrency,
    this.value,
  }) : super(key: key);
  final String? coinData;
  final String? selectedCurrency;
  final String? value;

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
            '1 $coinData = $value $selectedCurrency',
            // '1 $coinData  = ${coinData != null ? coinData["rate"].toStringAsFixed(2) : '0'} $selectedCurrency',
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
