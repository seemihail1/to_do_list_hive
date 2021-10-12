import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list_hive/domain/data_provider/hive_box_manager.dart';
import 'package:to_do_list_hive/domain/entity/group.dart';
import 'package:to_do_list_hive/ui/navigation/main_navigation.dart';
import 'package:to_do_list_hive/ui/widgets/tasks/task_widget.dart';

class GroupsWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _box;
  var _groups = <Group>[];
  ValueListenable<Object>? _listenableBox;
  List<Group> get groups => _groups.toList();
  GroupsWidgetModel() {
    _setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigetionRoutesNames.groupsForm);
  }

  Future<void> _readGroups() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openGroupBox();
    await _readGroups();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readGroups);
  }

  Future<void> removeGroup(int index) async {
    final box = await _box;
    final groupKey = (await _box).keyAt(index) as int;
    final taskBoxName = BoxManager.instance.makeTaskBoxName(groupKey);
    await Hive.deleteBoxFromDisk('tasks_box_$taskBoxName');
    box.deleteAt(index);
  }

  Future<void> openTaskScreen(BuildContext context, int index) async {
    final group = (await _box).getAt(index);
    if (group != null) {
      final configuration = TaskWidgetConfig(
        title: group.name,
        groupKey: group.key as int,
      );

      Navigator.of(context)
          .pushNamed(MainNavigetionRoutesNames.tasks, arguments: configuration);
    }
  }

  @override
  Future<void> dispose() async {
    await BoxManager.instance.closeBox(await _box);
    _listenableBox?.removeListener(_readGroups);
    super.dispose();
  }
}

class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;
  const GroupsWidgetModelProvider(
      {Key? key, required Widget child, required this.model})
      : super(key: key, child: child, notifier: model);

  static GroupsWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
  }

  static GroupsWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupsWidgetModelProvider>()
        ?.widget;
    return widget is GroupsWidgetModelProvider ? widget : null;
  }
}
