import 'package:flutter/material.dart';

class Task {
  String title;
  bool isDone;
  Task(this.title, {this.isDone = false});
}

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final List<Task> _tasks = [
    Task("Clean Archtecture"),
    Task("Flutter Widget Catelog"),
    Task("Problem Solving"),
    Task("Read Book"),
  ];

  Task? _recentlyDeleted;
  int? _recentlyDeletedIndex;

  Future<bool> _confirmDismiss(BuildContext context, String task) async {
    return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Confirm Delete"),
            content: Text("Are you sure you want to delete \"$task\"?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text("Delete"),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _deleteTask(int index) {
    setState(() {
      _recentlyDeleted = _tasks[index];
      _recentlyDeletedIndex = index;
      _tasks.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Deleted: ${_recentlyDeleted?.title}"),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () {
            if (_recentlyDeleted != null && _recentlyDeletedIndex != null) {
              setState(() {
                _tasks.insert(_recentlyDeletedIndex!, _recentlyDeleted!);
              });
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
        centerTitle: true,
      ),
      body: ReorderableListView.builder(
        itemCount: _tasks.length,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex -= 1;
            final item = _tasks.removeAt(oldIndex);
            _tasks.insert(newIndex, item);
          });
        },
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Dismissible(
            key: ValueKey(task),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) => _confirmDismiss(context, task.title),
            onDismissed: (direction) => _deleteTask(index),
            background: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              key: ValueKey("card_$index"),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle),
                ),
                trailing: Checkbox(
                  value: task.isDone,
                  onChanged: (val) {
                    setState(() {
                      task.isDone = val ?? false;
                    });
                  },
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: task.isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
