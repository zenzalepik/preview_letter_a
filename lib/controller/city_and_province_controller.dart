import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:letter_a/models/city_and_province_model.dart';

const String apiKey = 'YOUR_RAJAONGKIR_API_KEY';

Future<List<Province>> fetchProvinces() async {
  final response = await http.get(
    Uri.parse('https://api.rajaongkir.com/starter/province'),
    headers: {
      'key': apiKey,
    },
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)['rajaongkir']['results'];
    return jsonResponse.map((data) => Province.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load provinces');
  }
}

Future<List<City>> fetchCities(String provinceId) async {
  final response = await http.get(
    Uri.parse('https://api.rajaongkir.com/starter/city?province=$provinceId'),
    headers: {
      'key': apiKey,
    },
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)['rajaongkir']['results'];
    return jsonResponse.map((data) => City.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load cities');
  }
}
