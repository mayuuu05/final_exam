
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../helper/database_helper.dart';
import '../model/contact_model.dart';
import '../service/firebase_service.dart';

class ContactController extends GetxController {
  var contacts = <Contact>[].obs;
  final DatabaseHelper dbHelper = DatabaseHelper();
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadContacts();
    searchController.addListener(searchContacts);
  }

  void loadContacts({String? query}) async {
    contacts.value = await dbHelper.getContacts(query: query);
  }

  void insertUser(Contact contact) async {
    await dbHelper.insertContact(contact);
    syncContactsToFirestore();
    loadContacts();
  }

  void updateUser(Contact contact) async {
    await dbHelper.updateContact(contact);
    syncContactsToFirestore();
    loadContacts();
  }

  Future<void> deleteUser(String id) async {
    int contactId = int.tryParse(id) ?? -1;
    await dbHelper.deleteItem(contactId);
    loadContacts();
  }

  Future<void> syncContactsToFirestore() async {
    String userId = "currentUserId";
    await firestoreService.syncContacts(userId, contacts);
  }

  Future<void> fetchContactsFromFirestore() async {
    String userId = "currentUserId";
    var cloudContacts = await firestoreService.getContacts(userId);

    for (var contact in cloudContacts) {
      await dbHelper.insertContact(contact);
    }

    loadContacts();
  }

  void searchContacts() {
    String query = searchController.text;
    loadContacts(query: query);
  }
}
