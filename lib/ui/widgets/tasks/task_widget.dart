import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_list_hive/ui/widgets/tasks/task_widget_model.dart';

class TaskWidgetConfig {
  final String title;
  final int groupKey;
  TaskWidgetConfig({required this.title, required this.groupKey});
}

class TasksWidget extends StatefulWidget {
  final TaskWidgetConfig configuration;
  const TasksWidget({Key? key, required this.configuration}) : super(key: key);

  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  late final TasksWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TasksWidgetModel(configuration: widget.configuration);
  }

  @override
  Widget build(BuildContext context) {
    return TasksWidgetModelProvider(
      model: _model,
      child: const TasksWidgetBody(),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await _model.dispose();
  }
}

class TasksWidgetBody extends StatelessWidget {
  const TasksWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final modelWatch = TasksWidgetModelProvider.watch(context)?.model;
    final modelRead = TasksWidgetModelProvider.read(context)?.model;

    return Scaffold(
      appBar: AppBar(
        title: Text(modelWatch?.configuration.title ?? 'Задачи'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add_task),
        onPressed: () => modelRead?.showForm(context),
      ),
      body: const SafeArea(
        child: _TaskList(),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupsLength =
        TasksWidgetModelProvider.watch(context)?.model.tasks.length ?? 0;

    return ListView.separated(
      itemCount: groupsLength,
      itemBuilder: (BuildContext context, int index) {
        return _TaskListWidget(indexInList: index);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: 1,
        );
      },
    );
  }
}

class _TaskListWidget extends StatelessWidget {
  final int indexInList;

  const _TaskListWidget({Key? key, required this.indexInList})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.read(context)?.model;
    final task = model!.tasks[indexInList];
    final icon = task.isDone ? Icons.done : null;
    final style = task.isDone
        ? const TextStyle(decoration: TextDecoration.lineThrough)
        : null;
    return Slidable(
      key: ValueKey(task),
      actionPane: const SlidableBehindActionPane(),
      dismissal: SlidableDismissal(
        child: const SlidableDrawerDismissal(),
        onDismissed: (actionType) {
          model.removeTask(indexInList);
        },
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => model.removeTask(indexInList),
        ),
      ],
      child: ColoredBox(
        color: Colors.white,
        child: ListTile(
          title: Text(task.text, style: style),
          trailing: Icon(icon),
          onTap: () => model.toggleDone(indexInList),
        ),
      ),
    );
  }
}
