import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Dashboard extends StatefulWidget {
  final token;

  const Dashboard({
    @required this.token,
    Key? key,
  }) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String userId;

  TextEditingController _todoTitle = TextEditingController();
  TextEditingController _todoDesc = TextEditingController();

  List? items;

  @override
  void initState() {
    super.initState();

    Map<String, dynamic> jwtDecodedToken =
        JwtDecoder.decode(widget.token);

    userId = jwtDecodedToken['_id'];

    getTodoList(userId);
  }

  // =========================
  // ADD TODO
  // =========================

  void addTodo() async {
    if (_todoTitle.text.isEmpty || _todoDesc.text.isEmpty) {
      print("Please enter title and description");
      return;
    }

    try {
      var regBody = {
        "userId": userId,
        "title": _todoTitle.text,
        "desc": _todoDesc.text
      };

      print("Adding Todo...");
      print("URL: $addtodo");
      print("Body: $regBody");

      var response = await http.post(
        Uri.parse(addtodo),
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode(regBody),
      );

      print("Add Todo Status Code: ${response.statusCode}");
      print("Add Todo Response: ${response.body}");

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == true) {
        // Clear input fields
        _todoTitle.clear();
        _todoDesc.clear();

        if (!mounted) return;

        // Close dialog
        Navigator.pop(context);

        // Refresh todo list
        getTodoList(userId);
      } else {
        print("Something went wrong while adding Todo");
      }
    } catch (e) {
      print("Add Todo Error: $e");
    }
  }

  // =========================
  // GET TODO LIST
  // =========================

  void getTodoList(String userId) async {
    try {
      var regBody = {
        "userId": userId
      };

      print("Getting Todo List...");
      print("URL: $getToDoList");
      print("Body: $regBody");

      var response = await http.post(
        Uri.parse(getToDoList),
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode(regBody),
      );

      print("Get Todo Status Code: ${response.statusCode}");
      print("Get Todo Response: ${response.body}");

      var jsonResponse = jsonDecode(response.body);

      if (!mounted) return;

      setState(() {
        items = jsonResponse['success'];
      });
    } catch (e) {
      print("Get Todo Error: $e");
    }
  }

  // =========================
  // DELETE TODO
  // =========================

  void deleteItem(String id) async {
    try {
      print("Deleting Todo ID: $id");
      print("Delete URL: $deleteTodo");

      var regBody = {
        "_id": id
      };

      var response = await http.post(
        Uri.parse(deleteTodo),
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode(regBody),
      );

      print("Delete Status Code: ${response.statusCode}");
      print("Delete Response: ${response.body}");

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == true) {
        print("Todo deleted successfully");

        // Refresh list after deleting
        getTodoList(userId);
      } else {
        print("Todo deletion failed");
      }
    } catch (e) {
      print("Delete Todo Error: $e");
    }
  }

  // =========================
  // BUILD UI
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // =========================
          // HEADER
          // =========================

          Container(
            padding: const EdgeInsets.only(
              top: 60.0,
              left: 30.0,
              right: 30.0,
              bottom: 30.0,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30.0,
                  child: Icon(
                    Icons.list,
                    size: 30.0,
                  ),
                ),

                const SizedBox(height: 10.0),

                const Text(
                  'ToDo with NodeJS + Mongodb',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8.0),

                Text(
                  '${items?.length ?? 0} Task',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),

          // =========================
          // TODO LIST
          // =========================

          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),

              child: Padding(
                padding: const EdgeInsets.all(8.0),

                child: items == null

                    // Loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )

                    // Todo List
                    : items!.isEmpty

                        // No todos
                        ? const Center(
                            child: Text(
                              "No Todos Yet",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          )

                        // List
                        : ListView.builder(
                            itemCount: items!.length,

                            itemBuilder: (context, index) {

                              final todo = items![index];

                              return Slidable(
                                key: ValueKey(todo['_id']),

                                // =========================
                                // SLIDE ACTION
                                // =========================

                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),

                                  children: [

                                    SlidableAction(
                                      backgroundColor:
                                          const Color(0xFFFE4A49),

                                      foregroundColor:
                                          Colors.white,

                                      icon: Icons.delete,

                                      label: 'Delete',

                                      onPressed: (context) {

                                        final id =
                                            todo['_id'].toString();

                                        print(
                                            "Delete button pressed: $id");

                                        deleteItem(id);
                                      },
                                    ),
                                  ],
                                ),

                                // =========================
                                // TODO CARD
                                // =========================

                                child: Card(
                                  borderOnForeground: false,

                                  child: ListTile(

                                    leading: const Icon(
                                      Icons.task,
                                    ),

                                    title: Text(
                                      '${todo['title']}',
                                    ),

                                    subtitle: Text(
                                      '${todo['desc']}',
                                    ),

                                    trailing: const Icon(
                                      Icons.arrow_back,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
          ),
        ],
      ),

      // =========================
      // ADD TODO BUTTON
      // =========================

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayTextInputDialog(context);
        },

        child: const Icon(
          Icons.add,
        ),

        tooltip: 'Add-ToDo',
      ),
    );
  }

  // =========================
  // ADD TODO DIALOG
  // =========================

  Future<void> _displayTextInputDialog(
      BuildContext context) async {

    return showDialog(
      context: context,

      builder: (context) {

        return AlertDialog(

          title: const Text(
            'Add To-Do',
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

              // =========================
              // TITLE
              // =========================

              TextField(
                controller: _todoTitle,

                keyboardType: TextInputType.text,

                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Title",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ).p4().px8(),

              // =========================
              // DESCRIPTION
              // =========================

              TextField(
                controller: _todoDesc,

                keyboardType: TextInputType.text,

                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Description",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ).p4().px8(),

              // =========================
              // ADD BUTTON
              // =========================

              ElevatedButton(
                onPressed: () {
                  addTodo();
                },

                child: const Text(
                  "Add",
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}