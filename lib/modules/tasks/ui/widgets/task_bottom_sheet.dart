
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/core/constants/string_constants.dart';
import 'package:task_manager/core/reusable_widgets/app_text_form_field.dart';
import 'package:task_manager/core/style/style_constants/color_constants.dart';
import 'package:task_manager/modules/tasks/providers/tasks_bottomsheet_provider.dart';

class TasksBottomsheet extends StatelessWidget {
  const TasksBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    TasksBottomsheetProvider tasksBottomsheetProvider =
        Provider.of<TasksBottomsheetProvider>(context);

    switch (tasksBottomsheetProvider.state) {
      case TasksBottomsheetState.INITIALIZING:
        tasksBottomsheetProvider.init(context);
        break;
      case TasksBottomsheetState.INITIALIZED:
        break;
      case TasksBottomsheetState.LOADING:
        break;
      case TasksBottomsheetState.FAILED:
        tasksBottomsheetProvider.reinitializeState(context);
        break;
      case TasksBottomsheetState.SUCCEEDED:
        tasksBottomsheetProvider.reinitializeState(context);
        break;
    }

    return tasksBottomsheetProvider.isBottomSheetOpened
        ? Container(
            padding: const EdgeInsets.all(
              20,
            ),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20))),
            child: Form(
              key: tasksBottomsheetProvider.taskFormKey,
              child: ListView(shrinkWrap: true, children: [
                AppTextFormField(
                  label: StringConstants.taskTitleFieldLabel,
                  textEditingController:
                      tasksBottomsheetProvider.taskTitleController,
                  hintText: StringConstants.taskTitleFieldHint,
                  validator: (input) =>
                      tasksBottomsheetProvider.validateTaskTitle(),
                  autoFocus: true,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 15,
                ),
                AppTextFormField(
                  label: StringConstants.taskDescriptionFieldLabel,
                  textEditingController:
                      tasksBottomsheetProvider.taskDescriptionController,
                  hintText: StringConstants.taskDescriptionFieldHint,
                  validator: (input) =>
                      tasksBottomsheetProvider.validateTaskDescription(),
                  maxLines: 5,
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      tasksBottomsheetProvider.setDueDate(pickedDate);
                    }
                  },
                  child: AbsorbPointer(
                    child: AppTextFormField(
                      label: StringConstants.taskDueDateFieldLabel,
                      textEditingController:
                          tasksBottomsheetProvider.taskDueDateController,
                      hintText: StringConstants.taskDueDateFieldHint,
                      validator: (input) =>
                          tasksBottomsheetProvider.validateTaskDueDate(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                DropdownButtonFormField<String>(
                  value: tasksBottomsheetProvider.taskStatus,
                  items: [
                    StringConstants.taskStatusPending,
                    StringConstants.taskStatusCompleted
                  ].map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    tasksBottomsheetProvider.setTaskStatus(newValue);
                  },
                  decoration: InputDecoration(
                    labelText: StringConstants.taskStatusFieldLabel,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: MaterialButton(
                        elevation: 0,
                        height: 50,
                        color: ColorConstants.kSecondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onPressed: () => tasksBottomsheetProvider.setTask(),
                        child: tasksBottomsheetProvider.state ==
                                TasksBottomsheetState.LOADING
                            ? const SizedBox(
                                width: 50,
                                child: CircularProgressIndicator(),
                              )
                            : Text(tasksBottomsheetProvider.editedTask == null
                                ? StringConstants.addButtonLabel
                                : StringConstants.updateButtonLabel))),
              ]),
            ),
          )
        : const SizedBox(
            height: 0,
          );
  }
}
