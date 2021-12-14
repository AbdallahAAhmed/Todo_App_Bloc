import 'package:flutter/material.dart';
import 'package:todo/cubit/cubit.dart';

Widget buildTaskItem(
    Map task,
    context
    ) => Dismissible(
      key: Key(task['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:  [
            CircleAvatar(
              radius: 40.0,
              child: Text(
                  '${task['time']}',
                style: const TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${task['title']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  Text(
                    '${task['date']}',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20.0),
            IconButton(
              onPressed: ()
              {
                AppCubit.get(context).updateData(status: 'done', id: task['id']);
              },
              icon: const Icon(Icons.check, color: Colors.green,),
            ),
            IconButton(
              onPressed: ()
              {
                AppCubit.get(context).updateData(status: 'archive', id: task['id']);
              },
              icon: const Icon(Icons.archive),
            ),
          ],
        ),
      ),
      background: Container(color: Colors.red),
      onDismissed: (direction)
      {
        AppCubit.get(context).deleteTask(id: task['id']);
      },
    );

