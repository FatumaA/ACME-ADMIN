import 'package:flutter/material.dart';
import 'package:acme_admin/constants/constants.dart';
import 'package:acme_admin/screens/Add.dart';
import 'package:acme_admin/screens/ShowList/ShowDetail.dart';

class ShowList extends StatefulWidget {
  const ShowList({Key? key}) : super(key: key);

  @override
  _ShowListState createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  late String tableName;

  Future<List> getList(String userRole) async {
    tableName = userRole == 'admin' ? 'agent' : 'customer';
    final res = await supaClient.from(tableName).select();
    print('LISTTT ${res.toString()}');

    return res;
  }

  @override
  Widget build(BuildContext context) {
    final userRole = checkUserRole(context);

    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // icon: IconButton(icon: Icon(Icons.close), onPressed: () => context.pop(context), ),
                title: Text(
                  'Add new ${userRole == 'admin' ? 'Agent' : 'Customer'}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Add(activeUserRole: userRole),
              );
            },
          );
        },
        icon: const Icon(Icons.add),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        tooltip: 'Add new ${userRole == 'admin' ? 'agent' : 'customer'}',
        color: Colors.blue,
      ),
      body: FutureBuilder<List>(
        future: getList(userRole),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final list = snapshot.data!;

            return DataTable(
              showCheckboxColumn: true,
              columns: const [
                DataColumn(label: Text('')),
                DataColumn(
                  label: Text('Name'),
                ),
                DataColumn(
                  label: Text('Email'),
                ),
                DataColumn(
                  label: Text('Details'),
                ),
              ],
              rows: List<DataRow>.generate(
                list.length,
                (index) => DataRow(
                  cells: [
                    DataCell(
                      Checkbox(
                        value: false,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              supaClient
                                  .from(tableName)
                                  .delete()
                                  .match({'id': list[index]['id']});
                            }
                            print(list[index]['id']);
                          });
                        },
                      ),
                    ),
                    DataCell(Text(list[index]['name'].toString())),
                    DataCell(Text(list[index]['email'].toString())),
                    DataCell(
                      TextButton(
                        child: const Text('See More'),
                        onPressed: () {
                          // open modal with details
                        },
                      ),
                    ),
                  ],
                ),
              ).toList(),
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
