import 'package:flutter/material.dart';
import 'Main/Main_page.dart';
import 'Main/Ticket_page.dart';
import 'calender.dart';

class BottomNavigationPage extends StatelessWidget {
  final Map<String, dynamic> user;

  BottomNavigationPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(user: user),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Map<String, dynamic> user;

  MyHomePage({required this.user});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;  // Current index of selected page

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = [
      MainPage(user: widget.user),
      CalendarPage(user: widget.user),
      TicketingPage(),
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;  // Update the selected index
      });
    }

    return Scaffold(
      body: Center(
        // Display the widget from _widgetOptions based on the selected index
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '메인',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '달력',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplane_ticket_outlined),
            label: '응모하기',
          ),
        ],
        selectedItemColor: Colors.black, // 색상을 검은색으로 설정
        unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,  // Which item is currently selected
        onTap: _onItemTapped,  // Handle tap
      ),
    );
  }
}
