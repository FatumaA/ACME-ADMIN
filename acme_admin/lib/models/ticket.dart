// enum Status {
//   open,
//   inProgress,
//   resolved,
//   closed,
//   reOpened,
//   blocked,
// }

class Ticket {
  Ticket({
    required this.id,
    required this.createdAt,
    required this.ticketNo,
    required this.title,
    required this.description,
    required this.status,
    required this.attachments,
    required this.customerId,
    required this.agentId,
  });

  final String id, title, description, customerId, agentId, status;
  final int ticketNo;
  final List<String> attachments;
  // final Status status;

  final DateTime createdAt;

  Ticket.fromMap({
    required Map<String, dynamic> map,
  })  : id = map['id'],
        ticketNo = map['ticket_no'],
        agentId = map['agent_id'],
        customerId = map['customer_id'],
        title = map['title'],
        description = map['description'],
        status = map['status'],
        attachments = (map['attachments']).cast<String>(),
        // attachments = map['attachments'] as List<String>,
        createdAt = DateTime.parse(map['created_at']);
}
