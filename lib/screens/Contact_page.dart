import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/Contact.dart';
import 'new_conact_form.dart';

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive CRUD'),
      ),
      body: Column(
        children: [
          Expanded(child: _buildListView()),
          NewContactForm(),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return WatchBoxBuilder(
      box: Hive.box('contacts'),
      builder: (context, contactsBox) {
        return ListView.builder(
            itemCount: contactsBox.length,
            itemBuilder: (context, index) {
              final contact = contactsBox.getAt(index) as Contact;
              return ListTile(
                title: Text(contact.name),
                subtitle: Text(contact.age.toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {
                          contactsBox.putAt(
                            index,
                            Contact(
                                name: '${contact.name} *',
                                age: contact.age + 1),
                          );
                        }),
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          contactsBox.deleteAt(
                            index,
                          );
                        }),
                  ],
                ),
              );
            });
      },
    );
  }
}
