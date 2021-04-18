import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/cubit/app_states.dart';

import 'package:to_do/widgets/separator.dart';
import '../cubit/app_cubit.dart';
import 'package:to_do/widgets/task.dart';

class HomeScreen extends StatelessWidget {
  TimeOfDay taskTime;

  TextEditingController timerController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AppCubit()..createDatabase(),
        child: BlocConsumer<AppCubit, AppStates>(
            listener: (context, state) {},
            builder: (context, state) {
              AppCubit cubit = AppCubit.get(context);
              return Scaffold(
                key: scaffoldKey,
                backgroundColor: Colors.lightBlueAccent,
                body: cubit.tasks.length == 0
                    ? Center(
                        child: Text("No Tasks Yet.. Add Some!",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                top: 60, left: 30, right: 30, bottom: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  child: Icon(
                                    Icons.list,
                                    size: 30,
                                    color: Colors.lightBlueAccent,
                                  ),
                                  backgroundColor: Colors.white,
                                  radius: 30,
                                ),
                                SizedBox(height: 10),
                                Text("Todoiea",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 40)),
                                Text(
                                  "${cubit.tasks.length} Tasks",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                                child: ListView.separated(
                                    itemBuilder: (context, index) => Task(
                                          myTask: cubit.tasks[index],
                                        ),
                                    separatorBuilder: (context, index) =>
                                        Separator(),
                                    itemCount: cubit.tasks.length),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                )),
                          ),
                        ],
                      ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => scaffoldKey.currentState
                      .showBottomSheet((context) => Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: bodyController,
                                  decoration: InputDecoration(
                                    hintText: "Type your task",
                                    prefixIcon:
                                        Icon(Icons.check_circle_outline),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                    controller: timerController,
                                    onTap: () {
                                      showPicker(context).then((value) =>
                                          timerController.text =
                                              value.format(context));
                                    },
                                    decoration: InputDecoration(
                                        hintText: "Pick time",
                                        suffixIcon: Icon(Icons.timer_rounded))),
                                ElevatedButton(
                                    onPressed: () {
                                      cubit
                                          .insertIntoDb(bodyController.text,
                                              timerController.text, 0)
                                          .then((db) {
                                        cubit.getTasks(cubit.database);
                                        bodyController.clear();
                                        timerController.clear();

                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child: Text("Add Task"))
                              ],
                            ),
                          )),
                  backgroundColor: Colors.lightBlueAccent,
                  child: Icon(
                    Icons.add,
                    size: 30,
                  ),
                ),
              );
            }));
  }

  Future<TimeOfDay> showPicker(BuildContext context) async {
    taskTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    return taskTime;
  }
}
