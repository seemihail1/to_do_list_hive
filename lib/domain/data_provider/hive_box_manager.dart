import 'package:hive/hive.dart';
import 'package:to_do_list_hive/domain/entity/group.dart';
import 'package:to_do_list_hive/domain/entity/task.dart';

class BoxManager {
  static final BoxManager instance = BoxManager._();
  final Map<String, int> _boxCounter = <String, int>{};
  BoxManager._();

  Future<Box<T>> _openBox<T>(
      int typeId, String name, TypeAdapter<T> adapter) async {
    if (Hive.isBoxOpen(name)) {
      final count = _boxCounter[name] ?? 1;
      _boxCounter[name] = count + 1;
      return Hive.box(name);
    } else {
      _boxCounter[name] = 1;
      if (!Hive.isAdapterRegistered(typeId)) {
        Hive.registerAdapter(adapter);
      }
      return await Hive.openBox<T>(name);
    }
  }

  Future<Box<Group>> openGroupBox() async {
    return _openBox(0, 'groups_box', GroupAdapter());
  }

  Future<Box<Task>> openTasksBox(int groupKey) async {
    return _openBox(1, 'tasks_box_$groupKey', TaskAdapter());
  }

  String makeTaskBoxName(int groupKey) {
    return 'tasks_box_$groupKey';
  }

  Future<void> closeBox<T>(Box<T> box) async {
    if (!box.isOpen) {
      _boxCounter.remove(box.name);
      return;
    }

    var count = _boxCounter[box.name] ?? 1;
    count-=1;
    _boxCounter[box.name] = count;

    if (count > 0) return;

    await box.compact();
    await box.close();
  }
}
