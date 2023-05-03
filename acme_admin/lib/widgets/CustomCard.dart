import 'package:acme_admin/screens/ViewTicket.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final String ticketNo;
  final String status;
  final String title;
  final String description;

  const CustomCard({
    super.key,
    required this.ticketNo,
    required this.status,
    required this.title,
    required this.description,
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
              'Ticket No.${widget.ticketNo}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.4,
            child: ViewTicket(),
          ),
        );
      },
    ).then(
      (value) => setState(() {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    final descToDisplay = widget.description.length > 40
        ? '${widget.description.substring(0, 70)} ...'
        : widget.description;
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
                    'No.${widget.ticketNo}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.status,
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
                    widget.title,
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
