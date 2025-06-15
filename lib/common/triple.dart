class Triple<T1, T2, T3> {
  final T1 first;
  final T2 second;
  final T2 third;

  Triple({
    required this.first,
    required this.second,
    required this.third,
  });

  factory Triple.fromJson(Map<String, dynamic> json) {
    return Triple(
      first: json['first'],
      second: json['second'],
      third: json['third'],
    );
  }
}
