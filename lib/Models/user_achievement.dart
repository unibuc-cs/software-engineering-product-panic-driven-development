import 'package:mediamaster/Models/app_achievement.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserAchievement {
  // Data
  int userId;
  int achievementId;
  DateTime unlockDate;

  UserAchievement(
      {required this.userId,
      required this.achievementId,
      required this.unlockDate});

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

  Map<String, dynamic> toSupa() {
    return {
      "userid": userId,
      "achievementid": achievementId,
      "unlockDate": unlockDate,
    };
  }

  factory UserAchievement.from(Map<String, dynamic> json) {
    return UserAchievement(
      userId: json["userid"],
      achievementId: json["achievementid"],
      unlockDate: json["unlockdate"],
    );
  }

  Future<List<AppAchievement>> getAchievements(int userId) async {
    var ids = await Supabase.instance.client.from("userachievements").select("achievementid").eq("userid", userId);
    List<AppAchievement> ans=List.empty();
    for(var json in await Supabase.instance.client.from("appachievement").select().inFilter("id", ids)) {
      ans.add(AppAchievement.from(json));
    }
    return ans;
  }
}