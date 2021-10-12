import 'package:flutter/material.dart';
import 'package:to_do_list_hive/ui/widgets/tasks%20form/task_form_widget_model.dart';

class TaskFormWidget extends StatefulWidget {
  final int groupKey;
  const TaskFormWidget({Key? key, required this.groupKey}) : super(key: key);

  @override
  _TaskFormWidgetState createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  late final TaskFormWidgetModel _model;

  @override
  void initState() {
    _model = TaskFormWidgetModel(groupKey: widget.groupKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TaskFormWidgetModelProvider(
        child: const _TaskFormBody(), model: _model);
  }
}

class _TaskFormBody extends StatelessWidget {
  const _TaskFormBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _model = TaskFormWidgetModelProvider.watch(context)?.model;

    final actionButton = FloatingActionButton(
      backgroundColor: Colors.blueGrey,
      child: const Icon(Icons.done),
      onPressed: () => _model?.saveTask(context),
    );
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new task'),
        centerTitle: true,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _FormWidget(),
        ),
      ),
      floatingActionButton: _model?.isValid == true ? actionButton : null,
    );
  }
}

class _FormWidget extends StatelessWidget {
  const _FormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _taskFormModel = TaskFormWidgetModelProvider.read(context)?.model;
    return TextField(
      minLines: null,
      maxLines: null,
      expands: true,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Enter new task',
      ),
      autofocus: true,
      onEditingComplete: () => _taskFormModel?.saveTask(context),
      onChanged: (value) => _taskFormModel?.taskText = value,
    );
  }
}
