import 'package:flutter/material.dart';
import 'package:acme_admin/constants/constants.dart';
import 'package:acme_admin/state/auth.dart';
import 'package:provider/provider.dart';

class Ticket extends StatelessWidget {
  const Ticket({super.key});

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
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text('Create New Ticket'),
                    ),
                  ),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final maxWidth = constraints.maxWidth;
                    final isTabletView = maxWidth < 700;
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
                          (ticket) => _customCard(
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
    {required String status,
    required String title,
    required String description}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
      side: const BorderSide(
        color: Colors.grey,
      ),
    ),
    child: Column(
      children: [
        Text(status),
        Text(title),
        Text(description),
        TextButton(child: const Text('see comments'), onPressed: () {}),
      ],
    ),
  );
}
