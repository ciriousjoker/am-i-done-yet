import 'package:amidoneyet/config/colors.config.dart';
import 'package:amidoneyet/config/general.config.dart';
import 'package:amidoneyet/helper/db.helper.dart';
import 'package:amidoneyet/helper/ui.helper.dart';
import 'package:amidoneyet/models/todo.model.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddTodoBarWidget extends StatefulWidget {
  const AddTodoBarWidget({super.key});

  @override
  _AddTodoBarWidgetState createState() => _AddTodoBarWidgetState();
}

class _AddTodoBarWidgetState extends State<AddTodoBarWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controllerText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
      delay: GeneralConfig.addTodoAnimationDelay,
      slidingBeginOffset: const Offset(0, 1),
      slidingCurve: Curves.easeOutBack,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: UIHelper.HorizontalSpaceMedium,
          vertical: UIHelper.VerticalSpaceMedium,
        ),
        child: TextField(
          controller: _controllerText,
          cursorColor: ColorsConfig.primary,
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            hintText: "Enter New Item",
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: UIHelper.HorizontalSpaceMedium,
            ),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(99),
              borderSide: BorderSide.none,
            ),
          ),
          onSubmitted: (title) {
            _controllerText.clear();
            _addTodo(title);
          },
        ),
      ),
    );
  }

  void _addTodo(String name) {
    if (name.isEmpty) return;
    db.create(
      TodoModel(
        id: const Uuid().v4(),
        title: name,
        priority: 0.5,
        pinned: true,
        timestamp: DateTime.now(),
      ),
    );
  }
}
