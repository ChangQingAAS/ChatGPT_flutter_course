import 'package:chatgpt/config/openai.dart';
import 'package:chatgpt/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:chatgpt/models/openai_models_model.dart';

/// class [OpenAIModelsProvider] contains all the models related data.
/// It is used to store the models list and to set the current model.
/// It is used in [OpenAIModelsScreen] and [OpenAIModelsWidget].
/// It is a [ChangeNotifier] so that it can notify its listeners
/// when the models list or the current model changes.
class OpenAIModelsProvider with ChangeNotifier {
  /// [currentModel] contains the current model.
  /// It is initialized with the default model.
  /// It is used in [ChatScreen] and [ChatWidget].
  String currentModel = OpenAIConfig.defaultModel;

  /// [setCurrentModel] sets the current model.
  /// It is used in [OpenAIModelsScreen] and [OpenAIModelsWidget].
  void setCurrentModel(String model) {
    /// Set the current model.
    currentModel = model;

    /// Notify the listeners that the current model has changed.
    notifyListeners();
  }

  /// [modelsList] contains the models list.
  /// It is initialized with an empty list.
  List<OpenAIModelsModel> modelsList = [];

  /// [getAllModels] gets the models list from the API.
  /// It is used in [OpenAIModelsScreen] and [OpenAIModelsWidget].
  /// It is a [Future] so that it can be used with [async] and [await].
  /// It throws an [error] if the API call fails.
  Future<List<OpenAIModelsModel>> getAllModels() async {
    /// Try to get the models list from the API.
    try {
      // Get the models list from the API.
      modelsList = await ApiService.getModels();

      // Notify the listeners that the models list has changed.
      notifyListeners();

      // Return the models list.
      return modelsList;
    } catch (error) {
      // If the API call fails, then throw the error.
      rethrow;
    }
  }
}
