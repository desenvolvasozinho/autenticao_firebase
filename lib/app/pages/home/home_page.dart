import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final CollectionReference _notesCollection =
      FirebaseFirestore.instance.collection('notes');

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) Navigator.popAndPushNamed(context, '/');
  }

  // Função para adicionar uma nota
  Future<void> _addNote() async {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      await _notesCollection.add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
    _titleController.clear();
    _descriptionController.clear();
  }

  // Função para atualizar uma nota
  Future<void> _updateNote(
      String docId, String newTitle, String newDescription) async {
    await _notesCollection.doc(docId).update({
      'title': newTitle,
      'description': newDescription,
    });
  }

  // Função para deletar ma nota
  Future<void> _deleteNote(String docId) async {
    await _notesCollection.doc(docId).delete();
  }

  // Função para mostrar um diálogo de edição
  Future<void> _showEditDialog(DocumentSnapshot doc) async {
    _titleController.text = doc['title'];
    _descriptionController.text = doc['description'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Nota'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título')),
            TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição')),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Salvar'),
            onPressed: () {
              _updateNote(
                  doc.id, _titleController.text, _descriptionController.text);
              Navigator.of(context).pop();
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
        automaticallyImplyLeading: false,
        title: const Text('Home page'),
        actions: [TextButton(onPressed: logout, child: const Text('LogOut'))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Titulo'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addNote,
                  child: const Text('Adicionar Nota'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _notesCollection
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Nenhuma nota encontrada'),
                  );
                }
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    return ListTile(
                      title: Text(doc['title']),
                      subtitle: Text(doc['description']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _showEditDialog(doc),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () => _deleteNote(doc.id),
                            icon: const Icon(Icons.delete),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
