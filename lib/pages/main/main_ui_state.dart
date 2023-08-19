import '../../core/models/contact_data.dart';

enum UIState { init, success, loading, error }

class MainUIState {
  UIState state = UIState.init;
  List<ContactData> list = [];
  String errorMessage = "";
  bool isLoading = false;

  MainUIState(
      {required this.state,
      this.list = const [],
      this.errorMessage = "",
      this.isLoading = false});
}
