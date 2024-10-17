class Todo {
  String? id;
  String? todoName;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isCompleted;
  SyncStatus? syncStatus;

  Todo(
      {this.id,
      this.todoName,
      this.isCompleted,
      this.createdAt,
      this.updatedAt,
      this.syncStatus});

  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
      id: json["id"],
      todoName: json["todoName"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ''),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ''),
      isCompleted: json["isCompleted"],
      syncStatus: _parseSyncStatus(json["syncStatus"] as String?));

  Map<String, dynamic> toMap() => {
        "id": id,
        "todoName": todoName,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "isCompleted": isCompleted,
        "syncStatus" : syncStatus?.name
      };

  static SyncStatus? _parseSyncStatus(String? status) {
    if (status == null) return null;

    switch (status) {
      case 'pending':
        return SyncStatus.pending;
      case 'syncronized':
        return SyncStatus.syncronized;
      case 'failed':
        return SyncStatus.failed;
      default:
        return null;
    }
  }
}

enum SyncStatus { pending, syncronized, failed }
