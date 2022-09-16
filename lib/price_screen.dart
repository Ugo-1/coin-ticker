import 'package:bitcoin_price/models/exchange_model.dart';
import 'package:flutter/material.dart';
import 'package:bitcoin_price/constants/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:bitcoin_price/services/implementation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  bool isLoading = false;
  List<Exchange> exchangeList = [];

  String selectedCurrency = 'USD';
  CoinData coinData = CoinData();

  DropdownButton<String> getButton() {
    return DropdownButton<String>(
      underline: Container(),
      value: selectedCurrency,
      onChanged: (newValue) {
        setState(() {
          selectedCurrency = newValue!;
          getRates();
        });
      },
      items: currenciesList.map<DropdownMenuItem<String>>((String newValue) {
        return DropdownMenuItem<String>(
          child: Text(newValue),
          value: newValue,
        );
      }).toList(), //map
    ); //DropDown
  }

  CupertinoPicker getPicker() {
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (int value) {
        setState(() {
          selectedCurrency = currenciesList[value];
          getRates();
        });
      },
      children: currenciesList.map((e) {
        return Text(e);
      }).toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    getRates();
  }

  void getRates() async {
    setState(() {
      isLoading = true;
    });
    //exchangeList = await coinData.getCoinList(selectedCurrency);
    try {
      exchangeList = await coinData.getCoinList(selectedCurrency);
    } catch (e) {
      exchangeList = [];
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('No internet connection'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      },
                    child: const Text('Try again later.')),
              ],
            );
          });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
      ),
      body: Builder(builder: (context) {
        if (isLoading) {
          return const Center(
            child: SpinKitFadingCircle(
              color: Colors.lightBlueAccent,
            ),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 10.0, 18.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: exchangeList.map((exchange) {
                  return Card(
                    color: Colors.lightBlueAccent,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 28.0),
                      child: Text(
                        '1 ${exchange.assetIdBase} = ${exchange.rate?.toStringAsFixed(0)} $selectedCurrency',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Container(
              height: 130.0,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isAndroid ? getButton() : getPicker(),
            ),
          ],
        );
      }),
    );
  }
}
