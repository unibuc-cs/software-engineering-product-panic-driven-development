import 'general/model.dart';

class UserAchievement implements Model {
  // Data
  String userId;
  int achievementId;
  DateTime unlockDate;

  UserAchievement({
    required this.userId,
    required this.achievementId,
    required this.unlockDate
  });

  static String get endpoint => 'userachievements';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return userId == (other as UserAchievement).userId &&
        achievementId == other.achievementId;
  }

  @override
  int get hashCode => Object.hash(userId, achievementId);

  dynamic get id => achievementId;

  @override
  Map<String, dynamic> toJson() {
    return {
      'userid': userId,
      'achievementid': achievementId,
      'unlockdate': unlockDate.toIso8601String(),
    };
  }

  @override
  factory UserAchievement.from(Map<String, dynamic> json) {
    return UserAchievement(
      userId: json['userid'],
      achievementId: json['achievementid'],
      unlockDate: DateTime.parse(json['unlockdate']),
    );
  }
}