import 'package:acme_admin/screens/ViewTicket.dart';
import 'package:acme_admin/widgets/CustomCard.dart';
import 'package:flutter/material.dart';
import 'package:acme_admin/widgets/AddTicket.dart';
import 'package:acme_admin/constants/constants.dart';
import 'package:acme_admin/state/auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:acme_admin/models/ticket.dart';

class Tickets extends StatefulWidget {
  const Tickets({Key? key}) : super(key: key);

  @override
  State<Tickets> createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  Future<List<Ticket>> getTickets(String id) async {
    final res = await supaClient.from('ticket').select().eq('agent_id', id);

    final data = res as List<dynamic>;
    final tickets = data
        .map((e) => Ticket.fromMap(map: e as Map<String, dynamic>))
        .toList();

    return tickets;
  }

  @override
  Widget build(BuildContext context) {
    final activeUser = context.read<AuthStateLocal>().activeUser!;
    return FutureBuilder(
      future: getTickets(activeUser.id),
      builder: (BuildContext context, AsyncSnapshot<List<Ticket>> snapshot) {
        if (snapshot.hasData) {
          final tickets = snapshot.data!;
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
                        ).then(
                          (_) => setState(() {}),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Create New Ticket'),
                    ),
                  ),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final maxWidth = constraints.maxWidth;
                    final isTabletView = maxWidth < 700;
                    // final isTabletView =
                    //     MediaQuery.of(context).size.width < 700;
                    // final isMobileView =
                    //     MediaQuery.of(context).size.width < 400;
                    final isMobileView = maxWidth < 400;
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
                          (ticket) => CustomCard(
                            ticket: ticket,
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
