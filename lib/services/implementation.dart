import 'package:bitcoin_price/models/exchange_model.dart';
import 'package:http/http.dart' as http;
import 'package:bitcoin_price/constants/coin_data.dart';

class CoinData {
  final String apiKey = 'DE519C12-0C50-4B36-8062-3A93F27EF3Fd';
  final String address = 'https://rest.coinapi.io/v1/exchangerate/';

  Future<List<Exchange>> getCoinList(String assetQuote) async {
    http.Client newClient = http.Client();
    List<http.Response> responseList = await Future.wait(cryptoList.map(
        (crypto) => newClient
            .get(Uri.parse("$address$crypto/$assetQuote?apikey=$apiKey"))));
    //print(responseList.map((response) => exchangeFromJson(response.body)).toList());
    return responseList.map((response) => exchangeFromJson(response.body)).toList();
  }
}
