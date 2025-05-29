import 'package:flutter/material.dart';

final List<Map<String, String>> languageList = [
  { 'code': 'en', 'label': 'English', 'emoji': '🇺🇸' },
  { 'code': 'lv', 'label': 'Latviešu', 'emoji': '🇱🇻' },
  { 'code': 'tr', 'label': 'Türkçe', 'emoji': '🇹🇷' },
];

final List<Locale> supportedLocaleList =
    languageList.map((lang) => Locale(lang['code']!)).toList();