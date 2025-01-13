import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/student.dart';
import '../services/database_helper.dart';
import 'add_student_screen.dart';
import 'edit_student_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final dbHelper = DatabaseHelper();
    final studentMaps = await dbHelper.getStudents();
    setState(() {
      students = studentMaps.map((map) => Student.fromMap(map)).toList();
    });
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Étudiants'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: student.photo.isNotEmpty
                  ? CircleAvatar(
                backgroundImage: FileImage(File(student.photo)),
                radius: 30,
              )
                  : const CircleAvatar(
                child: Icon(Icons.person),
                radius: 30,
              ),
              title: Text(
                '${student.nom} ${student.prenom}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Téléphone: ${student.tel}'),
                  Text('Date de Naissance: ${student.dateNaiss}'),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final dbHelper = DatabaseHelper();
                  await dbHelper.deleteStudent(student.id);
                  setState(() {
                    students.removeAt(index);
                  });
                  _showToast('Étudiant supprimé avec succès');
                },
              ),
              onTap: () async {
                final updatedStudent = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditStudentScreen(student: student),
                  ),
                );

                if (updatedStudent != null) {
                  await _loadStudents();
                  _showToast('Étudiant modifié avec succès');
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddStudentScreen(),
            ),
          );

          if (result == true) {
            await _loadStudents();
            _showToast('Étudiant ajouté avec succès');
          }
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}