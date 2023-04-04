/// class [ChatModel] contains the message and the chat index.
class ChatModel {
  final String msg;

  /// 0 means user, 1 means bot
  final int chatIndex;

  /// Constructor for [ChatModel]
  ChatModel({
    required this.msg,
    required this.chatIndex,
  });

  /// Convert a JSON to a [ChatModel] object.
  /// This is used when we get the response from the API.
  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        msg: json["msg"],
        chatIndex: json["chatIndex"],
      );
}
