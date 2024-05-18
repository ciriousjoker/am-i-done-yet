import 'dart:math';

import 'package:amidoneyet/config/colors.config.dart';
import 'package:amidoneyet/config/general.config.dart';
import 'package:amidoneyet/helper/ui.helper.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = ColorsConfig.text.withOpacity(0.3);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DelayedDisplay(
      delay: GeneralConfig.emptyAnimationDelay,
      slidingCurve: Curves.easeOutCubic,
      slidingBeginOffset: const Offset(0, 0.02),
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: max(
              384,
              MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "How to use:",
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 32,
                  color: color,
                ),
              ),
              UIHelper.verticalSpaceLarge(),
              MarkdownBody(
                data: """
- Add a new item *(pinned)*
- Swipe to set priority *(unpins it)*
- Long press to delete
""",
                styleSheet: MarkdownStyleSheet(
                  p: textTheme.bodyMedium?.copyWith(
                    fontSize: 24,
                    color: color,
                  ),
                  em: textTheme.bodyMedium?.copyWith(
                    fontSize: 24,
                    color: color.withOpacity(0.2),
                  ),
                  listBullet: TextStyle(
                    fontSize: 24,
                    color: color,
                  ),
                ),
              ),
              UIHelper.verticalSpaceLarge(),
              UIHelper.verticalSpaceLarge(),
              UIHelper.verticalSpaceLarge(),
              Text(
                "Have fun!",
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color.withOpacity(0.4),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
