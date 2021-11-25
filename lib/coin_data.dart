import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'KRW',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'SOL',
];

class CoinData {
  Future<dynamic> getCoinRate(String currency) async {
    String apiKey = dotenv.env['API_KEY'].toString();
    String baseUrl = dotenv.get('BASE_URL').toString();
    Map<String, String> requestHeaders = {'X-CoinAPI-Key': apiKey};
    Map<String, String> cryptoRates = {};
    var client = http.Client();
    try {
      for (String crypto in cryptoList) {
        var urlString = Uri.parse("$baseUrl/$crypto/$currency");
        var res = await http.get(urlString, headers: requestHeaders);
        if (res.statusCode == 200) {
          var decodedData = jsonDecode(res.body);
          double lastPrice = decodedData['rate'];
          cryptoRates[crypto] = lastPrice.toStringAsFixed(0);
        } else {
          throw ('Request for $crypto failed with status: ${res.statusCode}');
        }
      }
      return cryptoRates;
    } finally {
      client.close();
    }
  }
}
