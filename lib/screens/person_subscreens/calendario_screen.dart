import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _storage = GetStorage(); // Instancia de GetStorage
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _routines = {}; // Rutinas asignadas

  @override
  void initState() {
    super.initState();
    _loadRoutines(); // Cargar rutinas al iniciar
  }

  void _loadRoutines() {
    // Obtener rutinas guardadas de GetStorage
    Map<String, dynamic>? storedRoutines = _storage.read<Map<String, dynamic>>('routines');
    if (storedRoutines != null) {
      // Convertir las claves del mapa de String a DateTime
      setState(() {
        _routines = storedRoutines.map((key, value) {
          return MapEntry(DateTime.parse(key), List<String>.from(value));
        });
      });
    }
  }

  void _saveRoutines() {
    // Convertir las claves del mapa de DateTime a String antes de guardar
    Map<String, List<String>> routinesToSave = _routines.map((key, value) {
      return MapEntry(key.toIso8601String(), value);
    });
    _storage.write('routines', routinesToSave); // Guardar en GetStorage
  }

  @override
  Widget build(BuildContext context) {
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
              if (_routines[selectedDay] != null && _routines[selectedDay]!.isNotEmpty) {
                _showRoutinePopup(selectedDay); // Mostrar ventana flotante si hay rutinas
              } else {
                _showRoutineDialog(selectedDay); // Mostrar diálogo para asignar rutina
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
            eventLoader: (day) {
              return _routines[day] ?? [];
            },
          ),
        ],
      ),
    );
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
                  _assignRoutine(selectedDay, 'Pecho');
                },
                child: const Text('Pecho'),
              ),
              ElevatedButton(
                onPressed: () {
                  _assignRoutine(selectedDay, 'Espalda');
                },
                child: const Text('Espalda'),
              ),
              ElevatedButton(
                onPressed: () {
                  _assignRoutine(selectedDay, 'Brazo');
                },
                child: const Text('Brazo'),
              ),
              ElevatedButton(
                onPressed: () {
                  _assignRoutine(selectedDay, 'Pierna');
                },
                child: const Text('Pierna'),
              ),
            ],
          ),
        );
      },
    );
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
            ..._routines[selectedDay]!.map((routine) {
              return ListTile(
                title: Text(routine),
              );
            }).toList(),
            const SizedBox(height: 20),
            const Text(
              'Agregar más rutinas:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _addRoutineToExistingDay(selectedDay, 'Pecho');
                  },
                  child: const Text('Pecho'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _addRoutineToExistingDay(selectedDay, 'Espalda');
                  },
                  child: const Text('Espalda'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _addRoutineToExistingDay(selectedDay, 'Brazo');
                  },
                  child: const Text('Brazo'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _addRoutineToExistingDay(selectedDay, 'Pierna');
                  },
                  child: const Text('Pierna'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el modal
              },
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    },
  );
}

void _addRoutineToExistingDay(DateTime day, String routine) {
  setState(() {
    if (_routines[day] == null) {
      _routines[day] = [];
    }
    if (!_routines[day]!.contains(routine)) {
      // Agregar la rutina si no está ya en la lista
      _routines[day]!.add(routine);
      _saveRoutines(); // Guardar los cambios
      Get.snackbar(
        'Rutina Agregada',
        'Has agregado la rutina de $routine al ${day.toLocal().toString().split(' ')[0]}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Rutina Duplicada',
        'La rutina de $routine ya está asignada a este día.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  });
}

    
         

  void _assignRoutine(DateTime day, String routine) {
    setState(() {
      if (_routines[day] == null) {
        _routines[day] = [];
      }
      _routines[day]!.add(routine);
      _saveRoutines(); // Guardar rutinas después de cada asignación
    });
    Navigator.pop(context);
    Get.snackbar(
      'Rutina Asignada',
      'Has asignado la rutina de $routine para ${day.toLocal().toString().split(' ')[0]}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}


