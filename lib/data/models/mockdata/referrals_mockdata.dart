class Referrals {
  final String id;
  final String email;
  final String status;
  final String joinDate;

  Referrals({
    required this.id,
    required this.joinDate,
    required this.email,
    required this.status,
  });
}

class Commission {
  final String id;
  final String email;
  final String status;
  final String date;
  final String usdPrice;
  final String coinPrice;

  Commission({
    required this.id,
    required this.date,
    required this.email,
    required this.status,
    required this.usdPrice,
    required this.coinPrice,
  });
}

final Referrals mockReferral = Referrals(
  id: 'D320E080CBD',
  joinDate: 'Over 1 year ago - Jan 1, 2024',
  email: 'thanhbtt08@gmail.com',
  status: 'Active',
);
final Commission mockCommission = Commission(
  id: 'D320E080CBD',
  date: 'Over 1 year ago - Jan 1, 2024',
  email: 'thanhbtt08@gmail.com',
  status: 'Active',
  usdPrice: '100 USD',
  coinPrice: '200 USDT',
);
