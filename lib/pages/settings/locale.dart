import 'package:flutter/material.dart';
import 'package:k8zdev/common/ops.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/providers/lang.dart';
import 'package:k8zdev/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LocaleSettingPage extends StatefulWidget {
  const LocaleSettingPage({super.key});

  @override
  State<LocaleSettingPage> createState() => _LocaleSettingPageState();
}

class _LocaleSettingPageState extends State<LocaleSettingPage> {
  void _changed(String? value, CurrentLocale current) {
    Locale? locale;
    talker.log("change, value is null: ${value == null}");
    if (value == null) {
      current.setLocale(locale);
      return;
    }

    locale = Locale(value);
    current.setLocale(locale);
  }

  Widget body(BuildContext context, S lang) {
    var current = Provider.of<CurrentLocale>(context, listen: true);
    String? code = current.locale?.languageCode;

    return Column(
      children: [
        RadioListTile<String?>(
          title: Text(lang.general_language_null),
          value: null,
          groupValue: code,
          onChanged: (v) => _changed(v, current),
          selected: current.isAuto,
        ),
        RadioListTile<String>(
          title: Text(lang.general_language_zh),
          value: 'zh',
          groupValue: code,
          selected: code == "zh",
          onChanged: (v) => _changed(v, current),
        ),
        RadioListTile<String>(
          title: Text(lang.general_language_en),
          value: 'en',
          groupValue: code,
          selected: code == "en",
          onChanged: (v) => _changed(v, current),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);

    return safeSca(
      context,
      Text("${lang.general_language}/${lang.settings}"),
      body(context, lang),
    );
  }
}
