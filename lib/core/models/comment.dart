class Comment {
  Comment({
    required this.node,
  });

  Node node;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        node: Node.fromJson(json["node"]),
      );

  Map<String, dynamic> toJson() => {
        "node": node.toJson(),
      };
}

class Node {
  Node({
    required this.commentsText,
    required this.inserted,
    required this.userId,
    required this.user,
  });

  String commentsText;
  DateTime inserted;
  int userId;
  User user;

  factory Node.fromJson(Map<String, dynamic> json) => Node(
        commentsText: json["commentsText"],
        inserted: DateTime.parse(json["inserted"]),
        userId: json["userId"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "commentsText": commentsText,
        "inserted": inserted.toIso8601String(),
        "userId": userId,
        "user": user.toJson(),
      };
}

class User {
  User({
  required  this.userName,
  required  this.email,
  });

  String userName;
  String email;

  factory User.fromJson(Map<String, dynamic> json) => User(
        userName: json["userName"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "email": email,
      };
}
