// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `k8z`
  String get appName {
    return Intl.message(
      'k8z',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `version`
  String get version {
    return Intl.message(
      'version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `ok`
  String get ok {
    return Intl.message(
      'ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `cancel`
  String get cancel {
    return Intl.message(
      'cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `delete`
  String get delete {
    return Intl.message(
      'delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `error`
  String get error {
    return Intl.message(
      'error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `load file`
  String get load_file {
    return Intl.message(
      'load file',
      name: 'load_file',
      desc: '',
      args: [],
    );
  }

  /// `next step`
  String get next_step {
    return Intl.message(
      'next step',
      name: 'next_step',
      desc: '',
      args: [],
    );
  }

  /// `Clusters`
  String get clusters {
    return Intl.message(
      'Clusters',
      name: 'clusters',
      desc: '',
      args: [],
    );
  }

  /// `Workloads`
  String get workloads {
    return Intl.message(
      'Workloads',
      name: 'workloads',
      desc: '',
      args: [],
    );
  }

  /// `Pods`
  String get pods {
    return Intl.message(
      'Pods',
      name: 'pods',
      desc: '',
      args: [],
    );
  }

  /// `DaemonSets`
  String get daemon_sets {
    return Intl.message(
      'DaemonSets',
      name: 'daemon_sets',
      desc: '',
      args: [],
    );
  }

  /// `Deployments`
  String get deployments {
    return Intl.message(
      'Deployments',
      name: 'deployments',
      desc: '',
      args: [],
    );
  }

  /// `StatefulSets`
  String get stateful_sets {
    return Intl.message(
      'StatefulSets',
      name: 'stateful_sets',
      desc: '',
      args: [],
    );
  }

  /// `Discovery and Load Balancing`
  String get discovery_and_lb {
    return Intl.message(
      'Discovery and Load Balancing',
      name: 'discovery_and_lb',
      desc: '',
      args: [],
    );
  }

  /// `Endpoints`
  String get endpoints {
    return Intl.message(
      'Endpoints',
      name: 'endpoints',
      desc: '',
      args: [],
    );
  }

  /// `Ingresses`
  String get ingresses {
    return Intl.message(
      'Ingresses',
      name: 'ingresses',
      desc: '',
      args: [],
    );
  }

  /// `Services`
  String get services {
    return Intl.message(
      'Services',
      name: 'services',
      desc: '',
      args: [],
    );
  }

  /// `Resources`
  String get resources {
    return Intl.message(
      'Resources',
      name: 'resources',
      desc: '',
      args: [],
    );
  }

  /// `Namespaces`
  String get namespaces {
    return Intl.message(
      'Namespaces',
      name: 'namespaces',
      desc: '',
      args: [],
    );
  }

  /// `CustomResourceDefinition`
  String get crds {
    return Intl.message(
      'CustomResourceDefinition',
      name: 'crds',
      desc: '',
      args: [],
    );
  }

  /// `Config`
  String get config {
    return Intl.message(
      'Config',
      name: 'config',
      desc: '',
      args: [],
    );
  }

  /// `ConfigMaps`
  String get config_maps {
    return Intl.message(
      'ConfigMaps',
      name: 'config_maps',
      desc: '',
      args: [],
    );
  }

  /// `Secrets`
  String get secrets {
    return Intl.message(
      'Secrets',
      name: 'secrets',
      desc: '',
      args: [],
    );
  }

  /// `ServiceAccounts`
  String get service_accounts {
    return Intl.message(
      'ServiceAccounts',
      name: 'service_accounts',
      desc: '',
      args: [],
    );
  }

  /// `Storage`
  String get storage {
    return Intl.message(
      'Storage',
      name: 'storage',
      desc: '',
      args: [],
    );
  }

  /// `StorageClass`
  String get storage_class {
    return Intl.message(
      'StorageClass',
      name: 'storage_class',
      desc: '',
      args: [],
    );
  }

  /// `Persistent Volumes`
  String get pvs {
    return Intl.message(
      'Persistent Volumes',
      name: 'pvs',
      desc: '',
      args: [],
    );
  }

  /// `Persistent Volume Claims`
  String get pvcs {
    return Intl.message(
      'Persistent Volume Claims',
      name: 'pvcs',
      desc: '',
      args: [],
    );
  }

  /// `save clusters`
  String get save_clusters {
    return Intl.message(
      'save clusters',
      name: 'save_clusters',
      desc: '',
      args: [],
    );
  }

  /// `appearance`
  String get appearance {
    return Intl.message(
      'appearance',
      name: 'appearance',
      desc: '',
      args: [],
    );
  }

  /// `auto`
  String get theme_auto {
    return Intl.message(
      'auto',
      name: 'theme_auto',
      desc: '',
      args: [],
    );
  }

  /// `dark mode`
  String get theme_dark {
    return Intl.message(
      'dark mode',
      name: 'theme_dark',
      desc: '',
      args: [],
    );
  }

  /// `light mode`
  String get theme_light {
    return Intl.message(
      'light mode',
      name: 'theme_light',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `general`
  String get general {
    return Intl.message(
      'general',
      name: 'general',
      desc: '',
      args: [],
    );
  }

  /// `language`
  String get general_language {
    return Intl.message(
      'language',
      name: 'general_language',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get general_language_en {
    return Intl.message(
      'English',
      name: 'general_language_en',
      desc: '',
      args: [],
    );
  }

  /// `Chinese`
  String get general_language_zh {
    return Intl.message(
      'Chinese',
      name: 'general_language_zh',
      desc: '',
      args: [],
    );
  }

  /// `Japanese`
  String get general_language_ja {
    return Intl.message(
      'Japanese',
      name: 'general_language_ja',
      desc: '',
      args: [],
    );
  }

  /// `Auto`
  String get general_language_null {
    return Intl.message(
      'Auto',
      name: 'general_language_null',
      desc: '',
      args: [],
    );
  }

  /// `debug`
  String get general_debug {
    return Intl.message(
      'debug',
      name: 'general_debug',
      desc: '',
      args: [],
    );
  }

  /// `sqlview`
  String get general_debug_sqlview {
    return Intl.message(
      'sqlview',
      name: 'general_debug_sqlview',
      desc: '',
      args: [],
    );
  }

  /// `Add cluster`
  String get add_cluster {
    return Intl.message(
      'Add cluster',
      name: 'add_cluster',
      desc: '',
      args: [],
    );
  }

  /// `Load kubeconfig file`
  String get manual_load_kubeconfig {
    return Intl.message(
      'Load kubeconfig file',
      name: 'manual_load_kubeconfig',
      desc: '',
      args: [],
    );
  }

  /// `can not get cluster kubeconfig, contexts maybe empty`
  String get empyt_context {
    return Intl.message(
      'can not get cluster kubeconfig, contexts maybe empty',
      name: 'empyt_context',
      desc: '',
      args: [],
    );
  }

  /// `Select cluster(s)`
  String get select_clusters {
    return Intl.message(
      'Select cluster(s)',
      name: 'select_clusters',
      desc: '',
      args: [],
    );
  }

  /// `flush database`
  String get debug_flushdb {
    return Intl.message(
      'flush database',
      name: 'debug_flushdb',
      desc: '',
      args: [],
    );
  }

  /// `database flushed`
  String get debug_flushdb_done {
    return Intl.message(
      'database flushed',
      name: 'debug_flushdb_done',
      desc: '',
      args: [],
    );
  }

  /// `will flush all data at database`
  String get debug_flushdb_desc {
    return Intl.message(
      'will flush all data at database',
      name: 'debug_flushdb_desc',
      desc: '',
      args: [],
    );
  }

  /// `Overview`
  String get overview {
    return Intl.message(
      'Overview',
      name: 'overview',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Running`
  String get running {
    return Intl.message(
      'Running',
      name: 'running',
      desc: '',
      args: [],
    );
  }

  /// `Nodes`
  String get nodes {
    return Intl.message(
      'Nodes',
      name: 'nodes',
      desc: '',
      args: [],
    );
  }

  /// `A node may be a virtual or physical machine.`
  String get nodes_desc {
    return Intl.message(
      'A node may be a virtual or physical machine.',
      name: 'nodes_desc',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more {
    return Intl.message(
      'More',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Events`
  String get events {
    return Intl.message(
      'Events',
      name: 'events',
      desc: '',
      args: [],
    );
  }

  /// `last {n} warnings`
  String last_warning_events(num n) {
    return Intl.message(
      'last $n warnings',
      name: 'last_warning_events',
      desc: '',
      args: [n],
    );
  }

  /// `{namespace} / {name}\n\nType: {type}\nReason: {reason}\nObject: {kind}/{objName}\nLast Seen: {lastTimestamp}\n\nMessage: {message}\n`
  String event_text(String namespace, String name, String type, String reason,
      String kind, String objName, String lastTimestamp, String message) {
    return Intl.message(
      '$namespace / $name\n\nType: $type\nReason: $reason\nObject: $kind/$objName\nLast Seen: $lastTimestamp\n\nMessage: $message\n',
      name: 'event_text',
      desc: '',
      args: [
        namespace,
        name,
        type,
        reason,
        kind,
        objName,
        lastTimestamp,
        message
      ],
    );
  }

  /// `Roles:\t\t {arg}`
  String node_roles(Object arg) {
    return Intl.message(
      'Roles:\t\t $arg',
      name: 'node_roles',
      desc: '',
      args: [arg],
    );
  }

  /// `Architecture\t\t: {arg}`
  String node_arch(Object arg) {
    return Intl.message(
      'Architecture\t\t: $arg',
      name: 'node_arch',
      desc: '',
      args: [arg],
    );
  }

  /// `Version:\t\t {arg}`
  String node_version(Object arg) {
    return Intl.message(
      'Version:\t\t $arg',
      name: 'node_version',
      desc: '',
      args: [arg],
    );
  }

  /// `Kernel:\t\t {arg}`
  String node_os_image(Object arg) {
    return Intl.message(
      'Kernel:\t\t $arg',
      name: 'node_os_image',
      desc: '',
      args: [arg],
    );
  }

  /// `Kernel:\t\t {os}/{arg}`
  String node_kernel(Object os, Object arg) {
    return Intl.message(
      'Kernel:\t\t $os/$arg',
      name: 'node_kernel',
      desc: '',
      args: [os, arg],
    );
  }

  /// `Internal-IP:\t\t {arg}`
  String internel_ip(Object arg) {
    return Intl.message(
      'Internal-IP:\t\t $arg',
      name: 'internel_ip',
      desc: '',
      args: [arg],
    );
  }

  /// `External-IP:\t\t {arg}`
  String external_ip(Object arg) {
    return Intl.message(
      'External-IP:\t\t $arg',
      name: 'external_ip',
      desc: '',
      args: [arg],
    );
  }

  /// `Runtime:\t\t {arg}`
  String container_runtime(Object arg) {
    return Intl.message(
      'Runtime:\t\t $arg',
      name: 'container_runtime',
      desc: '',
      args: [arg],
    );
  }

  /// `Current cluster`
  String get current_cluster {
    return Intl.message(
      'Current cluster',
      name: 'current_cluster',
      desc: '',
      args: [],
    );
  }

  /// `are your sure?`
  String get arsure {
    return Intl.message(
      'are your sure?',
      name: 'arsure',
      desc: '',
      args: [],
    );
  }

  /// `will delete {type} {name}`
  String will_delete(Object type, Object name) {
    return Intl.message(
      'will delete $type $name',
      name: 'will_delete',
      desc: '',
      args: [type, name],
    );
  }

  /// `{name} deleted`
  String deleted(Object name) {
    return Intl.message(
      '$name deleted',
      name: 'deleted',
      desc: '',
      args: [name],
    );
  }

  /// `delete failed, error: {error}`
  String delete_failed(Object error) {
    return Intl.message(
      'delete failed, error: $error',
      name: 'delete_failed',
      desc: '',
      args: [error],
    );
  }

  /// `no current cluster`
  String get no_current_cluster {
    return Intl.message(
      'no current cluster',
      name: 'no_current_cluster',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get age {
    return Intl.message(
      'Age',
      name: 'age',
      desc: '',
      args: [],
    );
  }

  /// `Totals: {number}`
  String totals(Object number) {
    return Intl.message(
      'Totals: $number',
      name: 'totals',
      desc: '',
      args: [number],
    );
  }

  /// `{name}\n\nKind: {kind}\nScope: {scope}\nshortNames: {shortNames}`
  String crds_text(Object name, Object kind, Object scope, Object shortNames) {
    return Intl.message(
      '$name\n\nKind: $kind\nScope: $scope\nshortNames: $shortNames',
      name: 'crds_text',
      desc: '',
      args: [name, kind, scope, shortNames],
    );
  }

  /// `{name}\n\nNamespace: {namespace}\nReady: {ready}\nStatus: {status}\nRestarts: {restarts}\nContainers: {containers}\nCPU: {cpu}\nMemory: {memory}`
  String pod_text(Object name, Object namespace, Object ready, Object status,
      Object restarts, Object containers, Object cpu, Object memory) {
    return Intl.message(
      '$name\n\nNamespace: $namespace\nReady: $ready\nStatus: $status\nRestarts: $restarts\nContainers: $containers\nCPU: $cpu\nMemory: $memory',
      name: 'pod_text',
      desc: '',
      args: [name, namespace, ready, status, restarts, containers, cpu, memory],
    );
  }

  /// ` ({number} items)`
  String items_number(Object number) {
    return Intl.message(
      ' ($number items)',
      name: 'items_number',
      desc: '',
      args: [number],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
