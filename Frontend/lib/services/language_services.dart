import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/l10n/app_localizations.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('pt');

  Locale get locale => _locale;

  LanguageProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString('language_code');
    if (code != null) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    _locale = locale;
    notifyListeners();
  }
}

String translateCode(AppLocalizations loc, int code) {
  switch (code) {
    case 1:
      return loc.code_1;
    case 2:
      return loc.code_2;
    case 3:
      return loc.code_3;
    case 4:
      return loc.code_4;
    case 5:
      return loc.code_5;
    case 6:
      return loc.code_6;
    case 7:
      return loc.code_7;
    case 8:
      return loc.code_8;
    case 9:
      return loc.code_9;
    case 10:
      return loc.code_10;
    case 11:
      return loc.code_11;
    case 12:
      return loc.code_12;
    case 13:
      return loc.code_13;
    case 14:
      return loc.code_14;
    case 15:
      return loc.code_15;
    case 16:
      return loc.code_16;
    case 17:
      return loc.code_17;
    case 18:
      return loc.code_18;
    case 19:
      return loc.code_19;
    case 20:
      return loc.code_20;
    case 21:
      return loc.code_21;
    case 22:
      return loc.code_22;
    case 23:
      return loc.code_23;
    case 24:
      return loc.code_24;
    case 25:
      return loc.code_25;
    case 26:
      return loc.code_26;
    case 27:
      return loc.code_27;
    case 28:
      return loc.code_28;
    case 29:
      return loc.code_29;
    case 30:
      return loc.code_30;
    case 31:
      return loc.code_31;
    case 32:
      return loc.code_32;
    case 33:
      return loc.code_33;
    case 34:
      return loc.code_34;
    case 35:
      return loc.code_35;
    case 36:
      return loc.code_36;
    case 37:
      return loc.code_37;
    case 38:
      return loc.code_38;
    case 39:
      return loc.code_39;
    case 40:
      return loc.code_40;
    case 41:
      return loc.code_41;
    case 42:
      return loc.code_42;
    case 43:
      return loc.code_43;
    case 44:
      return loc.code_44;
    case 45:
      return loc.code_45;
    case 46:
      return loc.code_46;
    case 47:
      return loc.code_47;
    case 48:
      return loc.code_48;
    case 49:
      return loc.code_49;
    case 50:
      return loc.code_50;
    case 51:
      return loc.code_51;
    case 52:
      return loc.code_52;
    case 53:
      return loc.code_53;
    case 54:
      return loc.code_54;
    case 55:
      return loc.code_55;
    case 56:
      return loc.code_56;
    case 57:
      return loc.code_57;
    case 58:
      return loc.code_58;
    case 59:
      return loc.code_59;
    case 60:
      return loc.code_60;
    case 61:
      return loc.code_61;
    case 62:
      return loc.code_62;
    case 63:
      return loc.code_63;
    case 64:
      return loc.code_64;
    case 65:
      return loc.code_65;
    case 66:
      return loc.code_66;
    case 67:
      return loc.code_67;
    case 68:
      return loc.code_68;
    case 69:
      return loc.code_69;
    case 70:
      return loc.code_70;
    case 71:
      return loc.code_71;
    case 72:
      return loc.code_72;
    case 73:
      return loc.code_73;
    case 74:
      return loc.code_74;
    case 75:
      return loc.code_75;
    case 76:
      return loc.code_76;
    case 77:
      return loc.code_77;
    case 78:
      return loc.code_78;
    case 79:
      return loc.code_79;
    case 80:
      return loc.code_80;
    case 81:
      return loc.code_81;
    case 82:
      return loc.code_82;
    case 83:
      return loc.code_83;

    default:
      return loc.message;
  }
}
