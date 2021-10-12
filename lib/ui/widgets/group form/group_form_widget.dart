import 'package:flutter/material.dart';
import 'package:to_do_list_hive/ui/widgets/group%20form/group_form_widget_model.dart';

class GroupFormWidget extends StatefulWidget {
  const GroupFormWidget({Key? key}) : super(key: key);

  @override
  State<GroupFormWidget> createState() => _GroupFormWidgetState();
}

class _GroupFormWidgetState extends State<GroupFormWidget> {
  final _model = GroupFormWidgetModel();
  @override
  Widget build(BuildContext context) {
    return GroupFormWidgetModelProvider(
      child: const _GroupFormBody(),
      model: _model,
    );
  }
}

class _GroupFormBody extends StatelessWidget {
  const _GroupFormBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New group'),
        centerTitle: true,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _FormWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.done),
        backgroundColor: Colors.blueGrey,
        onPressed: () =>
            GroupFormWidgetModelProvider.read(context)?.model.saveGroup(context),
      ),
    );
  }
}

class _FormWidget extends StatelessWidget {
  const _FormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formModel = GroupFormWidgetModelProvider.watch(context)?.model;
    return TextField(
      autofocus: true,
      decoration:  InputDecoration(
        border: const OutlineInputBorder(),
        hintText: 'Enter group name',
        errorText: _formModel?.errorText,
      ),
      onEditingComplete: () => _formModel?.saveGroup(context),
      onChanged: (value) => _formModel?.groupName = value,
    );
  }
}
