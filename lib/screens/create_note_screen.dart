import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_todo_app/utils/Utils.dart';
import 'package:flutter_firebase_todo_app/utils/database_helper.dart';
import 'package:flutter_firebase_todo_app/utils/modals/note_modal.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

class CreateNote extends StatefulWidget {
  DocumentSnapshot<Note> document;
  CreateNote({this.document});

  @override
  _CreateNoteState createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  String titleForm = "";
  String descriptionForm = "";
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now().add(Duration(hours: 2));
  Color backgroundColor;
  bool isAllDay = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.document != null) {
      titleForm = widget.document.data().title;
      descriptionForm = widget.document.data().description;
      fromDate = widget.document.data().from.toDate();
      toDate = widget.document.data().to.toDate();
      isAllDay = widget.document.data().isAllDay;
    }
    titleController.text = titleForm;
    descriptionController.text = descriptionForm;
    //fromDateController.value(fromDate);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: Colors.black12,
          title: button(titleController, descriptionController, context),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.document == null
                            ? "Create new todo"
                            : "View Event",
                        style: TextStyle(
                          fontSize: 33,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      title("Event title", titleController),
                      SizedBox(
                        height: 20,
                      ),
                      buildDateTimePicker(),
                      SizedBox(
                        height: 20,
                      ),
                      description("Event description", descriptionController),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget description(String name, TextEditingController Controller) {
    return Container(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 300.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: Controller,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: name,
                  labelStyle: TextStyle(color: Colors.green, fontSize: 30),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  enabledBorder: Controller.text == ''
                      ? UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        )
                      : OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                ),
                style: TextStyle(fontSize: 19, color: Colors.white),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget title(
    String name,
    TextEditingController Controller,
  ) {
    return Container(
      height: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: Controller,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                //contentPadding: EdgeInsets.all(20),
                labelText: name,
                labelStyle: TextStyle(color: Colors.green, fontSize: 30),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
              ),
              style: TextStyle(fontSize: 19, color: Colors.white),
              keyboardType: TextInputType.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget button(
    TextEditingController titleController,
    TextEditingController descriptionController,
    BuildContext context,
  ) {
    return Container(
      //decoration: BoxDecoration(border: Border.all(color: Colors.amber)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              var uid = Database.user.uid;
              var datetime = DateTime.now();
              Timestamp myTimeStamp = Timestamp.fromDate(datetime);
              if (widget.document == null) {
                Database.addNote(
                  Note(
                    title: titleController.text,
                    description: descriptionController.text,
                    from: Timestamp.fromDate(fromDate),
                    to: Timestamp.fromDate(toDate),
                    isAllDay: isAllDay,
                    uid: uid,
                    dateTime: myTimeStamp,
                  ),
                  context,
                );
              } else {
                Database.updateNoteById(
                  widget.document.id,
                  Note(
                    title: titleController.text,
                    description: descriptionController.text,
                    from: Timestamp.fromDate(fromDate),
                    to: Timestamp.fromDate(toDate),
                    isAllDay: isAllDay,
                    dateTime: myTimeStamp,
                  ),
                );
              }
              Get.back();
            },
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 33,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            style: ElevatedButton.styleFrom(primary: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget buildDateTimePicker() {
    return Column(
      children: [
        buildForm(),
        buildTo(),
      ],
    );
  }

  Widget buildForm() {
    return buildHeader(
      header: 'FROM',
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: buildDropdownField(
              text: Utils.toDate(fromDate),
              onClicked: () => pickFromDateTime(pickDate: true),
            ),
          ),
          Expanded(
            child: buildDropdownField(
              text: Utils.toTime(fromDate),
              onClicked: () => pickFromDateTime(pickDate: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTo() {
    return buildHeader(
      header: 'TO',
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: buildDropdownField(
              text: Utils.toDate(toDate),
              onClicked: () => pickToDateTime(pickDate: true),
            ),
          ),
          Expanded(
            child: buildDropdownField(
              text: Utils.toTime(toDate),
              onClicked: () => pickToDateTime(pickDate: false),
            ),
          ),
        ],
      ),
    );
  }

  Future pickFromDateTime({bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if (date == null) return;
    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, date.hour, date.minute);
    }
    setState(() {
      return fromDate = date;
    });
  }

  Future pickToDateTime({bool pickDate}) async {
    final date = await pickDateTime(
      toDate,
      pickDate: pickDate,
      firstDate: pickDate ? fromDate : null,
    );
    if (date == null) return;

    setState(() {
      return toDate = date;
    });
  }

  Future<DateTime> pickDateTime(
    DateTime initialDate, {
    bool pickDate,
    DateTime firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2015, 8),
        lastDate: DateTime(2101),
      );

      if (date == null) return null;
      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(initialDate));
      if (timeOfDay == null) return null;
      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }

  Widget buildDropdownField({String text, VoidCallback onClicked}) {
    return ListTile(
      title: Text(text),
      trailing: Icon(Icons.arrow_drop_down),
      onTap: onClicked,
    );
  }

  Widget buildHeader({String header, Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        child,
      ],
    );
  }
}
