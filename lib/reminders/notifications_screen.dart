// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rehearse_app/models/reminder_model.dart';
import 'package:rehearse_app/shared/dialog_state.dart';
import 'package:rehearse_app/reminders/notifications_state.dart';
import 'package:rehearse_app/services/database_helper.dart';
import 'package:rehearse_app/shared/shared.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  late Future<List<Reminder>> remindersFuture =
      _databaseHelper.getRemindersDatabase();
  List<Reminder> reminders = [];
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: 'option.select',
        child: ChangeNotifierProvider<NotificationsState>(
            create: (_) => NotificationsState(),
            builder: (context, child) {
              var state = Provider.of<NotificationsState>(context);
              String selectedDate = state.dateToString();
              String selectedTime = state.timeToString(state.getAccurateTime());
              return Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                      leading: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          FontAwesomeIcons.backward,
                          color: accentLight,
                          size: 30,
                        ),
                      ),
                      centerTitle: true,
                      title: Text(
                          pageIndex == 0
                              ? "Novi podsjetnik"
                              : "Zakazani podsjetnici",
                          style: pBold.copyWith(color: white))),
                  body: Builder(builder: (context) {
                    if (pageIndex == 0) {
                      return Container(
                        color: Colors.black12,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Podsjeti me...",
                              style: dialogText.copyWith(
                                color: accentLight,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 50),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            final DateTime? dateSelected =
                                                await showDatePicker(
                                              context: context,
                                              initialDate:
                                                  state.getAccurateDate(),
                                              firstDate:
                                                  state.getAccurateDate(),
                                              lastDate: DateTime(
                                                  DateTime.now().year + 2,
                                                  12,
                                                  31),
                                              helpText: "Unesi koji dan",
                                              cancelText: "Odustani",
                                            );
                                            if (dateSelected != null) {
                                              state.date = dateSelected;
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 50,
                                            backgroundColor: black,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors.green[200]!)),
                                          ),
                                          child: Text(
                                            selectedDate,
                                            style: p2.copyWith(
                                                color: Colors.green[200]),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "u  ",
                                        textAlign: TextAlign.right,
                                        style: p1.copyWith(
                                          color: Colors.green[200],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () async {
                                          TimeOfDay? time =
                                              await showTimePicker(
                                                  context: context,
                                                  initialTime:
                                                      state.getAccurateTime(),
                                                  initialEntryMode:
                                                      TimePickerEntryMode
                                                          .inputOnly,
                                                  hourLabelText: "Sati",
                                                  minuteLabelText: "Minuta",
                                                  helpText: "Unesi u koliko",
                                                  cancelText: "Odustani");
                                          if (time != null) {
                                            state.time = time;
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 50,
                                          backgroundColor: black,
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.green[200]!)),
                                        ),
                                        child: Text(
                                          selectedTime,
                                          style: p2.copyWith(
                                              color: Colors.green[200]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const SizedBox(width: 30),
                                      Flexible(
                                        child: TextField(
                                          controller: state.controller,
                                          cursorColor: Colors.green[100],
                                          maxLines: 1,
                                          maxLength: 70,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 30.0,
                                          ),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _setReminder(state, context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                elevation: 50,
                                                backgroundColor:
                                                    Colors.green[500],
                                                shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color: Colors
                                                            .green[600]!))),
                                            child: Text("Zakaži podsjetnik",
                                                style:
                                                    p1.copyWith(color: white)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container(
                      alignment: Alignment.center,
                      color: Colors.black12,
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: FutureBuilder(
                          future: remindersFuture,
                          builder: (context, snapshot) {
                            reminders = snapshot.data ?? [];
                            if (!snapshot.hasData || reminders.isEmpty) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Sve isposlato!",
                                      style: p1.copyWith(color: white)),
                                  ElevatedButton.icon(
                                      icon: const Icon(
                                        FontAwesomeIcons.arrowLeft,
                                        color: white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          pageIndex = 0;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: const RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.white))),
                                      label: Text(
                                        "Zakaži novi",
                                        style: p1.copyWith(color: white),
                                      ))
                                ],
                              );
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return ListView.builder(
                                itemCount: reminders.length,
                                itemBuilder: (context, index) {
                                  DateTime date = DateTime.parse(
                                      reminders[index].Iso8601scheduledTime);
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: ListTile(
                                      shape: const RoundedRectangleBorder(
                                          side: BorderSide(color: white)),
                                      tileColor: Colors.black87,
                                      title: Text(
                                        "${date.day}. ${date.month}. | ${state.timeToString(TimeOfDay.fromDateTime(date))}",
                                        style: pBold.copyWith(color: white),
                                      ),
                                      subtitle: Text(
                                          reminders[index].reminderContent),
                                      trailing: IconButton.outlined(
                                        onPressed: () async {
                                          DialogData.BuildDialog(
                                            context,
                                            Text("Otkazati?", style: pBold),
                                            Text(
                                              "Da li sigurno želiš obrisati ${reminders[index].reminderContent}?",
                                              style: p2,
                                            ),
                                            [
                                              TextButton(
                                                  child: Text(
                                                    "Odustani",
                                                    style: p3.copyWith(
                                                        color: black),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  }),
                                              ElevatedButton.icon(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors.red)),
                                                  icon: const Icon(
                                                      Icons.sticky_note_2,
                                                      color: white),
                                                  label: Text(
                                                    "Obriši",
                                                    style: p3.copyWith(
                                                        color: white),
                                                  ),
                                                  onPressed: () {
                                                    RehearseAppNotificationManager
                                                        .cancelNotification(
                                                            reminders[index]
                                                                .id!);
                                                    _databaseHelper
                                                        .deleteReminder(
                                                            reminders[index]);
                                                    setState(() {
                                                      remindersFuture =
                                                          _databaseHelper
                                                              .getRemindersDatabase();
                                                    });
                                                    Navigator.of(context).pop();
                                                  }),
                                            ],
                                          );
                                        },
                                        icon: const Icon(
                                          FontAwesomeIcons.trashCan,
                                          color: white,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                            return const CircularProgressIndicator(
                              color: Colors.greenAccent,
                            );
                          }),
                    );
                  }),
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: pageIndex,
                    selectedItemColor: Colors.green[500],
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(
                          FontAwesomeIcons.solidBell,
                          size: 20,
                        ),
                        label: 'Zakaži novi',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          FontAwesomeIcons.list,
                          size: 20,
                        ),
                        label: 'Lista zakazanih',
                      ),
                    ],
                    backgroundColor: Colors.black38,
                    onTap: (int idx) {
                      setState(() {
                        pageIndex = idx;
                        _getUnsentNotifications();
                      });
                    },
                  ));
            }));
  }

  void _setReminder(NotificationsState state, BuildContext context) async {
    if (DateTime.now().compareTo(state.getAccurateDate()) >= 0 &&
        TimeOfDay.now().compareTo(state.getAccurateTime()) >= 0) {
      DismissableBottomSheet.show(
        context: context,
        backgroundColor: Colors.red,
        durationInSeconds: 2,
        content: Text("Odaberi validno vrijeme za podsjetnik!",
            style: p1.copyWith(color: white)),
      );
      state.date = DateTime.now();
      state.time = TimeOfDay(
          hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute + 1);
      return;
    }
    if (state.controller.text == "") {
      DismissableBottomSheet.show(
          context: context,
          durationInSeconds: 2,
          content: Text(
            "Nije problem zovnut, al moraš nam reć što",
            style: p1.copyWith(color: white),
            textAlign: TextAlign.center,
          ));
      return;
    }
    final DateTime scheduledDate = state.getAccurateDate();
    final TimeOfDay scheduledTime = state.getAccurateTime();
    int reminderId =
        await _databaseHelper.getLastID(_databaseHelper.tableReminders);
    DateTime finalDate = DateTime(scheduledDate.year, scheduledDate.month,
        scheduledDate.day, scheduledTime.hour, scheduledTime.minute);
    await RehearseAppNotificationManager.scheduleNotification(
      id: reminderId + 1,
      body: state.controller.text,
      date: finalDate,
    );
    _databaseHelper.insertReminder(
      Reminder(
        Iso8601scheduledTime: finalDate.toIso8601String(),
        reminderContent: state.controller.text,
      ),
    );
    remindersFuture = _databaseHelper.getRemindersDatabase();
    state.controller.text = "";
    DismissableBottomSheet.show(
        context: context,
        durationInSeconds: 3,
        backgroundColor: Colors.green,
        content: Text("Dogovoreno! U ta doba te zvrcnemo!",
            style: p1.copyWith(color: white)));
  }

  _getUnsentNotifications() {
    for (var reminder in reminders) {
      if (DateTime.parse(reminder.Iso8601scheduledTime)
              .compareTo(DateTime.now()) <=
          0) {
        _databaseHelper.deleteReminder(reminder);
      }
    }
    remindersFuture = _databaseHelper.getRemindersDatabase();
  }
}
