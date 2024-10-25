
import 'package:final_exam_flutter/controller/auth_Controller.dart';
import 'package:final_exam_flutter/view/screens/sign%20in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/contact_controoler.dart';
import '../../model/contact_model.dart';


class ContactPage extends StatelessWidget {
  final ContactController contactController = Get.put(ContactController());
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(
          icon: Icon(
            Icons.logout,
            color: Colors.white,
          ),
          onPressed:() async {
            await authController.logOut();
            Get.offAll(SignIn());
          },
        ),
        backgroundColor:Colors.black,
        title: Text(
          'Contacts',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.sync,
              color: Colors.white,
            ),
            onPressed:()  async {
               await contactController.syncContactsToFirestore;

              Get.snackbar('Data successfully add in firestore', 'Sync',snackPosition: SnackPosition.BOTTOM,);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.backup_outlined,
              color: Colors.white,
            ),
            onPressed: () async {
              await contactController.fetchContactsFromFirestore();
              Get.snackbar('Backup successfully', 'Backup',snackPosition: SnackPosition.BOTTOM,);
            },
          ),

        ],
        centerTitle: true,
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: contactController.searchController,
              onChanged: (value) {},
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Expanded(
            child: Obx(
                  () => ListView.builder(
                itemCount: contactController.contacts.length,
                itemBuilder: (context, index) {
                  final contact = contactController.contacts[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 0
                    ),
                    child: Card(
                      child: ListTile(
                        title: Text(contact.name),
                        subtitle: Text(contact.phoneNumber),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                icon: Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () =>
                                    contactController.deleteUser(contact.id!)),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () =>
                                  _showEditContactDialog(context, contact),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => _showAddContactDialog(context),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name')),
              TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone')),
              TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final contact = Contact(
                  name: nameController.text,
                  phoneNumber: phoneController.text,
                  email: emailController.text,
                );
                contactController.insertUser(contact);
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showEditContactDialog(BuildContext context, Contact contact) {
    final nameController = TextEditingController(text: contact.name);
    final phoneController = TextEditingController(text: contact.phoneNumber);
    final emailController = TextEditingController(text: contact.email);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name')),
              TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone')),
              TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final updatedContact = Contact(
                  id: contact.id,
                  name: nameController.text,
                  phoneNumber: phoneController.text,
                  email: emailController.text,
                );
                contactController.updateUser(updatedContact);
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}