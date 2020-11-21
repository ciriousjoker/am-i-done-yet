class TodoModel {
  static const TodoModelFields fields = TodoModelFields();

  final String id;
  final String title;
  final double priority;
  final bool pinned;

  /// Currently unused, but might be at some point
  final DateTime timestamp;

  const TodoModel({
    this.id,
    this.title,
    this.priority,
    this.pinned,
    this.timestamp,
  });

  TodoModel.fromJson(Map<String, dynamic> json)
      : id = json[fields.id],
        title = json[fields.title],
        priority = json[fields.priority],
        pinned = json[fields.pinned],
        timestamp = DateTime.fromMillisecondsSinceEpoch(json[fields.timestamp]);

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
