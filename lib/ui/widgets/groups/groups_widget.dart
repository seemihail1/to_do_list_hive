import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_list_hive/ui/widgets/groups/groups_widget_model.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({Key? key}) : super(key: key);

  @override
  State<GroupsWidget> createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  final _model = GroupsWidgetModel();

  @override
  Widget build(BuildContext context) {
    return GroupsWidgetModelProvider(
      child: const _GroupsBody(),
      model: _model,
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await _model.dispose();
  }
}

class _GroupsBody extends StatelessWidget {
  const _GroupsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: GroupsList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add),
        onPressed: () =>
            GroupsWidgetModelProvider.read(context)?.model.showForm(context),
      ),
    );
  }
}

class GroupsList extends StatelessWidget {
  const GroupsList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final groupsLength =
        GroupsWidgetModelProvider.watch(context)?.model.groups.length ?? 0;

    return ListView.separated(
      itemCount: groupsLength,
      itemBuilder: (BuildContext context, int index) {
        return _GroupListWidget(indexInList: index);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: 1,
        );
      },
    );
  }
}

class _GroupListWidget extends StatelessWidget {
  final int indexInList;

  const _GroupListWidget({Key? key, required this.indexInList})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = GroupsWidgetModelProvider.read(context)?.model;
    final group = model!.groups[indexInList];
    return SizedBox(
      height: 70,
      width: double.infinity,
      child: Slidable(
        key: ValueKey(group),
        actionPane: const SlidableBehindActionPane(),
        dismissal: SlidableDismissal(
          child: const SlidableDrawerDismissal(),
          onDismissed: (actionType) {
            model.removeGroup(indexInList);
          },
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => model.removeGroup(indexInList),
          ),
        ],
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(
              color: Colors.white,
              child: ListTile(
                title: Text(group.name),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => model.openTaskScreen(context, indexInList),
              ),
            )
          ],
        ),
      ),
    );
  }
}
