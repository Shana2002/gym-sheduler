import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight;

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
        floatingActionButton: _addExercise(),
      ),
    );
  }

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

  List<Widget> _buildTabViews() {
    // Function to generate the children of TabBarView
    return [
      _dayFirstView(),
      Center(child: Text('Tab 2 content')),
    ];
  }

  Widget _dayFirstView() {
    return ListView(
      children: const [
        ListTile(
          title: Text("Worm up"),
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          subtitle: Text("15 min"),
          trailing: Icon(Icons.check_box_outline_blank),
        ),
        ListTile(
          title: Text("Push ups"),
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          subtitle: Text("10x10x10"),
          trailing: Icon(Icons.check_box_outline_blank),
        ),
        ListTile(
          title: Text("Bench Press"),
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
          subtitle: Text("10x8x8x6"),
          trailing: Icon(Icons.check_box_outline_blank),
        ),
      ],
    );
  }

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

  void _displayPopUp() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Add Exercise"),
            content: SizedBox(
              height: _deviceHeight * 0.30,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Exercise Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Time or Number of Sets',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
