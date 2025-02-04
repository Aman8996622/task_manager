import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/core/constants/string_constants.dart';
import 'package:task_manager/core/style/style_constants/color_constants.dart';
import 'package:task_manager/data/local_storage.dart';
import 'package:task_manager/models/response.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/modules/tasks/providers/tasks_list_provider.dart';

enum TasksBottomsheetState {
  INITIALIZING,
  INITIALIZED,
  LOADING,
  FAILED,
  SUCCEEDED
}

class TasksBottomsheetProvider extends ChangeNotifier {
  // Singleton instance
  TasksBottomsheetProvider._privateConstructor();
  static final TasksBottomsheetProvider _instance =
      TasksBottomsheetProvider._privateConstructor();
  factory TasksBottomsheetProvider() => _instance;

  TasksBottomsheetState state = TasksBottomsheetState.INITIALIZING;

  late TasksListProvider tasksListProvider;
  var taskTitleController = TextEditingController();
  var taskDescriptionController = TextEditingController();
  var taskDueDateController = TextEditingController(); // Added
  var taskFormKey = GlobalKey<FormState>();
  bool isUrgentTask = false;
  Task? editedTask;
  Response? latestResponse;
  bool isBottomSheetOpened = false;
  String? taskStatus; // Added

  void init(BuildContext context) {
    tasksListProvider = Provider.of<TasksListProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => updateState(TasksBottomsheetState.INITIALIZED));
  }

  Future<void> setTask() async {
    if (!taskFormKey.currentState!.validate()) return;

    updateState(TasksBottomsheetState.LOADING);
    if (editedTask == null) {
      // Add new task
      latestResponse = await LocalStorage.addTask(Task(
          title: taskTitleController.text,
          description: taskDescriptionController.text,
          isUrgent: isUrgentTask,
          dueDate: taskDueDateController.text, // Added
          status: taskStatus ?? "")); // Added
    } else {
      // Update existing task
      editedTask?.title = taskTitleController.text;
      editedTask?.description = taskDescriptionController.text;
      editedTask?.isUrgent = isUrgentTask;
      editedTask?.dueDate = taskDueDateController.text; // Added
      editedTask?.status = taskStatus ?? ""; // Added
      latestResponse = await LocalStorage.updateTask(editedTask!);
    }

    if (latestResponse!.isOperationSuccessful) {
      isBottomSheetOpened = false;
      tasksListProvider.updateState(TasksListState.RELOADING);
      updateState(TasksBottomsheetState.SUCCEEDED);
    } else {
      updateState(TasksBottomsheetState.FAILED);
    }
  }

  void updateState(TasksBottomsheetState newState) {
    state = newState;
    notifyListeners();
  }

  String? validateTaskTitle() {
    return taskTitleController.text.isEmpty
        ? StringConstants.taskTitleFieldError
        : null;
  }

  String? validateTaskDescription() {
    return taskDescriptionController.text.isEmpty
        ? StringConstants.taskDescriptionFieldError
        : null;
  }

  String? validateTaskDueDate() {
    return taskDueDateController.text.isEmpty
        ? StringConstants.taskDueDateFieldError
        : null;
  }

  void setDueDate(DateTime dueDate) {
    taskDueDateController.text = dueDate.toString(); // Format as needed
    notifyListeners();
  }

  void setTaskStatus(String? newValue) {
    taskStatus = newValue;
    notifyListeners();
  }

  void open({Task? task}) {
    _setStateData(task: task);
    isBottomSheetOpened = true;
    notifyListeners();
  }

  void close() {
    isBottomSheetOpened = false;
    _setStateData();
    updateState(TasksBottomsheetState.INITIALIZED);
  }

  void toggleBottomSheet() {
    isBottomSheetOpened ? close() : open();
  }

  void setUrgentTask(bool? value) {
    if (value != null) {
      isUrgentTask = value;
      notifyListeners();
    }
  }

  void _setStateData({Task? task}) {
    editedTask = task;
    if (editedTask != null) {
      taskTitleController.text = editedTask?.title ?? "";
      taskDescriptionController.text = editedTask?.description ?? "";
      taskDueDateController.text = editedTask?.dueDate ?? ''; // Added
      taskStatus = editedTask!.status; // Added
      isUrgentTask = editedTask!.isUrgent;
    } else {
      taskTitleController.clear();
      taskDescriptionController.clear();
      taskDueDateController.clear(); // Added
      taskStatus = null; // Added
      isUrgentTask = false;
      editedTask = null;
      latestResponse?.message = '';
    }
  }

  void reinitializeState(BuildContext context) {
    if (latestResponse?.message.isNotEmpty ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorConstants.kPrimaryColor,
          content: Text(latestResponse!.message),
        ));
        _setStateData();
        updateState(TasksBottomsheetState.INITIALIZED);
      });
    }
  }
}
