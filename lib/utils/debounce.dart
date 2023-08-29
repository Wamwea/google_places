




import 'dart:async';

class TextDebounce {
  Timer? _debounceTimer;
  TextDebounce();

  void debouncing({required Function() fn, int waitForMs = 500}) {
    // if this function is called before 500ms [waitForMs] expired
    //cancel the previous call
    _debounceTimer?.cancel();
    // set a 500ms [waitForMs] timer for the [fn] to be called
    _debounceTimer = Timer(Duration(milliseconds: waitForMs), fn);
  }
}