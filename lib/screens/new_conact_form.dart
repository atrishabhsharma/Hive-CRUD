import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hiveDo/model/Contact.dart';

class NewContactForm extends StatefulWidget {
  @override
  _NewContactFormState createState() => _NewContactFormState();
}

class _NewContactFormState extends State<NewContactForm> {
  final _formkey = GlobalKey<FormState>();

  String _name;
  String _age;

  void addContact(Contact contact) {
    final contactsBox = Hive.box('contacts');
    contactsBox.add(contact);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onSaved: (value) => _name = value,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Age'),
                  onSaved: (value) => _age = value,
                ),
              ),
            ],
          ),
          RaisedButton(
              child: Text('Add New Contact'),
              onPressed: () {
                _formkey.currentState.save();
                final newContact = Contact(name: _name, age: int.parse(_age));
                addContact(newContact);
              })
        ],
      ),
    );
  }
}
