import 'package:file_picker/file_picker.dart';
import 'package:fl_lib/fl_lib.dart';
import 'package:fl_lib/src/res/l10n.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

part 'info.dart';
part 'files.dart';

final class UserPage extends StatefulWidget {
  const UserPage({super.key});

  static const route = AppRouteNoArg(page: UserPage.new, path: '/user');

  @override
  State<UserPage> createState() => _UserPageState();
}

enum UserPageTab {
  info,
  files,
  ;

  String get l10n {
    return switch (this) {
      info => libL10n.user,
      files => libL10n.file,
    };
  }

  Widget get tab {
    return Tab(
      text: l10n,
      icon: switch (this) {
        info => const Icon(Icons.person),
        files => const Icon(Icons.file_present),
      },
    );
  }
}

final class _UserPageState extends State<UserPage> with SingleTickerProviderStateMixin {
  late final _tabtrl = TabController(
    length: UserPageTab.values.length,
    initialIndex: 0,
    vsync: this,
  );
  final _pageCtrl = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return UserApi.user.listenVal(
      (user) {
        if (user != null) return _build(user);
        return Scaffold(
          appBar: AppBar(title: Text(l10n.user)),
          body: const UserCard(),
        );
      },
    );
  }

  Widget _build(User user) {
    return Scaffold(
      appBar: TabBar(
        tabs: UserPageTab.values.map((e) => e.tab).toList(),
        controller: _tabtrl,
      ),
      body: PageView.builder(
        itemBuilder: (_, index) {
          return switch (UserPageTab.values[index]) {
            UserPageTab.info => _UserInfoPage(user: user),
            UserPageTab.files => _UserFilesPage(user: user),
          };
        },
        controller: _pageCtrl,
      ),
    );
  }
}
