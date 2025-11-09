import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:rehearse_app/main.dart';
import 'package:rehearse_app/quiz/quiz_screen.dart';
import 'package:rehearse_app/services/database_helper.dart';
import 'package:rehearse_app/shared/shared.dart';
import 'package:rehearse_app/models/note_model.dart';
import 'package:rehearse_app/shared/dialog_state.dart';

class CreateTestDialog extends StatefulWidget {
  final List<NoteType> categories;

  const CreateTestDialog({super.key, required this.categories});

  @override
  State<CreateTestDialog> createState() => _CreateTestDialogState();
}

enum QuestionType { multipleChoice, writtenTest }

class _CreateTestDialogState extends State<CreateTestDialog> {
  QuestionType selectedQuestionType = QuestionType.multipleChoice;
  List<NoteType> selectedCategories = [];
  bool allCategoriesSelected = false;
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final MultiSelectController<NoteType> _categoryController =
      MultiSelectController<NoteType>();

  @override
  Widget build(BuildContext context) {
    // Dropdown items store the full NoteType objects
    final dropdownItems = widget.categories
        .map((cat) => DropdownItem<NoteType>(
              label: cat.name.capitalized(),
              value: cat,
            ))
        .toList();

    return Dialog.fullscreen(
      child: Container(
        decoration: const BoxDecoration(color: white),
        padding: const EdgeInsets.only(top: 2, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(FontAwesomeIcons.xmark),
                color: black,
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Text("Podesi ispit:",
                textAlign: TextAlign.center, style: dialogText),
            const SizedBox(height: 100),
            Text("tip pitanja:", style: dialogText),
            SegmentedButton(
              selectedIcon: const Icon(FontAwesomeIcons.pen, color: black),
              onSelectionChanged: (Set<QuestionType> newSelection) {
                setState(() {
                  selectedQuestionType = newSelection.first;
                });
              },
              segments: [
                ButtonSegment(
                    value: QuestionType.multipleChoice,
                    label: Text("Višestruki izbor",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: pBold.copyWith(color: black))),
                ButtonSegment(
                    value: QuestionType.writtenTest,
                    label: Text("Pisani test",
                        style: pBold.copyWith(color: black))),
              ],
              selected: <QuestionType>{selectedQuestionType},
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size.fromHeight(40)),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) =>
                      states.contains(MaterialState.selected)
                          ? accent
                          : accentLight,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text("kategorije:", style: dialogText),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: MultiDropdown<NoteType>(
                    items: dropdownItems,
                    controller: _categoryController,
                    fieldDecoration: FieldDecoration(
                      hintText: 'Odaberi: ',
                      hintStyle: pBold.copyWith(color: black),
                    ),
                    chipDecoration: ChipDecoration(
                      backgroundColor: accentLight,
                      labelStyle: pBold.copyWith(color: black, fontSize: 13),
                    ),
                    onSelectionChange: (selectedItems) {
                      // selectedItems are NoteType objects
                      selectedCategories = selectedItems;
                      setState(() {
                        allCategoriesSelected =
                            selectedItems.length == dropdownItems.length;
                      });
                    },
                  ),
                ),
                Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  activeColor: accent,
                  value: allCategoriesSelected,
                  onChanged: (newValue) {
                    setState(() {
                      allCategoriesSelected = newValue!;
                      if (newValue) {
                        _categoryController.selectAll();
                      } else {
                        _categoryController.clearAll();
                      }
                    });
                  },
                ),
                Text("Svi zapisi", style: pBold.copyWith(color: black)),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
            ElevatedButton(
              onPressed: () => validateOptions(context),
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              child: Text("GENERIŠI TEST", style: pBold),
            ),
          ],
        ),
      ),
    );
  }

  void validateOptions(BuildContext context) async {
    // Map selected NoteType objects to their IDs for the database query
    final selectedIds = selectedCategories.map((e) => e.categoryID!).toList();

    List selectedNotes = await databaseHelper.notesByCategoryQuery(selectedIds);
    if (selectedCategories.isEmpty || selectedNotes.isEmpty) {
      DialogData.BuildDialog(
        context,
        Text("Nepotpun zahtjev", style: pBold),
        Text("Nijedan zapis nije odabran!",
            textAlign: TextAlign.center, style: p2),
        [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red)),
            child: Text("Probat ću.", style: p1.copyWith(color: white)),
          ),
        ],
      );
      return;
    }

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          quizCategories: selectedIds,
          questionType: selectedQuestionType,
        ),
      ),
    );
  }
}
