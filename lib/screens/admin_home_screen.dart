import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_manager_app/screens/add_event_screen.dart';
import 'package:events_manager_app/screens/edit_profile_screen.dart';
import 'package:events_manager_app/screens/loading_screen.dart';
import 'package:events_manager_app/screens/todo_screen.dart';
import 'package:events_manager_app/screens/add_event_screen.dart';
import 'package:events_manager_app/screens/edit_event_screen.dart';
import 'package:events_manager_app/utils/alert.dart';
import 'package:events_manager_app/utils/events.dart';
import 'package:events_manager_app/utils/todo.dart';
import 'package:events_manager_app/main.dart';
import 'package:events_manager_app/screens/welcome_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class AdminHomeScreen extends StatefulWidget {
  static const String id = '/admin';

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

String userName2 = '';

class _AdminHomeScreenState extends State<AdminHomeScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;
  int currIndex = 0;

  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  Map<String, Color> colorCodes = {
    '---' : Color(Colors.black.value),
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    setState(() {
      loadEvents();
    });
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    print('Called');
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> tabs = [
      Column(
        children: [

            // color: isDark ? Colors.red.shade300 : Colors.grey.shade200,
            TableCalendar<Event>(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: _onDaySelected,
              onRangeSelected: _onRangeSelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),

          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index].title}'),
                        title: Text('${value[index].title}'),
                        // subtitle: Text('${value[index].board}'),
                        leading: IconButton(
                          icon: Icon(
                            Icons.edit_road,
                          ),
                          onPressed: (){
                            editEventTitle = value[index].title;
                            editEventUid = value[index].uid;
                            // editEventBoard = value[index].board;
                            editEventDate = _focusedDay;
                            Navigator.pushNamed(context, EditEventScreen.id);
                          },
                        ),
                        trailing: IconButton(
                          icon: Icon(
                              Icons.playlist_add_sharp
                          ),
                          onPressed: (){
                            if(!myToDo.contains(value[index].uid)){
                              myToDo.add(value[index].uid);
                              FirebaseFirestore.instance.collection('users')
                                  .doc(email)
                                  .update({
                                'todo' : myToDo,
                              })
                                  .then((value) {
                                print('Added');
                                Navigator.pushNamed(context, LoadingScreen.id);
                              })
                                  .catchError((err) {
                                showAlert(context, err);
                              });
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'My Profile',
                style: TextStyle(

                  fontWeight: FontWeight.bold,
                  fontSize: 40.0,
                    fontStyle: FontStyle.italic,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(height: 20,),
              Text(
                'Name: ' + userName2,
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              SizedBox(height: 20,),
              Text(
                "You are an ADMIN",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: (){
                  Navigator.pushNamed(context, EditProfileScreen.id);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange),
                ),
                child: Text(
                    'Edit Profile'
                ),
              ),
            ],
          ),
        ),
      )
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Home',
        ),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, AddEventScreen.id);
            },
            icon: Icon(
              Icons.add_box,
            ),
          ),
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, ToDoScreen.id);
            },
            icon: Icon(
              Icons.list_alt_outlined,
            ),
          ),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.logout,
          ),
          onPressed: () async{
            auth.signOut();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();
            email = null;
            isAdmin = false;
            try{
              await FirebaseStorage.instance
                  .ref('profile.png')
                  .writeToFile(File(profileImagePath));
            } on FirebaseException catch (err){
              showAlert(context, err.toString());
            }
            Navigator.popAndPushNamed(context, WelcomeScreen.id);
          },
        ),
      ),
      body: tabs[currIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            label: 'Calendar',
            icon: Icon(
              Icons.calendar_today,
            )
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(
              Icons.person_pin_rounded,
            )
          ),
        ],
        currentIndex: currIndex,
        onTap: (val){
          setState(() {
            currIndex = val;
            print(currIndex);
          });
        },
      ),
    );
  }
}
