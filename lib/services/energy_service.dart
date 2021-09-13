// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/models.dart';

class NotEnoughEnergy extends Error {}

class NotEnoughCoins extends Error {}

class EnergyService {
  static final learnerRef =
      FirebaseFirestore.instance.collection('learners').withConverter<Learner>(
            fromFirestore: (snapshot, _) => Learner.fromJson(snapshot.data()!),
            toFirestore: (learner, _) => learner.toJson(),
          );

  static final planetRef =
      FirebaseFirestore.instance.collection('planets').withConverter<Planet>(
            fromFirestore: (snapshot, _) => Planet.fromJson(snapshot.data()!),
            toFirestore: (planet, _) => planet.toJson(),
          );

  static Future<void> buyEnergyWithCoins(String user) async {
    final doc = await learnerRef.doc(user).get();
    final l = doc.data()!;

    if (l.coins < 100) throw NotEnoughCoins();

    await learnerRef
        .doc(user)
        .update({'energy': l.energy + 100, 'coins': l.coins - 100});
  }

  static Future<void> buyEnergy(String user) async {
    final doc = await learnerRef.doc(user).get();
    final l = doc.data()!;

    await learnerRef.doc(user).update({'energy': l.energy + 100});
  }

  static Future<void> completeLog(String user) async {
    final doc = await learnerRef.doc(user).get();
    final l = doc.data()!;

    if (l.energy < 10) throw NotEnoughEnergy();

    final mined = l.mined + 5;

    if (mined >= 100) {
      // Fetch the next planet
      final planetDoc = await planetRef.doc(l.currentPlanet).get();
      final p = planetDoc.data()!;

      await learnerRef.doc(user).update({
        'energy': l.energy - 5,
        'mined': mined - 100,
        'current_planet': p.next,
        'coins': l.coins + 100,
      });
    } else {
      await learnerRef
          .doc(user)
          .update({'energy': l.energy - 5, 'mined': mined});
    }
  }

  static Future<void> createChallenge(String user) async {
    final doc = await learnerRef.doc(user).get();
    final l = doc.data()!;

    if (l.energy < 5) throw NotEnoughEnergy();

    await learnerRef.doc(user).update({
      'energy': l.energy - 5,
    });
  }

  static Future<bool> completeChallenge(String user) async {
    final doc = await learnerRef.doc(user).get();
    final l = doc.data()!;

    final mined = l.mined + 5;

    if (mined >= 100) {
      // Fetch the next planet
      final planetDoc = await planetRef.doc(l.currentPlanet).get();
      final p = planetDoc.data()!;

      await learnerRef.doc(user).update({
        'mined': mined - 100,
        'current_planet': p.next,
        'coins': l.coins + 100
      });
    } else {
      await learnerRef.doc(user).update({'mined': mined});
    }

    return true;
  }
}
