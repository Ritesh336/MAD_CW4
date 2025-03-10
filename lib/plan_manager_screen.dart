import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:table_calendar/table_calendar.dart';

class Plan {
  String name;
  String description;
  DateTime date;
  String status;
  String priority;

  Plan({
    required this.name,
    required this.description,
    required this.date,
    this.status = 'pending',
    this.priority = 'low'
  });
}

class PlanManagerScreen extends StatefulWidget {
  const PlanManagerScreen({Key? key}) : super(key: key);

  @override
  _PlanManagerScreenState createState() => _PlanManagerScreenState();
}

class _PlanManagerScreenState extends State<PlanManagerScreen> {
  List<Plan> plans = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void addPlan(Plan plan) {
    setState(() {
      plans.add(plan);
    });
  }

  void updatePlan(int index, Plan updatedPlan) {
    setState(() {
      plans[index] = updatedPlan;
    });
  }

  void deletePlan(int index) {
    setState(() {
      plans.removeAt(index);
    });
  }

  void toggleCompletion(int index) {
    setState(() {
      plans[index].status = plans[index].status == 'completed' ? 'pending' : 'completed';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plan Manager'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final item = plans[index];
                return Slidable(
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text('${item.description}, Due on ${item.date.toLocal()}'),
                    trailing: Text(item.status),
                  ),
                  startActionPane: ActionPane(
                    motion: DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => toggleCompletion(index),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        icon: Icons.check,
                        label: 'Complete',
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => deletePlan(index),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          // Implement edit functionality or show a modal to edit the plan
                        },
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Code to show a modal form to add a new plan
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Plan'),
                content: Text('Form to add a plan would be here.'),
              );
            },
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add New Plan',
      ),
    );
  }
}
