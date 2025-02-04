
import 'package:flutter/material.dart';
import 'package:task_manager/core/style/style_constants/color_constants.dart';
import 'package:task_manager/data/local_storage.dart';
import 'package:task_manager/models/response.dart';
import 'package:task_manager/models/task.dart';

// ignore: constant_identifier_names
enum TasksListState { LOADING, RELOADING, LOADED }

class TasksListProvider extends ChangeNotifier {
  // Make singleton
  TasksListProvider._privateConstructor();
  static final TasksListProvider _instance =
      TasksListProvider._privateConstructor();
  factory TasksListProvider() {
    return _instance;
  }

  TasksListState state = TasksListState.LOADING;
  List<Task> _tasks = [];
  late Response latestResponse;

  // Add a variable to track the current filter
  String currentFilter = 'All';

  // Getter for tasks that applies the current filter
  List<Task> get tasks {
    switch (currentFilter) {
      case 'Completed':
        return _tasks.where((task) => task.status == "Completed").toList();
      case 'Pending':
        return _tasks.where((task) => task.status == "Pending").toList();
      default:
        return _tasks;
    }
  }

  // Method to update the filter
  void setFilter(String filter) {
    currentFilter = filter;
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  initialize() async {
    latestResponse = await LocalStorage.init();
    if (latestResponse.isOperationSuccessful) {
      getTasks();
    } else {
      updateState(TasksListState.LOADED);
    }
  }

  deleteTask(Task task) async {
    latestResponse = await LocalStorage.deleteTask(task);
    if (latestResponse.isOperationSuccessful) {
      updateState(TasksListState.RELOADING);
    } else {
      updateState(TasksListState.LOADED);
    }
  }

  updateState(TasksListState state) {
    this.state = state;
    notifyListeners();
  }

  reinitialzeState(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (latestResponse.message.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorConstants.kPrimaryColor,
          content: Text(latestResponse.message),
        ));
        latestResponse.message = '';
      }
      getTasks();
    });
  }

  getTasks() {
    latestResponse = LocalStorage.getTasks();
    if (latestResponse.isOperationSuccessful) {
      _tasks = latestResponse.data;
      updateState(TasksListState.LOADED);
    } else {
      updateState(TasksListState.LOADED);
    }
  }
}
