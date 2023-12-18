import 'package:flutter/material.dart';
import 'package:rehearse_app/main.dart';
import 'package:rehearse_app/services/database_helper.dart';
import 'package:rehearse_app/shared/shared.dart';
import 'package:accordion/accordion.dart';
import 'package:rehearse_app/utils/note_model.dart';
import 'package:provider/provider.dart';

import '../utils/dialog.dart';

class NotebookScreen extends StatefulWidget {
  const NotebookScreen({super.key});

  @override
  State<NotebookScreen> createState() => _NotebookScreenState();
}

class _NotebookScreenState extends State<NotebookScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late TextEditingController controllerTerm;
  late TextEditingController controllerDefinition;
  late Future<List<Note>> notesFuture = _databaseHelper.getNotesDatabase();
  late Future<List<NoteType>> categoriesFuture =
      _databaseHelper.getCategoriesDatabase();
  List<Note> notes = [];
  @override
  void initState() {
    super.initState();
    controllerTerm = TextEditingController();
    controllerDefinition = TextEditingController();
  }

  @override
  void dispose() {
    ChangeNotifier().dispose();
    super.dispose();
  }

  void _update() {
    setState(() {
      notesFuture = _databaseHelper.getNotesDatabase();
      notesFuture.then((notes) => this.notes = notes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentLight,
      // ADD BUTTON
      floatingActionButton: IconButton.filled(
        icon: const Icon(Icons.add, color: icon),
        onPressed: () async {
          List dialogInputs = [];
          dialogInputs = await openDialog() ?? [];
          if (dialogInputs.isNotEmpty) {
            _databaseHelper.insertNote(Note(
                id: await _databaseHelper.notesRecordCount + 1,
                term: dialogInputs[0],
                definition: dialogInputs[1],
                categoryID: dialogInputs[2]));
            _update();
          }
        },
        style: ButtonStyle(
            padding: MaterialStateProperty.resolveWith(
                (states) => const EdgeInsets.all(15)),
            backgroundColor:
                MaterialStateProperty.resolveWith((states) => white)),
      ),
      body: FutureBuilder(
          future: notesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      color: accent,
                    )),
              );
            } else if (snapshot.hasError) {
              // return: show error widget
            }
            notes = snapshot.data ?? [];
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView(
                    shrinkWrap: true,
                    children: [
                      const SizedBox(height: 20),
                      AppBar(
                        backgroundColor: Colors.transparent,
                        leading: IconButton(
                          padding: const EdgeInsets.only(top: 18, bottom: 18),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith((states) {
                              return heading;
                            }),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: black,
                            size: 22.0,
                          ),
                        ),
                        leadingWidth: 32,
                        title: Text("Zid zapisa",
                            style: heading2.copyWith(color: black)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Accordion(
                          paddingBetweenClosedSections: 5,
                          maxOpenSections: 2,
                          scaleWhenAnimating: false,
                          children: createSections(notes, context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }

  Future openDialog([Note? note]) {
    Alignment dialogAlignment = Alignment.centerRight;
    bool hasNote = false;
    if (note != null) {
      controllerTerm.text = note.term;
      controllerDefinition.text = note.definition;
      dialogAlignment = Alignment.centerLeft;
    } else {
      controllerTerm.clear();
      controllerDefinition.clear();
    }

    return showDialog(
        context: context,
        builder: ((BuildContext context) {
          return ChangeNotifierProvider<DialogData>(
              create: (_) => DialogData(),
              builder: ((context, child) {
                if (note != null && hasNote == false) {
                  Provider.of<DialogData>(context).setDialog(note);
                  hasNote = true;
                }
                return AlertDialog(
                    titlePadding: EdgeInsets.zero,
                    alignment: dialogAlignment,
                    backgroundColor: white,
                    title: Container(
                      margin: EdgeInsets.zero,
                      decoration: ShapeDecoration(
                        color: Provider.of<DialogData>(context, listen: true)
                            .dialogColor,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 12,
                              color:
                                  Provider.of<DialogData>(context, listen: true)
                                      .dialogColor),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                      ),
                      padding: EdgeInsets.zero,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controllerTerm,
                              style: pBold,
                              maxLines: 1,
                              decoration: InputDecoration(
                                labelText: "Pojam:",
                                labelStyle: p1.copyWith(color: white),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: accent),
                                ),
                                enabledBorder: InputBorder.none,
                                fillColor: black,
                              ),
                            ),
                          ),
                          DropdownMenu<NoteType>(
                            width: 40,
                            trailingIcon: const Icon(null),
                            selectedTrailingIcon: const Icon(null),
                            leadingIcon: Icon(
                              Provider.of<DialogData>(context, listen: true)
                                  .noteCategory
                                  .leftIcon
                                  ?.icon,
                              color: white,
                            ),
                            enableSearch: false,
                            initialSelection:
                                Provider.of<DialogData>(context, listen: true)
                                    .noteCategory,
                            menuStyle: MenuStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => Provider.of<DialogData>(
                                                context,
                                                listen: true)
                                            .dialogColor)),
                            onSelected: (current) {
                              Provider.of<DialogData>(context, listen: false)
                                  .onChanged(current!);
                            },
                            dropdownMenuEntries: categories
                                .map<DropdownMenuEntry<NoteType>>(
                                    (NoteType category) {
                              return DropdownMenuEntry<NoteType>(
                                  value: category,
                                  label: category.name.capitalize());
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    content: TextField(
                      controller: controllerDefinition,
                      cursorHeight: 20,
                      minLines: 1,
                      maxLines: 5,
                      style: p1,
                      decoration: InputDecoration(
                        labelText: "Definicija:",
                        labelStyle: p1.copyWith(color: black),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: black),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: accent),
                        ),
                      ),
                    ),
                    actions: [
                      ElevatedButton.icon(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => Provider.of<DialogData>(context,
                                        listen: true)
                                    .dialogColor)),
                        icon: const Icon(Icons.sticky_note_2, color: white),
                        onPressed: () {
                          if (controllerTerm.text.isNotEmpty &&
                              controllerDefinition.text.isNotEmpty) {
                            Navigator.of(context).pop([
                              controllerTerm.text.capitalize(),
                              controllerDefinition.text.capitalize(),
                              Provider.of<DialogData>(context, listen: false)
                                  .noteCategory
                                  .categoryID,
                            ]);
                          }
                        },
                        label: Text(
                          "Zalijepi",
                          style: p3.copyWith(color: white),
                        ),
                      ),
                    ]);
              }));
        }));
  }

  List<AccordionSection> createSections(
      List<Note> notes, BuildContext superContext) {
    return notes
        .map((note) => AccordionSection(
              header: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 2, 0, 2),
                child: Text(
                  note.term,
                  style: pBold.copyWith(color: black),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Definicija: ${note.definition}",
                    style: p1,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        // EDIT BUTTON
                        iconSize: 25,
                        onPressed: () async {
                          List? input = await openDialog(note);
                          if (input == null) {
                            // CHECK IF PRESSED OUTSIDE BARRIER
                            Navigator.of(context, rootNavigator: false).pop();
                            return;
                          }
                          for (int i = 0; i < input.length; i++) {
                            if (input[i] != note.elements[i]) {
                              _databaseHelper.updateNote(Note(
                                  id: note.id,
                                  term: input[0],
                                  definition: input[1],
                                  categoryID: input[2]));
                            }
                            _update();
                          }
                        },
                        alignment: Alignment.bottomLeft,
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => white)),
                        icon: const Icon(
                          Icons.edit,
                          color: black,
                        ),
                      ),
                      IconButton(
                        // DELETE BUTTON
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                titlePadding: EdgeInsets.zero,
                                backgroundColor: white,
                                title: Container(
                                  margin: EdgeInsets.zero,
                                  decoration: const ShapeDecoration(
                                    color: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 12, color: Colors.red),
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                    ),
                                  ),
                                  padding: EdgeInsets.zero,
                                  child: Text("Obrisati?", style: pBold),
                                ),
                                content: Text(
                                  "Da li sigurno želiš obrisati ${note.term}?",
                                  style: p2,
                                ),
                                actions: [
                                  TextButton(
                                      child: Text(
                                        "Odustani",
                                        style: p3.copyWith(color: black),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      }),
                                  ElevatedButton.icon(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.resolveWith(
                                                  (states) => Colors.red)),
                                      icon: const Icon(Icons.sticky_note_2,
                                          color: white),
                                      label: Text(
                                        "Obriši",
                                        style: p3.copyWith(color: white),
                                      ),
                                      onPressed: () {
                                        _databaseHelper.deleteNote(note);
                                        Navigator.of(context).pop();
                                        _update();
                                      }),
                                ],
                              );
                            },
                          );
                        },

                        alignment: Alignment.bottomLeft,
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => white)),
                        icon: const Icon(
                          Icons.delete,
                          color: black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              headerBackgroundColor:
                  categories[note.categoryID].headerBackgroundColor,
              headerBackgroundColorOpened:
                  categories[note.categoryID].headerBackgroundColorOpened ??
                      categories[note.categoryID].headerBackgroundColor,
              headerBorderColor:
                  categories[note.categoryID].headerBorderColor ??
                      categories[note.categoryID].headerBackgroundColor,
              headerBorderColorOpened:
                  categories[note.categoryID].headerBorderColorOpened ??
                      categories[note.categoryID].headerBorderColor,
              leftIcon: categories[note.categoryID].leftIcon,
              contentBackgroundColor: white,
              headerBorderRadius: 5,
            ))
        .toList();
  }
}
