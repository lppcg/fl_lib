part of 'user.dart';

final class _UserInfoPage extends StatefulWidget {
  final User user;
  const _UserInfoPage({required this.user});

  @override
  State<_UserInfoPage> createState() => _UserInfoPageState();
}

final class _UserInfoPageState extends State<_UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(17),
      child: ListView(
        children: <Widget>[
          const UserAvatar(),
          UIs.height13,
          Btn.elevated(
            onTap: _onLogout,
            icon: const Icon(Icons.logout),
            text: l10n.logout,
          ),
          Btn.elevated(
            onTap: _onRename,
            icon: const Icon(BoxIcons.bx_rename),
            text: l10n.rename,
          ),
          Btn.elevated(
            onTap: _onDelete,
            icon: const Icon(Icons.delete),
            text: l10n.delete,
          ),
        ].joinWith(UIs.height13),
      ),
    );
  }

  Future<void> _onLogout() async {
    final sure = await context.showRoundDialog(
      title: l10n.logout,
      actions: Btnx.oks,
    );
    if (sure != true) return;
    UserApi.logout(_onAnonyUserLogout);
    contextSafe?.pop();
  }

  Future<bool> _onAnonyUserLogout() async {
    final sure = await context.showRoundDialog(
      title: l10n.attention,
      child: Text(l10n.anonLoseDataTip),
      actions: Btnx.oks,
    );
    return sure == true;
  }

  void _onRename() async {
    final ctrl = TextEditingController(text: UserApi.user.value?.name);
    void onOk() async {
      context.pop();
      final name = ctrl.text;
      if (name.isEmpty) return;
      await context.showLoadingDialog(fn: () => UserApi.edit(name: name));
    }

    await context.showRoundDialog(
      title: l10n.rename,
      child: Input(
        controller: ctrl,
        label: l10n.name,
        icon: BoxIcons.bx_rename,
        onSubmitted: (p0) => onOk(),
      ),
      actions: Btn.ok(onTap: onOk).toList,
    );
  }

  void _onDelete() async {
    final sure = await context.showRoundDialog(
      title: l10n.delete,
      child: Text(l10n.delFmt(l10n.user, UserApi.user.value?.name ?? '???')),
      actions: [
        CountDownBtn(
          onTap: () => context.pop(true),
          text: l10n.ok,
          afterColor: Colors.red,
        ),
      ],
    );
    if (sure != true) return;

    UserApi.logout(_onAnonyUserLogout);
  }

  // void _onImageRet(ImagePageRet ret) async {
  //   if (ret.isDeleted) {
  //     await context.showLoadingDialog(fn: () async {
  //       await Apis.userEdit(avatar: '');
  //     });
  //   }
  // }
}