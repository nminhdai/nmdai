import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_todo_app/screens/create_note_screen.dart';
import 'package:flutter_firebase_todo_app/utils/custom_colors.dart';
import 'package:flutter_firebase_todo_app/utils/database_helper.dart';
import 'package:flutter_firebase_todo_app/utils/modals/note_modal.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

enum NoteQuery { titleAsc, titleDesc, dateAsc, dateDesc, dateChoosen }

extension on Query<Note> {
  /// Create a firebase query from a [NoteQuery]

  Query<Note> queryBy(NoteQuery query, DateTime now) {
    DateTime toda1 = now;
    DateTime toda2 = now.add(Duration(hours: 24));

    switch (query) {
      case NoteQuery.dateChoosen:
        return where('from', isGreaterThan: toda1)
            .where('from', isLessThan: toda2);
      case NoteQuery.titleAsc:
      case NoteQuery.titleDesc:
        return orderBy('title', descending: query == NoteQuery.titleDesc);
      case NoteQuery.dateAsc:
      case NoteQuery.dateDesc:
        return orderBy('dateTime', descending: query == NoteQuery.dateDesc);
    }
  }
}

class MyNotes extends StatefulWidget {
  @override
  _MyNotesState createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {
  Stream<QuerySnapshot<Note>> _notes;

  Query<Note> _notesQuery;

  bool _isCalendarVisible = false;
  DateTime date = DateTime.now();

  getDiff() {
    DateTime now = DateTime.now();

    if (DateFormat.MMMEd().format(now) == DateFormat.MMMEd().format(date))
      return "Today";
    return DateFormat.MMMEd().format(date).toString();
  }

  void _updateNotesQuery(NoteQuery query, DateTime now) {
    setState(() {
      Database.updateNoteref(FirebaseAuth.instance.currentUser.uid);
      _notesQuery = Database.notesRef.queryBy(query, now);
      _notes = _notesQuery.snapshots();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateNotesQuery(NoteQuery.dateChoosen, date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isCalendarVisible = !_isCalendarVisible;
                });
              },
              icon: Icon(
                Icons.calendar_today,
                color: Colors.white,
              ),
              //iconSize: 30.0,
            ),
            PopupMenuButton<NoteQuery>(
              onSelected: (value) => _updateNotesQuery(value, date),
              icon: const Icon(Icons.sort),
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: NoteQuery.titleAsc,
                    child: Text('Sort by Title ascending'),
                  ),
                  const PopupMenuItem(
                    value: NoteQuery.titleDesc,
                    child: Text('Sort by Title descending'),
                  ),
                  const PopupMenuItem(
                    value: NoteQuery.dateAsc,
                    child: Text('Sort by Date ascending'),
                  ),
                  const PopupMenuItem(
                    value: NoteQuery.dateDesc,
                    child: Text('Sort by Date descending'),
                  ),
                ];
              },
            ),
          ],
        ),
      ]),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          child: Column(children: <Widget>[
            _isCalendarVisible
                ? Container()
                : Expanded(
                    child: SfCalendar(
                    view: CalendarView.month,
                    initialSelectedDate: DateTime.now(),
                    cellBorderColor: Colors.transparent,
                    onTap: (CalendarTapDetails details) {
                      date = details.date;

                      _updateNotesQuery(NoteQuery.dateChoosen, date);
                    },
                  )),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Text(
                getDiff(),
                style: TextStyle(fontSize: 25, color: Colors.purple[200]),
              ),
            ),
            Expanded(
              child: Container(
                child: StreamBuilder<QuerySnapshot<Note>>(
                  stream: _notes,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Note>> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Icon(
                          Icons.report_gmailerrorred_sharp,
                          size: 80,
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                          CustomColors.firebaseOrange,
                        )),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            if (snapshot.data.docs.length != null) {
                              if (true)
                                return Dismissible(
                                  key: Key(snapshot.data.docs[index].id),
                                  background: Container(
                                      color: Theme.of(context).primaryColor),
                                  onDismissed: (direction) {
                                    Database.deleteNoteById(
                                        snapshot.data.docs[index].id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text('Note deleted')));
                                  },
                                  child: Card(
                                    color: Colors.white10,
                                    child: ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            snapshot.data.docs[index]
                                                .data()
                                                .title,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            DateFormat.jm()
                                                .format(snapshot
                                                    .data.docs[index]
                                                    .data()
                                                    .from
                                                    .toDate())
                                                .toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      onTap: () async {
                                        DocumentReference doc_ref = Database
                                            .notesRef
                                            .doc(snapshot.data.docs[index].id);
                                        DocumentSnapshot<Note> docSnap =
                                            await doc_ref.get();

                                        Get.to(CreateNote(document: docSnap));
                                      },
                                    ),
                                  ),
                                );
                            } else
                              return Text('No data');
                          });
                    }
                  },
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}























//
// body: FutureBuilder<List<QueryDocumentSnapshot<Note>>>(
// future: Database.fetchNotes(),
// builder: (BuildContext context,
//     AsyncSnapshot<List<QueryDocumentSnapshot<Note>>> snapshot) {
// if (snapshot.hasError) {
// return Text('Something went wrong');
// }
//
// if (snapshot.connectionState == ConnectionState.waiting) {
// return Text("Loading");
// } else {
// return ListView.builder(
// itemCount: snapshot.data.length,
// itemBuilder: (BuildContext ctxt, int index) {
// return ListTile(
// title: Text(snapshot.data[index].data().title),
// onTap: () async {
// DocumentReference doc_ref = Database.notesRef.doc(snapshot.data[index].id);
// DocumentSnapshot<Note> docSnap = await doc_ref.get();
//
// Get.to(CreateNote(document:docSnap));
// },
// );
// });
// }
// },
// ),
