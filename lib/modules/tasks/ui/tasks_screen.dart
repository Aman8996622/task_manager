import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/core/constants/string_constants.dart';
import 'package:task_manager/core/style/style_constants/color_constants.dart';
import 'package:task_manager/modules/tasks/providers/tasks_list_provider.dart';
import 'package:task_manager/modules/tasks/ui/widgets/task_bottom_sheet.dart';
import 'package:task_manager/modules/tasks/ui/widgets/tasks_floating_action_button.dart';
import 'package:task_manager/modules/tasks/ui/widgets/tasks_list.dart';
import 'package:task_manager/modules/tasks/ui/widgets/tasks_screen_header.dart';

// import '../../../core/style/style_constants/color_constants.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: const TasksBottomsheet(),
        floatingActionButton: const TasksFloatingActionButton(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              buildUserInfo(),
              Consumer<TasksListProvider>(
                builder: (context, tasksListProvider, child) =>
                    buildScreenBody(tasksListProvider),
              ),
            ]),
          ),
        ));
  }

  buildUserInfo() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      height: 130,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    child: const Text(
                      StringConstants.welcomeTitle,
                      style: TextStyle(
                          color: ColorConstants.kPrimaryColor,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: const Text(
                    StringConstants.greatDay,
                    style: TextStyle(
                        color: ColorConstants.kPrimaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  buildScreenBody(TasksListProvider tasksListProvider) {
    switch (tasksListProvider.state) {
      case TasksListState.LOADING:
        tasksListProvider.initialize();
        return buildLoadingScreen();
      case TasksListState.LOADED:
        return buildTasks(tasksListProvider);
      case TasksListState.RELOADING:
        tasksListProvider.reinitialzeState(context);
        return buildTasks(tasksListProvider);
    }
  }

  buildTasks(TasksListProvider tasksListProvider) {
    return tasksListProvider.tasks.isEmpty
        ? buildEmptyTasksList(
            provider:  tasksListProvider
        )
        : Column(
            children: [
              TasksScreenHeader(
                currentFilter: tasksListProvider.currentFilter,
                tasksCount: tasksListProvider.tasks.length,
                onFilterChanged: (filter) {
                  tasksListProvider.setFilter(filter);
                },
              ),
              TasksList(tasks: tasksListProvider.tasks)
            ],
          );
  }

  buildLoadingScreen() {
    return const SizedBox(
      height: 120,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  buildEmptyTasksList({required TasksListProvider provider}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TasksScreenHeader(
          currentFilter: provider.currentFilter,
          tasksCount: provider.tasks.length,
          onFilterChanged: (filter) {
            provider.setFilter(filter);
          },
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
        ),
        SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(
              "assets/images/empty.png",
            )),
        const SizedBox(
          height: 20,
        ),
        const Text(
          StringConstants.emptyTasksLabel,
          style: TextStyle(color: ColorConstants.kPrimaryColor),
        ),
      ],
    );
  }
}
