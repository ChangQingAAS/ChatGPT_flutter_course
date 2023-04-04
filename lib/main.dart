import 'package:chatgpt/config/color_config.dart';
import 'package:chatgpt/providers/chat_provider.dart';
import 'package:chatgpt/providers/openai_models_provider.dart';
import 'package:chatgpt/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This is the main function of the app.
void main() {
  runApp(
    const MyApp(),
  );
}

/// This is the root widget of the app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // The [MultiProvider] widget is used to provide multiple providers
    return MultiProvider(
      providers: [
        // The [ChangeNotifierProvider] is used to provide a provider
        ChangeNotifierProvider(
          // The [OpenAIModelsProvider] is used to provide the models from OpenAI
          create: (_) => OpenAIModelsProvider(),
        ),
        ChangeNotifierProvider(
          // The [ChatProvider] is used to provide the chat
          create: (_) => ChatProvider(),
        )
      ],
      // The [MaterialApp] widget is the root of the app
      child: MaterialApp(
        // [title] is the title of the app
        title: 'Flutter ChatGPT',
        // debugShowCheckedModeBanner is used to show the debug banner
        debugShowCheckedModeBanner: false,
        // [theme] is the theme of the app
        theme: ThemeData(
          scaffoldBackgroundColor: ColorConfig.scaffoldBackgroundColor,
          appBarTheme: AppBarTheme(
            color: ColorConfig.cardColor,
          ),
        ),
        // [home] is the home screen of the app
        home: const ChatScreen(),
      ),
    );
  }
}
