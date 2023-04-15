import 'package:flutter/material.dart';
import 'package:acme_admin/constants/constants.dart';
import 'package:acme_admin/screens/Add.dart';
import 'package:go_router/go_router.dart';

class ShowList extends StatefulWidget {
  const ShowList({Key? key}) : super(key: key);

  @override
  _ShowListState createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  late String tableName;
  late List _data;

  Future<List> getList(String userRole) async {
    tableName = userRole == 'admin' ? 'agent' : 'customer';
    final res = await supaClient.from(tableName).select();
    print('LISTTT ${res.toString()}');

    return res;
  }

  Future<int> getTotalCustomers(String id) async {
    final res =
        await supaClient.from('customer').select().eq('agent_id', id) as List;
    print('No. of customers ${res.length}');

    return res.length;
  }

  Future<int> getTotalTickets(String id, String userRole) async {
    final columnCheck = userRole == 'admin' ? 'agent_id' : 'customer_id';
    final res =
        await supaClient.from('ticket').select().eq(columnCheck, id) as List;
    print('No. of tickets created by the agent ${res.length}');
    return res.length;
  }

  Future<int> getTotalOpenTickets(String id) async {
    final res = await supaClient
        .from('ticket')
        .select()
        .eq('customer_id', id)
        .eq('status', 'open') as List;
    print('No. of customer open tickets - ${res.length}');
    return res.length;
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final userRole = checkUserRole(context);
    final isAdmin = userRole == 'admin';

    return Scaffold(
      floatingActionButton: IconButton(
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
                title: Align(
                  child: Text(
                    'Add new ${isAdmin ? 'Agent' : 'Customer'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                content: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Add(activeUserRole: userRole)),
              );
            },
          );
        },
        icon: const Icon(Icons.add),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        tooltip: "Add new $isAdmin ? 'agent' : 'customer'",
        color: Colors.blue,
      ),
      body: FutureBuilder<List>(
        future: getList(userRole),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _data = snapshot.data!;

            return Scrollbar(
              controller: scrollController,
              child: SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  showCheckboxColumn: true,
                  columns: [
                    const DataColumn(
                      label: Text('Name'),
                    ),
                    const DataColumn(
                      label: Text('Email'),
                    ),
                    DataColumn(
                      label:
                          Text(isAdmin ? 'Total Customers' : 'Total Tickets'),
                    ),
                    DataColumn(
                      label: Text(isAdmin ? 'Total Tickets' : 'Open Tickets'),
                    ),
                    const DataColumn(
                      label: Text(''),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    _data.length,
                    (index) => DataRow(
                      cells: [
                        DataCell(Text(_data[index]['name'].toString())),
                        DataCell(Text(_data[index]['email'].toString())),
                        DataCell(
                          FutureBuilder<int>(
                            future: isAdmin
                                ? getTotalCustomers(_data[index]['id'])
                                : getTotalTickets(_data[index]['id'], userRole),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(snapshot.data!.toString());
                              } else if (snapshot.hasError) {
                                return const Text('Error');
                              } else {
                                return const Text('-');
                              }
                            },
                          ),
                        ),
                        DataCell(
                          FutureBuilder<int>(
                            future: isAdmin
                                ? getTotalTickets(_data[index]['id'], userRole)
                                : getTotalOpenTickets(_data[index]['id']),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(snapshot.data!.toString());
                              } else if (snapshot.hasError) {
                                return const Text('Error');
                              } else {
                                return const Text('-');
                              }
                            },
                          ),
                        ),
                        DataCell(
                          TextButton.icon(
                            icon: const Icon(
                              Icons.delete,
                              size: 12,
                              color: Colors.red,
                            ),
                            label: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () async {
                              await supaClient
                                  .from(tableName)
                                  .delete()
                                  .eq('id', _data[index]['id']);
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ).toList(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data.'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
