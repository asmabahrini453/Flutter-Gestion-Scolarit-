import 'package:flutter/material.dart';
import '../models/group.dart';
import '../services/database_helper.dart';

class EditGroupScreen extends StatefulWidget {
  final Group group;

  const EditGroupScreen({super.key, required this.group});

  @override
  State<EditGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _libelleController;

  @override
  void initState() {
    super.initState();
    _libelleController = TextEditingController(text: widget.group.libelle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier un Groupe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _libelleController,
                decoration: const InputDecoration(labelText: 'Libellé du Groupe'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un libellé';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final group = Group(
                      id: widget.group.id,
                      libelle: _libelleController.text,
                    );

                    final dbHelper = DatabaseHelper();
                    await dbHelper.updateGroup(group);

                    // Retour à l'écran précédent
                    Navigator.pop(context);
                  }
                },
                child: const Text('Modifier'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}