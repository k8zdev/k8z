import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const minWinSize = Size(375, 667);
const initWinSize = Size(600, 667);
const bottomEdge = EdgeInsets.only(bottom: 60);
const releaseMode = kDebugMode
    ? "debug"
    : kReleaseMode
        ? "release"
        : "profile";
final privacyUrl = Uri(
  scheme: "https",
  host: "k8z.dev",
  path: "/docs/privacy/",
);

final stdeulaUrl = Uri(
  scheme: "https",
  host: "www.apple.com",
  path: "/legal/internet-services/itunes/dev/stdeula/",
);

final githubUrl = Uri(
  scheme: "https",
  host: "github.com",
  path: "/k8zdev/k8z",
);
