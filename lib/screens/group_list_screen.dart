import 'package:flutter/material.dart';
import '../models/group.dart';
import '../services/database_helper.dart';
import 'add_group_screen.dart';
import 'edit_group_screen.dart'; // Importe l'écran de modification

class GroupListScreen extends StatefulWidget {
  const GroupListScreen({super.key});

  @override
  State<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  List<Group> groups = [];

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    final dbHelper = DatabaseHelper();
    final groupMaps = await dbHelper.getGroups();
    setState(() {
      groups = groupMaps.map((map) => Group.fromMap(map)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Groupes'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: groups.length,
        itemBuilder: (context, index) {
          final group = groups[index];
          return Card(
            child: ListTile(
              title: Text(group.libelle),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final dbHelper = DatabaseHelper();
                  await dbHelper.deleteGroup(group.id);
                  setState(() {
                    groups.removeAt(index);
                  });
                },
              ),
              onTap: () async {
                final updatedGroup = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditGroupScreen(group: group),
                  ),
                );

                if (updatedGroup != null) {
                  setState(() {
                    groups[index] = updatedGroup;
                  });
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddGroupScreen(),
            ),
          ).then((_) => _loadGroups());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}