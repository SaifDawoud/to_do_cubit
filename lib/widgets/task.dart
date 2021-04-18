import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/app_cubit.dart';
import '../cubit/app_states.dart';

class Task extends StatefulWidget {
  Map myTask;

  Task({this.myTask});

  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.lightBlueAccent,
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: FittedBox(
                          child: Text(
                            "${widget.myTask["time"]}",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(child: Text("${widget.myTask["body"]}")),
                  Checkbox(
                    onChanged: (bool value) {
                      cubit.updateDb(widget.myTask["id"], value ? 1 : 0);
                    },
                    value: widget.myTask["isDone"] == 1 ? true : false,
                  ),
                ],
              ));
        },
        listener: (context, state) {});
  }
}
