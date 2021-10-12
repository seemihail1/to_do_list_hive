import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list_hive/domain/data_provider/hive_box_manager.dart';
import 'package:to_do_list_hive/domain/entity/task.dart';
import 'package:to_do_list_hive/ui/navigation/main_navigation.dart';
import 'package:to_do_list_hive/ui/widgets/tasks/task_widget.dart';

class TasksWidgetModel extends ChangeNotifier {
  final TaskWidgetConfig configuration;
  ValueListenable<Object>? _listenableBox;
  late final Future<Box<Task>> _box;

  var _tasks = <Task>[];

  List<Task> get tasks => _tasks.toList();

  TasksWidgetModel({required this.configuration}) {
    _setup();
  }

  Future<void> _readTasks() async {
    _tasks = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openTasksBox(configuration.groupKey);
    await _readTasks();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(() {
      _readTasks();
    });
  }

  Future<void> removeTask(int index) async {
    final box = await _box;
    await box.deleteAt(index);
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigetionRoutesNames.tasksForm,
        arguments: configuration.groupKey);
  }

  Future<void> toggleDone(int index) async {
    final task = (await _box).getAt(index);
    task?.isDone = !task.isDone;
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    await BoxManager.instance.closeBox(await _box);
    _listenableBox?.removeListener(() {
      _readTasks();
    });
    super.dispose();
  }
}

class TasksWidgetModelProvider extends InheritedNotifier {
  final TasksWidgetModel model;
  const TasksWidgetModelProvider(
      {Key? key, required Widget child, required this.model})
      : super(key: key, child: child, notifier: model);

  static TasksWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TasksWidgetModelProvider>();
  }

  static TasksWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TasksWidgetModelProvider>()
        ?.widget;
    return widget is TasksWidgetModelProvider ? widget : null;
  }
}
