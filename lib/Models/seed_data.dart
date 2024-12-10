import 'package:supabase_flutter/supabase_flutter.dart';

void addSeedData() async {
  final supabase=Supabase.instance.client;

  if (await supabase.from("tag").count() == 0) {
    var tagsToAdd = [
      "Singleplayer",
      "Multiplayer",
      "Casual",
      "Competitive",
      "VR",
      "Indie",
      "Co-Op",
      "Local Co-Op",
      "MMO",
    ];

    List<dynamic> toInsert = List.empty();

    for (String tagName in tagsToAdd) {
      toInsert.add(
        {"name": tagName}
      );
    }

    supabase.from("tag").insert(toInsert);
  }

  if (await supabase.from("genre").count() == 0) {
    var genresToAdd = [
      "Shooter",
      "Strategy",
      "Role Playing",
      "Survival",
      "Fighting",
      "Horror",
      "Sandbox",
      "Tower Defense",
      "Simulator",
      "Action",
      "Adventure",
      "Party Game",
      "Trivia",
      "Puzzle",
      "Board Game",
      "Sports",
      "Racing",
      "Rhythm",
      "Platformer",
      "Battle Royale",
      "Metroidvania",
      "Roguelike",
      "Soulslike",
      "Idle",
      "Open World",
      "Point and Click",
      "Real Time Strategy",
      "Visual Novel",
      "Superhero",
      "Stealth",
      "Detective",
      "Management",
      "Comedy",
      "Difficult",
      "Cooking",
      "MOBA",
    ];

    List<dynamic> toInsert = List.empty();

    for (String genreName in genresToAdd) {
      toInsert.add(
        {"name": genreName}
      );
    }

    supabase.from("genre").insert(toInsert);
  }
}
