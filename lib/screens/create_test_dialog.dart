import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:rehearse_app/main.dart';
import 'package:rehearse_app/screens/quiz_screen.dart';
import 'package:rehearse_app/shared/shared.dart';
import 'package:rehearse_app/models/note_model.dart';
import 'package:rehearse_app/utils/dialog_state.dart';

class CreateTestDialog extends StatefulWidget {
  const CreateTestDialog({super.key});

  @override
  State<CreateTestDialog> createState() => _CreateTestDialogState();
}

enum QuestionType { multipleChoice, writtenTest }

class _CreateTestDialogState extends State<CreateTestDialog> {
  QuestionType selectedQuestionType = QuestionType.multipleChoice;
  List<int> selectedCategories = [];
  bool allCategoriesSelected = false;
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
                  fixedSize: MaterialStateProperty.resolveWith<Size>(
                      (states) => const Size.fromHeight(10.0)),
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: MultiSelectDropDown(
                      hint: "Odaberi: ",
                      controller: _categorycontroller,
                      dropdownHeight: 90,
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
                      },
                      optionTextStyle: p2,
                      options: List.generate(
                          categories.length,
                          (index) => ValueItem<int>(
                              label: categories[index].name.capitalize(),
                              value: categories[index].categoryID)),
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
                      padding: MaterialStateProperty.resolveWith<EdgeInsets>(
                          (states) => const EdgeInsets.all(15)),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (states) => Colors.green)),
                  child: Text(
                    "GENERIŠI TEST",
                    style: pBold,
                  )),
            ],
          )),
    );
  }

  void validateOptions(BuildContext context) {
    if (_categorycontroller.selectedOptions.isEmpty) {
      return DialogData().BuildDialog(
        context,
        Text(
          "Nepotpun zahtjev",
          style: pBold,
        ),
        Text(
          "Odaberi bar jednu kategoriju!",
          textAlign: TextAlign.center,
          style: p2,
        ),
        [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (states) => Colors.red)),
            child: Text(
              "Probat ću.",
              style: p1.copyWith(color: white),
            ),
          ),
        ],
      );
    }
    selectedCategories = List.generate(
        _categorycontroller.selectedOptions.length,
        (index) => _categorycontroller.selectedOptions[index].value);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                QuizScreen(quizCategories: selectedCategories)));
  }
}
