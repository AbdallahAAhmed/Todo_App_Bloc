import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/cubit/states.dart';

import '../archive_task_screen.dart';
import '../done_task_screen.dart';
import '../new_task_screen.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialStates());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archTasks = [];

  List screens = const [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchiveTaskScreen(),
  ];
  List<String> titles = [
    'New Task',
    'Done Task',
    'Archive Task',
  ];

  void changeIndex(int index)
  {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;

  void createDatabase()
  {
    openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database, version) {
          print('database created');
          database
              .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
              .then(
                (value) {
              print('table Created');
            },
          ).catchError(
                (error) {
              print('there is error on ${error.toString()}');
            },
          );
        },
        onOpen: (database) {
          getDataFromDatabase(database);
          print('database opened');
        }).then((value) {
          database = value;
          emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase(
      {
        required title,
        required time,
        required date,
      }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES ("$title", "$time", "$date", "new")')
          .then((value) {
        print('$value insert successfully');
        emit(AppInsertToDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error when insert new Record ${error.toString()}');
      });
      return await null;
    });
  }

  void getDataFromDatabase(database)
  {
    newTasks = [];
    doneTasks = [];
    archTasks = [];

    emit(AppGetFromDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {

      value.forEach((element) {
        if(element['status'] == 'new') {
          newTasks.add(element);
        } else if(element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archTasks.add(element);
        }
      });

      emit(AppGetFromDatabaseState());
    });
  }


  void updateData
      ({
    required String status,
    required int id,
}) async {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteTask({ required int id })
  {
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?',
      [id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteTaskFromDatabaseState());
    });
  }


}