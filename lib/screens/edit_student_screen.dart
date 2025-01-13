import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/student.dart';
import '../services/database_helper.dart';

class EditStudentScreen extends StatefulWidget {
  final Student student;

  const EditStudentScreen({super.key, required this.student});

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _dateNaissController;
  late TextEditingController _telController;
  late TextEditingController _photoController;
  late TextEditingController _groupeldController;

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
    );
  }

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.student.nom);
    _prenomController = TextEditingController(text: widget.student.prenom);
    _dateNaissController = TextEditingController(text: widget.student.dateNaiss);
    _telController = TextEditingController(text: widget.student.tel);
    _photoController = TextEditingController(text: widget.student.photo);
    _groupeldController = TextEditingController(text: widget.student.groupeld.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier un Étudiant'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _prenomController,
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prénom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateNaissController,
                decoration: const InputDecoration(labelText: 'Date de Naissance'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une date de naissance';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telController,
                decoration: const InputDecoration(labelText: 'Téléphone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un numéro de téléphone';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _photoController,
                decoration: const InputDecoration(labelText: 'Photo (URL)'),
              ),
              TextFormField(
                controller: _groupeldController,
                decoration: const InputDecoration(labelText: 'ID du Groupe'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un ID de groupe';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final student = Student(
                      id: widget.student.id,
                      nom: _nomController.text,
                      prenom: _prenomController.text,
                      dateNaiss: _dateNaissController.text,
                      tel: _telController.text,
                      photo: _photoController.text,
                      groupeld: int.parse(_groupeldController.text),
                    );

                    final dbHelper = DatabaseHelper();
                    await dbHelper.updateStudent(student);

                    _showToast('Étudiant modifié avec succès');
                    Navigator.pop(context, student);
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