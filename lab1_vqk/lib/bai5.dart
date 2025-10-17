import 'package:flutter/material.dart';

class Exercise05 extends StatelessWidget {
  Exercise05({super.key});

  final List<Contact> contacts = List.generate(
    20,
        (index) => Contact(
      index,
      'MyContact $index',
      'assets/images/contact.webp',
      '088899988$index',
    ),
  );
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: const Text('CONTACTS')),
        body: TabBarView(
          children: [
            const Center(child: Text('Contact yêu thích')),
            const Center(child: Text('Contact gọi gần đây')),
            ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final c = contacts[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(c.avatar),
                  ),
                  title: Text(c.name),
                  subtitle: Text(c.phone),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.call),
                  ),
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: const Material(
          color: Colors.red,
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.favorite), text: 'Favourites'),
              Tab(icon: Icon(Icons.recent_actors), text: 'Recent'),
              Tab(icon: Icon(Icons.contacts), text: 'Contacts'),
            ],
          ),
        ),
      ),
    );
  }
}

class Contact {
  final int id;
  final String name;
  final String avatar;
  final String phone;

  const Contact(this.id, this.name, this.avatar, this.phone);
}
