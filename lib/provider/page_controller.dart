import 'package:hooks_riverpod/hooks_riverpod.dart';

class PageController extends StateNotifier<int> {
  PageController() : super(0);

  void setPage(int index) {
    state = index;
  }
}

final pageProvider = StateNotifierProvider<PageController, int>((ref) {
  return PageController();
});
