import 'package:dont_forget/main.dart';
import 'package:dont_forget/util/main_app_drawer.dart';
import 'package:dont_forget/routes/medication_entry.dart';
import 'package:dont_forget/models/medication.dart';
import 'package:dont_forget/util/confirm_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme/apptheme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    // Load the list of medications from local storage
    loadMedications().then((medications) {
      setState(() {
        medMgr.medications
            .clear(); // Clear the existing list before adding new medications
        medMgr.medications.addAll(medications);
      });
    });
  }

  // Add a new medication to the list
  void _addMedication(Medication newMed) {
    setState(() {
      medMgr.addMedication(newMed);
    });
  }

  // Update an existing medication in the list
  void _updateMedication(Medication existingMed, Medication newMed) {
    try {
      setState(() {
        medMgr.updateMedication(existingMed, newMed);
      });
    } catch (e) {
      print('Error updating medication: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: Builder(builder: (context) {
        return Scaffold(
          // Add a floating action button to add a new medication
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MedicationEntry(
                    onAdd: (newMed) {
                      _addMedication(newMed);
                    },
                    onUpdate: (_, __) {}, // Do nothing
                  ),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
          // Display the list of medications
          body: medMgr.medications.isEmpty
              ? const Center(
                  child: Text(
                      'No medications added yet\nTap the + button to add one!'),
                )
              : ListView.separated(
                  itemCount: medMgr.medications.length,
                  itemBuilder: (context, index) {
                    final med = medMgr.medications[index];
                    // Display a ListTile for each medication
                    return ListTile(
                      selected: true,
                      selectedTileColor:
                          const Color.fromARGB(255, 141, 197, 243),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      onLongPress: () {
                        if (kDebugMode) {
                          print('Long press on ${med.name}');
                        }
                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(100, 100, 100, 100),
                          items: [
                            PopupMenuItem(
                              child: ListTile(
                                leading: const Icon(Icons.edit),
                                title: const Text('Edit'),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MedicationEntry(
                                        existingMed: medMgr.medications[index],
                                        onAdd: (_) {}, // Do nothing
                                        onUpdate: (oldMed, newMed) {
                                          setState(() {
                                            _updateMedication(oldMed, newMed);
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            PopupMenuItem(
                              child: ListTile(
                                leading: const Icon(Icons.delete),
                                title: const Text('Delete'),
                                onTap: () {
                                  Navigator.pop(context);
                                  showConfirmDialog(context, () {
                                    setState(
                                      () {
                                        if (medMgr.medications[index]
                                                .notificationId !=
                                            null) {
                                          notificationService
                                              .removeNotification(medMgr
                                                  .medications[index]
                                                  .notificationId!);
                                        }
                                        medMgr.removeMedication(
                                            medMgr.medications[index]);
                                      },
                                    );
                                  }, 'Are you sure you want to delete this medication?');
                                },
                              ),
                            ),
                          ],
                        );
                      },
                      leading: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: const Icon(Icons.medication)),
                      title: Text(
                          '${med.count} x ${med.name} - ${med.dose} ${med.unit.displayString}'),
                      subtitle: kDebugMode
                          ? Text(
                              '${med.frequencyString} - Next reminder at ${med.nextReminderDateString} - Notification ID: ${med.notificationId}')
                          : Text(
                              '${med.frequencyString} - Next reminder at ${med.nextReminderDateString}'),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: 10,
                  ),
                ),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 61, 110, 202),
            title: const Text("Don't Forget"),
          ),
          // Add the main drawer to the Scaffold
          drawer: const MainAppDrawer(),
        );
      }),
    );
  }
}