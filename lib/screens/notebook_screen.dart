import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rehearse_app/main.dart';
import 'package:rehearse_app/screens/create_test_dialog.dart';
import 'package:rehearse_app/services/database_helper.dart';
import 'package:rehearse_app/shared/shared.dart';
import 'package:accordion/accordion.dart';
import 'package:rehearse_app/models/note_model.dart';
import 'package:provider/provider.dart';

import 'package:rehearse_app/utils/dialog_state.dart';

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
  List<int> categoryFilter = [];

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

  void _update([List<int> filter = const []]) {
    setState(() {
      if (filter.isEmpty) {
        notesFuture = _databaseHelper.getNotesDatabase();
      } else {
        notesFuture = _databaseHelper.notesByCategoryQuery(filter);
      }
      notesFuture.then((notes) => this.notes = notes);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool buttonsEnabled = notes.isNotEmpty;
    return Hero(
      tag: 'option.select',
      child: Scaffold(
        backgroundColor: accentLight,
        // ADD BUTTON
        floatingActionButton: IconButton.filled(
          icon: const Icon(Icons.add, color: white),
          onPressed: () async {
            List dialogInputs = [];
            dialogInputs = await openDialog() ?? [];
            if (dialogInputs.isNotEmpty) {
              _databaseHelper.insertNote(Note.noId(
                  term: dialogInputs[0],
                  definition: dialogInputs[1],
                  categoryID: dialogInputs[2]));
              _update();
            }
          },
          style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
              backgroundColor: MaterialStateProperty.all(background)),
        ),
        body: FutureBuilder(
            future: notesFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 5),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(10.0),
                      child: IconButton.outlined(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 5),
                          iconSize: 35,
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            FontAwesomeIcons.backward,
                            color: black,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 5),
                      child: Text(
                        softWrap: true,
                        textAlign: TextAlign.left,
                        "Moji \nzapisi",
                        style: TextStyle(
                            fontSize: 48,
                            fontFamily: pBold.fontFamily,
                            color: black),
                      ),
                    ),
                    const SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          color: icon,
                        )),
                  ],
                );
              } else if (snapshot.hasError) {
                // return: show error widget
              }

              notes = snapshot.data ?? [];

              // Plain display when there are saved notes
              if (notes.isEmpty) {
                buttonsEnabled = false;
              } else {
                buttonsEnabled = true;
              }

              // What displays after a note is added,
              // Category row implemented

              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 3.0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton.outlined(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 5),
                                  iconSize: 35,
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: const Icon(
                                    FontAwesomeIcons.backward,
                                    color: black,
                                  )),
                              ElevatedButton.icon(
                                onPressed: () {
                                  buttonsEnabled || categoryFilter.isNotEmpty
                                      ? showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const CreateTestDialog(),
                                        )
                                      : DialogData().BuildDialog(
                                          context,
                                          Text("Trenutno nemoguće",
                                              style: pBold),
                                          Text(
                                            "Dodaj koji zapis prije nego što se ispitaš!",
                                            style: p2,
                                            textAlign: TextAlign.center,
                                          ),
                                          [
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(
                                                  Colors.red,
                                                )),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text(
                                                  "OK",
                                                  style:
                                                      p2.copyWith(color: white),
                                                ),
                                              )
                                            ]);
                                },
                                icon: const Icon(
                                    FontAwesomeIcons.clipboardQuestion,
                                    color: white),
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10)),
                                    backgroundColor: buttonsEnabled ||
                                            categoryFilter.isNotEmpty
                                        ? MaterialStateProperty.all(icon)
                                        : MaterialStateProperty.all(
                                            Colors.black26)),
                                label: Text(
                                  "Ispitaj me",
                                  style: pBold.copyWith(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 20, bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  softWrap: true,
                                  "Moji \nzapisi",
                                  style: TextStyle(
                                      fontSize: 48,
                                      fontFamily: pBold.fontFamily,
                                      color: black),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 30,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: IconButton.filled(
                                    iconSize: 15,
                                    onPressed: null,
                                    icon: const Icon(Icons.add),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.black54),
                                        foregroundColor:
                                            MaterialStateProperty.all(white)),
                                  ),
                                ),
                                Expanded(
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: List.generate(
                                      categories.length,
                                      (index) {
                                        NoteType buttonCategory =
                                            categories[index];
                                        return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0),
                                            child: ElevatedButton.icon(
                                              icon: Icon(
                                                buttonCategory.leftIcon!.icon,
                                                color: white,
                                              ),
                                              label: Text(
                                                categories[index]
                                                    .name
                                                    .capitalize(),
                                                style:
                                                    p3.copyWith(color: white),
                                              ),
                                              onPressed: () {
                                                buttonsEnabled ||
                                                        categoryFilter
                                                            .isNotEmpty
                                                    ? setState(() {
                                                        if (!categoryFilter
                                                            .contains(
                                                                buttonCategory
                                                                    .categoryID)) {
                                                          categoryFilter.add(
                                                              buttonCategory
                                                                  .categoryID);
                                                        } else {
                                                          categoryFilter.remove(
                                                              buttonCategory
                                                                  .categoryID);
                                                        }
                                                        categoryFilter
                                                                .isNotEmpty
                                                            ? _update(
                                                                categoryFilter)
                                                            : _update();
                                                      })
                                                    : null;
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      categoryFilter.contains(
                                                              buttonCategory
                                                                  .categoryID)
                                                          ? accent
                                                          : Colors.black38),
                                            ));
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Accordion(
                    paddingBetweenClosedSections: 5,
                    maxOpenSections: 3,
                    scaleWhenAnimating: false,
                    children: createSections(notes, context),
                  ),
                ),
              );
            }),
      ),
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
                                backgroundColor: MaterialStateProperty.all(
                                    Provider.of<DialogData>(context,
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
                            backgroundColor: MaterialStateProperty.all(
                                Provider.of<DialogData>(context, listen: true)
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
                            backgroundColor: MaterialStateProperty.all(white)),
                        icon: const Icon(
                          Icons.edit,
                          color: black,
                        ),
                      ),
                      IconButton(
                        // DELETE BUTTON
                        onPressed: () {
                          DialogData().BuildDialog(
                            context,
                            Text("Obrisati?", style: pBold),
                            Text(
                              "Da li sigurno želiš obrisati ${note.term}?",
                              style: p2,
                            ),
                            [
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
                                          MaterialStateProperty.all(
                                              Colors.red)),
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

                        alignment: Alignment.bottomLeft,
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(white)),
                        icon: const Icon(
                          Icons.delete,
                          color: black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Just some regular properties of the note display
              // They look frightening but really I've just set a default value for all of them which is the color of the category, which is required

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
