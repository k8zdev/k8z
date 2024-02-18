// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(arg) => "Runtime:\t\t ${arg}";

  static String m1(name, kind, scope, shortNames) =>
      "${name}\n\nKind: ${kind}\nScope: ${scope}\nshortNames: ${shortNames}";

  static String m2(name, ns, ready, upToDate, available) =>
      "${name}\nNamespace: ${ns}\nReady: ${ready}\nUp to date: ${upToDate}\nAvailable: ${available}\n";

  static String m3(error) => "delete failed, error: ${error}";

  static String m4(name) => "${name} deleted";

  static String m5(name, ns, ready, upToDate, available) =>
      "${name}\nNamespace: ${ns}\nReady: ${ready}\nUp to date: ${upToDate}\nAvailable: ${available}";

  static String m6(name, ns, endpoints) =>
      "${name}\nNamespace: ${ns}\nEndpoints: ${endpoints}";

  static String m7(namespace, name, type, reason, kind, objName, lastTimestamp,
          message) =>
      "${namespace} / ${name}\n\nType: ${type}\nReason: ${reason}\nObject: ${kind}/${objName}\nLast Seen: ${lastTimestamp}\n\nMessage: ${message}\n";

  static String m8(arg) => "External-IP:\t\t ${arg}";

  static String m9(name, ns, className, hosts, address, ports) =>
      "${name}\nNamespace: ${ns}\nClass: ${className}\nHosts: ${hosts}\nAddress: ${address}\nPorts: ${ports}";

  static String m10(arg) => "Internal-IP:\t\t ${arg}";

  static String m11(number) => " (${number} items)";

  static String m12(n) => "last ${n} warnings";

  static String m13(error) => "load metrics error: ${error}";

  static String m14(arg) => "Architecture\t\t: ${arg}";

  static String m15(os, arg) => "Kernel:\t\t ${os}/${arg}";

  static String m16(arg) => "Kernel:\t\t ${arg}";

  static String m17(arg) => "Roles:\t\t ${arg}";

  static String m18(arg) => "Version:\t\t ${arg}";

  static String m19(
          name, namespace, ready, status, restarts, containers, cpu, memory) =>
      "${name}\n\nNamespace: ${namespace}\nReady: ${ready}\nStatus: ${status}\nRestarts: ${restarts}\nContainers: ${containers}\nCPU: ${cpu}\nMemory: ${memory}";

  static String m20(name, ns, type, clusterIP, externalIP, ports) =>
      "${name}\nNamespace: ${ns}\nType: ${type}\nCluster IP: ${clusterIP}\nExternal IP: ${externalIP}\nPorts: ${ports}";

  static String m21(name, ns, ready, upToDate, available) =>
      "${name}\nNamespace: ${ns}\nReady: ${ready}\nUp to date: ${upToDate}\nAvailable: ${available}\n";

  static String m22(number) => "Totals: ${number}";

  static String m23(type, name) => "will delete ${type} ${name}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add_cluster": MessageLookupByLibrary.simpleMessage("Add cluster"),
        "age": MessageLookupByLibrary.simpleMessage("Age"),
        "all": MessageLookupByLibrary.simpleMessage("All"),
        "appName": MessageLookupByLibrary.simpleMessage("k8z"),
        "appearance": MessageLookupByLibrary.simpleMessage("appearance"),
        "arsure": MessageLookupByLibrary.simpleMessage("are your sure?"),
        "cancel": MessageLookupByLibrary.simpleMessage("cancel"),
        "clusters": MessageLookupByLibrary.simpleMessage("Clusters"),
        "config": MessageLookupByLibrary.simpleMessage("Config"),
        "config_maps": MessageLookupByLibrary.simpleMessage("ConfigMaps"),
        "container_runtime": m0,
        "cpu": MessageLookupByLibrary.simpleMessage("CPU"),
        "crds":
            MessageLookupByLibrary.simpleMessage("CustomResourceDefinition"),
        "crds_text": m1,
        "current_cluster":
            MessageLookupByLibrary.simpleMessage("Current cluster"),
        "daemon_set_text": m2,
        "daemon_sets": MessageLookupByLibrary.simpleMessage("DaemonSets"),
        "debug_flushdb": MessageLookupByLibrary.simpleMessage("flush database"),
        "debug_flushdb_desc": MessageLookupByLibrary.simpleMessage(
            "will flush all data at database"),
        "debug_flushdb_done":
            MessageLookupByLibrary.simpleMessage("database flushed"),
        "delete": MessageLookupByLibrary.simpleMessage("delete"),
        "delete_failed": m3,
        "deleted": m4,
        "deployment_text": m5,
        "deployments": MessageLookupByLibrary.simpleMessage("Deployments"),
        "discovery_and_lb": MessageLookupByLibrary.simpleMessage(
            "Discovery and Load Balancing"),
        "edit": MessageLookupByLibrary.simpleMessage("Edit"),
        "empyt_context": MessageLookupByLibrary.simpleMessage(
            "can not get cluster kubeconfig, contexts maybe empty"),
        "endpoint_text": m6,
        "endpoints": MessageLookupByLibrary.simpleMessage("Endpoints"),
        "error": MessageLookupByLibrary.simpleMessage("error"),
        "event_text": m7,
        "events": MessageLookupByLibrary.simpleMessage("Events"),
        "external_ip": m8,
        "general": MessageLookupByLibrary.simpleMessage("general"),
        "general_debug": MessageLookupByLibrary.simpleMessage("debug"),
        "general_debug_sqlview":
            MessageLookupByLibrary.simpleMessage("sqlview"),
        "general_language": MessageLookupByLibrary.simpleMessage("language"),
        "general_language_en": MessageLookupByLibrary.simpleMessage("English"),
        "general_language_ja": MessageLookupByLibrary.simpleMessage("Japanese"),
        "general_language_null": MessageLookupByLibrary.simpleMessage("Auto"),
        "general_language_zh": MessageLookupByLibrary.simpleMessage("Chinese"),
        "ingress_text": m9,
        "ingresses": MessageLookupByLibrary.simpleMessage("Ingresses"),
        "internel_ip": m10,
        "items_number": m11,
        "last_warning_events": m12,
        "load_file": MessageLookupByLibrary.simpleMessage("load file"),
        "load_metrics_error": m13,
        "loading_metrics":
            MessageLookupByLibrary.simpleMessage("loading metrics"),
        "manual_load_kubeconfig":
            MessageLookupByLibrary.simpleMessage("Load kubeconfig file"),
        "memory": MessageLookupByLibrary.simpleMessage("Memory"),
        "more": MessageLookupByLibrary.simpleMessage("More"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "namespaces": MessageLookupByLibrary.simpleMessage("Namespaces"),
        "next_step": MessageLookupByLibrary.simpleMessage("next step"),
        "no_current_cluster":
            MessageLookupByLibrary.simpleMessage("no current cluster"),
        "node_arch": m14,
        "node_kernel": m15,
        "node_os_image": m16,
        "node_roles": m17,
        "node_version": m18,
        "nodes": MessageLookupByLibrary.simpleMessage("Nodes"),
        "nodes_desc": MessageLookupByLibrary.simpleMessage(
            "A node may be a virtual or physical machine."),
        "ok": MessageLookupByLibrary.simpleMessage("ok"),
        "overview": MessageLookupByLibrary.simpleMessage("Overview"),
        "pod_text": m19,
        "pods": MessageLookupByLibrary.simpleMessage("Pods"),
        "pvcs":
            MessageLookupByLibrary.simpleMessage("Persistent Volume Claims"),
        "pvs": MessageLookupByLibrary.simpleMessage("Persistent Volumes"),
        "resources": MessageLookupByLibrary.simpleMessage("Resources"),
        "running": MessageLookupByLibrary.simpleMessage("Running"),
        "save_clusters": MessageLookupByLibrary.simpleMessage("save clusters"),
        "secrets": MessageLookupByLibrary.simpleMessage("Secrets"),
        "select_clusters":
            MessageLookupByLibrary.simpleMessage("Select cluster(s)"),
        "service_accounts":
            MessageLookupByLibrary.simpleMessage("ServiceAccounts"),
        "service_text": m20,
        "services": MessageLookupByLibrary.simpleMessage("Services"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "stateful_set_text": m21,
        "stateful_sets": MessageLookupByLibrary.simpleMessage("StatefulSets"),
        "status": MessageLookupByLibrary.simpleMessage("Status"),
        "storage": MessageLookupByLibrary.simpleMessage("Storage"),
        "storage_class": MessageLookupByLibrary.simpleMessage("StorageClass"),
        "theme_auto": MessageLookupByLibrary.simpleMessage("auto"),
        "theme_dark": MessageLookupByLibrary.simpleMessage("dark mode"),
        "theme_light": MessageLookupByLibrary.simpleMessage("light mode"),
        "totals": m22,
        "version": MessageLookupByLibrary.simpleMessage("version"),
        "will_delete": m23,
        "workloads": MessageLookupByLibrary.simpleMessage("Workloads")
      };
}
