import 'package:http/http.dart' as http;
import 'dart:convert';

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
  'LTC',
];

class CoinData {
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    for (String coin in cryptoList) {
      http.Response response = await http.get(Uri.parse('https://apiv2.bitcoinaverage.com/indices/global/ticker/$coin$selectedCurrency'));
      if (response.statusCode == 200) {
        String data = response.body;
        double price = jsonDecode(data)['last'];
        cryptoPrices[coin] = price.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with get Request';
      }
    }
    return cryptoPrices;
  }
}
