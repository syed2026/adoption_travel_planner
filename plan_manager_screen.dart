import 'package:flutter/material.dart';
import 'plan.dart';

class PlanManagerScreen extends StatefulWidget {
  @override
  _PlanManagerScreenState createState() => _PlanManagerScreenState();
}

class _PlanManagerScreenState extends State<PlanManagerScreen> {
  List<Plan> plans = [];

  void addPlan(String name, String desc, DateTime date, String priority) {
    setState(() {
      plans.add(Plan(name: name, description: desc, date: date, priority: priority));
      plans.sort((a, b) => b.priority.compareTo(a.priority)); // Sorting by priority
    });
  }

  void updatePlan(int index, String name, String desc, String priority) {
    setState(() {
      plans[index].name = name;
      plans[index].description = desc;
      plans[index].priority = priority;
      plans.sort((a, b) => b.priority.compareTo(a.priority));
    });
  }

  void markAsCompleted(int index) {
    setState(() {
      plans[index].isCompleted = !plans[index].isCompleted;
    });
  }

  void deletePlan(int index) {
    setState(() {
      plans.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adoption & Travel Planner')),
      body: ListView.builder(
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return GestureDetector(
            onDoubleTap: () => deletePlan(index),
            onLongPress: () => _editPlanDialog(index),
            child: Dismissible(
              key: Key(plan.name),
              onDismissed: (_) => markAsCompleted(index),
              background: Container(color: Colors.green),
              child: ListTile(
                title: Text(plan.name),
                subtitle: Text('${plan.description} | ${plan.priority} Priority'),
                trailing: plan.isCompleted ? Icon(Icons.check, color: Colors.green) : null,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPlanDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddPlanDialog() {
    String name = '';
    String desc = '';
    String priority = 'Medium';
    DateTime date = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Create Plan"),
          content: Column(
            children: [
              TextField(onChanged: (value) => name = value, decoration: InputDecoration(labelText: 'Plan Name')),
              TextField(onChanged: (value) => desc = value, decoration: InputDecoration(labelText: 'Description')),
              DropdownButton<String>(
                value: priority,
                items: ['Low', 'Medium', 'High'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) priority = value;
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                addPlan(name, desc, date, priority);
                Navigator.of(context).pop();
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _editPlanDialog(int index) {
    String name = plans[index].name;
    String desc = plans[index].description;
    String priority = plans[index].priority;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Plan"),
          content: Column(
            children: [
              TextField(onChanged: (value) => name = value, decoration: InputDecoration(labelText: 'Plan Name')),
              TextField(onChanged: (value) => desc = value, decoration: InputDecoration(labelText: 'Description')),
              DropdownButton<String>(
                value: priority,
                items: ['Low', 'Medium', 'High'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) priority = value;
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                updatePlan(index, name, desc, priority);
                Navigator.of(context).pop();
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
