import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/student.dart';
import '../services/database_helper.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _dateNaissController = TextEditingController();
  final _telController = TextEditingController();
  final _photoController = TextEditingController();
  final _groupeldController = TextEditingController();
  XFile? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
        _photoController.text = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un Étudiant'),
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
                readOnly: true,
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _dateNaissController.text = "${pickedDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
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
                readOnly: true,
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Choisir une photo'),
              ),
              if (_imageFile != null)
                Image.file(
                  File(_imageFile!.path),
                  height: 100,
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
                      id: 0, // Auto-incremented by SQLite
                      nom: _nomController.text,
                      prenom: _prenomController.text,
                      dateNaiss: _dateNaissController.text,
                      tel: _telController.text,
                      photo: _photoController.text,
                      groupeld: int.parse(_groupeldController.text),
                    );

                    final dbHelper = DatabaseHelper();
                    await dbHelper.insertStudent(student);

                    // Show SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Étudiant ajouté avec succès'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    Navigator.pop(context, true);
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