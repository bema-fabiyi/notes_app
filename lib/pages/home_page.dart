import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/services/firestore.dart';
import 'package:notes_app/widgets/custom_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const route = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void openNoteBox({String? docID, String? noteText}) {
    if (noteText != null) {
      textController.text = noteText;
    } else {
      textController.clear();
    }
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Create a Note'),
          content: TextField(
            controller: textController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (docID == null) {
                  _firestoreService.addNote(textController.text);
                } else {
                  _firestoreService.editNote(docID, textController.text);
                }
                textController.clear();
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (error) {
      if (mounted) {
        displaydialog(
            'Can\'t log user out at the moment, please try again later',
            context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: _firestoreService.getUserDetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    Map<String, dynamic>? user = snapshot.data!.data();
                    return Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          child: Icon(
                            Icons.person,
                            size: 80,
                          ),
                        ),
                        Text(
                          user!['username'],
                          style: const TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(user['email']),
                      ],
                    );
                  } else {
                    return const Text('No data!');
                  }
                },
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => logOut(),
                label: const Text('LOGOUT'),
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Notes App'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              openNoteBox();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print("Error in StreamBuilder: ${snapshot.error}");
            return const Center(child: Text('Error loading notes'));
          }

          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;
            if (notesList.isEmpty) {
              return const Center(child: Text('Add a note'));
            }

            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (content, index) {
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                return ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          openNoteBox(docID: docID, noteText: noteText);
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          _firestoreService.deleteNote(docID);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text(''),
            );
          }
        },
      ),
    );
  }
}
