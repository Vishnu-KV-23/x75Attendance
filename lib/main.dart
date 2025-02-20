import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AttendanceState(),
      child: MaterialApp(
        title: 'Attendance Tracker',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: HomePage(),
      ),
    );
  }
}

class AttendanceState extends ChangeNotifier {
  double result = 0;

  void calculateDutyLeave(double attendedHours, double totalHours) {
    result = (0.75 * totalHours) - attendedHours;
    notifyListeners();
  }

  void calculateMinPeriods(double attendedHours, double totalHours) {
    result = ((0.75 * totalHours) - attendedHours) / 0.25;
    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = DutyLeaveFinder();
      case 1:
        page = MinPeriodCounter();
      default:
        throw UnimplementedError('No widget for $selectedIndex');
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: MediaQuery.of(context).size.width >= 600,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.calculate),
                  label: Text('DutyLeave Finder'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.timer),
                  label: Text('MinPeriod Counter'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}

class DutyLeaveFinder extends StatelessWidget {
  final TextEditingController attendedController = TextEditingController();
  final TextEditingController totalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AttendanceState>();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: attendedController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Attended Hours'),
            ),
            TextField(
              controller: totalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Total Hours'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                double attended = double.tryParse(attendedController.text) ?? 0;
                double total = double.tryParse(totalController.text) ?? 0;
                appState.calculateDutyLeave(attended, total);
              },
              child: Text('Submit'),
            ),
            SizedBox(height: 10),
            Text('Required Hours: ${appState.result.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}

class MinPeriodCounter extends StatelessWidget {
  final TextEditingController attendedController = TextEditingController();
  final TextEditingController totalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AttendanceState>();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: attendedController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Attended Hours'),
            ),
            TextField(
              controller: totalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Total Hours'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                double attended = double.tryParse(attendedController.text) ?? 0;
                double total = double.tryParse(totalController.text) ?? 0;
                appState.calculateMinPeriods(attended, total);
              },
              child: Text('Submit'),
            ),
            SizedBox(height: 10),
            Text('Required Periods: ${appState.result.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
