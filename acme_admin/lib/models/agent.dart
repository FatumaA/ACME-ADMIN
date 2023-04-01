class Agent {
  Agent({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.password,
    required this.isAdmin,
  });

  final String id;
  final String name;
  final String email;
  final String password;
  final bool isAdmin;
  final DateTime createdAt;

  Agent.fromMap({
    required Map<String, dynamic> map,
  })  : id = map['id'],
        name = map['name'],
        email = map['email'],
        password = map['passowrd'],
        createdAt = DateTime.parse(map['created_at']),
        isAdmin = map['is_admin'];
}
