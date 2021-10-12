import 'package:flutter/material.dart';
import 'package:to_do_list_hive/ui/widgets/group%20form/group_form_widget.dart';
import 'package:to_do_list_hive/ui/widgets/groups/groups_widget.dart';
import 'package:to_do_list_hive/ui/widgets/tasks%20form/task_form_widget.dart';
import 'package:to_do_list_hive/ui/widgets/tasks/task_widget.dart';

abstract class MainNavigetionRoutesNames {
  static const groups = '/';
  static const groupsForm = '/form';
  static const tasks = '/task';
  static const tasksForm = '/task/form';
}

class MainNavigation {
  final initialRoute = MainNavigetionRoutesNames.groups;
  final routes = <String, Widget Function(BuildContext context)>{
    MainNavigetionRoutesNames.groups: (context) => const GroupsWidget(),
    MainNavigetionRoutesNames.groupsForm: (context) => const GroupFormWidget(),
  };

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigetionRoutesNames.tasks:
        final configuration = settings.arguments as TaskWidgetConfig; 
        return MaterialPageRoute(
            builder: (context) => TasksWidget(configuration: configuration));
      case MainNavigetionRoutesNames.tasksForm:
        final groupKey = settings.arguments as int;
        return MaterialPageRoute(
            builder: (context) => TaskFormWidget(groupKey: groupKey));
      default:
        {
          const errorScreen = Text('Navigation error!');
          return MaterialPageRoute(builder: (context) => errorScreen);
        }
    }
  }
}
