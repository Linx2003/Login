import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  static String? userId;
  static String? userName;
  static String? email;
  static String? profilePhotoUrl;

  static void setUserId(String id) {
    userId = id;
  }

  static Future<void> fetchUserDataByUsernameOrEmail(String identifier) async {
    try {
      final usernameQuerySnapshot = await FirebaseFirestore.instance
          .collection('Usuario')
          .where('Usuario', isEqualTo: identifier)
          .limit(1)
          .get();

      final emailQuerySnapshot = await FirebaseFirestore.instance
          .collection('Usuario')
          .where('Email', isEqualTo: identifier)
          .limit(1)
          .get();

      if (usernameQuerySnapshot.docs.isNotEmpty) {
        final userData = usernameQuerySnapshot.docs.first.data() as Map<String, dynamic>;
        final userId = usernameQuerySnapshot.docs.first.id;
        setUserId(userId); // Guardar el ID en la variable userId de UserData

        userName = userData['Usuario'];
        email = userData['Email'];
        profilePhotoUrl = userData['ImagenPerfil'];

        await fetchUserDataByUserId(userId);
      } else if (emailQuerySnapshot.docs.isNotEmpty) {
        final userData = emailQuerySnapshot.docs.first.data() as Map<String, dynamic>;
        final userId = emailQuerySnapshot.docs.first.id;
        setUserId(userId); // Guardar el ID en la variable userId de UserData

        userName = userData['Usuario'];
        email = userData['Email'];
        profilePhotoUrl = userData['ImagenPerfil'];

        await fetchUserDataByUserId(userId);
      } else {
        // El usuario no existe en la base de datos
        userName = null;
        email = null;
        profilePhotoUrl = null;
        userId = null; // Limpiar el ID en caso de no encontrar el usuario
      }
    } catch (e) {
      // Manejar el error en caso de que la consulta falle
      print('Error al obtener los datos del usuario: $e');
    }
  }

  static Future<void> fetchUserDataByUserId(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('Usuario')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        userName = userData['Usuario'];
        email = userData['Email'];
        profilePhotoUrl = userData['ImagenPerfil'];

        if (profilePhotoUrl == null || profilePhotoUrl!.isEmpty) {
          // La imagen de perfil no está disponible en la base de datos, buscar y guardar la URL
          final imageUrl = await searchProfilePhotoUrl(userId); // Buscar la URL de la imagen

          if (imageUrl != null) {
            // Actualizar la URL de la imagen en Firestore
            await updateUserProfilePhotoUrl(userId, imageUrl);
            profilePhotoUrl = imageUrl; // Actualizar la URL de la imagen en la variable local
          }
        }

        // Aquí puedes hacer lo que necesites con los datos del usuario
      }
    } catch (e) {
      // Manejar el error en caso de que la consulta falle
      print('Error al obtener los datos del usuario: $e');
    }
  }

  static Future<String?> searchProfilePhotoUrl(String userId) async {
    try {
      // Aquí debes implementar la lógica para buscar la URL de la imagen de perfil
      // Puedes utilizar cualquier método que corresponda a tu aplicación
      // Por ejemplo, podrías buscar la URL en otro documento o colección de Firestore,
      // o utilizar Firebase Storage si has almacenado la imagen allí.
      // A continuación, se muestra un ejemplo de cómo podrías hacerlo utilizando Firestore.

      final userDoc = await FirebaseFirestore.instance
          .collection('Usuario')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final profilePhotoUrl = userData['ImagenPerfil'];

        return profilePhotoUrl;
      }
    } catch (e) {
      print('Error al buscar la URL de la imagen de perfil: $e');
    }

    return null;
  }

  static Future<void> updateUserProfilePhotoUrl(String userId, String imageUrl) async {
    try {
      // Actualizar la URL de la imagen de perfil en Firestore
      await FirebaseFirestore.instance
          .collection('Usuario')
          .doc(userId)
          .update({'ImagenPerfil': imageUrl});
    } catch (e) {
      print('Error al actualizar la URL de la imagen de perfil: $e');
    }
  }
}
