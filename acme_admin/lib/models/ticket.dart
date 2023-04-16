enum Status {
  open,
  inProgress,
  resolved,
  closed,
  reOpened,
  blocked,
}

class Ticket {
  Ticket({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.description,
    required this.status,
    required this.attachments,
    required this.customerId,
    required this.agentId,
  });

  final String id, title, description, customerId, agentId;
  final List<String> attachments;
  final Status status;

  final DateTime createdAt;

  Ticket.fromMap({
    required Map<String, dynamic> map,
  })  : id = map['id'],
        agentId = map['agent_id'],
        customerId = map['customer_id'],
        title = map['title'],
        description = map['description'],
        status = map['status'],
        attachments = map['attachments'],
        createdAt = DateTime.parse(map['created_at']);
}
