import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'models/contact.dart';

class NewContactForm extends StatefulWidget {
  final int? index;
  final String? name;
  final String? age;
  final bool isEditing;
  NewContactForm({
    this.name,
    this.age,
    this.isEditing = false,
    this.index,
  });
  @override
  _NewContactFormState createState() => _NewContactFormState();
}

class _NewContactFormState extends State<NewContactForm> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _age = '';

  void manageContact(Contact contact) {
    final contactsBox = Hive.box<Contact>('contacts');
    if (widget.isEditing) {
      contactsBox.putAt(widget.index!, contact);
    } else {
      contactsBox.add(contact);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: TextFormField(
                    initialValue: widget.name,
                    decoration: InputDecoration(labelText: 'Name'),
                    onSaved: (value) => _name = value!,
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: TextFormField(
                    initialValue: widget.age,
                    decoration: InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _age = value!,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              child:
                  Text(widget.isEditing ? 'Edit a Contact' : 'Add New Contact'),
              onPressed: () {
                _formKey.currentState!.save();
                final newContact = Contact(_name, int.parse(_age));
                manageContact(newContact);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
