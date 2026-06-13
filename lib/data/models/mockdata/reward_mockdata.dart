class Reward {
  final String season;
  final String reward;
  final String date;
  final String status;
  final String rank;

  Reward({
    required this.season,
    required this.reward,
    required this.date,
    required this.status,
    required this.rank,
  });
}

final Reward rewardMock = Reward(
  season: 'Q4 2024',
  date: 'Jan 1, 2024',
  reward: '500.0 USDT',
  status: 'Completed',
  rank: '#1',
);
