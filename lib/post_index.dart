import 'package:angular2/core.dart';

@Injectable()
class PostIndex {

  List<int> years = [2016, 2017];

  List<int> months(int year) {
    return [1, 2, 3, 4];
  }

  List<String> titles(int year, int month) {
    return ['My First Post', 'My Second Post'];
  }

  List getIndex({int year, int month}) {
    if (month != null) return titles(year, month);
    else if (year != null) return months(year);
    else return years;
  }

}
