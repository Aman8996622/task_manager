import 'package:flutter/material.dart';

class TasksScreenHeader extends StatelessWidget {
  final int tasksCount;
  final Function(String) onFilterChanged;
  final String currentFilter;

  const TasksScreenHeader({
    super.key,
    required this.tasksCount,
    required this.onFilterChanged,
    required this.currentFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$tasksCount Tasks',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              // color: ColorCons,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  6,
                ),
              ),
            ),
            child: DropdownButton<String>(
              value: currentFilter,
              icon: const Icon(Icons.filter_list),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onFilterChanged(newValue);
                }
              },
              items: <String>['All', 'Completed', 'Pending']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
