import 'dart:developer';

import 'package:chatgpt/providers/chat_provider.dart';
import 'package:chatgpt/providers/openai_models_provider.dart';
import 'package:chatgpt/config/images.dart';
import 'package:chatgpt/config/color_config.dart';
import 'package:chatgpt/services/services.dart';
import 'package:chatgpt/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../widgets/text_widget.dart';

/// class [ChatScreen] contains the chat screen.
/// It is used to show the chat screen.
/// It is a [StatefulWidget] so that it can have a state.
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  /// [_isTyping] is used to show the typing indicator.
  bool _isTyping = false;

  /// They are used to control the text field.
  /// They are initialized in [initState] and disposed in [dispose].
  /// [textEditingController] is used to control the text in the text field.
  late TextEditingController textEditingController;

  /// [focusNode] is used to control the focus of the text field.
  late FocusNode focusNode;

  /// [_scrollController] is used to scroll to the bottom of the list view.
  late ScrollController _scrollController;

  /// [initState] is called when the state is initialized.
  @override
  void initState() {
    _scrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();

    // Call the super method.
    // If you don't call the super method, then the state will not be initialized.
    super.initState();
  }

  /// [dispose] is called when the state is disposed.
  @override
  void dispose() {
    _scrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();

    // Call the super method.
    // If you don't call the super method, then the state will not be disposed.
    super.dispose();
  }

  // [chatList] contains the chat list.
  // It is initialized with an empty list.
  // List<ChatModel> chatList = [];

  /// [build] is called when the widget is built.
  /// It is used to build the widget.
  @override
  Widget build(BuildContext context) {
    /// Get the models provider. It is used to get the current model.
    final modelsProvider = Provider.of<OpenAIModelsProvider>(context);

    /// Get the chat provider. It is used to get the chat list.
    /// It is also used to add the new chat to the chat list.
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            ImagesConfig.openaiLogo,
          ),
        ),
        title: const Text("ChatGPT"),
        actions: [
          IconButton(
            onPressed: () async {
              // Show the modal sheet.
              // It is used to show the model selection sheet.
              await Services.showModalSheet(context: context);
            },
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                controller: _scrollController,
                // itemCount is the number of items in the list.
                itemCount: chatProvider.chatList.length,
                // itemBuilder is used to build the list item.
                // It is called for each item in the list.
                itemBuilder: (context, index) {
                  // return the chat widget for each item in the list.
                  return ChatWidget(
                    msg: chatProvider.chatList[index].msg.toString(),
                    chatIndex: chatProvider.chatList[index].chatIndex,

                    // [shouldAnimate] is used to animate the chat widget.
                    // It is true only for the last item in the list.
                    shouldAnimate: chatProvider.chatList.length - 1 == index,
                  );
                },
              ),
            ),
            if (_isTyping) ...[
              // [SpinKitThreeBounce] is used to show the typing indicator.
              // It is shown only when [_isTyping] is true.
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 20.0,
              ),
            ],

            // [SizedBox] is used to add some space between the widgets.
            const SizedBox(
              height: 15,
            ),

            // [Material] is used to show the text field.
            Material(
              color: ColorConfig.cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        // [focusNode] is used to control the focus of the text field.
                        focusNode: focusNode,
                        style: const TextStyle(
                          color: Colors.white,
                        ),

                        // [textEditingController] is used to control the text in the text field.
                        controller: textEditingController,

                        // [onSubmitted] is called when the user submits the text.
                        // It is called when the user presses the send button.
                        // It is also called when the user presses the enter key.
                        onSubmitted: (value) async {
                          // Call the [sendMessageFCT] function.
                          // It is used to send the message.
                          // It is also used to add the message to the chat list.
                          // It is also used to clear the text field.
                          await sendMessageFCT(
                            modelsProvider: modelsProvider,
                            chatProvider: chatProvider,
                          );
                        },

                        // decoration is used to show the text field decoration.
                        // InputDecoration.collapsed is used to show the collapsed text field.
                        // It is used to show the text field without the border.
                        decoration: const InputDecoration.collapsed(
                          // hintText is used to show the hint text.
                          hintText: "How can i help you?",

                          // hintStyle is used to style the hint text.
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),

                    // [IconButton] is used to show the send button.
                    IconButton(
                      // [onPressed] is called when the user presses the send button.
                      onPressed: () async {
                        // Call the [sendMessageFCT] function.
                        // It is used to send the message.
                        // It is also used to add the message to the chat list.
                        // It is also used to clear the text field.
                        await sendMessageFCT(
                          modelsProvider: modelsProvider,
                          chatProvider: chatProvider,
                        );
                      },

                      // icon is used to show the send icon.
                      icon: const Icon(
                        Icons.send,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// scrollToBottom is used to scroll to the bottom of the list.
  void scrollToBottom() {
    // animateTo is used to animate the scroll.
    _scrollController.animateTo(
      // maxScrollExtent is the maximum scroll extent.
      _scrollController.position.maxScrollExtent,

      // duration is the duration of the animation.
      duration: const Duration(seconds: 1),

      // curve is the curve of the animation.
      curve: Curves.easeOut,
    );
  }

  /// sendMessageFCT is used to send the message.
  /// It is also used to add the message to the chat list.
  /// It is also used to clear the text field.
  /// It is also used to show the error message.
  Future<void> sendMessageFCT(
      {required OpenAIModelsProvider modelsProvider,
      required ChatProvider chatProvider}) async {
    // It is used to show the error message when the user tries to send multiple messages at the same time.
    if (_isTyping) {
      // showSnackBar is used to show the error message.
      ScaffoldMessenger.of(context).showSnackBar(
        // SnackBar is used to show the error message.
        const SnackBar(
          content: TextWidget(
            label: "You can not send multiple messages at the same time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // When the user tries to send an empty message, it shows the error message
    if (textEditingController.text.isEmpty) {
      // showSnackBar is used to show the error message.
      ScaffoldMessenger.of(context).showSnackBar(
        // SnackBar is used to show the error message.
        const SnackBar(
          content: TextWidget(
            label: "Please input a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // msg is the message that the user sends.
      String msg = textEditingController.text;

      // It is used for debugging.
      // It is not used in the production app.
      log("In function sendMessage: textEditingController.text: $msg");

      // setState is used to update the UI.
      setState(
        () {
          // set [_isTyping] to true, to show the typing indicator,
          // and to prevent the user from sending multiple messages at the same time.
          _isTyping = true;
          // chatList.add(
          //   ChatModel(msg: msg, chatIndex: 0),
          // );
          // add the message to the chat list.
          chatProvider.addUserMessage(msg: msg);

          // clear the text field.
          textEditingController.clear();

          // unfocused the text field.
          focusNode.unfocus();
        },
      );

      // get answers from the API, and add them to the chat list.
      await chatProvider.sendMessageAndGetAnswers(
        msg: msg,
        chosenModel: modelsProvider.currentModel,
      );
      // chatList.addAll(
      //   await ApiService.sendMessage(
      //     message: msg,
      //     modelId: modelsProvider.getCurrentModel,
      //   ),
      // );

      // setState is used to update the UI.
      setState(() {});
    } catch (error) {
      // It is used for debugging.
      log("error when sending: $error");

      // showSnackBar is used to show the error message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget(
            label: error.toString(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // finally is called when the try block is finished,
      // whether it is successful or not.
      setState(
        () {
          // scroll to the bottom of the list.
          scrollToBottom();

          // set the _isTyping to false, to allow the user to send another message.
          _isTyping = false;
        },
      );
    }
  }
}
