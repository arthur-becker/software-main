import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:mobile_app/models/ModelProvider.dart';

/// Provides utility methods to interface with Amplify user database.
///
class DataRepository {
  Future<User?> getUserById(String userId) async {
    try {
      final users = await Amplify.DataStore.query(
        User.classType,
        where: User.ID.eq(userId),
      );
      return users.isNotEmpty ? users.first : null;
    } catch (e) {
      rethrow;
    }
  }

  Future<User> createUser({
    required String userId,
    required String firstName,
    required String lastName,
    String? bio,
  }) async {
    // todo: placeholder -> how is this handled?
    List<Permission> permissions = [
      Permission(
          allowedEntities: const [""], permissionType: PermissionType.ADMIN)
    ];

    final newUser = User(
      id: userId,
      firstName: firstName,
      lastName: lastName,
      permissions: permissions,
      bio: bio,
      schemeVersion: 1020,
    );
    try {
      await Amplify.DataStore.save(newUser);
      return newUser;
    } catch (e) {
      rethrow;
    }
  }
}
