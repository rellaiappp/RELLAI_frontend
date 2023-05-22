// import 'dart:math';

// import 'package:flutter/foundation.dart';
// import 'package:rellai_frontend/models/project.dart';
// import 'package:rellai_frontend/models/quote.dart';
// import 'package:rellai_frontend/models/user.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rellai_frontend/models/invite.dart';
// import 'package:rellai_frontend/models/relation.dart';
// import 'package:rellai_frontend/services/email.dart';

// class FirestoreCRUD {
//   bool createUser(AppUser user, String id) {
//     try {
//       FirebaseFirestore db = FirebaseFirestore.instance;
//       db.collection('users').doc(id).set(user.toFirestore());
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<AppUser?> getUser(String userId) async {
//     FirebaseFirestore db = FirebaseFirestore.instance;
//     final ref = db.collection("users").doc(userId).withConverter(
//           fromFirestore: AppUser.fromFirestore,
//           toFirestore: (AppUser city, _) => city.toFirestore(),
//         );
//     final docSnap = await ref.get();
//     final user = docSnap.data(); // Convert to City object
//     return user;
//   // }

//   Future<bool> createRelation(
//     String userId,
//     String projectId,
//     String role,
//   ) async {
//     try {
//       final now = DateTime.now().microsecondsSinceEpoch;
//       final newRelation = Relation(
//         userId: userId,
//         projectId: projectId,
//         role: role,
//         createdAt: now,
//       );

//       final docRef = await FirebaseFirestore.instance
//           .collection('relations')
//           .add(newRelation.toFirestore());

//       await docRef.update({'id': docRef.id});

//       return true;
//     } catch (error) {
//       return false;
//     }
//   }

//   Future<List<Map<String, dynamic>>> getProjectIdsAndRoles(
//       String userId) async {
//     try {
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('relations')
//           .where('user_id', isEqualTo: userId)
//           .get();

//       final projectIdsAndRoles = querySnapshot.docs.map((doc) {
//         final data = doc.data();
//         return {'project_id': data['project_id'], 'role': data['role']};
//       }).toList();

//       return projectIdsAndRoles;
//     } catch (e) {
//       print('Si è verificato un errore durante la lettura dei dati 1: $e');
//       return [];
//     }
//   }

//   Future<bool> createInvite(
//       String userMail, String projectId, String role, String senderId) async {
//     try {
//       final now = DateTime.now().microsecondsSinceEpoch;
//       final newInvite = Invite(
//         id: '',
//         email: userMail,
//         projectId: projectId,
//         senderId: senderId,
//         role: role,
//         accepted: false,
//         rejected: false,
//         createdAt: now,
//       );
//       final docRef = await FirebaseFirestore.instance
//           .collection('invites')
//           .add(newInvite.toFirestore());

//       await docRef.update({'id': docRef.id});
//       MailgunMailer().sendInviteEmail(userMail);
//       return true;
//     } catch (error) {
//       return false;
//     }
//   }

//   Future<bool> acceptInvite(Invite invite, String userId) async {
//     try {
//       final docRef =
//           FirebaseFirestore.instance.collection('invites').doc(invite.id);
//       await docRef.update({'accepted': true});
//       await createRelation(userId, invite.projectId, invite.role);
//       final projRef = FirebaseFirestore.instance
//           .collection('projects')
//           .doc(invite.projectId);
//       await projRef.update({'accepted': true});
//       return true;
//     } catch (error) {
//       return false;
//     }
//   }

//   Future<bool> rejectInvite(Invite invite) async {
//     try {
//       final docRef =
//           FirebaseFirestore.instance.collection('invites').doc(invite.id);
//       await docRef.update({'rejected': true});
//       final projRef = FirebaseFirestore.instance
//           .collection('projects')
//           .doc(invite.projectId);
//       await projRef.update({'rejected': true});
//       return true;
//     } catch (error) {
//       return false;
//     }
//   }

//   Future<List<Invite>> getUserInvites(String userEmail) async {
//     try {
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('invites')
//           .where('email', isEqualTo: userEmail)
//           .where('accepted', isEqualTo: false)
//           .where('rejected', isEqualTo: false) // Corretto 'emal' in 'email'
//           .get();
//       print(userEmail);
//       print(
//           'Inizio a richiedere gli inviti'); // Corretto 'comicio a hiedere gli inviti'
//       final invites = querySnapshot.docs.map((doc) {
//         print(querySnapshot.docs.length);
//         final data = doc.data();
//         final invite = Invite.fromJson(data);
//         print(invite);
//         return invite;
//       }).toList();

//       return invites;
//     } catch (e) {
//       print('Si è verificato un errore durante la lettura dei dati 2: $e');
//       return [];
//     }
//   }

//   Future<List<Project>> getProjectsByUserId(String userId) async {
//     try {
//       List<Project> projects = [];
//       final projectsAndRoles = await getProjectIdsAndRoles(userId);
//       for (final projectAndRole in projectsAndRoles) {
//         try {
//           final project = await getProjectById(projectAndRole['project_id']);
//           if (project != null) {
//             project.role = projectAndRole['role'];
//             projects.add(project);
//           }
//         } catch (e) {
//           print(e);
//         }
//       }
//       return projects;
//     } catch (e) {
//       print('Si è verificato un errore durante la lettura dei dati 3: $e');
//       return [];
//     }
//   }

//   void printLongString(String longString) {
//     const int chunkSize = 800;
//     for (int i = 0; i < longString.length; i += chunkSize) {
//       int end = (i + chunkSize < longString.length)
//           ? i + chunkSize
//           : longString.length;
//       print(longString.substring(i, end));
//     }
//   }

//   Future<Project?> getProjectById(String projectId) async {
//     try {
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('projects')
//           .where('id', isEqualTo: projectId)
//           .get();

//       final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
//           querySnapshot.docs;
//       if (docs.isNotEmpty) {
//         final data = docs.first.data();
//         printLongString(data.toString());
//         final project = Project.fromFirestore(docs.first, null);
//         return project;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       print('Si è verificato un errore durante la lettura dei dati 4: $e');
//       return null;
//     }
//   }

//   Future<bool> createProject(Project project, String userId) async {
//     try {
//       CollectionReference projectsCollection =
//           FirebaseFirestore.instance.collection('projects');
//       project.timestamp = DateTime.now().microsecondsSinceEpoch;

//       DocumentReference docRef =
//           await projectsCollection.add(project.toFirestore());
//       docRef.update({'id': docRef.id});
//       createRelation(userId, docRef.id, "owner");
//       createInvite(project.client.email, docRef.id, "client", userId);
//       return true;
//     } catch (e) {
//       print("Error creating new project: $e");
//       return false;
//     }
//   }

//   Future<bool> acceptProject(String projectId, String userId) async {
//     try {
//       final docRef =
//           FirebaseFirestore.instance.collection('projects').doc(projectId);
//       await docRef.update({'accepted': true});
//       return true;
//     } catch (error) {
//       return false;
//     }
//   }

//   Future<bool> rejectProject(String projectId, String userId) async {
//     try {
//       final docRef =
//           FirebaseFirestore.instance.collection('projects').doc(projectId);
//       await docRef.update({'rejected': true});
//       return true;
//     } catch (error) {
//       return false;
//     }
//   }

//   Future<bool> createQuote(Quote quote, String projectId) async {
//     try {
//       final docRef =
//           FirebaseFirestore.instance.collection('projects').doc(projectId);
//       await docRef.update({
//         'quotations': FieldValue.arrayUnion([quote.toJson()])
//       });
//       return true;
//     } catch (error) {
//       return false;
//     }
//   }

//   // Funzione per aggiornare la proprietà "accepted" a true nel database
//   Future<bool> acceptQuote(Project project) async {
//     try {
//       // Otteniamo un riferimento al documento della citazione nel database
//       DocumentReference quoteRef =
//           FirebaseFirestore.instance.collection('projects').doc(project.id);
//       // Utilizziamo il metodo "update" per aggiornare la proprietà "accepted" a true
//       await quoteRef.update(project.toFirestore());
//       return true;
//     } catch (error) {
//       return false;
//     }
//   }

// // Funzione per aggiornare la proprietà "rejected" a true nel database
//   Future<bool> rejectQuote(Project project) async {
//     try {
//       // Otteniamo un riferimento al documento della citazione nel database
//       DocumentReference quoteRef =
//           FirebaseFirestore.instance.collection('projects').doc(project.id);
//       // Utilizziamo il metodo "update" per aggiornare la proprietà "accepted" a true
//       await quoteRef.update(project.toFirestore());
//       return true;
//     } catch (error) {
//       return false;
//     }
//   }

//   Future<bool> createVO(
//       Quote quote, String projectId, String quotationId) async {
//     try {
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('projects')
//           .where('id', isEqualTo: projectId)
//           .get();

//       final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
//           querySnapshot.docs;
//       if (docs.isEmpty) {
//         return false;
//       }
//       Project project = Project.fromFirestore(docs.first, null);
//       for (int i = 0; i < project.quotations!.length; i++) {
//         if (project.quotations![i].id == quotationId) {
//           project.quotations![i].variationOrders.add(quote);
//           break;
//         }
//       }
//       await docs.first.reference.update(
//           {'quotations': project.quotations!.map((q) => q.toJson()).toList()});
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<List<dynamic>> getInviteByMailDetails(String userEmail) async {
//     try {
//       List<dynamic> result = [];
//       final invites = await getUserInvites(userEmail);
//       for (int i = 0; i < invites.length; i++) {
//         final project = await getProjectById(invites[i].projectId);
//         final user = await getUser(invites[i].senderId);
//         result.add({'project': project, 'user': user, 'invite': invites[i]});
//       }
//       return result;
//     } catch (e) {
//       print('Si è verificato un errore durante la lettura degli inviti: $e');
//       return [];
//     }
//   }
// }
