import 'package:flutter/material.dart';
import 'contact.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Storage',
      home: ContactList(),
    );
  }
}

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  List<Contact> contacts = [];
  String searchQuery = '';

    void editContact(Contact contact, String newName, String newPhone) {
    setState(() {
      contact.name = newName;
      contact.phone = newPhone;
    });
  }

  void toggleFavorite(Contact contact) {
    setState(() {
      contact.isFavorite = !contact.isFavorite;
    });
  }

  void toggleBlock(Contact contact) {
    setState(() {
      contact.isBlocked = !contact.isBlocked;
    });
  }

  void deleteContact(Contact contact) {
    setState(() {
      contacts.remove(contact);
    });
  }

  void _addContact(String name, String phone, XFile? avatar) {
    setState(() {
      contacts.add(Contact(name, phone, avatar?.path));
    });

  void editContact(Contact contact, String newName, String newPhone) {
    setState(() {
      contact.name = newName;
      contact.phone = newPhone;
    });

    void showEditContactDialog(BuildContext context, Contact contact) {
  String newName = contact.name;
  String newPhone = contact.phone;

  

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              controller: TextEditingController(text: contact.name),
              onChanged: (value) => newName = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Phone'),
              controller: TextEditingController(text: contact.phone),
              onChanged: (value) => newPhone = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              editContact(contact, newName, newPhone);
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}
  }

  void toggleFavorite(Contact contact) {
    setState(() {
      contact.isFavorite = !contact.isFavorite;
    });
  }

  void toggleBlock(Contact contact) {
    setState(() {
      contact.isBlocked = !contact.isBlocked;
    });
  }

  void deleteContact(Contact contact) {
    setState(() {
      contacts.remove(contact);
    });
  }
    
  }


  Future<void> _showAddContactDialog() async {
    String name = '';
    String phone = '';
    XFile? avatar;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  avatar = await picker.pickImage(source: ImageSource.gallery);
                  setState(() {}); // Update UI after image is selected
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: avatar != null
                      ? FileImage(File(avatar!.path)) // Gunakan File(avatar.path)
                      : const AssetImage('assets/default_avatar.png') as ImageProvider,
                ),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Phone'),
                onChanged: (value) => phone = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (name.isNotEmpty && phone.isNotEmpty) {
                  _addContact(name, phone, avatar);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

Widget _buildContactTile(Contact contact) {
  return ListTile(
    leading: CircleAvatar(
      backgroundImage: contact.avatar != null
          ? FileImage(File(contact.avatar!))
          : const AssetImage('assets/default_avatar.png') as ImageProvider,
    ),
    title: Text(contact.name),
    subtitle: Text(contact.phone),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(contact.isFavorite ? Icons.star : Icons.star_border, color: Colors.yellow),
          onPressed: () => toggleFavorite(contact),
        ),
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () => showEditContactDialog(context, contact),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            deleteContact(contact);
          },
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('User Profile', style: TextStyle(fontSize: 16)),
            Text(
              '${contacts.length} Contacts • ${contacts.where((c) => c.name.contains("Online")).length} Online',
              style: const TextStyle(fontSize: 12, color: Colors.green),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/user_profile.png'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                if (contact.name.toLowerCase().contains(searchQuery.toLowerCase())) {
                  return _buildContactTile(contact);
                }
                return Container();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Add Contact',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorite',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            _showAddContactDialog();
          }
        },
      ),
    );
  }
  
  showEditContactDialog(BuildContext context, Contact contact) {}
}
