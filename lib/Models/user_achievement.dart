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

  // TODO: Endpoint this
  // Future<List<AppAchievement>> getAchievements(int userId) async {
  //   var ids = await Supabase.instance.client.from('userachievements').select('achievementid').eq('userid', userId);
  //   List<AppAchievement> ans=List.empty();
  //   for(var json in await Supabase.instance.client.from('appachievement').select().inFilter('id', ids)) {
  //     ans.add(AppAchievement.from(json));
  //   }
  //   return ans;
  // }
}