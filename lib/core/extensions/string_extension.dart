extension StringExtension on String {
  String capitalize() {
    return toLowerCase().split(' ').map((word) {
      if (word.length > 1) {
        String leftText = word.substring(1, word.length);
        return word[0].toUpperCase() + leftText;
      } else {
        return word.toUpperCase();
      }
    }).join(' ');
  }
}
