import 'package:flutter/material.dart';
import '../models/group.dart';
import '../services/database_helper.dart';

class AddGroupScreen extends StatefulWidget {
  const AddGroupScreen({super.key});

  @override
  State<AddGroupScreen> createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _libelleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un Groupe'),
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
                      id: 0, // L'ID sera généré automatiquement par la base de données
                      libelle: _libelleController.text,
                    );

                    final dbHelper = DatabaseHelper();
                    await dbHelper.insertGroup(group);

                    // Retour à l'écran précédent
                    Navigator.pop(context);
                  }
                },
                child: const Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}