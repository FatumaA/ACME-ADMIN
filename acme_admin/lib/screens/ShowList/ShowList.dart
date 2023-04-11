import 'package:flutter/material.dart';
import 'package:acme_admin/constants/constants.dart';
import 'package:acme_admin/screens/Add.dart';
import 'package:acme_admin/screens/ShowList/ShowDetail.dart';
import 'package:go_router/go_router.dart';

class ShowList extends StatefulWidget {
  const ShowList({super.key});

  @override
  State<ShowList> createState() => _ShowListState();
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

            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.construction),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => supaClient.from(tableName).delete().match(
                      {'id': list[index]['id']},
                    ),
                    color: Colors.red,
                  ),
                  title: Text(list[index]['name']),
                  subtitle: Text(list[index]['email']),
                  // onTap: () => Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => PageView(
                  //       children: [
                  //         ShowDetail(id: list[index]['id']),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                );
              },
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
