import 'package:amidoneyet/models/todo.model.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DbHelper {
  static const String NAME_DB = "todos.db";
  static const String NAME_TODOS = "todos";

  Database db;
  DatabaseFactory dbFactory;
  StoreRef<String, Map<String, dynamic>> store;

  bool isInitialized = false;

  DbHelper() {
    dbFactory = databaseFactoryIo;
  }

  Future<void> init() async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    db = await dbFactory.openDatabase(join(dir.path, NAME_DB));
    store = StoreRef.main();
    isInitialized = true;
  }

  Stream<bool> get isEmpty => store
      .query(finder: Finder(limit: 1))
      .onSnapshots(db)
      .map((event) => event?.isEmpty ?? true);

  Stream<List<TodoModel>> getStream({pinned = false, int limit}) {
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
    return TodoModel.fromJson(await _record(id).get(db));
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
