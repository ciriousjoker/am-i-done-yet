import 'package:amidoneyet/models/todo.model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DbHelper {
  static const String nameDb = "todos.db";
  static const String nameTodos = "todos";

  late Database db;
  final DatabaseFactory dbFactory;
  late StoreRef<String, Map<String, dynamic>> store;

  bool isInitialized = false;

  DbHelper() : dbFactory = databaseFactoryIo;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    db = await dbFactory.openDatabase(join(dir.path, nameDb));
    store = StoreRef.main();
    isInitialized = true;
  }

  Stream<bool> get isEmpty => store
      .query(finder: Finder(limit: 1))
      .onSnapshots(db)
      .map((event) => event.isEmpty);

  Stream<List<TodoModel>> getStream({bool pinned = false, int? limit}) {
    return store
        .query(
          finder: Finder(
            sortOrders: [
              SortOrder(TodoModel.fields.priority, false),
              SortOrder(TodoModel.fields.timestamp, false),
            ],
            filter: Filter.equals(TodoModel.fields.pinned, pinned),
            limit: limit,
          ),
        )
        .onSnapshots(db)
        .map((event) => event.map((e) => TodoModel.fromJson(e.value)).toList());
  }

  Future<void> create(TodoModel model) async {
    assert(isInitialized);
    await store.record(model.id).put(db, model.toJson());
  }

  Future<TodoModel> read(String id) async {
    assert(isInitialized);
    final json = await _record(id).get(db);
    return TodoModel.fromJson(json!);
  }

  Future<void> update(TodoModel model) async {
    assert(isInitialized);
    await _record(model.id).update(db, model.toJson());
  }

  Future<void> delete(String id) async {
    assert(isInitialized);
    await _record(id).delete(db);
  }

  RecordRef<String, Map<String, dynamic>> _record(String id) {
    assert(isInitialized);
    return store.record(id);
  }
}

DbHelper db = DbHelper();
