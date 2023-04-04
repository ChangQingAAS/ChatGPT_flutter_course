import 'package:chatgpt/config/color_config.dart';
import 'package:chatgpt/models/openai_models_model.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../providers/openai_models_provider.dart';

/// class [ModelDropDownWidget] shows the list of models
/// and allows the user to select a model.
class ModelDropDownWidget extends StatefulWidget {
  const ModelDropDownWidget({Key? key}) : super(key: key);

  @override
  State<ModelDropDownWidget> createState() => _ModelDropDownWidgetState();
}

class _ModelDropDownWidgetState extends State<ModelDropDownWidget> {
  /// The current model selected by the user
  late String currentModel;

  /// A boolean value to check if the widget is loading for the first time
  bool isFirstLoading = true;

  @override
  Widget build(BuildContext context) {
    /// Get the current model from the provider
    final modelsProvider =
        Provider.of<OpenAIModelsProvider>(context, listen: false);
    currentModel = modelsProvider.currentModel;

    return FutureBuilder<List<OpenAIModelsModel>>(
      // Get the list of models from the provider
      future: modelsProvider.getAllModels(),
      // Build the widget based on the state of the future
      builder: (context, snapshot) {
        // If the future is loading for the first time, show a loading indicator
        if (snapshot.connectionState == ConnectionState.waiting &&
            isFirstLoading == true) {
          isFirstLoading = false;
          return const FittedBox(
            child: SpinKitFadingCircle(
              color: Colors.lightBlue,
              size: 30,
            ),
          );
        }

        // If the snapshot has an error, show the error message
        if (snapshot.hasError) {
          return Center(
            child: TextWidget(
              label: snapshot.error.toString(),
            ),
          );
        }

        // If the snapshot has data, show the list of models
        return snapshot.data == null || snapshot.data!.isEmpty
            ? const SizedBox.shrink()
            : FittedBox(
                child: DropdownButton(
                  dropdownColor: ColorConfig.scaffoldBackgroundColor,
                  iconEnabledColor: Colors.white,
                  // Generate the list of models, and show the id of the model
                  items: List<DropdownMenuItem<String>>.generate(
                    snapshot.data!.length,
                    (index) => DropdownMenuItem(
                      value: snapshot.data![index].id,
                      child: TextWidget(
                        label: snapshot.data![index].id,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  value: currentModel,
                  // When the user selects a model, update the current model
                  onChanged: (value) {
                    setState(
                      () {
                        currentModel = value.toString();
                      },
                    );
                    modelsProvider.setCurrentModel(
                      value.toString(),
                    );
                  },
                ),
              );
      },
    );
  }
}
