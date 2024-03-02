import 'package:flutter/material.dart';
import 'package:k8zdev/generated/l10n.dart';
import 'package:k8zdev/providers/timeout.dart';
import 'package:provider/provider.dart';

class ApiTimeoutWidget extends StatelessWidget {
  const ApiTimeoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var lang = S.current;
    var timeout = Provider.of<TimeoutProvider>(context, listen: true);
    return Container(
      height: 30,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(lang.api_timeout),
              Text(lang.n_seconds(timeout.timeout)),
            ],
          ),
          Slider(
            value: timeout.timeout.toDouble(),
            onChanged: (double value) {
              timeout.update(value.toInt());
            },
            min: 1,
            max: 600,
            divisions: 20,
            label: lang.n_seconds(timeout.timeout),
          ),
        ],
      ),
    );
  }
}
