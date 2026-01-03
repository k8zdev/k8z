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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `k8z`
  String get appName {
    return Intl.message('k8z', name: 'appName', desc: '', args: []);
  }

  /// `Version`
  String get version {
    return Intl.message('Version', name: 'version', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `ok`
  String get ok {
    return Intl.message('ok', name: 'ok', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `error`
  String get error {
    return Intl.message('error', name: 'error', desc: '', args: []);
  }

  /// `load file`
  String get load_file {
    return Intl.message('load file', name: 'load_file', desc: '', args: []);
  }

  /// `next step`
  String get next_step {
    return Intl.message('next step', name: 'next_step', desc: '', args: []);
  }

  /// `Clusters`
  String get clusters {
    return Intl.message('Clusters', name: 'clusters', desc: '', args: []);
  }

  /// `Workloads`
  String get workloads {
    return Intl.message('Workloads', name: 'workloads', desc: '', args: []);
  }

  /// `Pods`
  String get pods {
    return Intl.message('Pods', name: 'pods', desc: '', args: []);
  }

  /// `DaemonSets`
  String get daemon_sets {
    return Intl.message('DaemonSets', name: 'daemon_sets', desc: '', args: []);
  }

  /// `Deployments`
  String get deployments {
    return Intl.message('Deployments', name: 'deployments', desc: '', args: []);
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
    return Intl.message('Endpoints', name: 'endpoints', desc: '', args: []);
  }

  /// `Ingresses`
  String get ingresses {
    return Intl.message('Ingresses', name: 'ingresses', desc: '', args: []);
  }

  /// `Services`
  String get services {
    return Intl.message('Services', name: 'services', desc: '', args: []);
  }

  /// `Resources`
  String get resources {
    return Intl.message('Resources', name: 'resources', desc: '', args: []);
  }

  /// `Namespace`
  String get namespace {
    return Intl.message('Namespace', name: 'namespace', desc: '', args: []);
  }

  /// `Namespaces`
  String get namespaces {
    return Intl.message('Namespaces', name: 'namespaces', desc: '', args: []);
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
    return Intl.message('Config', name: 'config', desc: '', args: []);
  }

  /// `ConfigMaps`
  String get config_maps {
    return Intl.message('ConfigMaps', name: 'config_maps', desc: '', args: []);
  }

  /// `Secrets`
  String get secrets {
    return Intl.message('Secrets', name: 'secrets', desc: '', args: []);
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
    return Intl.message('Storage', name: 'storage', desc: '', args: []);
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
    return Intl.message('Persistent Volumes', name: 'pvs', desc: '', args: []);
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

  /// `Appearance`
  String get appearance {
    return Intl.message('Appearance', name: 'appearance', desc: '', args: []);
  }

  /// `Auto`
  String get theme_auto {
    return Intl.message('Auto', name: 'theme_auto', desc: '', args: []);
  }

  /// `Dark mode`
  String get theme_dark {
    return Intl.message('Dark mode', name: 'theme_dark', desc: '', args: []);
  }

  /// `Light mode`
  String get theme_light {
    return Intl.message('Light mode', name: 'theme_light', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `General`
  String get general {
    return Intl.message('General', name: 'general', desc: '', args: []);
  }

  /// `Language`
  String get general_language {
    return Intl.message(
      'Language',
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
    return Intl.message('debug', name: 'general_debug', desc: '', args: []);
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
    return Intl.message('Add cluster', name: 'add_cluster', desc: '', args: []);
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
    return Intl.message('Overview', name: 'overview', desc: '', args: []);
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Running`
  String get running {
    return Intl.message('Running', name: 'running', desc: '', args: []);
  }

  /// `Nodes`
  String get nodes {
    return Intl.message('Nodes', name: 'nodes', desc: '', args: []);
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
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `More`
  String get more {
    return Intl.message('More', name: 'more', desc: '', args: []);
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Events`
  String get events {
    return Intl.message('Events', name: 'events', desc: '', args: []);
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
  String event_text(
    String namespace,
    String name,
    String type,
    String reason,
    String kind,
    String objName,
    String lastTimestamp,
    String message,
  ) {
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
        message,
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
    return Intl.message('are your sure?', name: 'arsure', desc: '', args: []);
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
    return Intl.message('Age', name: 'age', desc: '', args: []);
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
  String pod_text(
    Object name,
    Object namespace,
    Object ready,
    Object status,
    Object restarts,
    Object containers,
    Object cpu,
    Object memory,
  ) {
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

  /// `loading metrics`
  String get loading_metrics {
    return Intl.message(
      'loading metrics',
      name: 'loading_metrics',
      desc: '',
      args: [],
    );
  }

  /// `load metrics error: {error}`
  String load_metrics_error(Object error) {
    return Intl.message(
      'load metrics error: $error',
      name: 'load_metrics_error',
      desc: '',
      args: [error],
    );
  }

  /// `CPU`
  String get cpu {
    return Intl.message('CPU', name: 'cpu', desc: '', args: []);
  }

  /// `Memory`
  String get memory {
    return Intl.message('Memory', name: 'memory', desc: '', args: []);
  }

  /// `{name}\nNamespace: {ns}\nReady: {ready}\nUp to date: {upToDate}\nAvailable: {available}`
  String deployment_text(
    Object name,
    Object ns,
    Object ready,
    Object upToDate,
    Object available,
  ) {
    return Intl.message(
      '$name\nNamespace: $ns\nReady: $ready\nUp to date: $upToDate\nAvailable: $available',
      name: 'deployment_text',
      desc: '',
      args: [name, ns, ready, upToDate, available],
    );
  }

  /// `{name}\nNamespace: {ns}\nReady: {ready}\nUp to date: {upToDate}\nAvailable: {available}\n`
  String daemon_set_text(
    Object name,
    Object ns,
    Object ready,
    Object upToDate,
    Object available,
  ) {
    return Intl.message(
      '$name\nNamespace: $ns\nReady: $ready\nUp to date: $upToDate\nAvailable: $available\n',
      name: 'daemon_set_text',
      desc: '',
      args: [name, ns, ready, upToDate, available],
    );
  }

  /// `{name}\nNamespace: {ns}\nReady: {ready}\nUp to date: {upToDate}\nAvailable: {available}\n`
  String stateful_set_text(
    Object name,
    Object ns,
    Object ready,
    Object upToDate,
    Object available,
  ) {
    return Intl.message(
      '$name\nNamespace: $ns\nReady: $ready\nUp to date: $upToDate\nAvailable: $available\n',
      name: 'stateful_set_text',
      desc: '',
      args: [name, ns, ready, upToDate, available],
    );
  }

  /// `{name}\nNamespace: {ns}\nClass: {className}\nHosts: {hosts}\nAddress: {address}\nPorts: {ports}`
  String ingress_text(
    Object name,
    Object ns,
    Object className,
    Object hosts,
    Object address,
    Object ports,
  ) {
    return Intl.message(
      '$name\nNamespace: $ns\nClass: $className\nHosts: $hosts\nAddress: $address\nPorts: $ports',
      name: 'ingress_text',
      desc: '',
      args: [name, ns, className, hosts, address, ports],
    );
  }

  /// `{name}\nNamespace: {ns}\nType: {type}\nCluster IP: {clusterIP}\nExternal IP: {externalIP}\nPorts: {ports}`
  String service_text(
    Object name,
    Object ns,
    Object type,
    Object clusterIP,
    Object externalIP,
    Object ports,
  ) {
    return Intl.message(
      '$name\nNamespace: $ns\nType: $type\nCluster IP: $clusterIP\nExternal IP: $externalIP\nPorts: $ports',
      name: 'service_text',
      desc: '',
      args: [name, ns, type, clusterIP, externalIP, ports],
    );
  }

  /// `{name}\nNamespace: {ns}\nEndpoints: {endpoints}`
  String endpoint_text(Object name, Object ns, Object endpoints) {
    return Intl.message(
      '$name\nNamespace: $ns\nEndpoints: $endpoints',
      name: 'endpoint_text',
      desc: '',
      args: [name, ns, endpoints],
    );
  }

  /// `{name}\nNamespace: {ns}\nData: {data}`
  String config_map_text(Object name, Object ns, Object data) {
    return Intl.message(
      '$name\nNamespace: $ns\nData: $data',
      name: 'config_map_text',
      desc: '',
      args: [name, ns, data],
    );
  }

  /// `{name}\nNamespace: {ns}\nType: {type}\nData: {data}`
  String secret_text(Object name, Object ns, Object type, Object data) {
    return Intl.message(
      '$name\nNamespace: $ns\nType: $type\nData: $data',
      name: 'secret_text',
      desc: '',
      args: [name, ns, type, data],
    );
  }

  /// `{name}\nNamespace: {ns}\nSecret: {secrets}`
  String service_account_text(Object name, Object ns, Object secrets) {
    return Intl.message(
      '$name\nNamespace: $ns\nSecret: $secrets',
      name: 'service_account_text',
      desc: '',
      args: [name, ns, secrets],
    );
  }

  /// `{name}\nProvisioner: {provisioner}\nReclaim Policy: {reclaimPolicy}\nVolume Binding Mode: {volumeBindingMode}\nAllow Volume Expansion: {allowVolumeExpansion}\nMountOptions: {mountOptions}`
  String storage_class_text(
    Object name,
    Object provisioner,
    Object reclaimPolicy,
    Object mountOptions,
    Object volumeBindingMode,
    Object allowVolumeExpansion,
  ) {
    return Intl.message(
      '$name\nProvisioner: $provisioner\nReclaim Policy: $reclaimPolicy\nVolume Binding Mode: $volumeBindingMode\nAllow Volume Expansion: $allowVolumeExpansion\nMountOptions: $mountOptions',
      name: 'storage_class_text',
      desc: '',
      args: [
        name,
        provisioner,
        reclaimPolicy,
        mountOptions,
        volumeBindingMode,
        allowVolumeExpansion,
      ],
    );
  }

  /// `{name}\nCapacity: {capacity}\nAccess Modes: {accessModes}\nReclaim Policy: {reclaimPolicy}\nStatus: {status}\nClaim: {claim}\nStorage Class: {storageClass}\nReason: {reason}\n`
  String pv_text(
    Object name,
    Object capacity,
    Object accessModes,
    Object reclaimPolicy,
    Object status,
    Object claim,
    Object storageClass,
    Object reason,
  ) {
    return Intl.message(
      '$name\nCapacity: $capacity\nAccess Modes: $accessModes\nReclaim Policy: $reclaimPolicy\nStatus: $status\nClaim: $claim\nStorage Class: $storageClass\nReason: $reason\n',
      name: 'pv_text',
      desc: '',
      args: [
        name,
        capacity,
        accessModes,
        reclaimPolicy,
        status,
        claim,
        storageClass,
        reason,
      ],
    );
  }

  /// `{name}\nNamespace: {ns}\nStatus: {status}\nVolume: {volume}\nCapacity: {capacity}\nAccess Modes: {accessModes}\nStorage Class: {storageClass}`
  String pvc_text(
    Object name,
    Object ns,
    Object status,
    Object volume,
    Object capacity,
    Object accessModes,
    Object storageClass,
  ) {
    return Intl.message(
      '$name\nNamespace: $ns\nStatus: $status\nVolume: $volume\nCapacity: $capacity\nAccess Modes: $accessModes\nStorage Class: $storageClass',
      name: 'pvc_text',
      desc: '',
      args: [name, ns, status, volume, capacity, accessModes, storageClass],
    );
  }

  /// `Applications`
  String get applications {
    return Intl.message(
      'Applications',
      name: 'applications',
      desc: '',
      args: [],
    );
  }

  /// `Helm`
  String get helm {
    return Intl.message('Helm', name: 'helm', desc: '', args: []);
  }

  /// `Releases`
  String get releases {
    return Intl.message('Releases', name: 'releases', desc: '', args: []);
  }

  /// `{name}\nNamespace: {ns}\nRevision: {revision}\nApp Version: {appVer}\nUpdated: {updated}\nStatus: {status}\nChart: {chart}`
  String release_text(
    Object name,
    Object ns,
    Object revision,
    Object appVer,
    Object updated,
    Object status,
    Object chart,
  ) {
    return Intl.message(
      '$name\nNamespace: $ns\nRevision: $revision\nApp Version: $appVer\nUpdated: $updated\nStatus: $status\nChart: $chart',
      name: 'release_text',
      desc: '',
      args: [name, ns, revision, appVer, updated, status, chart],
    );
  }

  /// `EULA`
  String get eula {
    return Intl.message('EULA', name: 'eula', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `Sponsor me`
  String get sponsorme {
    return Intl.message('Sponsor me', name: 'sponsorme', desc: '', args: []);
  }

  /// `Sponsor me so that I can continue to develop and maintain this app.`
  String get sponsor_desc {
    return Intl.message(
      'Sponsor me so that I can continue to develop and maintain this app.',
      name: 'sponsor_desc',
      desc: '',
      args: [],
    );
  }

  /// `Monthly`
  String get subscriptions_monthly {
    return Intl.message(
      'Monthly',
      name: 'subscriptions_monthly',
      desc: '',
      args: [],
    );
  }

  /// `Yearly`
  String get subscriptions_yearly {
    return Intl.message(
      'Yearly',
      name: 'subscriptions_yearly',
      desc: '',
      args: [],
    );
  }

  /// `Lifetime`
  String get subscriptions_lifetime {
    return Intl.message(
      'Lifetime',
      name: 'subscriptions_lifetime',
      desc: '',
      args: [],
    );
  }

  /// `If not cancelled, the subscription will be renewed automatically. Payment will be charged to the iTunes account when the purchase is confirmed. Subscriptions are automatically renewed unless automatic renewal is closed at least 24 hours before the end of the current term. The account will charge a renewal fee within 24 hours prior to the end of the current period and determine the renewal fee. Subscriptions can be managed by the user and auto-renewal can be turned off after purchase by going to the user''s account settings. Any unused portion of the free trial period, if provided, will be forfeited when the user purchases a subscription to the publication.`
  String get subscriptions_iap_desc {
    return Intl.message(
      'If not cancelled, the subscription will be renewed automatically. Payment will be charged to the iTunes account when the purchase is confirmed. Subscriptions are automatically renewed unless automatic renewal is closed at least 24 hours before the end of the current term. The account will charge a renewal fee within 24 hours prior to the end of the current period and determine the renewal fee. Subscriptions can be managed by the user and auto-renewal can be turned off after purchase by going to the user\'\'s account settings. Any unused portion of the free trial period, if provided, will be forfeited when the user purchases a subscription to the publication.',
      name: 'subscriptions_iap_desc',
      desc: '',
      args: [],
    );
  }

  /// `Purchased`
  String get subscriptions_purchased {
    return Intl.message(
      'Purchased',
      name: 'subscriptions_purchased',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message('Success', name: 'success', desc: '', args: []);
  }

  /// `Restore Purchases`
  String get subscriptions_restore_purchases {
    return Intl.message(
      'Restore Purchases',
      name: 'subscriptions_restore_purchases',
      desc: '',
      args: [],
    );
  }

  /// `Resotre success.`
  String get subscriptions_restore_success {
    return Intl.message(
      'Resotre success.',
      name: 'subscriptions_restore_success',
      desc: '',
      args: [],
    );
  }

  /// `Restore Purchases Failed, ERROR: {error}`
  String subscriptions_restorePurchases_failed(Object error) {
    return Intl.message(
      'Restore Purchases Failed, ERROR: $error',
      name: 'subscriptions_restorePurchases_failed',
      desc: '',
      args: [error],
    );
  }

  /// `Sponsor expired: ${date}`
  String subscriptions_expired_at(Object date) {
    return Intl.message(
      'Sponsor expired: \$$date',
      name: 'subscriptions_expired_at',
      desc: '',
      args: [date],
    );
  }

  /// `Terminal`
  String get terminal {
    return Intl.message('Terminal', name: 'terminal', desc: '', args: []);
  }

  /// `Logs`
  String get logs {
    return Intl.message('Logs', name: 'logs', desc: '', args: []);
  }

  /// `Start debug`
  String get start_debug {
    return Intl.message('Start debug', name: 'start_debug', desc: '', args: []);
  }

  /// `Start debug will create a new ephemeral container in the pod, and attach to it's stdin, stdout, and stderr.`
  String get start_debug_desc {
    return Intl.message(
      'Start debug will create a new ephemeral container in the pod, and attach to it\'s stdin, stdout, and stderr.',
      name: 'start_debug_desc',
      desc: '',
      args: [],
    );
  }

  /// `Container`
  String get container {
    return Intl.message('Container', name: 'container', desc: '', args: []);
  }

  /// `Ephemeral Containers`
  String get ephemeral_containers {
    return Intl.message(
      'Ephemeral Containers',
      name: 'ephemeral_containers',
      desc: '',
      args: [],
    );
  }

  /// `Node Shell`
  String get node_shell {
    return Intl.message('Node Shell', name: 'node_shell', desc: '', args: []);
  }

  /// `Get Terminal`
  String get get_terminal {
    return Intl.message(
      'Get Terminal',
      name: 'get_terminal',
      desc: '',
      args: [],
    );
  }

  /// `{number} terminals opened`
  String terminals_opened(Object number) {
    return Intl.message(
      '$number terminals opened',
      name: 'terminals_opened',
      desc: '',
      args: [number],
    );
  }

  /// `Since`
  String get since {
    return Intl.message('Since', name: 'since', desc: '', args: []);
  }

  /// `Tail Lines`
  String get tail_lines {
    return Intl.message('Tail Lines', name: 'tail_lines', desc: '', args: []);
  }

  /// `API Timeout`
  String get api_timeout {
    return Intl.message('API Timeout', name: 'api_timeout', desc: '', args: []);
  }

  /// `{n} s`
  String n_seconds(num n) {
    return Intl.message('$n s', name: 'n_seconds', desc: '', args: [n]);
  }

  /// `\t\tduration: {duration}`
  String api_request_duration(Object duration) {
    return Intl.message(
      '\t\tduration: $duration',
      name: 'api_request_duration',
      desc: '',
      args: [duration],
    );
  }

  /// `Labels`
  String get labels {
    return Intl.message('Labels', name: 'labels', desc: '', args: []);
  }

  /// `Annotations`
  String get annotations {
    return Intl.message('Annotations', name: 'annotations', desc: '', args: []);
  }

  /// `metadata`
  String get metadata {
    return Intl.message('metadata', name: 'metadata', desc: '', args: []);
  }

  /// `Resource Yaml`
  String get resource_yaml {
    return Intl.message(
      'Resource Yaml',
      name: 'resource_yaml',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get export {
    return Intl.message('Export', name: 'export', desc: '', args: []);
  }

  /// `Exported to {path}`
  String exported(Object path) {
    return Intl.message(
      'Exported to $path',
      name: 'exported',
      desc: '',
      args: [path],
    );
  }

  /// `Scale`
  String get scale {
    return Intl.message('Scale', name: 'scale', desc: '', args: []);
  }

  /// `Scale to {N} replica(s)`
  String scale_to(Object N) {
    return Intl.message(
      'Scale to $N replica(s)',
      name: 'scale_to',
      desc: '',
      args: [N],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
  }

  /// `scale success`
  String get scale_ok {
    return Intl.message('scale success', name: 'scale_ok', desc: '', args: []);
  }

  /// `scale failed, error: {error}`
  String scale_failed(Object error) {
    return Intl.message(
      'scale failed, error: $error',
      name: 'scale_failed',
      desc: '',
      args: [error],
    );
  }

  /// `Support`
  String get support {
    return Intl.message('Support', name: 'support', desc: '', args: []);
  }

  /// `Feedback`
  String get feedback {
    return Intl.message('Feedback', name: 'feedback', desc: '', args: []);
  }

  /// `Documents`
  String get documents {
    return Intl.message('Documents', name: 'documents', desc: '', args: []);
  }

  /// `Generation`
  String get generation {
    return Intl.message('Generation', name: 'generation', desc: '', args: []);
  }

  /// `Version`
  String get resourceVersion {
    return Intl.message('Version', name: 'resourceVersion', desc: '', args: []);
  }

  /// `SelfLink`
  String get selfLink {
    return Intl.message('SelfLink', name: 'selfLink', desc: '', args: []);
  }

  /// `Uid`
  String get uid {
    return Intl.message('Uid', name: 'uid', desc: '', args: []);
  }

  /// `Finalizers`
  String get finalizers {
    return Intl.message('Finalizers', name: 'finalizers', desc: '', args: []);
  }

  /// `empty`
  String get empty {
    return Intl.message('empty', name: 'empty', desc: '', args: []);
  }

  /// `Data`
  String get data {
    return Intl.message('Data', name: 'data', desc: '', args: []);
  }

  /// `Spec`
  String get spec {
    return Intl.message('Spec', name: 'spec', desc: '', args: []);
  }

  /// `DNS Policy`
  String get dnsPolicy {
    return Intl.message('DNS Policy', name: 'dnsPolicy', desc: '', args: []);
  }

  /// `Host Network`
  String get hostNetwork {
    return Intl.message(
      'Host Network',
      name: 'hostNetwork',
      desc: '',
      args: [],
    );
  }

  /// `Hostname`
  String get hostname {
    return Intl.message('Hostname', name: 'hostname', desc: '', args: []);
  }

  /// `Image Pull Secrets`
  String get imagePullSecrets {
    return Intl.message(
      'Image Pull Secrets',
      name: 'imagePullSecrets',
      desc: '',
      args: [],
    );
  }

  /// `Containers`
  String get containers {
    return Intl.message('Containers', name: 'containers', desc: '', args: []);
  }

  /// `Image`
  String get image {
    return Intl.message('Image', name: 'image', desc: '', args: []);
  }

  /// `Image Pull Policy`
  String get imagePullPolicy {
    return Intl.message(
      'Image Pull Policy',
      name: 'imagePullPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Liveness Probe`
  String get livenessProbe {
    return Intl.message(
      'Liveness Probe',
      name: 'livenessProbe',
      desc: '',
      args: [],
    );
  }

  /// `Readiness Probe`
  String get readinessProbe {
    return Intl.message(
      'Readiness Probe',
      name: 'readinessProbe',
      desc: '',
      args: [],
    );
  }

  /// `Startup Probe`
  String get startupProbe {
    return Intl.message(
      'Startup Probe',
      name: 'startupProbe',
      desc: '',
      args: [],
    );
  }

  /// `Init Containers`
  String get initContainers {
    return Intl.message(
      'Init Containers',
      name: 'initContainers',
      desc: '',
      args: [],
    );
  }

  /// `Ports`
  String get ports {
    return Intl.message('Ports', name: 'ports', desc: '', args: []);
  }

  /// `Command`
  String get command {
    return Intl.message('Command', name: 'command', desc: '', args: []);
  }

  /// `Arguments`
  String get args {
    return Intl.message('Arguments', name: 'args', desc: '', args: []);
  }

  /// `Are you sure delete the resource?`
  String get delete_resource {
    return Intl.message(
      'Are you sure delete the resource?',
      name: 'delete_resource',
      desc: '',
      args: [],
    );
  }

  /// `Resource URL`
  String get resource_url {
    return Intl.message(
      'Resource URL',
      name: 'resource_url',
      desc: '',
      args: [],
    );
  }

  /// `Creation Time`
  String get creation_time {
    return Intl.message(
      'Creation Time',
      name: 'creation_time',
      desc: '',
      args: [],
    );
  }

  /// `delete resource success.`
  String get delete_ok {
    return Intl.message(
      'delete resource success.',
      name: 'delete_ok',
      desc: '',
      args: [],
    );
  }

  /// `Container ID`
  String get container_id {
    return Intl.message(
      'Container ID',
      name: 'container_id',
      desc: '',
      args: [],
    );
  }

  /// `Image ID`
  String get image_id {
    return Intl.message('Image ID', name: 'image_id', desc: '', args: []);
  }

  /// `ReplicaSets`
  String get replicasets {
    return Intl.message('ReplicaSets', name: 'replicasets', desc: '', args: []);
  }

  /// `{name}\nNamespace: {ns}\nCurrent: {current}\nReady: {ready}\nAvailable: {available}\n`
  String replicasets_text(
    Object name,
    Object ns,
    Object current,
    Object ready,
    Object available,
  ) {
    return Intl.message(
      '$name\nNamespace: $ns\nCurrent: $current\nReady: $ready\nAvailable: $available\n',
      name: 'replicasets_text',
      desc: '',
      args: [name, ns, current, ready, available],
    );
  }

  /// `Owner`
  String get owner {
    return Intl.message('Owner', name: 'owner', desc: '', args: []);
  }

  /// `apiVersion`
  String get apiVersion {
    return Intl.message('apiVersion', name: 'apiVersion', desc: '', args: []);
  }

  /// `blockOwnerDeletion`
  String get blockOwnerDeletion {
    return Intl.message(
      'blockOwnerDeletion',
      name: 'blockOwnerDeletion',
      desc: '',
      args: [],
    );
  }

  /// `controller`
  String get controller {
    return Intl.message('controller', name: 'controller', desc: '', args: []);
  }

  /// `kind`
  String get kind {
    return Intl.message('kind', name: 'kind', desc: '', args: []);
  }

  /// `Subsets`
  String get subsets {
    return Intl.message('Subsets', name: 'subsets', desc: '', args: []);
  }

  /// `Addresses`
  String get addresses {
    return Intl.message('Addresses', name: 'addresses', desc: '', args: []);
  }

  /// `Cluster IP`
  String get cluster_ip {
    return Intl.message('Cluster IP', name: 'cluster_ip', desc: '', args: []);
  }

  /// `External Name`
  String get external_name {
    return Intl.message(
      'External Name',
      name: 'external_name',
      desc: '',
      args: [],
    );
  }

  /// `External IPs`
  String get external_ips {
    return Intl.message(
      'External IPs',
      name: 'external_ips',
      desc: '',
      args: [],
    );
  }

  /// `Load Balancer IP`
  String get load_balancer_ip {
    return Intl.message(
      'Load Balancer IP',
      name: 'load_balancer_ip',
      desc: '',
      args: [],
    );
  }

  /// `Selector`
  String get selector {
    return Intl.message('Selector', name: 'selector', desc: '', args: []);
  }

  /// `Session Affinity`
  String get session_affinity {
    return Intl.message(
      'Session Affinity',
      name: 'session_affinity',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message('Type', name: 'type', desc: '', args: []);
  }

  /// `Page Not Found`
  String get page_not_found {
    return Intl.message(
      'Page Not Found',
      name: 'page_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Resource Details`
  String get resource_details {
    return Intl.message(
      'Resource Details',
      name: 'resource_details',
      desc: '',
      args: [],
    );
  }

  /// `Cluster Overview`
  String get cluster_overview {
    return Intl.message(
      'Cluster Overview',
      name: 'cluster_overview',
      desc: '',
      args: [],
    );
  }

  /// `Language Settings`
  String get language_settings {
    return Intl.message(
      'Language Settings',
      name: 'language_settings',
      desc: '',
      args: [],
    );
  }

  /// `Load Kubeconfig File`
  String get load_kubeconfig_file {
    return Intl.message(
      'Load Kubeconfig File',
      name: 'load_kubeconfig_file',
      desc: '',
      args: [],
    );
  }

  /// `Select Clusters`
  String get select_clusters_page {
    return Intl.message(
      'Select Clusters',
      name: 'select_clusters_page',
      desc: '',
      args: [],
    );
  }

  /// `Sponsor`
  String get sponsor_page {
    return Intl.message('Sponsor', name: 'sponsor_page', desc: '', args: []);
  }

  /// `Load Demo Cluster`
  String get load_demo_cluster {
    return Intl.message(
      'Load Demo Cluster',
      name: 'load_demo_cluster',
      desc: '',
      args: [],
    );
  }

  /// `Loading demo cluster...`
  String get demo_cluster_loading {
    return Intl.message(
      'Loading demo cluster...',
      name: 'demo_cluster_loading',
      desc: '',
      args: [],
    );
  }

  /// `Demo cluster loaded`
  String get demo_cluster_loaded {
    return Intl.message(
      'Demo cluster loaded',
      name: 'demo_cluster_loaded',
      desc: '',
      args: [],
    );
  }

  /// `Demo`
  String get demo_cluster_indicator {
    return Intl.message(
      'Demo',
      name: 'demo_cluster_indicator',
      desc: '',
      args: [],
    );
  }

  /// `Read-only`
  String get readonly_indicator {
    return Intl.message(
      'Read-only',
      name: 'readonly_indicator',
      desc: '',
      args: [],
    );
  }

  /// `Cannot connect to demo server, using offline demo.`
  String get demo_cluster_network_error {
    return Intl.message(
      'Cannot connect to demo server, using offline demo.',
      name: 'demo_cluster_network_error',
      desc: '',
      args: [],
    );
  }

  /// `Demo configuration decryption failed, please try again later.`
  String get demo_cluster_decrypt_error {
    return Intl.message(
      'Demo configuration decryption failed, please try again later.',
      name: 'demo_cluster_decrypt_error',
      desc: '',
      args: [],
    );
  }

  /// `Quickly experience K8zDev features without configuring a real cluster`
  String get demo_cluster_description {
    return Intl.message(
      'Quickly experience K8zDev features without configuring a real cluster',
      name: 'demo_cluster_description',
      desc: '',
      args: [],
    );
  }

  /// `Group`
  String get crd_group {
    return Intl.message('Group', name: 'crd_group', desc: '', args: []);
  }

  /// `Stored Versions`
  String get crd_storedVersions {
    return Intl.message(
      'Stored Versions',
      name: 'crd_storedVersions',
      desc: '',
      args: [],
    );
  }

  /// `Scope`
  String get crd_scope {
    return Intl.message('Scope', name: 'crd_scope', desc: '', args: []);
  }

  /// `Plural`
  String get crd_plural {
    return Intl.message('Plural', name: 'crd_plural', desc: '', args: []);
  }

  /// `Singular`
  String get crd_singular {
    return Intl.message('Singular', name: 'crd_singular', desc: '', args: []);
  }

  /// `Categories`
  String get crd_categories {
    return Intl.message(
      'Categories',
      name: 'crd_categories',
      desc: '',
      args: [],
    );
  }

  /// `Short Names`
  String get crd_shortNames {
    return Intl.message(
      'Short Names',
      name: 'crd_shortNames',
      desc: '',
      args: [],
    );
  }

  /// `Versions`
  String get crd_versions {
    return Intl.message('Versions', name: 'crd_versions', desc: '', args: []);
  }

  /// `Storage Version`
  String get crd_storageVersion {
    return Intl.message(
      'Storage Version',
      name: 'crd_storageVersion',
      desc: '',
      args: [],
    );
  }

  /// `OS Image`
  String get os_image {
    return Intl.message('OS Image', name: 'os_image', desc: '', args: []);
  }

  /// `Architecture`
  String get architecture {
    return Intl.message(
      'Architecture',
      name: 'architecture',
      desc: '',
      args: [],
    );
  }

  /// `Kernel Version`
  String get kernel_version {
    return Intl.message(
      'Kernel Version',
      name: 'kernel_version',
      desc: '',
      args: [],
    );
  }

  /// `Container Runtime Version`
  String get container_runtime_version {
    return Intl.message(
      'Container Runtime Version',
      name: 'container_runtime_version',
      desc: '',
      args: [],
    );
  }

  /// `Kubelet Version`
  String get kubelet_version {
    return Intl.message(
      'Kubelet Version',
      name: 'kubelet_version',
      desc: '',
      args: [],
    );
  }

  /// `OS Type`
  String get os_type {
    return Intl.message('OS Type', name: 'os_type', desc: '', args: []);
  }

  /// `Pod CIDR`
  String get pod_cidr {
    return Intl.message('Pod CIDR', name: 'pod_cidr', desc: '', args: []);
  }

  /// `Unschedulable`
  String get unschedulable {
    return Intl.message(
      'Unschedulable',
      name: 'unschedulable',
      desc: '',
      args: [],
    );
  }

  /// `Capacity`
  String get capacity {
    return Intl.message('Capacity', name: 'capacity', desc: '', args: []);
  }

  /// `Allocatable`
  String get allocatable {
    return Intl.message('Allocatable', name: 'allocatable', desc: '', args: []);
  }

  /// `Conditions`
  String get conditions {
    return Intl.message('Conditions', name: 'conditions', desc: '', args: []);
  }

  /// `Pod CIDRs`
  String get pod_cidrs {
    return Intl.message('Pod CIDRs', name: 'pod_cidrs', desc: '', args: []);
  }

  /// `Provider ID`
  String get provider_id {
    return Intl.message('Provider ID', name: 'provider_id', desc: '', args: []);
  }

  /// `Reason`
  String get reason {
    return Intl.message('Reason', name: 'reason', desc: '', args: []);
  }

  /// `Provisioner`
  String get provisioner {
    return Intl.message('Provisioner', name: 'provisioner', desc: '', args: []);
  }

  /// `Reclaim Policy`
  String get reclaim_policy {
    return Intl.message(
      'Reclaim Policy',
      name: 'reclaim_policy',
      desc: '',
      args: [],
    );
  }

  /// `Volume Binding Mode`
  String get volume_binding_mode {
    return Intl.message(
      'Volume Binding Mode',
      name: 'volume_binding_mode',
      desc: '',
      args: [],
    );
  }

  /// `Allow Volume Expansion`
  String get allow_volume_expansion {
    return Intl.message(
      'Allow Volume Expansion',
      name: 'allow_volume_expansion',
      desc: '',
      args: [],
    );
  }

  /// `Mount Options`
  String get mount_options {
    return Intl.message(
      'Mount Options',
      name: 'mount_options',
      desc: '',
      args: [],
    );
  }

  /// `Parameters`
  String get parameters {
    return Intl.message('Parameters', name: 'parameters', desc: '', args: []);
  }

  /// `Allowed Topologies`
  String get allowed_topologies {
    return Intl.message(
      'Allowed Topologies',
      name: 'allowed_topologies',
      desc: '',
      args: [],
    );
  }

  /// `Capacity`
  String get pv_capacity {
    return Intl.message('Capacity', name: 'pv_capacity', desc: '', args: []);
  }

  /// `Access Modes`
  String get pv_access_modes {
    return Intl.message(
      'Access Modes',
      name: 'pv_access_modes',
      desc: '',
      args: [],
    );
  }

  /// `Reclaim Policy`
  String get pv_reclaim_policy {
    return Intl.message(
      'Reclaim Policy',
      name: 'pv_reclaim_policy',
      desc: '',
      args: [],
    );
  }

  /// `Claim`
  String get pv_claim {
    return Intl.message('Claim', name: 'pv_claim', desc: '', args: []);
  }

  /// `Reason`
  String get pv_reason {
    return Intl.message('Reason', name: 'pv_reason', desc: '', args: []);
  }

  /// `Mount Options`
  String get pv_mount_options {
    return Intl.message(
      'Mount Options',
      name: 'pv_mount_options',
      desc: '',
      args: [],
    );
  }

  /// `Volume Mode`
  String get pv_volume_mode {
    return Intl.message(
      'Volume Mode',
      name: 'pv_volume_mode',
      desc: '',
      args: [],
    );
  }

  /// `Node Affinity`
  String get pv_node_affinity {
    return Intl.message(
      'Node Affinity',
      name: 'pv_node_affinity',
      desc: '',
      args: [],
    );
  }

  /// `Capacity Details`
  String get pv_capacity_details {
    return Intl.message(
      'Capacity Details',
      name: 'pv_capacity_details',
      desc: '',
      args: [],
    );
  }

  /// `Show`
  String get pv_show {
    return Intl.message('Show', name: 'pv_show', desc: '', args: []);
  }

  /// `Volume Name`
  String get volume_name {
    return Intl.message('Volume Name', name: 'volume_name', desc: '', args: []);
  }

  /// `Volume Mode`
  String get volume_mode {
    return Intl.message('Volume Mode', name: 'volume_mode', desc: '', args: []);
  }

  /// `Access Modes`
  String get access_modes {
    return Intl.message(
      'Access Modes',
      name: 'access_modes',
      desc: '',
      args: [],
    );
  }

  /// `Reason`
  String get event_reason {
    return Intl.message('Reason', name: 'event_reason', desc: '', args: []);
  }

  /// `Message`
  String get event_message {
    return Intl.message('Message', name: 'event_message', desc: '', args: []);
  }

  /// `Count`
  String get event_count {
    return Intl.message('Count', name: 'event_count', desc: '', args: []);
  }

  /// `Involved Object`
  String get event_involved_object {
    return Intl.message(
      'Involved Object',
      name: 'event_involved_object',
      desc: '',
      args: [],
    );
  }

  /// `Object UID`
  String get event_object_uid {
    return Intl.message(
      'Object UID',
      name: 'event_object_uid',
      desc: '',
      args: [],
    );
  }

  /// `First Timestamp`
  String get event_first_timestamp {
    return Intl.message(
      'First Timestamp',
      name: 'event_first_timestamp',
      desc: '',
      args: [],
    );
  }

  /// `Last Timestamp`
  String get event_last_timestamp {
    return Intl.message(
      'Last Timestamp',
      name: 'event_last_timestamp',
      desc: '',
      args: [],
    );
  }

  /// `Event Time`
  String get event_event_time {
    return Intl.message(
      'Event Time',
      name: 'event_event_time',
      desc: '',
      args: [],
    );
  }

  /// `Series Count`
  String get event_series_count {
    return Intl.message(
      'Series Count',
      name: 'event_series_count',
      desc: '',
      args: [],
    );
  }

  /// `Series Last Observed`
  String get event_series_last_observed {
    return Intl.message(
      'Series Last Observed',
      name: 'event_series_last_observed',
      desc: '',
      args: [],
    );
  }

  /// `Reporting Component`
  String get event_reporting_component {
    return Intl.message(
      'Reporting Component',
      name: 'event_reporting_component',
      desc: '',
      args: [],
    );
  }

  /// `Reporting Instance`
  String get event_reporting_instance {
    return Intl.message(
      'Reporting Instance',
      name: 'event_reporting_instance',
      desc: '',
      args: [],
    );
  }

  /// `Source Component`
  String get event_source_component {
    return Intl.message(
      'Source Component',
      name: 'event_source_component',
      desc: '',
      args: [],
    );
  }

  /// `Source Host`
  String get event_source_host {
    return Intl.message(
      'Source Host',
      name: 'event_source_host',
      desc: '',
      args: [],
    );
  }

  /// `Action`
  String get event_action {
    return Intl.message('Action', name: 'event_action', desc: '', args: []);
  }

  /// `Welcome to K8Z!`
  String get guide_step_1_title {
    return Intl.message(
      'Welcome to K8Z!',
      name: 'guide_step_1_title',
      desc: 'Title for the first onboarding guide step',
      args: [],
    );
  }

  /// `Let's quickly explore the main features of K8Z.`
  String get guide_step_1_desc {
    return Intl.message(
      'Let\'s quickly explore the main features of K8Z.',
      name: 'guide_step_1_desc',
      desc:
          'Description for the first onboarding guide step - introduction to K8Z',
      args: [],
    );
  }

  /// `Workloads Overview`
  String get guide_step_2_title {
    return Intl.message(
      'Workloads Overview',
      name: 'guide_step_2_title',
      desc: 'Title for the second onboarding guide step',
      args: [],
    );
  }

  /// `Here you can see all workload resources: Pods, Deployments, DaemonSets, and StatefulSets. Click any type to see resources.`
  String get guide_step_2_desc {
    return Intl.message(
      'Here you can see all workload resources: Pods, Deployments, DaemonSets, and StatefulSets. Click any type to see resources.',
      name: 'guide_step_2_desc',
      desc:
          'Description for the second onboarding guide step - explaining workload types',
      args: [],
    );
  }

  /// `Pod List`
  String get guide_step_3_title {
    return Intl.message(
      'Pod List',
      name: 'guide_step_3_title',
      desc: 'Title for the third onboarding guide step',
      args: [],
    );
  }

  /// `View all pods in your cluster. Swipe right for more actions (details, logs, terminal), swipe left to delete.`
  String get guide_step_3_desc {
    return Intl.message(
      'View all pods in your cluster. Swipe right for more actions (details, logs, terminal), swipe left to delete.',
      name: 'guide_step_3_desc',
      desc:
          'Description for the third onboarding guide step - explaining pod swipe gestures',
      args: [],
    );
  }

  /// `Pod Details`
  String get guide_step_4_title {
    return Intl.message(
      'Pod Details',
      name: 'guide_step_4_title',
      desc: 'Title for the fourth onboarding guide step',
      args: [],
    );
  }

  /// `View YAML configuration, real-time logs, and open a terminal. This page shows the detailed information for the '{podName}' pod in namespace '{podNamespace}'.`
  String guide_step_4_desc(String podName, String podNamespace) {
    return Intl.message(
      'View YAML configuration, real-time logs, and open a terminal. This page shows the detailed information for the \'$podName\' pod in namespace \'$podNamespace\'.',
      name: 'guide_step_4_desc',
      desc:
          'Description for the fourth onboarding guide step - explaining pod details',
      args: [podName, podNamespace],
    );
  }

  /// `Resources Menu`
  String get guide_step_5_title {
    return Intl.message(
      'Resources Menu',
      name: 'guide_step_5_title',
      desc: 'Title for the fifth onboarding guide step',
      args: [],
    );
  }

  /// `Access additional Kubernetes resources: Config (ConfigMaps, Secrets), Storage (PVs, PVCs, StorageClass), and Networking (Services, Ingresses).`
  String get guide_step_5_desc {
    return Intl.message(
      'Access additional Kubernetes resources: Config (ConfigMaps, Secrets), Storage (PVs, PVCs, StorageClass), and Networking (Services, Ingresses).',
      name: 'guide_step_5_desc',
      desc:
          'Description for the fifth onboarding guide step - explaining resources menu',
      args: [],
    );
  }

  /// `Nodes List`
  String get guide_step_6_title {
    return Intl.message(
      'Nodes List',
      name: 'guide_step_6_title',
      desc: 'Title for the sixth onboarding guide step',
      args: [],
    );
  }

  /// `View all cluster nodes. Swipe right to see node details, swipe left to cordon/uncordon the node.`
  String get guide_step_6_desc {
    return Intl.message(
      'View all cluster nodes. Swipe right to see node details, swipe left to cordon/uncordon the node.',
      name: 'guide_step_6_desc',
      desc:
          'Description for the sixth onboarding guide step - explaining node swipe gestures',
      args: [],
    );
  }

  /// `Node Details`
  String get guide_step_7_title {
    return Intl.message(
      'Node Details',
      name: 'guide_step_7_title',
      desc: 'Title for the seventh onboarding guide step',
      args: [],
    );
  }

  /// `Monitor node status, resource usage (CPU/memory), and view pods running on this node.`
  String get guide_step_7_desc {
    return Intl.message(
      'Monitor node status, resource usage (CPU/memory), and view pods running on this node.',
      name: 'guide_step_7_desc',
      desc:
          'Description for the seventh onboarding guide step - explaining node details',
      args: [],
    );
  }

  /// `Guide Complete!`
  String get guide_step_8_title {
    return Intl.message(
      'Guide Complete!',
      name: 'guide_step_8_title',
      desc: 'Title for the eighth onboarding guide step - completion message',
      args: [],
    );
  }

  /// `You've completed the onboarding guide! Feel free to explore further. Access help documentation anytime from settings.`
  String get guide_step_8_desc {
    return Intl.message(
      'You\'ve completed the onboarding guide! Feel free to explore further. Access help documentation anytime from settings.',
      name: 'guide_step_8_desc',
      desc:
          'Description for the eighth onboarding guide step - completion description',
      args: [],
    );
  }

  /// `Next`
  String get guide_button_next {
    return Intl.message(
      'Next',
      name: 'guide_button_next',
      desc: 'Button label for moving to the next step in the onboarding guide',
      args: [],
    );
  }

  /// `Skip`
  String get guide_button_skip {
    return Intl.message(
      'Skip',
      name: 'guide_button_skip',
      desc: 'Button label for skipping the onboarding guide',
      args: [],
    );
  }

  /// `Back`
  String get guide_button_back {
    return Intl.message(
      'Back',
      name: 'guide_button_back',
      desc:
          'Button label for moving to the previous step in the onboarding guide',
      args: [],
    );
  }

  /// `Complete`
  String get guide_button_complete {
    return Intl.message(
      'Complete',
      name: 'guide_button_complete',
      desc:
          'Button label for completing the onboarding guide on the final step',
      args: [],
    );
  }

  /// `Replay Onboarding Guide`
  String get settings_replay_guide {
    return Intl.message(
      'Replay Onboarding Guide',
      name: 'settings_replay_guide',
      desc: 'Menu option in settings to replay the onboarding guide',
      args: [],
    );
  }

  /// `Restart Guide`
  String get settings_restart_guide_title {
    return Intl.message(
      'Restart Guide',
      name: 'settings_restart_guide_title',
      desc: 'Dialog title when restarting the onboarding guide',
      args: [],
    );
  }

  /// `Do you want to reset the onboarding guide completion status?`
  String get settings_restart_guide_msg {
    return Intl.message(
      'Do you want to reset the onboarding guide completion status?',
      name: 'settings_restart_guide_msg',
      desc: 'Dialog message when confirming guide restart',
      args: [],
    );
  }

  /// `Reset`
  String get settings_reset {
    return Intl.message(
      'Reset',
      name: 'settings_reset',
      desc: 'Button label to reset the guide',
      args: [],
    );
  }

  /// `Onboarding guide has been reset`
  String get settings_guide_reset_success {
    return Intl.message(
      'Onboarding guide has been reset',
      name: 'settings_guide_reset_success',
      desc: 'Success message after resetting the onboarding guide',
      args: [],
    );
  }

  /// `k8z Pro`
  String get proDialogTitle {
    return Intl.message('k8z Pro', name: 'proDialogTitle', desc: '', args: []);
  }

  /// `{featureName} requires a Pro subscription`
  String proDialogFeatureLocked(String featureName) {
    return Intl.message(
      '$featureName requires a Pro subscription',
      name: 'proDialogFeatureLocked',
      desc: '',
      args: [featureName],
    );
  }

  /// `Pro Features:`
  String get proDialogBenefitsTitle {
    return Intl.message(
      'Pro Features:',
      name: 'proDialogBenefitsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get proDialogCancel {
    return Intl.message('Cancel', name: 'proDialogCancel', desc: '', args: []);
  }

  /// `View Pro Plans`
  String get proDialogViewPlans {
    return Intl.message(
      'View Pro Plans',
      name: 'proDialogViewPlans',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited cluster access`
  String get proBenefitUnlimitedClusters {
    return Intl.message(
      'Unlimited cluster access',
      name: 'proBenefitUnlimitedClusters',
      desc: '',
      args: [],
    );
  }

  /// `Node Shell access`
  String get proBenefitNodeShell {
    return Intl.message(
      'Node Shell access',
      name: 'proBenefitNodeShell',
      desc: '',
      args: [],
    );
  }

  /// `YAML editing and Apply`
  String get proBenefitYamlEdit {
    return Intl.message(
      'YAML editing and Apply',
      name: 'proBenefitYamlEdit',
      desc: '',
      args: [],
    );
  }

  /// `Historical log search`
  String get proBenefitLogSearch {
    return Intl.message(
      'Historical log search',
      name: 'proBenefitLogSearch',
      desc: '',
      args: [],
    );
  }

  /// `Custom dashboard`
  String get proBenefitCustomDashboard {
    return Intl.message(
      'Custom dashboard',
      name: 'proBenefitCustomDashboard',
      desc: '',
      args: [],
    );
  }

  /// `Priority support`
  String get proBenefitSupport {
    return Intl.message(
      'Priority support',
      name: 'proBenefitSupport',
      desc: '',
      args: [],
    );
  }

  /// `Unlock Everything`
  String get proUnlockTitle {
    return Intl.message(
      'Unlock Everything',
      name: 'proUnlockTitle',
      desc: '',
      args: [],
    );
  }

  /// `Unlock Full Power of Kubernetes Management`
  String get proHeadline {
    return Intl.message(
      'Unlock Full Power of Kubernetes Management',
      name: 'proHeadline',
      desc: '',
      args: [],
    );
  }

  /// `Manage unlimited clusters and access advanced features`
  String get proDescription {
    return Intl.message(
      'Manage unlimited clusters and access advanced features',
      name: 'proDescription',
      desc: '',
      args: [],
    );
  }

  /// `Best Value`
  String get proBestValue {
    return Intl.message('Best Value', name: 'proBestValue', desc: '', args: []);
  }

  /// `Unlock Everything Now`
  String get proUnlockNow {
    return Intl.message(
      'Unlock Everything Now',
      name: 'proUnlockNow',
      desc: '',
      args: [],
    );
  }

  /// `Pro`
  String get proSettingsTitle {
    return Intl.message('Pro', name: 'proSettingsTitle', desc: '', args: []);
  }

  /// `Free to try Pro`
  String get proFree {
    return Intl.message('Free to try Pro', name: 'proFree', desc: '', args: []);
  }

  /// `Pro`
  String get proPro {
    return Intl.message('Pro', name: 'proPro', desc: '', args: []);
  }

  /// `Unlimited Clusters`
  String get comparisonFeatureUnlimitedClusters {
    return Intl.message(
      'Unlimited Clusters',
      name: 'comparisonFeatureUnlimitedClusters',
      desc: '',
      args: [],
    );
  }

  /// `Node Shell Access`
  String get comparisonFeatureNodeShell {
    return Intl.message(
      'Node Shell Access',
      name: 'comparisonFeatureNodeShell',
      desc: '',
      args: [],
    );
  }

  /// `YAML Edit & Apply`
  String get comparisonFeatureYamlEdit {
    return Intl.message(
      'YAML Edit & Apply',
      name: 'comparisonFeatureYamlEdit',
      desc: '',
      args: [],
    );
  }

  /// `Basic Cluster Monitoring`
  String get comparisonFeatureMonitoring {
    return Intl.message(
      'Basic Cluster Monitoring',
      name: 'comparisonFeatureMonitoring',
      desc: '',
      args: [],
    );
  }

  /// `View Workloads`
  String get comparisonFeatureViewWorkloads {
    return Intl.message(
      'View Workloads',
      name: 'comparisonFeatureViewWorkloads',
      desc: '',
      args: [],
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
