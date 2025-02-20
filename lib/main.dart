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
  int roundedResult = 0;
  bool showResults = false;

  void calculateDutyLeave(double attendedHours, double totalHours) {
    result = (0.75 * totalHours) - attendedHours;
    roundedResult = result.ceil();
    showResults = true;
    notifyListeners();
  }

  void calculateMinPeriods(double attendedHours, double totalHours) {
    result = ((0.75 * totalHours) - attendedHours) / 0.25;
    roundedResult = result.ceil();
    showResults = true;
    notifyListeners();
  }

  void reset() {
    result = 0;
    roundedResult = 0;
    showResults = false;
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
        break;
      case 1:
        page = MinPeriodCounter();
        break;
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
            Text("Duty Leave Finder", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Calculate the minimum number of duty leaves required to get to 75% attendance.", style: TextStyle(fontSize: 14, color: Colors.grey)),
            SizedBox(height: 20),
            TextField(
              controller: attendedController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(labelText: 'Attended Hours', border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: totalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Total Hours', border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                double attended = double.tryParse(attendedController.text) ?? 0;
                double total = double.tryParse(totalController.text) ?? 0;
                appState.calculateDutyLeave(attended, total);
              },
              child: Text('Submit'),
            ),
            if (appState.showResults) ...[
              SizedBox(height: 20),
              Text('Required Hours: ${appState.result.toStringAsFixed(2)}'),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('Final Count: ${appState.roundedResult}', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  attendedController.clear();
                  totalController.clear();
                  appState.reset();
                },
                child: Text('Done'),
              ),
            ],
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
            Text("Minimum Hour Counter", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Calculate minimum additional hours required for 75% attendance.", style: TextStyle(fontSize: 14, color: Colors.grey)),
            SizedBox(height: 20),
            TextField(
              controller: attendedController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(labelText: 'Attended Hours', border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: totalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Total Hours', border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                double attended = double.tryParse(attendedController.text) ?? 0;
                double total = double.tryParse(totalController.text) ?? 0;
                appState.calculateMinPeriods(attended, total);
              },
              child: Text('Submit'),
            ),
            if (appState.showResults) ...[
              SizedBox(height: 20),
              Text('Required Periods: ${appState.result.toStringAsFixed(2)}'),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  attendedController.clear();
                  totalController.clear();
                  appState.reset();
                },
                child: Text('Done'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}