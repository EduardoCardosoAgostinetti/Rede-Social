import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt')
  ];

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get enterCode;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// No description provided for @rememberPassword.
  ///
  /// In en, this message translates to:
  /// **'Remembered your password? Back to login'**
  String get rememberPassword;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @invalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid code'**
  String get invalidCode;

  /// No description provided for @verifyingCode.
  ///
  /// In en, this message translates to:
  /// **'Verifying code...'**
  String get verifyingCode;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordMinChars.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinChars;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @rememberPasswordBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Remembered your password? Back to login'**
  String get rememberPasswordBackToLogin;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @resettingPassword.
  ///
  /// In en, this message translates to:
  /// **'Resetting password...'**
  String get resettingPassword;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @nickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter a username'**
  String get enterUsername;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter an email'**
  String get enterEmail;

  /// No description provided for @enterNickname.
  ///
  /// In en, this message translates to:
  /// **'Please enter a nickname'**
  String get enterNickname;

  /// No description provided for @minChars.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get minChars;

  /// No description provided for @acceptTerms.
  ///
  /// In en, this message translates to:
  /// **'I accept the Privacy Policy and Terms of Service'**
  String get acceptTerms;

  /// No description provided for @mustAcceptTerms.
  ///
  /// In en, this message translates to:
  /// **'You must accept the terms to proceed.'**
  String get mustAcceptTerms;

  /// No description provided for @accessNow.
  ///
  /// In en, this message translates to:
  /// **'Access Now'**
  String get accessNow;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get alreadyHaveAccount;

  /// No description provided for @registering.
  ///
  /// In en, this message translates to:
  /// **'Registering...'**
  String get registering;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get networkError;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get enterPassword;

  /// No description provided for @rememberLogin.
  ///
  /// In en, this message translates to:
  /// **'Remember login'**
  String get rememberLogin;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @noAccountRegister.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register'**
  String get noAccountRegister;

  /// No description provided for @accessing.
  ///
  /// In en, this message translates to:
  /// **'Accessing...'**
  String get accessing;

  /// No description provided for @occurredError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get occurredError;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'⚙️ Settings'**
  String get settingsTitle;

  /// No description provided for @responsiveness.
  ///
  /// In en, this message translates to:
  /// **'Responsiveness'**
  String get responsiveness;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @editAccountInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit Account Info'**
  String get editAccountInfo;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @themeModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeModeTitle;

  /// No description provided for @chooseThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Choose a theme mode:'**
  String get chooseThemeMode;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @selectLayoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Layout'**
  String get selectLayoutTitle;

  /// No description provided for @chooseLayoutMode.
  ///
  /// In en, this message translates to:
  /// **'Choose a layout mode:'**
  String get chooseLayoutMode;

  /// No description provided for @auto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get auto;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @tablet.
  ///
  /// In en, this message translates to:
  /// **'Tablet'**
  String get tablet;

  /// No description provided for @desktop.
  ///
  /// In en, this message translates to:
  /// **'Desktop'**
  String get desktop;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @code_1.
  ///
  /// In en, this message translates to:
  /// **'Validation error on fields'**
  String get code_1;

  /// No description provided for @code_2.
  ///
  /// In en, this message translates to:
  /// **'Email is already in use'**
  String get code_2;

  /// No description provided for @code_3.
  ///
  /// In en, this message translates to:
  /// **'Username is already in use'**
  String get code_3;

  /// No description provided for @code_4.
  ///
  /// In en, this message translates to:
  /// **'User registered successfully'**
  String get code_4;

  /// No description provided for @code_5.
  ///
  /// In en, this message translates to:
  /// **'Internal server error (register)'**
  String get code_5;

  /// No description provided for @code_6.
  ///
  /// In en, this message translates to:
  /// **'Validation error (login)'**
  String get code_6;

  /// No description provided for @code_7.
  ///
  /// In en, this message translates to:
  /// **'Incorrect username or password (username not found)'**
  String get code_7;

  /// No description provided for @code_8.
  ///
  /// In en, this message translates to:
  /// **'Incorrect username or password (password mismatch)'**
  String get code_8;

  /// No description provided for @code_9.
  ///
  /// In en, this message translates to:
  /// **'User already logged in (presence status online/in_match/busy)'**
  String get code_9;

  /// No description provided for @code_10.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get code_10;

  /// No description provided for @code_11.
  ///
  /// In en, this message translates to:
  /// **'Internal server error (login)'**
  String get code_11;

  /// No description provided for @code_12.
  ///
  /// In en, this message translates to:
  /// **'Invalid password input'**
  String get code_12;

  /// No description provided for @code_13.
  ///
  /// In en, this message translates to:
  /// **'Old password is incorrect'**
  String get code_13;

  /// No description provided for @code_14.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get code_14;

  /// No description provided for @code_15.
  ///
  /// In en, this message translates to:
  /// **'Internal server error (change password)'**
  String get code_15;

  /// No description provided for @code_16.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get code_16;

  /// No description provided for @code_17.
  ///
  /// In en, this message translates to:
  /// **'Username already taken'**
  String get code_17;

  /// No description provided for @code_18.
  ///
  /// In en, this message translates to:
  /// **'Username updated successfully'**
  String get code_18;

  /// No description provided for @code_19.
  ///
  /// In en, this message translates to:
  /// **'Internal server error (change username)'**
  String get code_19;

  /// No description provided for @code_20.
  ///
  /// In en, this message translates to:
  /// **'Nickname is required'**
  String get code_20;

  /// No description provided for @code_21.
  ///
  /// In en, this message translates to:
  /// **'Nickname updated successfully'**
  String get code_21;

  /// No description provided for @code_22.
  ///
  /// In en, this message translates to:
  /// **'Internal server error (change nickname)'**
  String get code_22;

  /// No description provided for @code_23.
  ///
  /// In en, this message translates to:
  /// **'Validation error on fields (request code)'**
  String get code_23;

  /// No description provided for @code_24.
  ///
  /// In en, this message translates to:
  /// **'Email not found'**
  String get code_24;

  /// No description provided for @code_25.
  ///
  /// In en, this message translates to:
  /// **'Code sent to your email'**
  String get code_25;

  /// No description provided for @code_26.
  ///
  /// In en, this message translates to:
  /// **'Internal server error (requestPasswordResetCode)'**
  String get code_26;

  /// No description provided for @code_27.
  ///
  /// In en, this message translates to:
  /// **'Validation error on fields (verify code)'**
  String get code_27;

  /// No description provided for @code_28.
  ///
  /// In en, this message translates to:
  /// **'Email not found'**
  String get code_28;

  /// No description provided for @code_29.
  ///
  /// In en, this message translates to:
  /// **'Invalid, expired, or already used code'**
  String get code_29;

  /// No description provided for @code_30.
  ///
  /// In en, this message translates to:
  /// **'Code successfully verified'**
  String get code_30;

  /// No description provided for @code_31.
  ///
  /// In en, this message translates to:
  /// **'Internal server error (verifyCode)'**
  String get code_31;

  /// No description provided for @code_32.
  ///
  /// In en, this message translates to:
  /// **'Validation error on fields (resetPassword)'**
  String get code_32;

  /// No description provided for @code_33.
  ///
  /// In en, this message translates to:
  /// **'Email not found'**
  String get code_33;

  /// No description provided for @code_34.
  ///
  /// In en, this message translates to:
  /// **'Invalid, expired, or already used code'**
  String get code_34;

  /// No description provided for @code_35.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get code_35;

  /// No description provided for @code_36.
  ///
  /// In en, this message translates to:
  /// **'Internal server error (resetPassword)'**
  String get code_36;

  /// No description provided for @code_37.
  ///
  /// In en, this message translates to:
  /// **'Invalid status value'**
  String get code_37;

  /// No description provided for @code_38.
  ///
  /// In en, this message translates to:
  /// **'Presence updated'**
  String get code_38;

  /// No description provided for @code_39.
  ///
  /// In en, this message translates to:
  /// **'Internal server error (updatePresence)'**
  String get code_39;

  /// No description provided for @code_40.
  ///
  /// In en, this message translates to:
  /// **'Nickname is required'**
  String get code_40;

  /// No description provided for @code_41.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get code_41;

  /// No description provided for @code_42.
  ///
  /// In en, this message translates to:
  /// **'Users found'**
  String get code_42;

  /// No description provided for @code_43.
  ///
  /// In en, this message translates to:
  /// **'Internal server error (searchByNickname)'**
  String get code_43;

  /// No description provided for @code_44.
  ///
  /// In en, this message translates to:
  /// **'receiverId is required in body'**
  String get code_44;

  /// No description provided for @code_45.
  ///
  /// In en, this message translates to:
  /// **'You cannot send a friend request to yourself'**
  String get code_45;

  /// No description provided for @code_46.
  ///
  /// In en, this message translates to:
  /// **'Receiver not found'**
  String get code_46;

  /// No description provided for @code_47.
  ///
  /// In en, this message translates to:
  /// **'Users are already friends'**
  String get code_47;

  /// No description provided for @code_48.
  ///
  /// In en, this message translates to:
  /// **'Friend request already sent or received'**
  String get code_48;

  /// No description provided for @code_49.
  ///
  /// In en, this message translates to:
  /// **'Friend request sent'**
  String get code_49;

  /// No description provided for @code_50.
  ///
  /// In en, this message translates to:
  /// **'Internal server error (sendFriendRequest)'**
  String get code_50;

  /// No description provided for @code_51.
  ///
  /// In en, this message translates to:
  /// **'Pending friend requests retrieved successfully'**
  String get code_51;

  /// No description provided for @code_52.
  ///
  /// In en, this message translates to:
  /// **'Internal server error (getPendingFriendRequests)'**
  String get code_52;

  /// No description provided for @code_53.
  ///
  /// In en, this message translates to:
  /// **'Friend request not found'**
  String get code_53;

  /// No description provided for @code_54.
  ///
  /// In en, this message translates to:
  /// **'Friend request accepted'**
  String get code_54;

  /// No description provided for @code_55.
  ///
  /// In en, this message translates to:
  /// **'Friend request declined'**
  String get code_55;

  /// No description provided for @code_56.
  ///
  /// In en, this message translates to:
  /// **'Invalid action. Use \"accept\" or \"decline\".'**
  String get code_56;

  /// No description provided for @code_57.
  ///
  /// In en, this message translates to:
  /// **'Internal server error (respondToFriendRequest)'**
  String get code_57;

  /// No description provided for @code_58.
  ///
  /// In en, this message translates to:
  /// **'Friends retrieved successfully'**
  String get code_58;

  /// No description provided for @code_59.
  ///
  /// In en, this message translates to:
  /// **'Internal server error (getFriendsList)'**
  String get code_59;

  /// No description provided for @code_60.
  ///
  /// In en, this message translates to:
  /// **'Sent friend requests retrieved successfully'**
  String get code_60;

  /// No description provided for @code_61.
  ///
  /// In en, this message translates to:
  /// **'Internal server error (getSentPendingFriendRequests)'**
  String get code_61;

  /// No description provided for @code_62.
  ///
  /// In en, this message translates to:
  /// **'Chats listed successfully'**
  String get code_62;

  /// No description provided for @code_63.
  ///
  /// In en, this message translates to:
  /// **'Failed to list chats'**
  String get code_63;

  /// No description provided for @code_64.
  ///
  /// In en, this message translates to:
  /// **'Cannot create a chat with yourself'**
  String get code_64;

  /// No description provided for @code_65.
  ///
  /// In en, this message translates to:
  /// **'Chat found or created successfully'**
  String get code_65;

  /// No description provided for @code_66.
  ///
  /// In en, this message translates to:
  /// **'Error retrieving or creating chat'**
  String get code_66;

  /// No description provided for @code_67.
  ///
  /// In en, this message translates to:
  /// **'Chat not found'**
  String get code_67;

  /// No description provided for @code_68.
  ///
  /// In en, this message translates to:
  /// **'Access denied for this chat'**
  String get code_68;

  /// No description provided for @code_69.
  ///
  /// In en, this message translates to:
  /// **'Messages retrieved successfully'**
  String get code_69;

  /// No description provided for @code_70.
  ///
  /// In en, this message translates to:
  /// **'Failed to retrieve messages'**
  String get code_70;

  /// No description provided for @code_71.
  ///
  /// In en, this message translates to:
  /// **'Validation error'**
  String get code_71;

  /// No description provided for @code_72.
  ///
  /// In en, this message translates to:
  /// **'Chat not found'**
  String get code_72;

  /// No description provided for @code_73.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get code_73;

  /// No description provided for @code_74.
  ///
  /// In en, this message translates to:
  /// **'Message sent successfully'**
  String get code_74;

  /// No description provided for @code_75.
  ///
  /// In en, this message translates to:
  /// **'Internal server error'**
  String get code_75;

  /// No description provided for @code_76.
  ///
  /// In en, this message translates to:
  /// **'No file uploaded.'**
  String get code_76;

  /// No description provided for @code_77.
  ///
  /// In en, this message translates to:
  /// **'Upload and conversion successful.'**
  String get code_77;

  /// No description provided for @code_78.
  ///
  /// In en, this message translates to:
  /// **'Error processing image.'**
  String get code_78;

  /// No description provided for @code_79.
  ///
  /// In en, this message translates to:
  /// **'Post content or image is required'**
  String get code_79;

  /// No description provided for @code_80.
  ///
  /// In en, this message translates to:
  /// **'Post created successfully'**
  String get code_80;

  /// No description provided for @code_81.
  ///
  /// In en, this message translates to:
  /// **'Error creating post'**
  String get code_81;

  /// No description provided for @code_82.
  ///
  /// In en, this message translates to:
  /// **'Feed loaded successfully'**
  String get code_82;

  /// No description provided for @code_83.
  ///
  /// In en, this message translates to:
  /// **'Error loading feed'**
  String get code_83;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get message;

  /// No description provided for @userSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get userSettingsTitle;

  /// No description provided for @updateUserInfo.
  ///
  /// In en, this message translates to:
  /// **'Update your information'**
  String get updateUserInfo;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @nicknameRequired.
  ///
  /// In en, this message translates to:
  /// **'Nickname is required'**
  String get nicknameRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @updateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Information updated successfully'**
  String get updateSuccess;

  /// No description provided for @savingChanges.
  ///
  /// In en, this message translates to:
  /// **'Saving changes...'**
  String get savingChanges;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @updateNickname.
  ///
  /// In en, this message translates to:
  /// **'Update Nickname'**
  String get updateNickname;

  /// No description provided for @updateUsername.
  ///
  /// In en, this message translates to:
  /// **'Update Username'**
  String get updateUsername;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @nicknameUpdated.
  ///
  /// In en, this message translates to:
  /// **'Nickname updated successfully!'**
  String get nicknameUpdated;

  /// No description provided for @usernameUpdated.
  ///
  /// In en, this message translates to:
  /// **'Username updated successfully!'**
  String get usernameUpdated;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully!'**
  String get passwordUpdated;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// No description provided for @sendingCode.
  ///
  /// In en, this message translates to:
  /// **'Sending Code...'**
  String get sendingCode;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguage;

  /// No description provided for @chooseFieldToUpdate.
  ///
  /// In en, this message translates to:
  /// **'Choose a field to update'**
  String get chooseFieldToUpdate;

  /// No description provided for @searchFriends.
  ///
  /// In en, this message translates to:
  /// **'Search Friends'**
  String get searchFriends;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @enterNicknameToSearch.
  ///
  /// In en, this message translates to:
  /// **'Please enter a nickname to search'**
  String get enterNicknameToSearch;

  /// No description provided for @tokenNotFound.
  ///
  /// In en, this message translates to:
  /// **'Token not found'**
  String get tokenNotFound;

  /// No description provided for @sendFriendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send friend request'**
  String get sendFriendRequest;

  /// No description provided for @searchTab.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTab;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @friendsList.
  ///
  /// In en, this message translates to:
  /// **'👥 Your friends\n- João\n- Maria\n- Ana'**
  String get friendsList;

  /// No description provided for @receivedRequests.
  ///
  /// In en, this message translates to:
  /// **'📥 Received requests'**
  String get receivedRequests;

  /// No description provided for @sentRequests.
  ///
  /// In en, this message translates to:
  /// **'📤 Sent requests'**
  String get sentRequests;

  /// No description provided for @sentRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sent Friend Requests'**
  String get sentRequestsTitle;

  /// No description provided for @noPendingSentRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending sent friend requests.'**
  String get noPendingSentRequests;

  /// No description provided for @unknownNickname.
  ///
  /// In en, this message translates to:
  /// **'Unknown nickname'**
  String get unknownNickname;

  /// No description provided for @unknownId.
  ///
  /// In en, this message translates to:
  /// **'Unknown ID'**
  String get unknownId;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @receivedRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Received Friend Requests'**
  String get receivedRequestsTitle;

  /// No description provided for @noPendingReceivedRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending received friend requests.'**
  String get noPendingReceivedRequests;

  /// No description provided for @requestAccepted.
  ///
  /// In en, this message translates to:
  /// **'Friend request accepted.'**
  String get requestAccepted;

  /// No description provided for @requestDeclined.
  ///
  /// In en, this message translates to:
  /// **'Friend request declined.'**
  String get requestDeclined;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @friendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friendsTitle;

  /// No description provided for @noFriendsFound.
  ///
  /// In en, this message translates to:
  /// **'No friends found.'**
  String get noFriendsFound;

  /// No description provided for @statusOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get statusOnline;

  /// No description provided for @statusOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get statusOffline;

  /// No description provided for @lastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen: {date}'**
  String lastSeen(Object date);

  /// No description provided for @unknownStatus.
  ///
  /// In en, this message translates to:
  /// **'Unknown status'**
  String get unknownStatus;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @noChatsFound.
  ///
  /// In en, this message translates to:
  /// **'No chats found'**
  String get noChatsFound;

  /// No description provided for @typeAMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message'**
  String get typeAMessage;

  /// No description provided for @feed.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get feed;

  /// No description provided for @newPost.
  ///
  /// In en, this message translates to:
  /// **'New Post'**
  String get newPost;

  /// No description provided for @writeSomething.
  ///
  /// In en, this message translates to:
  /// **'Write something...'**
  String get writeSomething;

  /// No description provided for @selectImage.
  ///
  /// In en, this message translates to:
  /// **'Select Image'**
  String get selectImage;

  /// No description provided for @post.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post;

  /// No description provided for @typeYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get typeYourMessage;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @updatingNickname.
  ///
  /// In en, this message translates to:
  /// **'Updating nickname...'**
  String get updatingNickname;

  /// No description provided for @updatingUsername.
  ///
  /// In en, this message translates to:
  /// **'Updating username...'**
  String get updatingUsername;

  /// No description provided for @updatingPassword.
  ///
  /// In en, this message translates to:
  /// **'Updating password...'**
  String get updatingPassword;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
