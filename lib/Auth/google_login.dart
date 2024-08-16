import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // Đăng nhập với Google và thêm dữ liệu vào Firestore
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Đăng xuất Google nếu đã đăng nhập trước đó
      await GoogleSignIn().signOut();
      // Gửi yêu cầu đăng nhập Google
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      // Kiểm tra nếu người dùng hủy đăng nhập
      if (gUser == null) {
        return null; // Người dùng đã hủy đăng nhập
      }

      // Xác thực Google
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Tạo credential từ token Google
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Kết thúc -> Đăng nhập Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Thêm dữ liệu người dùng vào Firestore
      await addUserDataToFirestore(userCredential.user);

      return userCredential;
    } catch (e) {
      print('Đăng nhập Google thất bại: $e');
      return null; // Hoặc bạn có thể ném lại lỗi để xử lý sau
    }
  }

  // Hàm thêm dữ liệu người dùng vào Firestore
  Future<void> addUserDataToFirestore(User? user) async {
    if (user != null) {
      // Kiểm tra nếu người dùng chưa có trong Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.email)
          .get();

      if (!userDoc.exists) {
        // Thêm dữ liệu người dùng vào Firestore
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.email)
            .set({
          'email': user.email,
          'username': user.displayName,
          'idApartmentBuilding': "a",
          'idApartmentFloor': "a",
          'idApartment': "a",
          'idApartmentName': 999,
          'role': "2",
          'CODE': "chuanhapcode",
          'Phone': user.phoneNumber ?? "",
          'CCCD': "",
          'Address': "",
          'Sex': "1",
        });
      }
    }
  }
}
