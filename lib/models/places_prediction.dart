class PredictionResponse {
  List<Prediction> predictions;
  String status;

  PredictionResponse({required this.predictions, required this.status});

  factory PredictionResponse.fromJson(Map<String, dynamic> json) =>
      PredictionResponse(
        predictions: List<Prediction>.from(
          json['predictions'].map((x) => Prediction.fromJson(x)),
        ),
        status: json['status'],
      );
}

class Prediction {
  String description;
  String placeId;
  String reference;
  List<String> types;

  Prediction({
    required this.description,
    required this.placeId,
    required this.reference,
    required this.types,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) => Prediction(
        description: json['description'],
        placeId: json['place_id'],
        reference: json['reference'],
        types: List<String>.from(json['types'].map((x) => x)),
      );
}
