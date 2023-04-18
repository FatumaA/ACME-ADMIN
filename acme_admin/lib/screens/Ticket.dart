import 'package:flutter/material.dart';
import 'package:acme_admin/widgets/AddTicket.dart';
import 'package:acme_admin/constants/constants.dart';
import 'package:acme_admin/state/auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Ticket extends StatelessWidget {
  const Ticket({Key? key}) : super(key: key);

  Future<List> getTickets(String id) async {
    final res = await supaClient.from('ticket').select().eq('agent_id', id);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final activeUser = context.read<AuthStateLocal>().activeUser!;
    return FutureBuilder(
      future: getTickets(activeUser.id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final tickets = snapshot.data! as List;
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Text(
                  'Customer Tickets',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 20),
                if (activeUser.userMetadata!['user_role'] == 'agent')
                  Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                        const EdgeInsets.all(15),
                      )),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actions: [
                                TextButton(
                                  child: const Text('Close'),
                                  onPressed: () => context.pop(context),
                                ),
                              ],
                              title: const Align(
                                child: Text(
                                  'Add new ticket',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: const AddTicket(),
                              ),
                            );
                          },
                        );
                        // .then(
                        //     // (value) => setState,
                        //     );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Create New Ticket'),
                    ),
                  ),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final maxWidth = constraints.maxWidth;
                    // final isTabletView = maxWidth < 700;
                    final isTabletView =
                        MediaQuery.of(context).size.width < 700;
                    final isMobileView =
                        MediaQuery.of(context).size.width < 400;
                    // final isMobileView = maxWidth < 400;
                    final crossAxisCount = isMobileView
                        ? 1
                        : isTabletView
                            ? 2
                            : 3;
                    return GridView.count(
                      padding: const EdgeInsets.all(24),
                      shrinkWrap: true,
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: [
                        ...tickets.map(
                          (ticket) => _customCard(
                            ticketNo: ticket['ticket_no'].toString(),
                            status: ticket['status'],
                            title: ticket['title'],
                            description: ticket['description'],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

Widget _customCard(
    {required String ticketNo,
    required String status,
    required String title,
    required String description}) {
  final descToDisplay = description.length > 40
      ? '${description.substring(0, 70)} ...'
      : description;

  return Card(
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
                'No.$ticketNo',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                status,
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
                title,
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
                  child: const Text('see details'), onPressed: () {})),
        ],
      ),
    ),
  );
}
