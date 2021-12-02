import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/contact.dart';
import 'new_contact_form.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive Tutorial'),
      ),
      body: _buildListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  content: Center(
                    child: NewContactForm(),
                  ),
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildListView() {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Contact>('contacts').listenable(),
      builder: (context, Box<Contact> contactsBox, _) {
        return ListView.builder(
          itemCount: contactsBox.length,
          itemBuilder: (context, index) {
            final contact = contactsBox.getAt(index) as Contact;

            return ListTile(
              title: Text(contact.name),
              subtitle: Text(contact.age.toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      // edit
                      await showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              content: Center(
                                child: NewContactForm(
                                  index: index,
                                  isEditing: true,
                                  name: contact.name,
                                  age: contact.age.toString(),
                                ),
                              ),
                            );
                          });
                      /*  contactsBox.putAt(
                        index,
                        Contact('${contact.name}*', contact.age + 1),
                      );*/
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      //edit
                      return showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Eliminar Contacto'),
                            content: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Text('Desea eliminar este contacto?'),
                                  Text(''),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Confirm'),
                                onPressed: () {
                                  contactsBox.deleteAt(index);
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );

                      // await showDialog(
                      //     context: context,
                      //     builder: (ctx) => AlertDialog(
                      //           title: Text('Eliminar Contacto'),
                      //           actions: <Widget>[
                      //             new TextButton(
                      //                 child: new Text("Eliminar"),
                      //                 onPressed: () {
                      //                   contactsBox.deleteAt(index);
                      //                 })
                      //           ],
                      //         ));
                    },
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/*
//Future openDialog() => showDialog(
      context: context,
       builder: (context) => AlertDialog(
         title: Text('Eliminar Contacto'),
         actions: <Widget> [
           new TextButton(
            child: new Text("Close"),
            onPressed:(){
              contactsBox.deleteAt(index);
            },)
         ], 
       )); */