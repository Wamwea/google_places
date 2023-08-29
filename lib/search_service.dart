import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:location_app/constants.dart';
import 'package:location_app/models/places_prediction.dart';

class SearchService {
  final Dio dioClient;

  SearchService({required this.dioClient});

  Future searchCity(String query) async {
    try {
      final apiKey = dotenv.env['PLACES_API_KEY'];
      final response = await dioClient.get(
        '$PLACES_AUTOCOMPLETE_BASE_URL?input=$query&key=$apiKey&types=(cities)',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      final parsedResponse = PredictionResponse.fromJson(response.data);
      return parsedResponse;
    } on DioException catch (e) {
      print(e);
      return PredictionResponse(predictions: [], status: 'error');
    }
  }
}
