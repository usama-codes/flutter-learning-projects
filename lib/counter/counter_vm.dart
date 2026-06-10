import 'package:stacked/stacked.dart';

class CounterVM extends BaseViewModel {
  int count = 0;
  int selectedIndex = 0;
  List<int> counter = [1, 2, 3, 4, 5];

  void add() {
    counter.add(++count);
    notifyListeners();
  }

  void selectIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void remove(int idx) {
    if (counter.isEmpty || idx < 0 || idx >= counter.length) {
      return;
    }
    counter.removeAt(idx);
    if (counter.isEmpty) {
      selectedIndex = 0;
    } else if (selectedIndex >= counter.length) {
      selectedIndex = counter.length - 1;
    }
    notifyListeners();
  }

  void reset() {
    counter.clear();
    selectedIndex = 0;
    count = 0;
    notifyListeners();
  }
}
