import 'package:amidoneyet/widgets/add_todo_bar.widget.dart';
import 'package:amidoneyet/config/colors.config.dart';
import 'package:amidoneyet/config/general.config.dart';
import 'package:amidoneyet/helper/db.helper.dart';
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
        primaryColor: ColorsConfig.primary,
        accentColor: ColorsConfig.accent,
        primaryTextTheme: Typography.material2018().white,
        textTheme: Typography.material2018().white,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Widget _loading = DelayedDisplay(
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
        title: Center(child: Text(GeneralConfig.appname)),
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
                    child: snapshot.data
                        ? EmptyWidget()
                        : CustomScrollView(
                            slivers: <Widget>[
                              SliverToBoxAdapter(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _delay(
                                      delay: Duration(
                                        milliseconds:
                                            GeneralConfig.listStaggerDuration,
                                      ),
                                      child: ListWidget(pinned: true),
                                    ),
                                  ],
                                ),
                              ),
                              SliverStickyHeader(
                                header: _delay(
                                  delay: Duration(
                                    milliseconds:
                                        2 * GeneralConfig.listStaggerDuration,
                                  ),
                                  slidingBeginOffset: Offset(0, 2),
                                  child: DividerWidget(),
                                ),
                                sliver: SliverFillRemaining(
                                  hasScrollBody: true,
                                  child: _delay(
                                    delay: Duration(
                                      milliseconds:
                                          3 * GeneralConfig.listStaggerDuration,
                                    ),
                                    child: ListWidget(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  AddTodoBarWidget(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _delay({
    Duration delay,
    Widget child,
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
