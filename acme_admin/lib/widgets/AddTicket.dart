import 'package:flutter/material.dart';
import 'package:acme_admin/constants/constants.dart';
import 'package:acme_admin/state/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddTicket extends StatefulWidget {
  const AddTicket({super.key});

  @override
  State<AddTicket> createState() => AddTicketState();
}

class AddTicketState extends State<AddTicket> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _customerEmail = TextEditingController();
  final List<PlatformFile> _attachments = [];

  final status = [
    'OPEN',
    'IN-PROGRESS',
    'BLOCKED',
    'RESOLVED',
    'CLOSED',
    'RE-OPENED'
  ];

  String? selectedStatus;
  bool invalidCustEmail = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _customerEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeUser = context.read<AuthStateLocal>().activeUser!;
    return Form(
      key: _formKey,
      child: ListView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(24.0),
        children: [
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 3) {
                return 'Please enter a title that is atleast 6 characters long';
              }
              return null;
            },
            decoration: const InputDecoration(
              icon: Icon(Icons.title),
              prefixStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              hintText: 'Enter Title',
            ),
            controller: _title,
          ),
          const SizedBox(
            height: 16,
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
            decoration: const InputDecoration(
              icon: Icon(Icons.description),
              border: OutlineInputBorder(),
              hintText: 'Enter Description',
            ),
            controller: _description,
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: invalidCustEmail ? Colors.red : Colors.transparent,
              ),
            ),
            child: TextFormField(
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !EmailValidator.validate(_customerEmail.text)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.email),
                border: OutlineInputBorder(),
                hintText: 'Enter Customer Email',
              ),
              controller: _customerEmail,
            ),
          ),
          if (invalidCustEmail)
            const Align(
              child: Text(
                'No customer with this email exists. Please create the customer first',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          //
          const SizedBox(
            height: 16,
          ),

          DropdownButtonFormField<String>(
            value: null,
            elevation: 16,
            decoration: const InputDecoration(
              icon: Icon(Icons.arrow_drop_down_circle),
              border: OutlineInputBorder(),
              hintText: 'Assign a status',
            ),
            focusColor: Colors.transparent,
            items: status.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                selectedStatus = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please assign a ticket status';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 16,
          ),

          //
          Row(
            children: [
              const Icon(
                Icons.attachment,
              ),
              const SizedBox(
                width: 18,
              ),
              OutlinedButton(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    allowMultiple: true,
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'png', 'pdf', 'doc'],
                  );
                  if (result == null) {
                    print("No file selected");
                  } else {
                    setState(() {});
                    result.files.forEach((file) {
                      _attachments.add(file);
                      print('picked file data: $file');
                    });
                  }
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(20)),
                  side: MaterialStateProperty.all<BorderSide>(
                      BorderSide(color: Colors.grey[700]!)),
                ),
                child: Text(
                  "Attach relevant files",
                  style: TextStyle(color: Colors.grey[700]!),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 16,
          ),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              child: const Text(
                'Create Ticket',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final List res = await supaClient
                      .from('customer')
                      .select()
                      .eq('email', _customerEmail.text);

                  print('customers $res');

                  if (res.isEmpty) {
                    setState(() {
                      invalidCustEmail = true;
                    });
                  } else {
                    final List<String> supaPaths = [];

                    await Future.wait(_attachments.map((attch) async {
                      final fileBytes = attch.bytes;
                      final fileName = (attch.name);

                      try {
                        await supaClient.storage
                            .from('attachments')
                            .uploadBinary(
                                '${_title.text}/$fileName', fileBytes!);

                        // get url
                        final url = supaClient.storage
                            .from('attachments/${_title.text}')
                            .getPublicUrl(fileName);

                        // setState(() {
                        supaPaths.add(url);
                        // });
                      } catch (e) {
                        print('error uploading file: $e');
                      }
                    }));

                    print('supa paths: $supaPaths');
                    final ticket = {
                      'title': _title.text,
                      'description': _description.text,
                      'status': selectedStatus,
                      'customer_id': res.first['id'],
                      'agent_id': activeUser.id,
                      'attachments': supaPaths,
                    };
                    final ticketRes =
                        await supaClient.from('ticket').insert(ticket);
                    print('ticket created: $ticketRes');

                    context.pop(context);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
