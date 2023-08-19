import 'package:contact_app/pages/add/add_contact_page.dart';
import 'package:contact_app/pages/main/main_bloc.dart';
import 'package:contact_app/pages/main/main_events.dart';
import 'package:contact_app/pages/main/main_ui_state.dart';
import 'package:flutter/material.dart';

import '../../di/hive_module.dart';

class MainPage extends StatefulWidget {
  static const String route = "/contacts";

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainBloc bloc;

  @override
  void initState() {
    bloc = getIt.get<MainBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Contacts",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var snapshotData = snapshot.data!;
            switch (snapshotData.state) {
              case UIState.init:
                return const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: Icon(Icons.hourglass_empty_outlined),
                  ),
                );

              case UIState.success:
                return snapshotData.list.isEmpty ? const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: Text("No Contacts")
                  ),
                ): Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                            itemCount: snapshotData.list.length,
                            itemBuilder: (context, index) {
                              if (snapshot.data != null) {
                                var data = snapshotData.list[index];
                                return SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 40,
                                            height: 40,
                                            child: Image.asset(data.isMale!
                                                ? "assets/images/man.png"
                                                : "assets/images/woman.png"),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                data.name ?? "",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                data.phone ?? "",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          const Spacer(
                                            flex: 1,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              bloc.onEventDispatcher(
                                                  DeleteEvent(data));
                                            },
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.red.shade200,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return SizedBox(child: Container());
                            }))
                  ],
                );
              case UIState.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case UIState.error:
                return Center(
                  child: Text(snapshotData.errorMessage),
                );
            }
          }
          return const Center(
            child: Text(
              "Error",
            ),
          );
        },
        stream: bloc.stream,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddContactPage.route);
        },
        child: const Center(
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
