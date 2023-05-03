import 'package:acme_admin/models/ticket.dart';
import 'package:acme_admin/screens/ViewTicket.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final Ticket ticket;

  const CustomCard({
    super.key,
    required this.ticket,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  void initState() {
    super.initState();
  }

  showTicketDetail() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
          title: Align(
            child: Text(
              'Ticket No.${widget.ticket.ticketNo.toString()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.4,
            child: ViewTicket(ticketInfo: widget.ticket),
          ),
        );
      },
    ).then(
      (value) => setState(() {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    final descToDisplay = widget.ticket.description.length > 40
        ? '${widget.ticket.description.substring(0, 70)} ...'
        : widget.ticket.description;
    return GestureDetector(
      onTap: showTicketDetail,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(
            color: Colors.grey,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'No.${widget.ticket.ticketNo.toString()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.ticket.status,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.ticket.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 18.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(descToDisplay),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  child: const Text(
                    'See Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: showTicketDetail,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
