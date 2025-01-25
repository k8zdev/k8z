// ignore_for_file: use_build_context_synchronously
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:k8zdev/common/const.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/dao/dao.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/providers/lang.dart';
import 'package:k8zdev/providers/talker.dart';
import 'package:k8zdev/providers/theme.dart';
import 'package:k8zdev/providers/timeout.dart';
import 'package:k8zdev/widgets/modal.dart';
import 'package:k8zdev/widgets/set_api_timeout.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _forceDebug = false;

  @override
  void initState() {
    super.initState();
  }

  Text code2text(S lang, String? code) {
    var string = "Unkonw";
    switch (code) {
      case "en":
        string = lang.general_language_en;

      case "zh":
        string = lang.general_language_zh;

      case "ja":
        string = lang.general_language_ja;

      case null:
        string = lang.general_language_null;

      default:
        break;
    }

    return Text(string);
  }

  SettingsTile dropDatabase(BuildContext context) {
    var lang = S.current;
    return SettingsTile(
      leading: const Icon(
        Icons.dangerous,
        color: Colors.red,
      ),
      title: Text(
        lang.debug_flushdb,
        style: const TextStyle(color: Colors.red),
      ),
      onPressed: (context) {
        Dialogs.materialDialog(
          context: context,
          title: lang.debug_flushdb,
          msg: lang.debug_flushdb_desc,
          actionsBuilder: (context) {
            return [
              IconsOutlineButton(
                onPressed: () {
                  context.pop();
                },
                text: lang.cancel,
                iconColor: Colors.grey,
                iconData: Icons.cancel_outlined,
                textStyle: const TextStyle(color: Colors.grey),
              ),
              IconsOutlineButton(
                text: lang.delete,
                color: Colors.red,
                iconData: Icons.delete,
                iconColor: Colors.white,
                textStyle: const TextStyle(color: Colors.white),
                onPressed: () {
                  Future.delayed(Duration.zero, () async {
                    await flushdb();
                  });

                  context.pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      showCloseIcon: true,
                      closeIconColor: Colors.white,
                      backgroundColor: Colors.red,
                      content: Text(lang.debug_flushdb_done),
                    ),
                  );
                },
              ),
            ];
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    var themeProvider = Provider.of<ThemeModeProvider>(context, listen: true);
    var locale = Provider.of<CurrentLocale>(context, listen: true).locale;
    var talkerProvider = Provider.of<TalkerModeProvider>(context, listen: true);
    var talkerEnabled = talkerProvider.enabled ?? false;

    var list = SettingsList(
      sections: [
        // theme
        SettingsSection(
          title: Text(lang.appearance),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              onToggle: (value) {
                talker.log("auto theme: $value");
                if (value) {
                  themeProvider.changeMode(ThemeMode.system);
                } else {
                  themeProvider.changeMode(ThemeMode.light);
                }
              },
              initialValue: themeProvider.mode == ThemeMode.system,
              leading: const Icon(Icons.lightbulb),
              title: Text(lang.theme_auto),
            ),
            SettingsTile.switchTile(
              onToggle: (value) {
                talker.log("dark mode: $value");
                if (value) {
                  themeProvider.changeMode(ThemeMode.dark);
                } else {
                  themeProvider.changeMode(ThemeMode.light);
                }
              },
              initialValue: themeProvider.mode == ThemeMode.dark,
              leading: const Icon(Icons.dark_mode),
              title: Text(lang.theme_dark),
            ),
          ],
        ),

        // general
        SettingsSection(
          title: Text(lang.general),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: const Icon(Icons.language),
              title: Text(lang.general_language),
              value: code2text(lang, locale?.languageCode),
              onPressed: (context) => context.pushNamed("locale"),
            ),
            SettingsTile(
              leading: const Icon(Icons.build_circle_outlined),
              title: Text(lang.version),
              value: FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (BuildContext context,
                    AsyncSnapshot<PackageInfo> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  var package = snapshot.data;
                  return Text(
                      "v${package?.version}(build: ${package?.buildNumber})");
                },
              ),
            ),
            // update timeout
            SettingsTile.navigation(
              leading: const Icon(Icons.timer_outlined),
              title: Text(lang.api_timeout),
              value: Text(lang
                  .n_seconds(Provider.of<TimeoutProvider>(context).timeout)),
              onPressed: (context) {
                showModal(context, const ApiTimeoutWidget(), minHeight: 150);
              },
            ),

            SettingsTile(
              leading: GestureDetector(
                onLongPress: () => setState(() => _forceDebug = !_forceDebug),
                child: const Icon(Icons.electrical_services_rounded),
              ),
              title: Text(lang.appName),
              onPressed: (context) {
                launchUrl(githubUrl);
              },
            ),
            if (talkerEnabled)
              SettingsTile.navigation(
                leading: const Icon(Icons.terminal),
                title: const Text("Talker Logs"),
                onPressed: (context) {
                  context.pushNamed("talker");
                },
              )
          ],
        ),

        SettingsSection(
          title: Text(lang.support),
          tiles: [
            // sponsor me
            SettingsTile.navigation(
              title: Text(lang.sponsorme),
              leading: const Icon(Icons.monetization_on_outlined),
              onPressed: (context) =>
                  GoRouter.of(context).pushNamed("appstore"),
            ),
            // feedback
            SettingsTile.navigation(
              title: Text(lang.feedback),
              leading: const Icon(Icons.rate_review_outlined),
              onPressed: (context) async {
                final inAppReview = InAppReview.instance;
                await inAppReview.openStoreListing(appStoreId: "6478047741");
              },
            ),
            // docs
            SettingsTile.navigation(
              title: Text(lang.documents),
              leading: const Icon(Icons.help_center_outlined),
              onPressed: (context) async {
                await launchUrl(docUrl);
              },
            ),
          ],
        ),
        // debug tool
        if (kProfileMode || _forceDebug)
          SettingsSection(
            title: Text(lang.general_debug),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.view_comfy_rounded),
                title: Text(
                  lang.general_debug_sqlview,
                ),
                onPressed: (context) {
                  context.pushNamed("sqlview");
                },
              ),
              SettingsTile.switchTile(
                leading: const Icon(Icons.terminal),
                title: const Text("Enable Talker"),
                initialValue: talkerEnabled,
                onToggle: (old) {
                  bool to = !talkerEnabled;
                  talker.log("change talker mode form $old to $to");
                  talkerProvider.changeMode(to);
                },
              ),

              // flushdb
              dropDatabase(context),
            ],
          ),
        //
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text(lang.settings)),
      body: Container(
        padding: bottomEdge,
        child: list,
      ),
    );
  }
}
