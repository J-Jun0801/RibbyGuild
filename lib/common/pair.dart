class Pair<T1, T2> {
  final T1 first;
  final T2 second;

  Pair({
    required this.first,
    required this.second,
  });

  factory Pair.fromJson(Map<String, dynamic> json) {
    return Pair(
      first: json['first'],
      second: json['second'],
    );
  }
}