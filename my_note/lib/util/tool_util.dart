//Date compare "xxxx年xx月xx日"
bool timeCompare(String date1String, String date2String) {
  final str1 = date1String
      .replaceAll('年', '-')
      .replaceAll('月', '-')
      .replaceAll('日', '').split('-');

  final str2 = date2String
      .replaceAll('年', '-')
      .replaceAll('月', '-')
      .replaceAll('日', '').split('-');
  final date1 = DateTime(int.parse(str1[0]),int.parse(str1[1]),int.parse(str1[2]));
  final date2 = DateTime(int.parse(str2[0]),int.parse(str2[1]),int.parse(str2[2]));
  return date1.compareTo(date2) > 0;
}
