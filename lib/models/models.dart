class ReviewCard {
  final String mission;
  final String topText;
  final String bottomText;
  final int rid;

  ReviewCard(
      {required this.mission,
      required this.topText,
      required this.bottomText,
      required this.rid});

  ReviewCard.fromJson(Map<String, Object?> json)
      : mission = json['mission']! as String,
        topText = json['top_text']! as String,
        bottomText = json['bottom_text']! as String,
        rid = json['rid']! as int;

  Map<String, Object?> toJson() {
    return {
      'mission': mission,
      'top_text': topText,
      'bottom_text': bottomText,
      'rid': rid,
    };
  }
}

class Challenge {
  final String mission;
  final String title;
  final String description;
  final bool completed;

  Challenge(
      {required this.mission,
      required this.title,
      required this.description,
      required this.completed});

  Challenge.fromJson(Map<String, Object?> json)
      : mission = json['mission']! as String,
        title = json['title']! as String,
        description = json['description']! as String,
        completed = json['completed']! as bool;

  Map<String, Object?> toJson() {
    return {
      'mission': mission,
      'title': title,
      'description': description,
      'completed': completed
    };
  }
}

class Log {
  final String type;
  final String mission;

  final int? progressLevel;
  final String? progressLog;

  final String? contentTitle;
  final String? contentReview;

  final String? challengeTitle;
  final String? challengeDescription;
  final String? challengeText;

  Log(
      {required this.type,
      required this.mission,
      this.progressLevel,
      this.progressLog,
      this.contentTitle,
      this.contentReview,
      this.challengeTitle,
      this.challengeDescription,
      this.challengeText});

  Log.fromJson(Map<String, Object?> json)
      : type = json['type']! as String,
        mission = json['mission']! as String,
        progressLevel = json['progress_level'] as int?,
        progressLog = json['progress_log'] as String?,
        contentTitle = json['content_title'] as String?,
        contentReview = json['content_review'] as String?,
        challengeTitle = json['challenge_title'] as String?,
        challengeDescription = json['challenge_description'] as String?,
        challengeText = json['challenge_text'] as String?;

  Map<String, Object?> toJson() {
    return {
      'type': type,
      'mission': mission,
      'progress_level': progressLevel,
      'progress_log': progressLog,
      'content_title': contentTitle,
      'content_review': contentReview,
      'challenge_title': challengeTitle,
      'challenge_description': challengeDescription,
      'challenge_text': challengeText
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

class Planet {
  final String name;
  final String system;
  final String next;

  Planet({required this.name, required this.system, required this.next});

  Planet.fromJson(Map<String, Object?> json)
      : name = json['name']! as String,
        system = json['system']! as String,
        next = json['next']! as String;

  Map<String, Object?> toJson() {
    return {'name': name, 'system': system, 'next': next};
  }
}

class Learner {
  final String email;
  final String name;
  final String currentPlanet;
  final int energy;
  final int coins;
  final int mined;

  Learner(
      {required this.email,
      required this.name,
      required this.energy,
      required this.mined,
      required this.currentPlanet,
      required this.coins});

  Learner.fromJson(Map<String, Object?> json)
      : email = json['email']! as String,
        name = json['name']! as String,
        energy = json['energy']! as int,
        currentPlanet = json['current_planet']! as String,
        mined = json['mined']! as int,
        coins = json['coins']! as int;

  Map<String, Object?> toJson() {
    return {
      'email': email,
      'name': name,
      'energy': energy,
      'coins': coins,
      'mined': mined,
      'current_planet': currentPlanet,
    };
  }
}
