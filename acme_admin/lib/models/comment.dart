class Comment {
  Comment({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.description,
    required this.ticketId,
    this.customerId,
    this.agentId,
  });

  final String id, title, description, ticketId;
  final String? customerId, agentId;

  final DateTime createdAt;

  Comment.fromMap({
    required Map<String, dynamic> map,
  })  : id = map['id'],
        agentId = map['agent_id'],
        ticketId = map['ticket_id'],
        customerId = map['customer_id'],
        title = map['title'],
        description = map['descriptionl'],
        createdAt = DateTime.parse(map['created_at']);
}
