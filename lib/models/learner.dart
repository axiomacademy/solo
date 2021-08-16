class Log {
  final String type;
  final String mission;
  final int progressLevel;
  final String? progressLog;

  Log(
      {required this.type,
      required this.progressLevel,
      required this.mission,
      this.progressLog});

  Log.fromJson(Map<String, Object?> json)
      : type = json['type']! as String,
        mission = json['mission']! as String,
        progressLevel = json['progress_level']! as int,
        progressLog = json['progress_log'] as String?;

  Map<String, Object?> toJson() {
    return {
      'type': type,
      'progress_level': progressLevel,
      'progress_log': progressLog,
    };
  }
}

class Challenge {
  final String title;
  final String description;
  final String missionId;

  Challenge(
      {required this.title,
      required this.description,
      required this.missionId});

  Challenge.fromJson(Map<String, Object?> json)
      : title = json['title']! as String,
        description = json['description']! as String,
        missionId = json['mission_id']! as String;

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'description': description,
      'mission_id': missionId,
    };
  }
}

class ReviewCard {
  final String topText;
  final String bottomText;

  ReviewCard({required this.topText, required this.bottomText});

  ReviewCard.fromJson(Map<String, Object?> json)
      : topText = json['top_text']! as String,
        bottomText = json['bottom_text']! as String;

  Map<String, Object?> toJson() {
    return {
      'top_text': topText,
      'bottom_text': bottomText,
    };
  }
}

class Mission {
  final String title;
  final String purpose;

  Mission({required this.title, required this.purpose});

  Mission.fromJson(Map<String, Object?> json)
      : title = json['title']! as String,
        purpose = json['purpose']! as String;

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'purpose': purpose,
    };
  }
}

class Learner {
  final String email;
  final String name;
  final int energy;
  final int coins;

  Learner(
      {required this.email,
      required this.name,
      required this.energy,
      required this.coins});

  Learner.fromJson(Map<String, Object?> json)
      : email = json['email']! as String,
        name = json['name']! as String,
        energy = json['energy']! as int,
        coins = json['coins']! as int;

  Map<String, Object?> toJson() {
    return {
      'email': email,
      'name': name,
      'energy': energy,
      'coins': coins,
    };
  }
}
