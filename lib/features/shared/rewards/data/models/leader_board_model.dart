class LeaderboardModel {
  final int rank;
  final String name;
  final int xp;
  final bool isCurrentUser;

  const LeaderboardModel({
    required this.rank,
    required this.name,
    required this.xp,
    this.isCurrentUser = false,
  });

  String get initials => name.trim().split(' ').take(2).map((w) => w[0]).join();
}
