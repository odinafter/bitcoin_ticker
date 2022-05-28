import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = 'D4F8CD04-D8C9-434F-B722-203C3C7B528C';
const coinExchangeDataURL = 'https://rest.coinapi.io/v1/exchangerate';

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

// class NetworkHelper {
//   Future getData(url) async {
//     http.Response response = await http.get(url);
//     if (response.statusCode == 200) {
//       String data = response.body;

//       return jsonDecode(data);
//     } else {
//       print(response.statusCode);
//     }
//   }
// }

class CoinData {
  // เวลารับค่าตัวแปร ต้องระบุชนิดตัวแปรด้วยทุกครั้ง
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> exchangeRateData = {};
    for (String coinName in cryptoList) {
      Uri? requestUrl = Uri.tryParse(
          '$coinExchangeDataURL/$coinName/$selectedCurrency?apikey=$apiKey');

      http.Response response = await http.get(requestUrl!);
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double price = decodedData['rate'];
        exchangeRateData[coinName] = price.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return exchangeRateData;
  }
}
