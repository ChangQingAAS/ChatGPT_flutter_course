import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatgpt/models/openai_models_model.dart';
import 'package:http/http.dart' as http;
import 'package:chatgpt/config/openai.dart';

import '../models/chat_model.dart';

/// class [ApiService] contains all the API calls from the app.
class ApiService {
  /// [getModels] gets the models list from the API.
  static Future<List<OpenAIModelsModel>> getModels() async {
    /// Try to get the models list from the API.
    try {
      log("Enter API_SERVICE.getModels()");

      var response = await http.get(
        // Uri.parse() is used to convert the string to a Uri object.
        Uri.parse(
          // The API endpoint for getting the models list.
          "${OpenAIConfig.baseURL}/models",
        ),
        // The headers for the API call.
        headers: {
          // The API key is used to authenticate the API call.
          'Authorization': 'Bearer ${OpenAIConfig.apiKey}',
        },
      );

      // convert the response body to a Map, the map is in JSON format.
      Map jsonResponse = jsonDecode(response.body);
      // if the response contains an error, then throw an exception.
      if (jsonResponse['error'] != null) {
        log("jsonResponse['error'] : ${jsonResponse['error']['message']}");
        throw Exception(
          jsonResponse['error']['message'],
        );
      }

      // log("jsonResponse: $jsonResponse");
      List temp = [];

      // Loop through the data in the response.
      for (var value in jsonResponse["data"]) {
        temp.add(value);
        // log("value: $value");
        // log("id: ${value['id']}");
      }

      // Convert the list of models to a list of [OpenAIModelsModel] objects.
      return OpenAIModelsModel.modelsFromSnapShot(temp);
    } catch (error) {
      // If the API call fails, then throw the error.
      log("error: $error");
      rethrow;
    }
  }

  /// ref: https://platform.openai.com/docs/api-reference/completions/create
  /// [sendMessage] sends the message to the API and gets the response.
  static Future<List<ChatModel>> sendMessage(
      {required String message, required String model}) async {
    // Try to send the message to the API and get the response.
    try {
      // Log the message and the model.
      log("Enter function: API_SERVICE.sendMessage()");
      log("model $model, message: $message");

      // Send the message to the API and get the response.
      var response = await http.post(
        Uri.parse(
          "${OpenAIConfig.baseURL}/completions",
        ),
        headers: {
          'Authorization': 'Bearer ${OpenAIConfig.apiKey}',
          'Content-Type': 'application/json'
        },

        // The body of the API call.
        body: jsonEncode(
          {
            // The prompt is the message that we send to the API.
            'model': model,

            // The model is the model that we use to get the response.
            'prompt': message,

            // The max_tokens is the number of tokens that we want to get from the API.
            'max_tokens': 300,
          },
        ),
      );

      // convert the response body to a Map, the map is in JSON format.
      Map jsonResponse = json.decode(
        utf8.decode(response.bodyBytes),
      );
      if (jsonResponse['error'] != null) {
        log("jsonResponse['error'] : ${jsonResponse['error']}");
        throw HttpException(
          jsonResponse['error']['message'],
        );
      }

      // Log the response, the response is in JSON format.
      log("jsonResponse: $jsonResponse");
      log("jsonResponse['choices']: ${jsonResponse['choices']}");
      log("jsonResponse['choices'][0]['text']: ${jsonResponse['choices'][0]['text']}");

      List<ChatModel> chatList = [];
      // If the response contains choices, then convert the choices to a list of [ChatModel] objects.
      if (jsonResponse["choices"].length > 0) {
        // Convert the choices to a list of [ChatModel] objects.
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            msg: jsonResponse["choices"][index]["text"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      // If the API call fails, then throw the error.
      log("error in api_service: $error");
      rethrow;
    }
  }

  /// ref: https://platform.openai.com/docs/api-reference/completions/create
  /// [sendMessageUsingChatGPT] sends the message to the API and gets the response.
  static Future<List<ChatModel>> sendMessageUsingChatGPT(
      {required String message, required String model}) async {
    // Try to send the message to the API and get the response.
    try {
      // Log the message and the model.
      log("Enter function: API_SERVICE.sendMessageUsingChatGPT()");
      log("model $model, message: $message");

      // Send the message to the API and get the response.
      var response = await http.post(
        Uri.parse(
          "${OpenAIConfig.baseURL}/v1/chat/completions",
        ),
        headers: {
          'Authorization': 'Bearer ${OpenAIConfig.apiKey}',
          'Content-Type': 'application/json'
        },
        // The body of the API call.
        body: jsonEncode(
          {
            // The prompt is the message that we send to the API.
            'model': model,
            // The model is the model that we use to get the response.
            'messages': [
              {
                // role is the role of the message, it can be user or bot.
                "role": "user",
                // The message is the message that we send to the API.
                "content": message,
              }
            ],
          },
        ),
      );

      // convert the response body to a Map, the map is in JSON format.
      Map jsonResponse = json.decode(
        utf8.decode(response.bodyBytes),
      );

      // If the response contains an error, then throw an exception.
      if (jsonResponse['error'] != null) {
        log("jsonResponse['error'] : ${jsonResponse['error']}");
        throw HttpException(
          jsonResponse['error']['message'],
        );
      }

      log("jsonResponse: $jsonResponse");
      log("jsonResponse['choices']: ${jsonResponse['choices']}");
      log("jsonResponse['choices'][0]['message']['content']: ${jsonResponse['choices'][0]['message']['content']}");

      List<ChatModel> chatList = [];
      // If the response contains choices, then convert the choices to a list of [ChatModel] objects.
      if (jsonResponse["choices"].length > 0) {
        // Convert the choices to a list of [ChatModel] objects.
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            msg: jsonResponse["choices"][index]["message"]['content'],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      // If the API call fails, then throw the error.
      log("error in api_service: $error");
      rethrow;
    }
  }
}
