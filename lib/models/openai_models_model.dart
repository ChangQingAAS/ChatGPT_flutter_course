/// [OpenAIModelsModel] contains the model for the OpenAI Models
class OpenAIModelsModel {
  /// [id] is the id of the model
  final String id;

  /// [created] is the date when the model was created
  final int created;

  /// [root] is the root of the model
  final String root;

  /// Constructor for [OpenAIModelsModel]
  OpenAIModelsModel({
    required this.id,
    required this.created,
    required this.root,
  });

  /// Convert a JSON to a [OpenAIModelsModel] object.
  /// This is used when we get the response from the API.
  factory OpenAIModelsModel.fromJson(Map<String, dynamic> json) =>
      OpenAIModelsModel(
        id: json["id"],
        created: json["created"],
        root: json["root"],
      );

  /// Convert a list of JSON to a list of [OpenAIModelsModel] objects.
  static List<OpenAIModelsModel> modelsFromSnapShot(List modelSnapshot) {
    return modelSnapshot
        .map((data) => OpenAIModelsModel.fromJson(data))
        .toList();
  }

  // /// Convert a JSON to a [OpenAIModelsModel] objects.
  // ModelsModel fromJson(Map<String, dynamic> json) {
  //   return ModelsModel(
  //     id: json["id"],
  //     created: json["created"],
  //     root: json["root"],
  //   );
  // }
  //
  // /// Convert a list of JSON to a list of [OpenAIModelsModel] objects.
  // List<ModelsModel> modelsFromSnapShot(List modelSnapshot) {
  //   return modelSnapshot.map((data) => fromJson(data)).toList();
  // }
}
