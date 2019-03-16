import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_ui/flutter_firebase_ui.dart';

var db = Firestore.instance.collection("todos");

void main() => runApp(App());

class App extends StatefulWidget {
	App({Key k}) : super(key: k);

	_AppState createState() => _AppState();
}

class _AppState extends State<App> {
	final FirebaseAuth _auth = FirebaseAuth.instance;
	StreamSubscription<FirebaseUser> _listen;
	FirebaseUser _user;
	bool _loggedIn = false, _loaded = false;

	@override
	void initState() {
		super.initState();
		_loadUser();
	}

	@override
	void dispose() {
		_listen?.cancel();
		super.dispose();
	}

	void _loadUser() async {
		_user = await _auth.currentUser();
		_user?.getIdToken(refresh: true);

		_listen = _auth.onAuthStateChanged.listen((u) => setState(() => {_loggedIn = true, _user = u}));
	}

	@override
	Widget build(var ctx) {
		return MaterialApp(
			theme: ThemeData(
				primaryColor: Color.fromRGBO(58, 67, 86, 1),
				accentColor: Colors.green
			),
			home: (() {
				if (!_loggedIn) return Image.asset("img/splash.png", fit: BoxFit.cover);

				if (_user == null) return Container(child: SignInScreen(title: 'Login', providers: [ProvidersTypes.google]));

				final TextEditingController _controller = TextEditingController();

				return Scaffold(
					backgroundColor: Color.fromRGBO(58, 67, 86, 1),
					appBar: AppBar(
						elevation: 0,
						title: Center(child: Text("Am I Done Yet")),
					),
					body: StreamBuilder(
						stream: db.where('uid', isEqualTo: _user.uid).snapshots(),
						builder: (context, snapshot) {
							_loaded = snapshot.hasData;

							return Column(children: [
								!_loaded
										? Container(
												child: CircularProgressIndicator(),
												height: 48,
												width: 48,
												margin: EdgeInsets.all(16))
										: Expanded(child: getListView(getTodos(snapshot.data.documents))),
								!_loaded ? Spacer() : Container(),
								Container(
									padding: EdgeInsets.all(14),
									margin: EdgeInsets.all(14),
									decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(99)), color: Colors.white),
									child: TextField(
										controller: _controller,
                    decoration: new InputDecoration.collapsed(hintText: 'Enter New Item'),
										onSubmitted: (txt) {
											_controller.clear();
											var ref = db.document();

											ref.setData({'id': ref.documentID, 'title': txt, 'percent': 0.0, 'uid': _user.uid});
										},
									),
								)
							]);
						},
					),
				);
			})(),
		);
	}

	ListView getListView(todos) {
		return ListView.builder(
			shrinkWrap: true,
			key: newKey(),
			itemCount: todos.length,
			itemBuilder: (var ctx, int i) => Todo(todo: todos[i].data),
		);
	}

	List<DocumentSnapshot> getTodos(List<DocumentSnapshot> docs) {
		List<DocumentSnapshot> retList = List(), done = List();

		for (var doc in docs) {
			if (doc.data["percent"] < 1) {
				retList.add(doc);
			} else {
				done.add(doc);
			}
		}

		retList.sort((a, b) => b.data['percent'].compareTo(a.data['percent']));

		retList.addAll(done);

		return retList;
	}

	newKey() => Key((Random.secure()).nextDouble().toString());
}

class Todo extends StatefulWidget {
	final Map todo;

	Todo({Key k, this.todo}) : super(key: k);

	_TodoState createState() => _TodoState(todo: todo);
}

class _TodoState extends State<Todo> {
	Map todo;
	double percent;

	_TodoState({this.todo}) {
		percent = todo["percent"];
	}

	@override
	Widget build(var context) {
		return Container(
			height: 56,
			margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
			child: ClipRRect(
				borderRadius: BorderRadius.all(Radius.circular(4)),
				child: LayoutBuilder(builder: (ct, c) {
					return Stack(children: [
						LinearPercentIndicator(
							width: c.maxWidth,
							linearStrokeCap: LinearStrokeCap.butt,
							padding: EdgeInsets.all(0),
							lineHeight: c.maxHeight,
							percent: percent,
							backgroundColor: Color.fromRGBO(68, 79, 99, 0.9),
							progressColor: Color.fromRGBO(76, 175, 80, 0.9),
						),
						ListTile(
							title: Text(
								todo["title"],
								style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
								overflow: TextOverflow.ellipsis,
							),
						),
						GestureDetector(
							onHorizontalDragUpdate: (d) {
								setState(() {
									percent += d.delta.dx / c.maxWidth;
									if (percent > 1) percent = 1;
									if (percent < 0) percent = 0;
								});
							},
							onHorizontalDragEnd: (d) => db.document(todo["id"]).updateData({'percent': percent}),
							onLongPress: () => db.document(todo["id"]).delete()
						)
					]);
				}),
			),
		);
	}
}
