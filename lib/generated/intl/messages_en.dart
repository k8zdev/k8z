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

  static String m0(duration) => "\t\tduration: ${duration}";

  static String m1(name, ns, data) =>
      "${name}\nNamespace: ${ns}\nData: ${data}";

  static String m2(arg) => "Runtime:\t\t ${arg}";

  static String m3(name, kind, scope, shortNames) =>
      "${name}\n\nKind: ${kind}\nScope: ${scope}\nshortNames: ${shortNames}";

  static String m4(name, ns, ready, upToDate, available) =>
      "${name}\nNamespace: ${ns}\nReady: ${ready}\nUp to date: ${upToDate}\nAvailable: ${available}\n";

  static String m5(error) => "delete failed, error: ${error}";

  static String m6(name) => "${name} deleted";

  static String m7(name, ns, ready, upToDate, available) =>
      "${name}\nNamespace: ${ns}\nReady: ${ready}\nUp to date: ${upToDate}\nAvailable: ${available}";

  static String m8(name, ns, endpoints) =>
      "${name}\nNamespace: ${ns}\nEndpoints: ${endpoints}";

  static String m9(
    namespace,
    name,
    type,
    reason,
    kind,
    objName,
    lastTimestamp,
    message,
  ) =>
      "${namespace} / ${name}\n\nType: ${type}\nReason: ${reason}\nObject: ${kind}/${objName}\nLast Seen: ${lastTimestamp}\n\nMessage: ${message}\n";

  static String m10(path) => "Exported to ${path}";

  static String m11(arg) => "External-IP:\t\t ${arg}";

  static String m12(name, ns, className, hosts, address, ports) =>
      "${name}\nNamespace: ${ns}\nClass: ${className}\nHosts: ${hosts}\nAddress: ${address}\nPorts: ${ports}";

  static String m13(arg) => "Internal-IP:\t\t ${arg}";

  static String m14(number) => " (${number} items)";

  static String m15(n) => "last ${n} warnings";

  static String m16(error) => "load metrics error: ${error}";

  static String m17(n) => "${n} s";

  static String m18(arg) => "Architecture\t\t: ${arg}";

  static String m19(os, arg) => "Kernel:\t\t ${os}/${arg}";

  static String m20(arg) => "Kernel:\t\t ${arg}";

  static String m21(arg) => "Roles:\t\t ${arg}";

  static String m22(arg) => "Version:\t\t ${arg}";

  static String m23(
    name,
    namespace,
    ready,
    status,
    restarts,
    containers,
    cpu,
    memory,
  ) =>
      "${name}\n\nNamespace: ${namespace}\nReady: ${ready}\nStatus: ${status}\nRestarts: ${restarts}\nContainers: ${containers}\nCPU: ${cpu}\nMemory: ${memory}";

  static String m24(
    name,
    capacity,
    accessModes,
    reclaimPolicy,
    status,
    claim,
    storageClass,
    reason,
  ) =>
      "${name}\nCapacity: ${capacity}\nAccess Modes: ${accessModes}\nReclaim Policy: ${reclaimPolicy}\nStatus: ${status}\nClaim: ${claim}\nStorage Class: ${storageClass}\nReason: ${reason}\n";

  static String m25(
    name,
    ns,
    status,
    volume,
    capacity,
    accessModes,
    storageClass,
  ) =>
      "${name}\nNamespace: ${ns}\nStatus: ${status}\nVolume: ${volume}\nCapacity: ${capacity}\nAccess Modes: ${accessModes}\nStorage Class: ${storageClass}";

  static String m26(name, ns, revision, appVer, updated, status, chart) =>
      "${name}\nNamespace: ${ns}\nRevision: ${revision}\nApp Version: ${appVer}\nUpdated: ${updated}\nStatus: ${status}\nChart: ${chart}";

  static String m27(name, ns, current, ready, available) =>
      "${name}\nNamespace: ${ns}\nCurrent: ${current}\nReady: ${ready}\nAvailable: ${available}\n";

  static String m28(error) => "scale failed, error: ${error}";

  static String m29(N) => "Scale to ${N} replica(s)";

  static String m30(name, ns, type, data) =>
      "${name}\nNamespace: ${ns}\nType: ${type}\nData: ${data}";

  static String m31(name, ns, secrets) =>
      "${name}\nNamespace: ${ns}\nSecret: ${secrets}";

  static String m32(name, ns, type, clusterIP, externalIP, ports) =>
      "${name}\nNamespace: ${ns}\nType: ${type}\nCluster IP: ${clusterIP}\nExternal IP: ${externalIP}\nPorts: ${ports}";

  static String m33(name, ns, ready, upToDate, available) =>
      "${name}\nNamespace: ${ns}\nReady: ${ready}\nUp to date: ${upToDate}\nAvailable: ${available}\n";

  static String m34(
    name,
    provisioner,
    reclaimPolicy,
    mountOptions,
    volumeBindingMode,
    allowVolumeExpansion,
  ) =>
      "${name}\nProvisioner: ${provisioner}\nReclaim Policy: ${reclaimPolicy}\nVolume Binding Mode: ${volumeBindingMode}\nAllow Volume Expansion: ${allowVolumeExpansion}\nMountOptions: ${mountOptions}";

  static String m35(date) => "Sponsor expired: \$${date}";

  static String m36(error) => "Restore Purchases Failed, ERROR: ${error}";

  static String m37(number) => "${number} terminals opened";

  static String m38(number) => "Totals: ${number}";

  static String m39(type, name) => "will delete ${type} ${name}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "add_cluster": MessageLookupByLibrary.simpleMessage("Add cluster"),
    "addresses": MessageLookupByLibrary.simpleMessage("Addresses"),
    "age": MessageLookupByLibrary.simpleMessage("Age"),
    "all": MessageLookupByLibrary.simpleMessage("All"),
    "annotations": MessageLookupByLibrary.simpleMessage("Annotations"),
    "apiVersion": MessageLookupByLibrary.simpleMessage("apiVersion"),
    "api_request_duration": m0,
    "api_timeout": MessageLookupByLibrary.simpleMessage("API Timeout"),
    "appName": MessageLookupByLibrary.simpleMessage("k8z"),
    "appearance": MessageLookupByLibrary.simpleMessage("Appearance"),
    "applications": MessageLookupByLibrary.simpleMessage("Applications"),
    "apply": MessageLookupByLibrary.simpleMessage("Apply"),
    "args": MessageLookupByLibrary.simpleMessage("Arguments"),
    "arsure": MessageLookupByLibrary.simpleMessage("are your sure?"),
    "blockOwnerDeletion": MessageLookupByLibrary.simpleMessage(
      "blockOwnerDeletion",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cluster_ip": MessageLookupByLibrary.simpleMessage("Cluster IP"),
    "cluster_overview": MessageLookupByLibrary.simpleMessage(
      "Cluster Overview",
    ),
    "clusters": MessageLookupByLibrary.simpleMessage("Clusters"),
    "command": MessageLookupByLibrary.simpleMessage("Command"),
    "config": MessageLookupByLibrary.simpleMessage("Config"),
    "config_map_text": m1,
    "config_maps": MessageLookupByLibrary.simpleMessage("ConfigMaps"),
    "container": MessageLookupByLibrary.simpleMessage("Container"),
    "container_id": MessageLookupByLibrary.simpleMessage("Container ID"),
    "container_runtime": m2,
    "containers": MessageLookupByLibrary.simpleMessage("Containers"),
    "controller": MessageLookupByLibrary.simpleMessage("controller"),
    "cpu": MessageLookupByLibrary.simpleMessage("CPU"),
    "crds": MessageLookupByLibrary.simpleMessage("CustomResourceDefinition"),
    "crds_text": m3,
    "creation_time": MessageLookupByLibrary.simpleMessage("Creation Time"),
    "current_cluster": MessageLookupByLibrary.simpleMessage("Current cluster"),
    "daemon_set_text": m4,
    "daemon_sets": MessageLookupByLibrary.simpleMessage("DaemonSets"),
    "data": MessageLookupByLibrary.simpleMessage("Data"),
    "debug_flushdb": MessageLookupByLibrary.simpleMessage("flush database"),
    "debug_flushdb_desc": MessageLookupByLibrary.simpleMessage(
      "will flush all data at database",
    ),
    "debug_flushdb_done": MessageLookupByLibrary.simpleMessage(
      "database flushed",
    ),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "delete_failed": m5,
    "delete_ok": MessageLookupByLibrary.simpleMessage(
      "delete resource success.",
    ),
    "delete_resource": MessageLookupByLibrary.simpleMessage(
      "Are you sure delete the resource?",
    ),
    "deleted": m6,
    "deployment_text": m7,
    "deployments": MessageLookupByLibrary.simpleMessage("Deployments"),
    "discovery_and_lb": MessageLookupByLibrary.simpleMessage(
      "Discovery and Load Balancing",
    ),
    "dnsPolicy": MessageLookupByLibrary.simpleMessage("DNS Policy"),
    "documents": MessageLookupByLibrary.simpleMessage("Documents"),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "empty": MessageLookupByLibrary.simpleMessage("empty"),
    "empyt_context": MessageLookupByLibrary.simpleMessage(
      "can not get cluster kubeconfig, contexts maybe empty",
    ),
    "endpoint_text": m8,
    "endpoints": MessageLookupByLibrary.simpleMessage("Endpoints"),
    "ephemeral_containers": MessageLookupByLibrary.simpleMessage(
      "Ephemeral Containers",
    ),
    "error": MessageLookupByLibrary.simpleMessage("error"),
    "eula": MessageLookupByLibrary.simpleMessage("EULA"),
    "event_text": m9,
    "events": MessageLookupByLibrary.simpleMessage("Events"),
    "export": MessageLookupByLibrary.simpleMessage("Export"),
    "exported": m10,
    "external_ip": m11,
    "external_ips": MessageLookupByLibrary.simpleMessage("External IPs"),
    "external_name": MessageLookupByLibrary.simpleMessage("External Name"),
    "feedback": MessageLookupByLibrary.simpleMessage("Feedback"),
    "finalizers": MessageLookupByLibrary.simpleMessage("Finalizers"),
    "general": MessageLookupByLibrary.simpleMessage("General"),
    "general_debug": MessageLookupByLibrary.simpleMessage("debug"),
    "general_debug_sqlview": MessageLookupByLibrary.simpleMessage("sqlview"),
    "general_language": MessageLookupByLibrary.simpleMessage("Language"),
    "general_language_en": MessageLookupByLibrary.simpleMessage("English"),
    "general_language_ja": MessageLookupByLibrary.simpleMessage("Japanese"),
    "general_language_null": MessageLookupByLibrary.simpleMessage("Auto"),
    "general_language_zh": MessageLookupByLibrary.simpleMessage("Chinese"),
    "generation": MessageLookupByLibrary.simpleMessage("Generation"),
    "get_terminal": MessageLookupByLibrary.simpleMessage("Get Terminal"),
    "helm": MessageLookupByLibrary.simpleMessage("Helm"),
    "hostNetwork": MessageLookupByLibrary.simpleMessage("Host Network"),
    "hostname": MessageLookupByLibrary.simpleMessage("Hostname"),
    "image": MessageLookupByLibrary.simpleMessage("Image"),
    "imagePullPolicy": MessageLookupByLibrary.simpleMessage(
      "Image Pull Policy",
    ),
    "imagePullSecrets": MessageLookupByLibrary.simpleMessage(
      "Image Pull Secrets",
    ),
    "image_id": MessageLookupByLibrary.simpleMessage("Image ID"),
    "ingress_text": m12,
    "ingresses": MessageLookupByLibrary.simpleMessage("Ingresses"),
    "initContainers": MessageLookupByLibrary.simpleMessage("Init Containers"),
    "internel_ip": m13,
    "items_number": m14,
    "kind": MessageLookupByLibrary.simpleMessage("kind"),
    "labels": MessageLookupByLibrary.simpleMessage("Labels"),
    "language_settings": MessageLookupByLibrary.simpleMessage(
      "Language Settings",
    ),
    "last_warning_events": m15,
    "livenessProbe": MessageLookupByLibrary.simpleMessage("Liveness Probe"),
    "load_balancer_ip": MessageLookupByLibrary.simpleMessage(
      "Load Balancer IP",
    ),
    "load_file": MessageLookupByLibrary.simpleMessage("load file"),
    "load_kubeconfig_file": MessageLookupByLibrary.simpleMessage(
      "Load Kubeconfig File",
    ),
    "load_metrics_error": m16,
    "loading_metrics": MessageLookupByLibrary.simpleMessage("loading metrics"),
    "logs": MessageLookupByLibrary.simpleMessage("Logs"),
    "manual_load_kubeconfig": MessageLookupByLibrary.simpleMessage(
      "Load kubeconfig file",
    ),
    "memory": MessageLookupByLibrary.simpleMessage("Memory"),
    "metadata": MessageLookupByLibrary.simpleMessage("metadata"),
    "more": MessageLookupByLibrary.simpleMessage("More"),
    "n_seconds": m17,
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "namespace": MessageLookupByLibrary.simpleMessage("Namespace"),
    "namespaces": MessageLookupByLibrary.simpleMessage("Namespaces"),
    "next_step": MessageLookupByLibrary.simpleMessage("next step"),
    "no_current_cluster": MessageLookupByLibrary.simpleMessage(
      "no current cluster",
    ),
    "node_arch": m18,
    "node_kernel": m19,
    "node_os_image": m20,
    "node_roles": m21,
    "node_shell": MessageLookupByLibrary.simpleMessage("Node Shell"),
    "node_version": m22,
    "nodes": MessageLookupByLibrary.simpleMessage("Nodes"),
    "nodes_desc": MessageLookupByLibrary.simpleMessage(
      "A node may be a virtual or physical machine.",
    ),
    "ok": MessageLookupByLibrary.simpleMessage("ok"),
    "overview": MessageLookupByLibrary.simpleMessage("Overview"),
    "owner": MessageLookupByLibrary.simpleMessage("Owner"),
    "page_not_found": MessageLookupByLibrary.simpleMessage("Page Not Found"),
    "pod_text": m23,
    "pods": MessageLookupByLibrary.simpleMessage("Pods"),
    "ports": MessageLookupByLibrary.simpleMessage("Ports"),
    "privacy_policy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "pv_text": m24,
    "pvc_text": m25,
    "pvcs": MessageLookupByLibrary.simpleMessage("Persistent Volume Claims"),
    "pvs": MessageLookupByLibrary.simpleMessage("Persistent Volumes"),
    "readinessProbe": MessageLookupByLibrary.simpleMessage("Readiness Probe"),
    "release_text": m26,
    "releases": MessageLookupByLibrary.simpleMessage("Releases"),
    "replicasets": MessageLookupByLibrary.simpleMessage("ReplicaSets"),
    "replicasets_text": m27,
    "resourceVersion": MessageLookupByLibrary.simpleMessage("Version"),
    "resource_details": MessageLookupByLibrary.simpleMessage(
      "Resource Details",
    ),
    "resource_url": MessageLookupByLibrary.simpleMessage("Resource URL"),
    "resource_yaml": MessageLookupByLibrary.simpleMessage("Resource Yaml"),
    "resources": MessageLookupByLibrary.simpleMessage("Resources"),
    "running": MessageLookupByLibrary.simpleMessage("Running"),
    "save_clusters": MessageLookupByLibrary.simpleMessage("save clusters"),
    "scale": MessageLookupByLibrary.simpleMessage("Scale"),
    "scale_failed": m28,
    "scale_ok": MessageLookupByLibrary.simpleMessage("scale success"),
    "scale_to": m29,
    "secret_text": m30,
    "secrets": MessageLookupByLibrary.simpleMessage("Secrets"),
    "select_clusters": MessageLookupByLibrary.simpleMessage(
      "Select cluster(s)",
    ),
    "select_clusters_page": MessageLookupByLibrary.simpleMessage(
      "Select Clusters",
    ),
    "selector": MessageLookupByLibrary.simpleMessage("Selector"),
    "selfLink": MessageLookupByLibrary.simpleMessage("SelfLink"),
    "service_account_text": m31,
    "service_accounts": MessageLookupByLibrary.simpleMessage("ServiceAccounts"),
    "service_text": m32,
    "services": MessageLookupByLibrary.simpleMessage("Services"),
    "session_affinity": MessageLookupByLibrary.simpleMessage(
      "Session Affinity",
    ),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "since": MessageLookupByLibrary.simpleMessage("Since"),
    "spec": MessageLookupByLibrary.simpleMessage("Spec"),
    "sponsor_desc": MessageLookupByLibrary.simpleMessage(
      "Sponsor me so that I can continue to develop and maintain this app.",
    ),
    "sponsor_page": MessageLookupByLibrary.simpleMessage("Sponsor"),
    "sponsorme": MessageLookupByLibrary.simpleMessage("Sponsor me"),
    "start_debug": MessageLookupByLibrary.simpleMessage("Start debug"),
    "start_debug_desc": MessageLookupByLibrary.simpleMessage(
      "Start debug will create a new ephemeral container in the pod, and attach to it\'s stdin, stdout, and stderr.",
    ),
    "startupProbe": MessageLookupByLibrary.simpleMessage("Startup Probe"),
    "stateful_set_text": m33,
    "stateful_sets": MessageLookupByLibrary.simpleMessage("StatefulSets"),
    "status": MessageLookupByLibrary.simpleMessage("Status"),
    "storage": MessageLookupByLibrary.simpleMessage("Storage"),
    "storage_class": MessageLookupByLibrary.simpleMessage("StorageClass"),
    "storage_class_text": m34,
    "subscriptions_expired_at": m35,
    "subscriptions_iap_desc": MessageLookupByLibrary.simpleMessage(
      "If not cancelled, the subscription will be renewed automatically. Payment will be charged to the iTunes account when the purchase is confirmed. Subscriptions are automatically renewed unless automatic renewal is closed at least 24 hours before the end of the current term. The account will charge a renewal fee within 24 hours prior to the end of the current period and determine the renewal fee. Subscriptions can be managed by the user and auto-renewal can be turned off after purchase by going to the user\'\'s account settings. Any unused portion of the free trial period, if provided, will be forfeited when the user purchases a subscription to the publication.",
    ),
    "subscriptions_lifetime": MessageLookupByLibrary.simpleMessage("Lifetime"),
    "subscriptions_monthly": MessageLookupByLibrary.simpleMessage("Monthly"),
    "subscriptions_purchased": MessageLookupByLibrary.simpleMessage(
      "Purchased",
    ),
    "subscriptions_restorePurchases_failed": m36,
    "subscriptions_restore_purchases": MessageLookupByLibrary.simpleMessage(
      "Restore Purchases",
    ),
    "subscriptions_restore_success": MessageLookupByLibrary.simpleMessage(
      "Resotre success.",
    ),
    "subscriptions_yearly": MessageLookupByLibrary.simpleMessage("Yearly"),
    "subsets": MessageLookupByLibrary.simpleMessage("Subsets"),
    "success": MessageLookupByLibrary.simpleMessage("Success"),
    "support": MessageLookupByLibrary.simpleMessage("Support"),
    "tail_lines": MessageLookupByLibrary.simpleMessage("Tail Lines"),
    "terminal": MessageLookupByLibrary.simpleMessage("Terminal"),
    "terminals_opened": m37,
    "theme_auto": MessageLookupByLibrary.simpleMessage("Auto"),
    "theme_dark": MessageLookupByLibrary.simpleMessage("Dark mode"),
    "theme_light": MessageLookupByLibrary.simpleMessage("Light mode"),
    "totals": m38,
    "type": MessageLookupByLibrary.simpleMessage("Type"),
    "uid": MessageLookupByLibrary.simpleMessage("Uid"),
    "version": MessageLookupByLibrary.simpleMessage("Version"),
    "will_delete": m39,
    "workloads": MessageLookupByLibrary.simpleMessage("Workloads"),
  };
}
