import 'dart:math';

class BackendService {

  /// simulated backend api call that return a list of strings
  Future<List<String>> futureSearch(String text) async {
    await Future.delayed(Duration(milliseconds: 10000));
    final random = Random();
    // return null; // simulate an error
    List<String> list = <String>[];
    for (int i=1; i<=10; i++) {
      if (random.nextBool()) {
        if (random.nextBool()) list.add("$text ***");
        else list.add("***$text");
      }else list.add("Result $i");
    }
    return list;
  }
}