// ignore_for_file: avoid_field_initializers_in_const_classes

class TodoModel {
  static const TodoModelFields fields = TodoModelFields();

  final String id;
  final String title;
  final double priority;
  final bool pinned;

  /// Currently unused, but might be at some point
  final DateTime timestamp;

  const TodoModel({
    required this.id,
    required this.title,
    required this.priority,
    required this.pinned,
    required this.timestamp,
  });

  TodoModel.fromJson(Map<String, dynamic> json)
      : id = json[fields.id] as String,
        title = json[fields.title] as String,
        priority = json[fields.priority] as double,
        pinned = json[fields.pinned] as bool,
        timestamp =
            DateTime.fromMillisecondsSinceEpoch(json[fields.timestamp] as int);

  Map<String, dynamic> toJson() => {
        fields.id: id,
        fields.title: title,
        fields.priority: priority,
        fields.pinned: pinned,
        fields.timestamp: timestamp.millisecondsSinceEpoch,
      };
}

class TodoModelFields {
  final String id = "id";
  final String title = "title";
  final String priority = "priority";
  final String pinned = "pinned";
  final String timestamp = "timestamp";

  const TodoModelFields();
}
