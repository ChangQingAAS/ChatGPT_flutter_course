import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgpt/config/images.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';

import '../config/color_config.dart';

/// This widget is used to show the chat messages
/// It takes in the message and the index of the message
/// It also takes in a boolean value to check if the message should be animated
class ChatWidget extends StatelessWidget {
  const ChatWidget(
      {Key? key,
      required this.msg,
      required this.chatIndex,
      this.shouldAnimate = false})
      : super(key: key);

  /// The message to be shown
  final String msg;

  /// The index of the message
  final int chatIndex;

  /// A boolean value to check if the message should be animated
  final bool shouldAnimate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: chatIndex == 0
              ? ColorConfig.scaffoldBackgroundColor
              : ColorConfig.cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0
                      ? ImagesConfig.userImage
                      : ImagesConfig.botImage,
                  height: 40,
                  width: 40,
                ),
                const SizedBox(width: 8),
                Expanded(
                  // If the message is from the user, then show the message as it is
                  // If the message is from the bot, then show the message with animation
                  child: chatIndex == 0
                      ? TextWidget(
                          label: msg,
                        )
                      : shouldAnimate
                          ? DefaultTextStyle(
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                              ),
                              // the animation show the message one character at a time
                              child: AnimatedTextKit(
                                isRepeatingAnimation: false,
                                repeatForever: false,
                                displayFullTextOnTap: true,
                                totalRepeatCount: 1,
                                animatedTexts: [
                                  TyperAnimatedText(
                                    msg.trim(),
                                  ),
                                ],
                              ),
                            )
                          : Text(
                              msg.trim(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                ),
                // If the message is from the bot, then show the thumbs up and down icons
                chatIndex == 0
                    ? const SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end, // 向右对齐
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Icon(
                            Icons.thumb_down_alt_outlined,
                            color: Colors.white,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
