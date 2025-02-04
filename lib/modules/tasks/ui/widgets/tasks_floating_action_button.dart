
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/core/style/style_constants/color_constants.dart';
import 'package:task_manager/modules/tasks/providers/tasks_bottomsheet_provider.dart';

class TasksFloatingActionButton extends StatelessWidget {
  const TasksFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    TasksBottomsheetProvider tasksBottomsheetProvider =
        Provider.of<TasksBottomsheetProvider>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 20),
      child: SizedBox(
        height: 60,
        width: 60,
        child: FloatingActionButton(
          backgroundColor: ColorConstants.kPrimaryColor,
          splashColor: ColorConstants.kPrimaryAccentColor,
          focusColor: ColorConstants.kPrimaryAccentColor,
          hoverColor: ColorConstants.kPrimaryAccentColor,
          foregroundColor: ColorConstants.kPrimaryAccentColor,
          onPressed: () => tasksBottomsheetProvider.toggleBottomSheet(),
          child: Icon(
            tasksBottomsheetProvider.isBottomSheetOpened
                ? Icons.close_rounded
                : Icons.add_rounded,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
    );
  }
}
