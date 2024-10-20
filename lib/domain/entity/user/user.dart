class User {
  String userId;

  String email;

  String createdAt;

  String? updatedAt;

  User(
      {this.userId = '', this.email = '', this.createdAt = '', this.updatedAt});

  factory User.fromMap(Map<String, dynamic> json) => User(
      userId: json["userId"] as String,
      email: json["email"] as String,
      createdAt: json["createdAt"] as String,
      updatedAt: json["updatedAt"] as String);

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'email': email,
        'createdAt': createdAt,
        'updatedAt': updatedAt
      };
}
