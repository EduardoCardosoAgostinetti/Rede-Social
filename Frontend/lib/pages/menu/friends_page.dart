import 'package:flutter/material.dart';
import 'package:app/pages/menu/friends/search_friends_page.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/menu/friends/sent_friends_page.dart';
import 'package:app/pages/menu/friends/requests_friends_page.dart';
import 'package:app/pages/menu/friends/my_friends_page.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          TabBar(
            labelStyle: const TextStyle(fontSize: 13),
            tabs: [
              Tab(text: loc.friends),
              Tab(text: loc.searchTab),
              Tab(text: loc.requests),
              Tab(text: loc.sent),
            ],
          ),
          const Expanded(
            child: TabBarView(
              children: [
                MyFriendsPage(),
                SearchFriendsPage(),
                RequestsFriendsPage(),
                SentFriendsPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
