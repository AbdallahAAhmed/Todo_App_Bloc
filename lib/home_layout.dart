// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubit/cubit.dart';
import 'package:todo/cubit/states.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class HomeLayout extends StatelessWidget {

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state)
        {
          if(state is AppInsertToDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state)
        {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body: state is! AppGetFromDatabaseLoadingState
                ? cubit.screens[cubit.currentIndex]
                : const Center(child: CircularProgressIndicator()),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: ()
              {
                showModalBottomSheet(context: context, builder: (context) =>
                    Container(
                      color: Colors.grey[200],
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: titleController,
                              keyboardType: TextInputType.text,
                              validator: (String? value) {
                                if(value!.isEmpty) {
                                  return 'title must not be empty';
                                }
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: timeController,
                              keyboardType: TextInputType.datetime,
                              validator: (String? value) {
                                if(value!.isEmpty) {
                                  return 'Time must not be empty';
                                }
                              },
                              onTap: (){
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  timeController.text = value!.format(context).toString();
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: dateController,
                              validator: (String? value) {
                                if(value!.isEmpty) {
                                  return 'Date must not be empty';
                                }
                              },
                              onTap: (){
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2021),
                                  lastDate: DateTime(2022),
                                ).then((value) {
                                  dateController.text = DateFormat.yMMMd().format(value!);
                                });
                              },
                            ),
                            ElevatedButton(
                              onPressed: (){
                                if(formKey.currentState!.validate()) {
                                  cubit.insertToDatabase(
                                      title: titleController.text,
                                      time: timeController.text,
                                      date: dateController.text,
                                  );
                                }
                              },
                              child: const Text('Submit'),
                            ),
                          ],
                        ),
                      ),
                    ),
                );
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (int value) {
                cubit.changeIndex(value);
              },
              currentIndex: cubit.currentIndex,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Task'),
                BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Done'),
                BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Archived'),
              ],
            ),
          );
        },
      ),
    );
  }



}
