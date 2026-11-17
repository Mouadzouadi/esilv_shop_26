//Note du produit, imbriquée dans le JSON : "rating": {"rate": 3.9, "count": 120}
class Rating {
  final num rate;
  final int count;

  Rating({required this.rate, required this.count});

  Map<String, dynamic> toMap() {
    return {'rate': rate, 'count': count};
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(rate: map['rate'] as num, count: map['count'] as int);
  }
}
