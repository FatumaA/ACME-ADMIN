class Customer {
  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.password,
    required this.agentId,
  });

  final String id;
  final String name;
  final String email;
  final String password;
  final String agentId;
  final DateTime createdAt;

  Customer.fromMap({
    required Map<String, dynamic> map,
  })  : id = map['id'],
        agentId = map['agent_id'],
        name = map['name'],
        email = map['email'],
        password = map['passowrd'],
        createdAt = DateTime.parse(map['created_at']);
}
