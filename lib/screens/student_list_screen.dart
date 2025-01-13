import 'dart:io';
import 'package:flutter/material.dart';
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
  List<Student> filteredStudents = []; // Liste filtrée pour la recherche
  final TextEditingController _searchController = TextEditingController();

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
      filteredStudents = students; // Initialise la liste filtrée avec tous les étudiants
    });
  }

  void _filterStudents(String query) {
    setState(() {
      filteredStudents = students.where((student) {
        final nom = student.nom.toLowerCase();
        final prenom = student.prenom.toLowerCase();
        final tel = student.tel.toLowerCase();
        final groupeld = student.groupeld.toString().toLowerCase();
        return nom.contains(query.toLowerCase()) ||
            prenom.contains(query.toLowerCase()) ||
            tel.contains(query.toLowerCase()) ||
            groupeld.contains(query.toLowerCase());
      }).toList();
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear(); // Efface le texte de recherche
      filteredStudents = students; // Réinitialise la liste filtrée
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Étudiants'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher un étudiant',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch, // Efface la recherche
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onChanged: _filterStudents, // Filtre les étudiants en temps réel
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                final student = filteredStudents[index];
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
                          students.removeWhere((s) => s.id == student.id);
                          filteredStudents.removeWhere((s) => s.id == student.id);
                        });

                        // Show SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Étudiant supprimé avec succès'),
                            duration: Duration(seconds: 2),
                          ),
                        );
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
                        await _loadStudents(); // Refresh the list

                        // Show SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Étudiant modifié avec succès'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
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
            await _loadStudents(); // Refresh the list

            // Show SnackBar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Étudiant ajouté avec succès'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}