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

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
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

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
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

  /// `Namespace`
  String get namespace {
    return Intl.message(
      'Namespace',
      name: 'namespace',
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

  /// `Appearance`
  String get appearance {
    return Intl.message(
      'Appearance',
      name: 'appearance',
      desc: '',
      args: [],
    );
  }

  /// `Auto`
  String get theme_auto {
    return Intl.message(
      'Auto',
      name: 'theme_auto',
      desc: '',
      args: [],
    );
  }

  /// `Dark mode`
  String get theme_dark {
    return Intl.message(
      'Dark mode',
      name: 'theme_dark',
      desc: '',
      args: [],
    );
  }

  /// `Light mode`
  String get theme_light {
    return Intl.message(
      'Light mode',
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

  /// `General`
  String get general {
    return Intl.message(
      'General',
      name: 'general',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'CPU',
      name: 'cpu',
      desc: '',
      args: [],
    );
  }

  /// `Memory`
  String get memory {
    return Intl.message(
      'Memory',
      name: 'memory',
      desc: '',
      args: [],
    );
  }

  /// `{name}\nNamespace: {ns}\nReady: {ready}\nUp to date: {upToDate}\nAvailable: {available}`
  String deployment_text(
      Object name, Object ns, Object ready, Object upToDate, Object available) {
    return Intl.message(
      '$name\nNamespace: $ns\nReady: $ready\nUp to date: $upToDate\nAvailable: $available',
      name: 'deployment_text',
      desc: '',
      args: [name, ns, ready, upToDate, available],
    );
  }

  /// `{name}\nNamespace: {ns}\nReady: {ready}\nUp to date: {upToDate}\nAvailable: {available}\n`
  String daemon_set_text(
      Object name, Object ns, Object ready, Object upToDate, Object available) {
    return Intl.message(
      '$name\nNamespace: $ns\nReady: $ready\nUp to date: $upToDate\nAvailable: $available\n',
      name: 'daemon_set_text',
      desc: '',
      args: [name, ns, ready, upToDate, available],
    );
  }

  /// `{name}\nNamespace: {ns}\nReady: {ready}\nUp to date: {upToDate}\nAvailable: {available}\n`
  String stateful_set_text(
      Object name, Object ns, Object ready, Object upToDate, Object available) {
    return Intl.message(
      '$name\nNamespace: $ns\nReady: $ready\nUp to date: $upToDate\nAvailable: $available\n',
      name: 'stateful_set_text',
      desc: '',
      args: [name, ns, ready, upToDate, available],
    );
  }

  /// `{name}\nNamespace: {ns}\nClass: {className}\nHosts: {hosts}\nAddress: {address}\nPorts: {ports}`
  String ingress_text(Object name, Object ns, Object className, Object hosts,
      Object address, Object ports) {
    return Intl.message(
      '$name\nNamespace: $ns\nClass: $className\nHosts: $hosts\nAddress: $address\nPorts: $ports',
      name: 'ingress_text',
      desc: '',
      args: [name, ns, className, hosts, address, ports],
    );
  }

  /// `{name}\nNamespace: {ns}\nType: {type}\nCluster IP: {clusterIP}\nExternal IP: {externalIP}\nPorts: {ports}`
  String service_text(Object name, Object ns, Object type, Object clusterIP,
      Object externalIP, Object ports) {
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
      Object allowVolumeExpansion) {
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
        allowVolumeExpansion
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
      Object reason) {
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
        reason
      ],
    );
  }

  /// `{name}\nNamespace: {ns}\nStatus: {status}\nVolume: {volume}\nCapacity: {capacity}\nAccess Modes: {accessModes}\nStorage Class: {storageClass}`
  String pvc_text(Object name, Object ns, Object status, Object volume,
      Object capacity, Object accessModes, Object storageClass) {
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
    return Intl.message(
      'Helm',
      name: 'helm',
      desc: '',
      args: [],
    );
  }

  /// `Releases`
  String get releases {
    return Intl.message(
      'Releases',
      name: 'releases',
      desc: '',
      args: [],
    );
  }

  /// `{name}\nNamespace: {ns}\nRevision: {revision}\nApp Version: {appVer}\nUpdated: {updated}\nStatus: {status}\nChart: {chart}`
  String release_text(Object name, Object ns, Object revision, Object appVer,
      Object updated, Object status, Object chart) {
    return Intl.message(
      '$name\nNamespace: $ns\nRevision: $revision\nApp Version: $appVer\nUpdated: $updated\nStatus: $status\nChart: $chart',
      name: 'release_text',
      desc: '',
      args: [name, ns, revision, appVer, updated, status, chart],
    );
  }

  /// `EULA`
  String get eula {
    return Intl.message(
      'EULA',
      name: 'eula',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Sponsor me',
      name: 'sponsorme',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Terminal',
      name: 'terminal',
      desc: '',
      args: [],
    );
  }

  /// `Logs`
  String get logs {
    return Intl.message(
      'Logs',
      name: 'logs',
      desc: '',
      args: [],
    );
  }

  /// `Container`
  String get container {
    return Intl.message(
      'Container',
      name: 'container',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Since',
      name: 'since',
      desc: '',
      args: [],
    );
  }

  /// `Tail Lines`
  String get tail_lines {
    return Intl.message(
      'Tail Lines',
      name: 'tail_lines',
      desc: '',
      args: [],
    );
  }

  /// `API Timeout`
  String get api_timeout {
    return Intl.message(
      'API Timeout',
      name: 'api_timeout',
      desc: '',
      args: [],
    );
  }

  /// `{n} s`
  String n_seconds(num n) {
    return Intl.message(
      '$n s',
      name: 'n_seconds',
      desc: '',
      args: [n],
    );
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
    return Intl.message(
      'Labels',
      name: 'labels',
      desc: '',
      args: [],
    );
  }

  /// `Annotations`
  String get annotations {
    return Intl.message(
      'Annotations',
      name: 'annotations',
      desc: '',
      args: [],
    );
  }

  /// `metadata`
  String get metadata {
    return Intl.message(
      'metadata',
      name: 'metadata',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Export',
      name: 'export',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Scale',
      name: 'scale',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `scale success`
  String get scale_ok {
    return Intl.message(
      'scale success',
      name: 'scale_ok',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Support',
      name: 'support',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get feedback {
    return Intl.message(
      'Feedback',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `Documents`
  String get documents {
    return Intl.message(
      'Documents',
      name: 'documents',
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
