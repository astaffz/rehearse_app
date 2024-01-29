import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:rehearse_app/main.dart';
import 'package:rehearse_app/quiz/quiz_screen.dart';
import 'package:rehearse_app/services/database_helper.dart';
import 'package:rehearse_app/shared/shared.dart';
import 'package:rehearse_app/models/note_model.dart';
import 'package:rehearse_app/shared/dialog_state.dart';

class CreateTestDialog extends StatefulWidget {
  CreateTestDialog({super.key, required this.categories});
  final List<NoteType> categories;
  @override
  State<CreateTestDialog> createState() => _CreateTestDialogState();
}

enum QuestionType { multipleChoice, writtenTest }

class _CreateTestDialogState extends State<CreateTestDialog> {
  QuestionType selectedQuestionType = QuestionType.multipleChoice;
  List<int> selectedCategories = [];
  bool allCategoriesSelected = false;
  final DatabaseHelper databaseHelper = DatabaseHelper();
  int noteCount = 0;
  final MultiSelectController _categorycontroller = MultiSelectController();

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Container(
          decoration: const BoxDecoration(
            color: white,
          ),
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Text("Podesi ispit:",
                  textAlign: TextAlign.center, style: dialogText),
              const SizedBox(
                height: 100,
              ),
              Text(
                "tip pitanja:",
                textAlign: TextAlign.left,
                style: dialogText,
              ),
              SegmentedButton(
                selectedIcon: const Icon(
                  FontAwesomeIcons.pen,
                  color: black,
                ),
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
                  fixedSize: MaterialStateProperty.all<Size>(
                      const Size.fromHeight(10.0)),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return accent;
                      }
                      return accentLight;
                    },
                  ),
                ),
              ),
              Text(
                "kategorije:",
                style: dialogText,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: MultiSelectDropDown(
                      hint: "Odaberi: ",
                      controller: _categorycontroller,
                      dropdownHeight: 130,
                      hintStyle: pBold.copyWith(color: black),
                      selectedOptionBackgroundColor: white,
                      chipConfig: ChipConfig(
                          backgroundColor: accentLight,
                          labelStyle:
                              pBold.copyWith(color: black, fontSize: 13),
                          deleteIconColor: black),
                      showClearIcon: true,
                      selectionType: SelectionType.multi,
                      onOptionSelected: (selectedOptions) {
                        selectedCategories = [];
                        selectedOptions.map((element) {
                          selectedCategories.add(element.value);
                        });

                        // The value that the 'Svi zapisi' checkbox depends on
                        // It should align with the selection
                        if (selectedOptions.length !=
                            widget.categories.length) {
                          setState(() {
                            allCategoriesSelected = false;
                          });
                        } else {
                          setState(() {
                            allCategoriesSelected = true;
                          });
                        }
                      },
                      optionTextStyle: p2,
                      options: List.generate(
                          widget.categories.length,
                          (index) => ValueItem<int>(
                              label:
                                  widget.categories[index].name.capitalized(),
                              value: widget.categories[index].categoryID)),
                    ),
                  ),
                  Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      activeColor: accent,
                      value: allCategoriesSelected,
                      onChanged: (newValue) {
                        setState(() {
                          allCategoriesSelected = newValue!;
                          if (newValue == true) {
                            _categorycontroller.setSelectedOptions(
                                _categorycontroller.options);
                          } else if (newValue == false) {
                            _categorycontroller.clearAllSelection();
                          }
                        });
                      }),
                  Text(
                    "Svi zapisi",
                    style: pBold.copyWith(color: black),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              ElevatedButton(
                  onPressed: () {
                    validateOptions(context);
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(15)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green)),
                  child: Text(
                    "GENERIŠI TEST",
                    style: pBold,
                  )),
            ],
          )),
    );
  }

  void validateOptions(BuildContext context) async {
    selectedCategories = List.generate(
        _categorycontroller.selectedOptions.length,
        (index) => _categorycontroller.selectedOptions[index].value);

    List selectedNotes =
        await databaseHelper.notesByCategoryQuery(selectedCategories);
    noteCount = selectedNotes.length;
    if (_categorycontroller.selectedOptions.isEmpty || noteCount == 0) {
      // ignore: use_build_context_synchronously
      DialogData.BuildDialog(
        context,
        Text(
          "Nepotpun zahtjev",
          style: pBold,
        ),
        Text(
          "Nijedan zapis nije odabran!",
          textAlign: TextAlign.center,
          style: p2,
        ),
        [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
            child: Text(
              "Probat ću.",
              style: p1.copyWith(color: white),
            ),
          ),
        ],
      );
      return;
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    // ignore: use_build_context_synchronously
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => QuizScreen(
                quizCategories: selectedCategories,
                questionType: selectedQuestionType)));
  }
}
