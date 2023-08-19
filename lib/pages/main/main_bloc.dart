
import 'dart:async';

import 'package:contact_app/core/hive/hive_helper.dart';
import 'package:contact_app/pages/main/main_events.dart';
import 'package:contact_app/pages/main/main_ui_state.dart';

import '../../core/models/contact_data.dart';

class MainBloc {
  final HiveHelper _hiveHelper;
  final _stateController = StreamController<MainUIState>();

  List<ContactData> contacts = [];

  MainBloc(this._hiveHelper) {
    _getAllContact();
  }


  Future<void> _getAllContact() async {
    var contacts = await _hiveHelper.getAllContact();
    _stateController.sink.add(MainUIState(state: UIState.success,list: contacts));
  }

  void onEventDispatcher(MainEvent event) {
    if(event is AddEvent) {
      var time = DateTime.now().millisecondsSinceEpoch;
      var contact = ContactData(time, event.name, event.phone, event.isMale);
      contacts.add(contact);
      _hiveHelper.addContact(contact);
      _stateController.sink.add(MainUIState(state: UIState.success,list: contacts));
    } else if(event is DeleteEvent) {
      _hiveHelper.deleteContact(event.contactData);
      contacts.removeWhere((element) => element.id == event.contactData.id);
      _stateController.sink.add(MainUIState(state: UIState.success,list: contacts));
    }
  }

  Stream<MainUIState> get stream => _stateController.stream;
}