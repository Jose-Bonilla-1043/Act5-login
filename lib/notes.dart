import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final titlecontroller = TextEditingController();
  final contentcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Daily Notes"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    "My Notes",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  SizedBox(height: 20),

                  TextField(
                    controller: titlecontroller,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: contentcontroller,
                    decoration: InputDecoration(
                      labelText: 'Content',
                      hintText: 'Enter Content',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance.collection('notes').add({
                        'title': titlecontroller.text.trim(),
                        'content': contentcontroller.text.trim(),
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      titlecontroller.clear();
                      contentcontroller.clear();
                    },
                    child: Text('Save Notes'),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance
                      .collection('notes')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return Text("No notes added");
                  } else {
                    return ListView.builder(
                      itemCount: docs.length,
                      shrinkWrap: true, // Added shrinkWrap to prevent unbounded height in Column
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final title = doc['title'];
                        final content = doc['content'];
                        return ListTile( 
                          title: Text(title),
                          subtitle: Text(content),
                          trailing: IconButton(
                            onPressed: (){
                                FirebaseFirestore.instance.
                                collection('notes').doc(doc.id).
                                delete();
                            },
                            icon: Icon(Icons.delete_forever,
                            color: Colors.red,)),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}