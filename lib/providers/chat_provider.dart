import 'package:flutter/material.dart';

import '../models/chat_model.dart';
import '../services/api_service.dart';

/// class [ChatProvider] contains all the chat related data.
/// It is used to store the chat history and to send messages.
/// It is used in [ChatScreen] and [ChatWidget].
/// It is a [ChangeNotifier] so that it can notify its listeners
/// when the chat history changes.
class ChatProvider with ChangeNotifier {
  /// [chatList] contains the chat history.
  List<ChatModel> chatList = [];

  /// [addUserMessage] adds the user's message to the chat history.
  void addUserMessage({required String msg}) {
    // Add the user's message to the chat history.
    chatList.add(
      // Create a [ChatModel] object.
      ChatModel(msg: msg, chatIndex: 0),
    );

    // Notify the listeners that the chat history has changed.
    notifyListeners();
  }

  /// [sendMessageAndGetAnswers] sends the message to the API and
  /// gets the answers from the API.
  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModel}) async {
    // If the chosen model is a GPT model, then use the GPT API.
    if (chosenModel.toLowerCase().startsWith('gpt')) {
      // Add the answers from the API to the chat history.
      chatList.addAll(
        // Call the [sendMessageUsingChatGPT] function from the [ApiService].
        await ApiService.sendMessageUsingChatGPT(
          // Send the message and the model to the API.
          message: msg,
          model: chosenModel,
        ),
      );
    } else {
      // If the chosen model is not a GPT model, then use the OpenAI API.
      chatList.addAll(
        // Call the [sendMessage] function from the [ApiService].
        await ApiService.sendMessage(
          // Send the message and the model to the API.
          message: msg,
          model: chosenModel,
        ),
      );
    }

    // Notify the listeners that the chat history has changed.
    notifyListeners();
  }
}
