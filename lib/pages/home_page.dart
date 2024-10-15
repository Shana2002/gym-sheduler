import 'package:flutter/material.dart';
import 'package:gym_shedule/model/exercise.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Box? _box;
  late double _deviceHeight;
  String dropdownValue = 'Day 1';
  final List<String> list = ['Day 1', 'Day 2'];
  String? _title, _details;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("MY Shedule",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
          ),
          toolbarHeight: _deviceHeight * 0.1,
          backgroundColor: Colors.red,
          bottom: _dayBar(),
        ),
        body: TabBarView(children: _buildTabViews()),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _clearDate(),
            const SizedBox(
              width: 20,
            ),
            _addExercise(),
          ],
        ),
      ),
    );
  }

  // date showing Bar
  PreferredSizeWidget _dayBar() {
    return const TabBar(tabs: [
      Tab(
          icon: Text(
        "Day 1",
        style: TextStyle(fontSize: 20, color: Colors.black),
      )),
      Tab(
          icon: Text(
        "Day 2",
        style: TextStyle(fontSize: 20, color: Colors.black),
      )),
    ]);
  }

  // Dates Tab
  List<Widget> _buildTabViews() {
    return [
      _futureTaskList("Day 1"),
      _futureTaskList("Day 2"),
    ];
  }

  Widget _futureTaskList(String day) {
    return FutureBuilder(
        future: Hive.openBox('exercise'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            _box = snapshot.data;
            return _dayFirstView(day);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  // Day view
  Widget _dayFirstView(String day) {
    // Exercise _newe = Exercise(
    //     title: "Scott Down", details: "10x10x10", done: true, sheduleDate: "Day 2");
    // _box?.add(_newe.toMap());
    List? exercises = _box!.values.toList();

    List filterExercise = exercises
        .where((exercise) => Exercise.fromMap(exercise).sheduleDate == day)
        .toList();
    // exercises = null;
    return ListView.builder(
      itemCount: filterExercise.length,
      itemBuilder: (BuildContext context, int _index) {
        var exercisemap = filterExercise[_index];
        var exercise = Exercise.fromMap(exercisemap);
        int originalKey = _box!.keyAt(exercises.indexOf(exercisemap));
        return ListTile(
          title: Text(
            exercise.title,
            style: TextStyle(
                decoration: exercise.done ? TextDecoration.lineThrough : null),
          ),
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          subtitle: Text(exercise.details),
          trailing: Icon(exercise.done
              ? Icons.check_box_outlined
              : Icons.check_box_outline_blank),
          onTap: () {
            exercise.done = !exercise.done;
            _box!.put(originalKey, exercise.toMap());
            setState(() {});
          },
          onLongPress: () {
            _box!.delete(originalKey);
            setState(() {});
          },
        );
      },
    );
  }

  // add exersice tab
  Widget _addExercise() {
    return FloatingActionButton(
      onPressed: _displayPopUp,
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      child: const Icon(
        Icons.add,
        size: 40,
      ),
    );
  }

  // clear dates
  Widget _clearDate() {
    return FloatingActionButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Are Uou Sure to reset ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _resetAllExercises();
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      child: const Icon(
        Icons.restart_alt,
        size: 40,
      ),
    );
  }

  // add exercise pop up
  void _displayPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Exercise"),
          content: SizedBox(
            height: _deviceHeight * 0.35,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(
                          () {
                            _title = value;
                          },
                        );
                      },
                      decoration: const InputDecoration(
                        labelText: 'Exercise Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Time or Number of Sets',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(
                          () {
                            _details = value;
                          },
                        );
                      },
                    ),
                    DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (String? value) {
                        // Update the dropdown value inside the dialog's state
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    _rideButton(),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _rideButton() {
    return Container(
      margin: EdgeInsets.only(bottom: _deviceHeight! * 0.01),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            10,
          )),
      child: MaterialButton(
        onPressed: () {
          if (_title != null && _details != null) {
            var _exercise = Exercise(
                title: _title!,
                details: _details!,
                done: false,
                sheduleDate: dropdownValue);
            _box!.add(_exercise.toMap());
            setState(() {
              _title = null;
              _details = null;
              Navigator.pop(context);
            });
          }
        },
        child: const Text(
          "Add Exercise",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  void _resetAllExercises() {
    List exercises = _box!.values.toList();

    // Iterate over each exercise and set 'done' to false
    for (int i = 0; i < exercises.length; i++) {
      var exercisemap = exercises[i];
      var exercise = Exercise.fromMap(exercisemap);

      if (exercise.done) {
        exercise.done = false; // Set 'done' to false
        _box!.putAt(i, exercise.toMap()); // Update the Hive box
      }
    }

    // Refresh the UI to reflect the changes
    setState(() {});
  }
}
