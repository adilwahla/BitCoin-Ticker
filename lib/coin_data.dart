import 'dart:convert';
import 'package:http/http.dart' as http;
const bitCoinUrl='https://apiv2.bitcoinaverage.com/indices/global/ticker';

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

  Future getCoinData(String SelectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    for (String cryptoCurrency in cryptoList) {
      String cryptoUrl = '$bitCoinUrl/$cryptoCurrency$SelectedCurrency';

      http.Response response = await http.get(cryptoUrl);
      print(response.body);
      if (response.statusCode == 200) {
        String data = response.body;

        double lastPrice = jsonDecode(data)['last'];
        cryptoPrices[cryptoCurrency]=lastPrice.toStringAsFixed(0);
      }
      else {
        print(response.statusCode);
      }
    }
    return cryptoPrices;
  }
  }
