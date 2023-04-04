import 'package:flutter/material.dart';

import '../config/color_config.dart';
import '../widgets/text_widget.dart';
import '../widgets/drop_down.dart';

class Services {
  /// Show a modal sheet
  static Future<void> showModalSheet({required BuildContext context}) async {
    // Show a modal sheet, and wait for the user to close it
    await showModalBottomSheet(
      // Set the shape of the modal sheet
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      backgroundColor: ColorConfig.scaffoldBackgroundColor,
      // Set the context, so that the modal sheet knows where to show
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            // Set the main axis alignment to space between, so that the widgets
            // are spaced out evenly
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Flexible(
                child: TextWidget(
                  label: "Chosen Model:",
                  fontSize: 16,
                ),
              ),
              Flexible(
                flex: 2,
                // Show the drop down widget, which will show the list of models
                child: ModelDropDownWidget(),
              ),
            ],
          ),
        );
      },
    );
  }
}
