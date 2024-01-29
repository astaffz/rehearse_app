import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rehearse_app/main.dart';
import 'package:rehearse_app/notes/create_test_dialog.dart';
import 'package:rehearse_app/services/database_helper.dart';
import 'package:rehearse_app/shared/shared.dart';
import 'package:accordion/accordion.dart';
import 'package:rehearse_app/models/note_model.dart';
import 'package:provider/provider.dart';
import 'package:rehearse_app/shared/dialog_state.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

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
  List<NoteType> categories = [];
  List<int> categoryFilter = [];

  bool buttonsEnabled = true;
  @override
  void initState() {
    super.initState();
    controllerTerm = TextEditingController();
    controllerDefinition = TextEditingController();
    _databaseHelper
        .getCategoriesDatabase()
        .then((categories) => this.categories = categories);
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
      categoriesFuture = _databaseHelper.getCategoriesDatabase();
      categoriesFuture.then((categories) => this.categories = categories);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'option.select',
      child: Scaffold(
        backgroundColor: accentLight,
        resizeToAvoidBottomInset: false,
        // ADD BUTTON
        floatingActionButton: IconButton.filled(
          icon: const Icon(FontAwesomeIcons.notesMedical, color: white),
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
            future: Future.wait(
              [categoriesFuture, notesFuture],
            ),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              Widget child;
              Widget content;

              notes = snapshot.data?[1] ?? [];
              categories = snapshot.data?[0] ?? [];
              if (!snapshot.hasData) {
                content = Center(
                  child: Text(
                    "Spremno za tvoj prvi zapis!",
                    style: p2,
                  ),
                );
              }
              if (snapshot.hasError) {
                child = Container();
              } else {
                content = Accordion(
                    paddingBetweenClosedSections: 5,
                    maxOpenSections: 3,
                    scaleWhenAnimating: false,
                    children: createSections(notes, context));

                child = NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      sliver: SliverAppBar(
                        pinned: true,
                        backgroundColor: accentLight,
                        centerTitle: true,
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: IconButton(
                            iconSize: 35,
                            icon: const Icon(
                              FontAwesomeIcons.backward,
                              color: black,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (buttonsEnabled ||
                                    categoryFilter.isNotEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => CreateTestDialog(
                                        categories: categories),
                                  );
                                } else {
                                  DialogData.BuildDialog(
                                    context,
                                    Text("Trenutno nemoguće", style: pBold),
                                    Text(
                                      "Dodaj koji zapis prije nego što se ispitaš!",
                                      style: p2,
                                      textAlign: TextAlign.center,
                                    ),
                                    [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                          Colors.red,
                                        )),
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          "OK",
                                          style: p2.copyWith(color: white),
                                        ),
                                      )
                                    ],
                                  );
                                }
                              },
                              icon: const Icon(FontAwesomeIcons.noteSticky,
                                  color: white),
                              label: Text(
                                "Test",
                                style: pBold.copyWith(
                                    color: white, fontSize: p2.fontSize),
                              ),
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
                                  backgroundColor:
                                      MaterialStateProperty.all(icon)),
                            ),
                          ),
                        ],
                        forceElevated: innerBoxIsScrolled,
                        collapsedHeight: 100,
                        expandedHeight: 200.0,
                        flexibleSpace: Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: FlexibleSpaceBar(
                            collapseMode: CollapseMode.pin,
                            titlePadding:
                                const EdgeInsets.only(left: 20, bottom: 5),
                            title: Text(
                              softWrap: true,
                              textAlign: TextAlign.center,
                              "Moji zapisi",
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                  fontSize: 36,
                                  fontFamily: pBold.fontFamily,
                                  color: black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "kategorije:",
                          style: dialogText.copyWith(fontSize: p1.fontSize),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: IconButton.filled(
                                iconSize: 15,
                                onPressed: () async {
                                  List dialogInputs =
                                      await openCategoryDialog() ?? [];
                                  if (dialogInputs.isNotEmpty) {
                                    _databaseHelper.insertCategory(NoteType(
                                        name: dialogInputs[0],
                                        colorHex: dialogInputs[1]));
                                  }
                                },
                                icon: const Icon(Icons.add),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.black54),
                                    foregroundColor:
                                        MaterialStateProperty.all(white)),
                              ),
                            ),
                            Expanded(
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children:
                                    List.generate(categories.length, (index) {
                                  NoteType buttonCategory = categories[index];
                                  return Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: ElevatedButton.icon(
                                        onLongPress: () async {
                                          List? input =
                                              await openCategoryDialog(
                                                  categories[index]);
                                          if (input == null) {
                                            return;
                                          }
                                          for (int i = 0;
                                              i < input.length;
                                              i++) {
                                            if (input[i] !=
                                                categories[index].elements[i]) {
                                              await _databaseHelper
                                                  .updateCategory(NoteType(
                                                      categoryID:
                                                          categories[index]
                                                              .categoryID,
                                                      name: input[0],
                                                      colorHex: input[1]));
                                            }
                                            _update();
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.notes,
                                          color: white,
                                        ),
                                        label: Text(
                                          buttonCategory.name.capitalized(),
                                          style: p3.copyWith(color: white),
                                        ),
                                        onPressed: () {
                                          buttonsEnabled ||
                                                  categoryFilter.isNotEmpty
                                              ? setState(() {
                                                  if (!categoryFilter.contains(
                                                      buttonCategory
                                                          .categoryID)) {
                                                    categoryFilter.add(
                                                        buttonCategory
                                                            .categoryID!);
                                                  } else {
                                                    categoryFilter.remove(
                                                        buttonCategory
                                                            .categoryID);
                                                  }
                                                  categoryFilter.isNotEmpty
                                                      ? _update(categoryFilter)
                                                      : _update();
                                                })
                                              : null;
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: categoryFilter
                                                    .contains(buttonCategory
                                                        .categoryID)
                                                ? accent
                                                : Colors.black38),
                                      ));
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            child: content,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Plain display when there are saved notes

              if (notes.isEmpty) {
                buttonsEnabled = false;
              } else {
                buttonsEnabled = true;
              }

              // What displays after a note is added,
              // Category row implemented
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: child,
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
              create: (_) => DialogData(categories: categories),
              builder: ((context, child) {
                if (note != null && hasNote == false) {
                  Provider.of<DialogData>(context).setDialog(note);
                  hasNote = true;
                }
                return AlertDialog(
                    alignment: dialogAlignment,
                    titlePadding: EdgeInsets.zero,
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
                                      .dialogColor!),
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
                          SizedBox(
                            width: 40,
                            height: 50,
                            child: DropdownMenu<NoteType>(
                              trailingIcon: const Icon(null),
                              selectedTrailingIcon: const Icon(null),
                              expandedInsets: EdgeInsets.zero,
                              leadingIcon: const Icon(
                                Icons.library_books,
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
                                    label: category.name.capitalized());
                              }).toList(),
                            ),
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
                              controllerTerm.text.capitalized(),
                              controllerDefinition.text.capitalized(),
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

  Future openCategoryDialog([NoteType? category]) {
    bool hasCategory = false;
    if (category != null && hasCategory == false) {
      controllerTerm.text = category.name;
      controllerDefinition.text = category.headerBackgroundColor!.toString();
      hasCategory = true;
    } else {
      controllerTerm.clear();
      controllerDefinition.clear();
    }
    return showDialog(
        context: context,
        builder: ((BuildContext context) {
          return ChangeNotifierProvider<DialogData>(
              create: (_) => DialogData(categories: categories),
              builder: ((context, child) {
                if (category != null &&
                    Provider.of<DialogData>(context, listen: false)
                            .hasCategory ==
                        false) {
                  Provider.of<DialogData>(context).setCategoryDialog(category);
                  Provider.of<DialogData>(context).hasCategory = true;
                }
                return AlertDialog(
                    titlePadding: EdgeInsets.zero,
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
                                      .dialogColor!),
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
                                labelText: "Ime kategorije:",
                                labelStyle: p1.copyWith(color: white),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: accent),
                                ),
                                enabledBorder: InputBorder.none,
                                fillColor: black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    content: ElevatedButton(
                      onPressed: () {
                        ColorPicker(
                            color:
                                Provider.of<DialogData>(context, listen: false)
                                    .dialogColor!,
                            onColorChanged: (Color color) {
                              setState(() {
                                Provider.of<DialogData>(context, listen: false)
                                    .updateCategory(color);
                              });
                            }).showPickerDialog(
                          context,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Provider.of<DialogData>(context).dialogColor),
                      child: Text("Boja kategorije:", style: p2),
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
                          String colorCode =
                              Provider.of<DialogData>(context, listen: false)
                                  .dialogColor!
                                  .toHex(leadingHashSign: false);
                          if (controllerTerm.text.isNotEmpty) {
                            Navigator.of(context).pop(
                                [controllerTerm.text.capitalized(), colorCode]);
                          }
                        },
                        label: Text(
                          "Potvrdi",
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
                          DialogData.BuildDialog(
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

              headerBackgroundColor: categories
                  .firstWhere(
                      (element) => element.categoryID == note.categoryID)
                  .headerBackgroundColor,
              headerBackgroundColorOpened: categories[note.categoryID]
                      .headerBackgroundColorOpened ??
                  categories
                      .firstWhere(
                          (element) => element.categoryID == note.categoryID)
                      .headerBackgroundColor,
              headerBorderColor: categories[note.categoryID]
                      .headerBorderColor ??
                  categories
                      .firstWhere(
                          (element) => element.categoryID == note.categoryID)
                      .headerBackgroundColor,
              headerBorderColorOpened: categories[note.categoryID]
                      .headerBorderColorOpened ??
                  categories
                      .firstWhere(
                          (element) => element.categoryID == note.categoryID)
                      .headerBackgroundColor,
              leftIcon: categories
                      .firstWhere(
                          (element) => element.categoryID == note.categoryID)
                      .leftIcon ??
                  defaultType.leftIcon,
              contentBackgroundColor: white,
              headerBorderRadius: 5,
            ))
        .toList();
  }
}
