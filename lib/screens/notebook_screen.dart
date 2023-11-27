import 'package:flutter/material.dart';
import 'package:rehearse_app/main.dart';
import 'package:rehearse_app/utils/styles.dart';
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
  late TextEditingController controllerTerm;
  late TextEditingController controllerDefinition;

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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NoteData>(
        create: (_) => NoteData(),
        builder: (context, child) {
          return Scaffold(
            backgroundColor: accentLight,
            // ADD BUTTON
            floatingActionButton: IconButton.filled(
              icon: const Icon(Icons.add, color: icon),
              onPressed: () async {
                List dialogInputs = [];
                dialogInputs = await openDialog() ?? [];
                if (dialogInputs.isNotEmpty) {
                  Provider.of<NoteData>(context, listen: false).addNote(
                      dialogInputs[0], dialogInputs[1], dialogInputs[2]);
                }
              },
              style: ButtonStyle(
                  padding: MaterialStateProperty.resolveWith(
                      (states) => const EdgeInsets.all(15)),
                  backgroundColor:
                      MaterialStateProperty.resolveWith((states) => white)),
            ),
            body: SingleChildScrollView(
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
                          children: createSections(
                              Provider.of<NoteData>(context).notes, context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future openDialog([Note? note]) {
    Alignment dialogAlignment = Alignment.centerRight;

    if (note != null) {
      controllerTerm.text = note.term;
      controllerDefinition.text = note.definition;
      dialogAlignment = Alignment.centerLeft;
    } else {
      controllerTerm.clear();
      controllerDefinition.clear();
    }
    NoteType? currentCategory = note?.category;
    return showDialog(
        context: context,
        builder: ((BuildContext context) {
          return ChangeNotifierProvider<DialogData>(
            create: (context) => DialogData(),
            builder: ((context, child) {
              var headerColor = currentCategory?.headerBackgroundColor ??
                  Provider.of<DialogData>(context, listen: true).dialogColor;
              return AlertDialog(
                  titlePadding: EdgeInsets.zero,
                  alignment: dialogAlignment,
                  backgroundColor: white,
                  title: Container(
                    margin: EdgeInsets.zero,
                    decoration: ShapeDecoration(
                      color: headerColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 12, color: headerColor),
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
                            Provider.of<DialogData>(context, listen: false)
                                .noteCategory
                                .leftIcon
                                ?.icon,
                            color: white,
                          ),
                          enableSearch: false,
                          initialSelection:
                              Provider.of<DialogData>(context, listen: false)
                                  .noteCategory,
                          menuStyle: MenuStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((states) =>
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
                                value: category, label: category.name);
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
                              (states) => headerColor)),
                      icon: const Icon(Icons.sticky_note_2, color: white),
                      onPressed: () {
                        if (controllerTerm.text.isNotEmpty &&
                            controllerDefinition.text.isNotEmpty) {
                          Navigator.of(context).pop([
                            controllerTerm.text.capitalize(),
                            controllerDefinition.text.capitalize(),
                            Provider.of<DialogData>(context, listen: false)
                                .noteCategory,
                          ]);
                        }
                      },
                      label: Text(
                        "Zalijepi",
                        style: p3.copyWith(color: white),
                      ),
                    ),
                  ]);
            }),
          );
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
                              Provider.of<NoteData>(superContext, listen: false)
                                  .editNote(note, i, input[i]);
                            }
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
                                        Provider.of<NoteData>(superContext,
                                                listen: false)
                                            .deleteNote(note);
                                        Navigator.of(context).pop();
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
              headerBackgroundColor: note.category.headerBackgroundColor,
              headerBackgroundColorOpened:
                  note.category.headerBackgroundColorOpened ??
                      note.category.headerBackgroundColor,
              headerBorderColor: note.category.headerBorderColor ??
                  note.category.headerBackgroundColor,
              headerBorderColorOpened: note.category.headerBorderColorOpened ??
                  note.category.headerBorderColor,
              leftIcon: note.category.leftIcon,
              contentBackgroundColor: white,
              headerBorderRadius: 5,
            ))
        .toList();
  }
}
