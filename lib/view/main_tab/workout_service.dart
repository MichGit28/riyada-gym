import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutService {
  final CollectionReference workouts =
      FirebaseFirestore.instance.collection('workouts');

  Future<void> addWorkout(String docId, Map<String, dynamic> workoutData) {
    return workouts
        .doc(docId)
        .set(workoutData)
        .then((value) => print("Workout Added"))
        .catchError((error) => print("Failed to add workout: $error"));
  }

  Future<Map<String, dynamic>> getWorkout(String docId) async {
    return await workouts
        .doc(docId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot.data() as Map<String, dynamic>;
      } else {
        throw Exception("Workout not found");
      }
    });
  }

  // More Firestore methods related to workouts here, e.g. fetchWorkouts, deleteWorkout, etc.
}
