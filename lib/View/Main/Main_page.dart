import 'dart:async';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Sports/Basketball_page1.dart';
import 'Ticket_page.dart';

class MainPage extends StatefulWidget {
  final Map<String, dynamic> user;

  MainPage({required this.user});
  final List<Map<String, String>> sports = [
    {'name': '축구', 'image': 'lib/assets/images/soccer.png'},
    {'name': '농구', 'image': 'lib/assets/images/basketball.png'},
    {'name': '탁구', 'image': 'lib/assets/images/pingpong.png'},
    {'name': '클라이밍', 'image': 'lib/assets/images/climing.png'},
    {'name': '배구', 'image': 'lib/assets/images/volleyball.png'},
    {'name': '배드민턴', 'image': 'lib/assets/images/badminton.png'},
    {'name': '테니스', 'image': 'lib/assets/images/tennis.png'},
    {'name': '사이클', 'image': 'lib/assets/images/cycling.png'},
  ];


  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage <= 3) {
        _currentPage++;
      } else {
        _currentPage = 3;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.user['nickname']} 님 반갑습니다',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            height: 150,
            child: PageView(
              controller: _pageController,
              children: [
                Image.asset(
                  'lib/assets/images/banner_1.png',
                  fit: BoxFit.cover,
                ),
                Image.asset(
                  'lib/assets/images/banner_2.png',
                  fit: BoxFit.cover,
                ),
                Image.asset(
                  'lib/assets/images/banner_3.png',
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '종목별로 한눈에',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                  height: 200, // 높이를 고정
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: widget.sports.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (widget.sports[index]['name'] == '농구') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BasketballPage1(),
                              ),
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.asset(
                                  widget.sports[index]['image']!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                widget.sports[index]['name']!,
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              '파리올림픽 티켓 응모',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            height: 180,
            color: Colors.white,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TicketingPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(0), // 패딩을 없애서 이미지 크기 그대로 유지
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage('lib/assets/images/paris.png'), // 버튼에 사용할 이미지
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    width: 340, // 버튼의 너비
                    height: 200, // 버튼의 높이
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '일정',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38, width: 1.0),
                  ),
                  height: 400, // Example height for calendar
                  child: CustomTableCalendar(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomTableCalendar extends StatefulWidget {
  @override
  _CustomTableCalendarState createState() => _CustomTableCalendarState();
}

class _CustomTableCalendarState extends State<CustomTableCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 사용자 정의 헤더
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            '${_focusedDay.month}월', // 현재 포커스된 달 표시
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            onFormatChanged: (format) {
              // Do nothing to prevent format change
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            headerVisible: false, // 기본 헤더를 숨김
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month', // 달력 형식을 월로 고정
            },
          ),
        ),
      ],
    );
  }
}
