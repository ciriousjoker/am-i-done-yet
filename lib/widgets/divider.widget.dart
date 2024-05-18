import 'package:amidoneyet/config/colors.config.dart';
import 'package:amidoneyet/config/general.config.dart';
import 'package:amidoneyet/helper/db.helper.dart';
import 'package:amidoneyet/helper/ui.helper.dart';
import 'package:amidoneyet/models/todo.model.dart';
import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TodoModel>>(
      stream: db.getStream(pinned: true, limit: 1),
      builder: (context, snapPinned) {
        return StreamBuilder<List<TodoModel>>(
          stream: db.getStream(limit: 1),
          builder: (context, snapNormal) {
            if (!snapPinned.hasData || !snapPinned.hasData) {
              return const SizedBox.shrink();
            }
            if (snapPinned.data!.isEmpty || snapNormal.data!.isEmpty) {
              return const SizedBox.shrink();
            }

            return Container(
              height: GeneralConfig.dividerHeight,
              color: ColorsConfig.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: UIHelper.VerticalSpaceMedium,
              ),
              child: const Divider(color: ColorsConfig.accent),
            );
          },
        );
      },
    );
  }
}
