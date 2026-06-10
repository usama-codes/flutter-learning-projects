import 'package:stacked/stacked.dart';

class AppVM extends BaseViewModel {
  bool isChat = true;
  bool isStatus = false;
  bool isCall = false;

  void showChat() {
    isChat = true;
    isCall = false;
    isStatus = false;
    notifyListeners();
  }

  void showStatus() {
    isChat = false;
    isCall = false;
    isStatus = true;
    notifyListeners();
  }

  void showCalls() {
    isChat = false;
    isCall = true;
    isStatus = false;
    notifyListeners();
  }
}
