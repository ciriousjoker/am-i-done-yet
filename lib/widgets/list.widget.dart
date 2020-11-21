import 'package:amidoneyet/config/general.config.dart';
import 'package:amidoneyet/helper/db.helper.dart';
import 'package:amidoneyet/models/todo.model.dart';
import 'package:amidoneyet/widgets/todo.widget.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';

class ListWidget extends StatefulWidget {
  ListWidget({
    Key key,
    this.pinned = false,
    this.hasStickyHeader = false,
  }) : super(key: key);

  final bool pinned;
  final bool hasStickyHeader;

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TodoModel>>(
      stream: db.getStream(pinned: widget.pinned),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox.shrink();
        List<TodoModel> items = snapshot.data;

        return ImplicitlyAnimatedReorderableList<TodoModel>(
          header: widget.hasStickyHeader
              ? Container(height: GeneralConfig.dividerHeight)
              : null,
          items: items,
          shrinkWrap: true,
          areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
          onReorderFinished: (item, from, to, newItems) {
            if (!mounted) return;
            setState(() {
              items
                ..clear()
                ..addAll(newItems);
            });
          },
          updateItemBuilder: _onItemCallback,
          removeItemBuilder: _onItemCallback,
          itemBuilder: _onItemCallback,
        );
      },
    );
  }

  Reorderable _onItemCallback(
    BuildContext context,
    Animation<double> animation,
    TodoModel item, [
    int index,
  ]) {
    return Reorderable(
      key: ValueKey(item),
      builder: (context, dragAnimation, inDrag) {
        return SizeFadeTransition(
          sizeFraction: 0.7,
          curve: Curves.easeInOut,
          animation: animation,
          child: TodoWidget(todo: item),
        );
      },
    );
  }
}
