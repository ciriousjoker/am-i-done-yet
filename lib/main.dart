import 'package:amidoneyet/config/colors.config.dart';
import 'package:amidoneyet/config/general.config.dart';
import 'package:amidoneyet/helper/db.helper.dart';
import 'package:amidoneyet/widgets/add_todo_bar.widget.dart';
import 'package:amidoneyet/widgets/divider.widget.dart';
import 'package:amidoneyet/widgets/empty.widget.dart';
import 'package:amidoneyet/widgets/list.widget.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: GeneralConfig.appname,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: ColorsConfig.primary,
          secondary: ColorsConfig.accent,
          surface: ColorsConfig.primary,
          surfaceContainer: ColorsConfig.primary,
          surfaceTint: ColorsConfig.primary,
          onSurface: Colors.white,
        ),
        primaryTextTheme: Typography.material2018().white,
        textTheme: Typography.material2018().white,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Widget _loading = const DelayedDisplay(
    delay: Duration(seconds: 1),
    child: Center(child: CircularProgressIndicator()),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Center(child: Text(GeneralConfig.appname)),
      ),
      backgroundColor: ColorsConfig.primary,
      body: FutureBuilder(
        future: db.init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return _loading;

          return StreamBuilder<bool>(
            stream: db.isEmpty,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return _loading;

              return Column(
                children: [
                  Expanded(
                    child: snapshot.data!
                        ? const EmptyWidget()
                        : CustomScrollView(
                            slivers: <Widget>[
                              SliverToBoxAdapter(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _delay(
                                      delay: const Duration(
                                        milliseconds:
                                            GeneralConfig.listStaggerDuration,
                                      ),
                                      child: const ListWidget(pinned: true),
                                    ),
                                  ],
                                ),
                              ),
                              SliverStickyHeader(
                                header: _delay(
                                  delay: const Duration(
                                    milliseconds:
                                        2 * GeneralConfig.listStaggerDuration,
                                  ),
                                  slidingBeginOffset: const Offset(0, 2),
                                  child: const DividerWidget(),
                                ),
                                sliver: SliverFillRemaining(
                                  child: _delay(
                                    delay: const Duration(
                                      milliseconds:
                                          3 * GeneralConfig.listStaggerDuration,
                                    ),
                                    child: const ListWidget(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  const AddTodoBarWidget(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _delay({
    required Duration delay,
    required Widget child,
    Offset slidingBeginOffset = const Offset(0, 0.1),
  }) {
    return DelayedDisplay(
      delay: delay,
      slidingCurve: Curves.easeOutCubic,
      slidingBeginOffset: slidingBeginOffset,
      child: child,
    );
  }
}
