import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarScreen extends StatefulWidget {
  final String license; // Licencia única del usuario

  const CalendarScreen({super.key, required this.license});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _routines = {}; // Rutinas asignadas
  String _filterOption = 'day'; // Filtro inicial: 'day', 'week', 'month'

  @override
  void initState() {
    super.initState();
    _loadRoutinesFromFirestore(); // Cargar rutinas específicas del usuario al iniciar
  }

  Future<void> _loadRoutinesFromFirestore() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(widget.license)
          .collection('routines')
          .get();
      Map<DateTime, List<String>> loadedRoutines = {};

      for (var doc in snapshot.docs) {
        DateTime date = DateTime.parse(doc['date']);
        List<String> routines = List<String>.from(doc['routines']);
        loadedRoutines[date] = routines;
      }

      setState(() {
        _routines = loadedRoutines;
      });
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar las rutinas: $e');
    }
  }

  Future<void> _saveRoutineToFirestore(DateTime day, List<String> routines) async {
    try {
      await _firestore
          .collection('users')
          .doc(widget.license)
          .collection('routines')
          .doc(day.toIso8601String())
          .set({
        'date': day.toIso8601String(),
        'routines': routines,
      });
    } catch (e) {
      Get.snackbar('Error', 'No se pudo guardar la rutina: $e');
    }
  }

  Future<void> _deleteRoutineFromFirestore(DateTime day) async {
    try {
      await _firestore
          .collection('users')
          .doc(widget.license)
          .collection('routines')
          .doc(day.toIso8601String())
          .delete();
    } catch (e) {
      Get.snackbar('Error', 'No se pudo eliminar la rutina: $e');
    }
  }

  void _addRoutineToExistingDay(DateTime day, String routine) {
    if (_routines[day]?.contains(routine) ?? false) {
      Get.snackbar(
        'Rutina Duplicada',
        'La rutina de $routine ya está asignada a este día.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    List<String> updatedRoutines;

    if (_routines[day] != null) {
        // Si ya hay rutinas para este día, creamos una copia y agregamos la nueva rutina
        updatedRoutines = List<String>.from(_routines[day]!);
        updatedRoutines.add(routine);
    } else {
        // Si no hay rutinas, inicializamos una nueva lista con la rutina
        updatedRoutines = [routine];
    }

      // Guardamos en Firestore y actualizamos el estado local
      _saveRoutineToFirestore(day, updatedRoutines);
      setState(() {
        _routines[day] = updatedRoutines;
    });

    Get.snackbar(
      'Rutina Agregada',
      'Has agregado la rutina de $routine para ${day.toLocal().toString().split(' ')[0]}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _deleteAllRoutinesForDay(DateTime day) {
    _deleteRoutineFromFirestore(day);
    setState(() {
      _routines.remove(day);
    });
  }

  void _showRoutinePopup(DateTime selectedDay) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rutinas para ${selectedDay.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (_routines[selectedDay] != null &&
                  _routines[selectedDay]!.isNotEmpty)
                ..._routines[selectedDay]!.map((routine) {
                  return ListTile(
                    title: Text(routine),
                  );
                }).toList()
              else
                const Text('No hay rutinas asignadas.'),
              const SizedBox(height: 20),
              const Divider(),
              const Text(
                'Agregar Rutinas:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _addRoutineToExistingDay(selectedDay, 'Pecho');
                      _refreshPopup(selectedDay);
                    },
                    child: const Text('Pecho'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addRoutineToExistingDay(selectedDay, 'Espalda');
                      _refreshPopup(selectedDay);
                    },
                    child: const Text('Espalda'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addRoutineToExistingDay(selectedDay, 'Brazo');
                      _refreshPopup(selectedDay);
                    },
                    child: const Text('Brazo'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addRoutineToExistingDay(selectedDay, 'Pierna');
                      _refreshPopup(selectedDay);
                    },
                    child: const Text('Pierna'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _deleteAllRoutinesForDay(selectedDay);
                  Navigator.pop(context); // Cierra la ventana flotante
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Eliminar Todas'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Cierra la ventana flotante
                },
                child: const Text('Cerrar'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _refreshPopup(DateTime selectedDay) {
    Navigator.pop(context); // Cierra la ventana flotante actual
    _showRoutinePopup(selectedDay); // La vuelve a abrir con los datos actualizados
  }

  List<MapEntry<DateTime, List<String>>> _getFilteredRoutines() {
    DateTime now = DateTime.now();
    if (_filterOption == 'day') {
      return _routines.entries
          .where((entry) => entry.key.isAfter(now))
          .toList()
        ..sort((a, b) => a.key.compareTo(b.key));
    } else if (_filterOption == 'week') {
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
      return _routines.entries
          .where((entry) =>
              entry.key.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
              entry.key.isBefore(endOfWeek.add(const Duration(days: 1))))
          .toList()
        ..sort((a, b) => a.key.compareTo(b.key));
    } else if (_filterOption == 'month') {
      DateTime startOfMonth = DateTime(now.year, now.month, 1);
      DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);
      return _routines.entries
          .where((entry) =>
              entry.key.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
              entry.key.isBefore(endOfMonth.add(const Duration(days: 1))))
          .toList()
        ..sort((a, b) => a.key.compareTo(b.key));
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('users')
          .doc(widget.license)
          .collection('routines')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _routines = _parseFirestoreData(snapshot.data!);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Calendario de Rutinas'),
          ),
          body: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  if (_routines[selectedDay] != null &&
                      _routines[selectedDay]!.isNotEmpty) {
                    _showRoutinePopup(selectedDay);
                  } else {
                    _showRoutineDialog(selectedDay);
                  }
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                eventLoader: (day) => _routines[day] ?? [],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _filterOption = 'day';
                      });
                    },
                    child: const Text('Siguiente Día'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _filterOption = 'week';
                      });
                    },
                    child: const Text('Semana'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _filterOption = 'month';
                      });
                    },
                    child: const Text('Mes'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: _getFilteredRoutines().map((entry) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        title: Text(
                          'Rutinas para ${entry.key.toLocal().toString().split(' ')[0]}:',
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: entry.value
                              .map((routine) => Text('- $routine'))
                              .toList(),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Map<DateTime, List<String>> _parseFirestoreData(QuerySnapshot snapshot) {
    Map<DateTime, List<String>> routines = {};
    for (var doc in snapshot.docs) {
      DateTime date = DateTime.parse(doc['date']);
      List<String> routineList = List<String>.from(doc['routines']);
      routines[date] = routineList;
    }
    return routines;
  }

  void _showRoutineDialog(DateTime selectedDay) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Selecciona una Rutina'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  _addRoutineToExistingDay(selectedDay, 'Pecho');
                  Navigator.pop(context);
                },
                child: const Text('Pecho'),
              ),
              ElevatedButton(
                onPressed: () {
                  _addRoutineToExistingDay(selectedDay, 'Espalda');
                  Navigator.pop(context);
                },
                child: const Text('Espalda'),
              ),
              ElevatedButton(
                onPressed: () {
                  _addRoutineToExistingDay(selectedDay, 'Brazo');
                  Navigator.pop(context);
                },
                child: const Text('Brazo'),
              ),
              ElevatedButton(
                onPressed: () {
                  _addRoutineToExistingDay(selectedDay, 'Pierna');
                  Navigator.pop(context);
                },
                child: const Text('Pierna'),
              ),
            ],
          ),
        );
      },
    );
  }
}

