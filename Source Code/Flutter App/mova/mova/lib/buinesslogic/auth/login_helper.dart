import 'dart:developer';
import 'dart:math' hide log;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:webtime_movie_ocean/presentation/utils/app_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../presentation/utils/app_colors.dart';
import '../../presentation/utils/app_images.dart';
import '../../presentation/utils/app_var.dart';
import '../../presentation/utils/routes/app_pages.dart';
import '../../presentation/utils/theme/theme.dart';
import '../../presentation/widget/size_configuration.dart';
import '../apiservice/creat_user/creat_user_controller.dart';

/// Google SignIn And SignOut ///
class GoogleSignInController extends ChangeNotifier {
  CreateUserController createUser = Get.put(CreateUserController());
  bool isLoading = false;

  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  String loginGoogle = "";

  final List<Map<String, String>> randomUsers = [
    {
      "name": "Aarav Patel",
      "email": "aarav.patel@example.com",
      "image":
          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg"
    },
    {
      "name": "Diya Sharma",
      "email": "diya.sharma@example.com",
      "image":
          "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg"
    },
    {
      "name": "Kabir Mehta",
      "email": "kabir.mehta@example.com",
      "image":
          "https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg"
    },
    {
      "name": "Ishita Joshi",
      "email": "ishita.joshi@example.com",
      "image":
          "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg"
    },
    {
      "name": "Rohan Desai",
      "email": "rohan.desai@example.com",
      "image":
          "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg"
    },
    {
      "name": "Anaya Kapoor",
      "email": "anaya.kapoor@example.com",
      "image":
          "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg"
    },
    {
      "name": "Vihaan Reddy",
      "email": "vihaan.reddy@example.com",
      "image": "https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg"
    },
    {
      "name": "Meera Iyer",
      "email": "meera.iyer@example.com",
      "image":
          "https://images.pexels.com/photos/774095/pexels-photo-774095.jpeg"
    },
    {
      "name": "Arjun Nair",
      "email": "arjun.nair@example.com",
      "image":
          "https://images.pexels.com/photos/1704488/pexels-photo-1704488.jpeg"
    },
    {
      "name": "Kavya Singh",
      "email": "kavya.singh@example.com",
      "image":
          "https://images.pexels.com/photos/1181686/pexels-photo-1181686.jpeg"
    },
  ];

  Map<String, String> getRandomUser() {
    final random = Random();
    return randomUsers[random.nextInt(randomUsers.length)];
  }

  Future googleLogin() async {
    try {
      isLoading = true;
      notifyListeners();

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      log("googleAuth :: $googleAuth");
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      if (FirebaseAuth.instance.currentUser != null) {
        log("Current use is not null");
        SharedPreferences pref = await SharedPreferences.getInstance();
        log("user========= ${user.photoUrl}");

        await createUser.createUser(
            email: user.email,
            password: "",
            loginType: "0",
            fcmToken: fcmToken,
            identity: identity,
            name: user.displayName,
            image: user.photoUrl);
        if (createUser.data == null ||
            createUser.data["message"]
                    ?.toString()
                    .startsWith("Connection failed") ==
                true) {
          log("Connection error during Google login");
          Get.snackbar(
              'Error', 'Could not connect to server. Please try again later.',
              snackPosition: SnackPosition.BOTTOM);
          return;
        }
        log("user status ${createUser.data["status"]}");
        log("user status ${createUser.data["user"]?["image"]}");
        if (createUser.data["status"] == false) {
          return Get.dialog(
            barrierColor: ColorValues.blackColor.withValues(alpha: 0.8),
            Dialog(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              child: Column(
                children: [
                  SizedBox(
                    height: Get.height / 5.6,
                    width: Get.width / 1.9,
                    child: SvgPicture.asset(MovixIcon.userBlock),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 3,
                  ),
                  Text(
                    "You Are Blocked!!!",
                    style: congratulationsStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 3,
                  ),
                  Text(
                    "You Have Blocked By Admin ",
                    style: accountReadyStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        } else {
          pref.setBool("isLogin", true);
          await pref.setString("userId", createUser.data['user']['_id']);
          userId = await createUser.data['user']['_id'];
          await pref.setString("userEmail", createUser.data['user']['email']);
          userEmail = await createUser.data['user']['email'];
          await pref.setString("userName", createUser.data['user']['fullName']);
          userName = await createUser.data['user']['fullName'];
          await pref.setString(
              "userNickName", createUser.data['user']['nickName']);
          userNickName = await createUser.data['user']['nickName'];
          await pref.setString("userGender", createUser.data['user']['gender']);
          userGender = await createUser.data['user']['gender'];
          await pref.setString("userImage", createUser.data['user']['image']);
          userImage = await createUser.data['user']['image'];
          await pref.setString(
              "userCountry", createUser.data['user']['country']);
          userCountry = await createUser.data['user']['country'];
          await pref.setBool(
              "isPremiumPlan", createUser.data["user"]["isPremiumPlan"]);
          isPremiumPlan = await createUser.data["user"]["isPremiumPlan"];
          loginGoogle = await createUser.data['user']['email'];

          Get.offAllNamed(Routes.interest);
        }
      } else {
        log("Still Logout");
        isLoading = false;
        notifyListeners();
      }
    } on PlatformException catch (e) {
      log("Google Sign-In PlatformException: ${e.message}");
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Exception: ${e.code}");
    } catch (e) {
      log("Google login error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future appleLogin() async {
    try {
      isLoading = true;
      notifyListeners();

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
      );
      var auth =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      final user = auth.user;
      if (user != null) {
        log("Current use is not null");
        SharedPreferences pref = await SharedPreferences.getInstance();
        await createUser.createUser(
            email: user.email,
            password: "",
            loginType: "1",
            fcmToken: fcmToken,
            identity: identity,
            name: user.displayName,
            image: user.photoURL);
        if (createUser.data == null ||
            createUser.data["message"]
                    ?.toString()
                    .startsWith("Connection failed") ==
                true) {
          log("Connection error during Apple login");
          Get.snackbar(
              'Error', 'Could not connect to server. Please try again later.',
              snackPosition: SnackPosition.BOTTOM);
          return;
        }
        log("user status ${createUser.data["status"]}");
        if (createUser.data["status"] == false) {
          return Get.dialog(
            barrierColor: ColorValues.blackColor.withValues(alpha: 0.8),
            Dialog(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              child: Column(
                children: [
                  SizedBox(
                    height: Get.height / 5.6,
                    width: Get.width / 1.9,
                    child: SvgPicture.asset(MovixIcon.userBlock),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 3,
                  ),
                  Text(
                    "You Are Blocked!!!",
                    style: congratulationsStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 3,
                  ),
                  Text(
                    "You Have Blocked By Admin ",
                    style: accountReadyStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        } else {
          pref.setBool("isLogin", true);
          await pref.setString("userId", createUser.data['user']['_id']);
          userId = await createUser.data['user']['_id'];
          await pref.setString("userEmail", createUser.data['user']['email']);
          userEmail = await createUser.data['user']['email'];
          await pref.setString("userName", createUser.data['user']['fullName']);
          userName = await createUser.data['user']['fullName'];
          await pref.setString(
              "userNickName", createUser.data['user']['nickName']);
          userNickName = await createUser.data['user']['nickName'];
          await pref.setString("userGender", createUser.data['user']['gender']);
          userGender = await createUser.data['user']['gender'];
          await pref.setString("userImage", createUser.data['user']['image']);
          userImage = await createUser.data['user']['image'];
          await pref.setString(
              "userCountry", createUser.data['user']['country']);
          userCountry = await createUser.data['user']['country'];
          await pref.setBool(
              "isPremiumPlan", createUser.data["user"]["isPremiumPlan"]);
          isPremiumPlan = await createUser.data["user"]["isPremiumPlan"];
          loginGoogle = await createUser.data['user']['email'];

          Get.offAllNamed(Routes.interest);
        }
      } else {
        log("Still Logout");

        isLoading = false;
        notifyListeners();
      }
    } on PlatformException catch (e) {
      log("Apple Sign-In PlatformException: ${e.message}");
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Exception: ${e.code}");
    } catch (e) {
      log("Apple login error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future quickLogin() async {
    try {
      isLoading = true;
      notifyListeners();

      SharedPreferences pref = await SharedPreferences.getInstance();

      var randomUser = getRandomUser();
      String randomName = randomUser["name"]!;
      String randomImage = randomUser["image"]!;
      String randomEmail = randomUser["email"]!;
      await createUser.createUser(
          email: randomEmail,
          password: "",
          loginType: '2',
          fcmToken: fcmToken,
          identity: identity,
          name: randomName,
          image: randomImage);
      if (createUser.data == null ||
          createUser.data["message"]
                  ?.toString()
                  .startsWith("Connection failed") ==
              true) {
        log("Connection error during quick login");
        Get.snackbar(
            'Error', 'Could not connect to server. Please try again later.',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      log("Login Status :: ${createUser.data["status"]}");
      log("Login message :: ${createUser.data["message"]}");
      if (createUser.data["status"] == false) {
        log("Is Login True");
        return Get.dialog(
          barrierColor: ColorValues.blackColor.withValues(alpha: 0.8),
          Dialog(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            child: Container(
              height: Get.height / 2.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (getStorage.read('isDarkMode') == true)
                    ? ColorValues.darkModeSecond
                    : ColorValues.whiteColor,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: Get.height / 5.6,
                    width: Get.width / 1.9,
                    child: SvgPicture.asset(MovixIcon.userBlock),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 3,
                  ),
                  Text(
                    StringValue.youAreBlocked.tr,
                    style: congratulationsStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 3,
                  ),
                  Text(
                    StringValue.youHaveBlockedByAdmin.tr,
                    style: accountReadyStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        log("Is Login False");
        pref.setBool("isLogin", true);
        await pref.setString("userId", createUser.data['user']['_id']);
        userId = await createUser.data['user']['_id'];
        await pref.setString("userEmail", createUser.data['user']['uniqueId']);
        userEmail = await createUser.data['user']['uniqueId'];
        await pref.setString("userName", createUser.data['user']['fullName']);
        userName = await createUser.data['user']['fullName'];
        await pref.setString(
            "userNickName", createUser.data['user']['nickName']);
        userNickName = await createUser.data['user']['nickName'];
        await pref.setString("userGender", createUser.data['user']['gender']);
        userGender = await createUser.data['user']['gender'];
        await pref.setString("userCountry", createUser.data['user']['country']);
        userCountry = await createUser.data['user']['country'];
        await pref.setBool(
            "isPremiumPlan", createUser.data["user"]["isPremiumPlan"]);
        isPremiumPlan = await createUser.data["user"]["isPremiumPlan"];
        await pref.setString(
            "userCountry", createUser.data["user"]["uniqueId"]);
        UniqueId = await createUser.data["user"]["uniqueId"];

        ///
        await pref.setString("image", createUser.data["user"]["image"]);
        userImage = await createUser.data["user"]["image"];

        ///

        Get.offAllNamed(Routes.interest);
      }
    } on PlatformException catch (e) {
      log("Quick login PlatformException: ${e.message}");
    } catch (e) {
      log("Quick login error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future logOut() async {
    try {
      googleSignIn.disconnect();
      FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      log(e.code);
    }
  }
}

/// 0.google 1.Apple 2.quick
