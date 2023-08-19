import 'package:contact_app/di/hive_module.dart';
import 'package:contact_app/pages/main/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../main/main_events.dart';

class AddContactPage extends StatefulWidget {
  static const String route = "/add_countact";

  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  late MainBloc bloc;
  bool isEmptyName = true;
  bool isEmptyPhone = true;

  @override
  void initState() {
    
    nameController.addListener(() { 
      isEmptyName = nameController.text.isEmpty;
    });

    nameController.addListener(() {
      isEmptyPhone = phoneController.text.isEmpty;
    });
    
    bloc = getIt.get<MainBloc>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Contact"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 32,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: Colors.white54, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: "Name"),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white38,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: "+998 ** *** ** **",
                ),
              ),
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.all(12),
            child: ElevatedButton(
              style: const ButtonStyle(
                minimumSize: MaterialStatePropertyAll(
                  Size(double.infinity, 56),
                ),
              ),
              onPressed: () {
                if (isEmptyName && isEmptyPhone) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Name or Phone is empty'),
                  ));
                } else {
                  bloc.onEventDispatcher(
                    AddEvent(
                      name: nameController.text,
                      phone: phoneController.text,
                      isMale: true,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Add",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
