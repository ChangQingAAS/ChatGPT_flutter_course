/// OpenAI API Config.
/// It contains the base URL and the API key.
class OpenAIConfig {
  /// Base URL for the OpenAI API.
  static String baseURL = "https://api.openai.com/v1";

  /// API key for the OpenAI API.
  static String apiKey = "https://platform.openai.com/account/api-keys";

  /// Default model to use.
  // static String defaultModel = "text-davinci-003";
  static String defaultModel = "gpt-3.5-turbo-0301";
}
