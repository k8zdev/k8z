// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_CN locale. All the
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
  String get localeName => 'zh_CN';

  static String m0(name, ns, data) => "${name}\n名字空间: ${ns}\n数据: ${data}";

  static String m1(arg) => "运行时:\t\t ${arg}";

  static String m2(name, kind, scope, shortNames) =>
      "${name}\n\n种类: ${kind}\n范围: ${scope}\n简称: ${shortNames}";

  static String m4(error) => "删除失败, 错误: ${error}";

  static String m5(name) => "${name} 已删除";

  static String m6(name, ns, ready, upToDate, available) =>
      "${name}\n名字空间: ${ns}\n就绪: ${ready}\nUp to date: ${upToDate}\n可用: ${available}";

  static String m7(name, ns, endpoints) =>
      "${name}\n名字空间Namespace: ${ns}\nEndpoints: ${endpoints}";

  static String m8(namespace, name, type, reason, kind, objName, lastTimestamp,
          message) =>
      "${namespace} / ${name}\n\n类型: ${type}\n原因: ${reason}\n对象: ${kind}/${objName}\n最后发生: ${lastTimestamp}\n\n信息: ${message}\n";

  static String m9(arg) => "外部 IP:\t\t ${arg}";

  static String m10(name, ns, className, hosts, address, ports) =>
      "${name}\n名字空间: ${ns}\n类: ${className}\n主机: ${hosts}\n地址: ${address}\n端口: ${ports}";

  static String m11(arg) => "内部 IP:\t\t ${arg}";

  static String m12(number) => " (${number} 项)";

  static String m13(n) => "最近 ${n} 警告";

  static String m14(error) => "加载指标错误: ${error}";

  static String m15(arg) => "架构\t\t: ${arg}";

  static String m16(os, arg) => "内核:\t\t ${os}/${arg}";

  static String m17(arg) => "系统镜像:\t\t ${arg}";

  static String m18(arg) => "角色:\t\t ${arg}";

  static String m19(arg) => "版本:\t\t ${arg}";

  static String m20(
          name, namespace, ready, status, restarts, containers, cpu, memory) =>
      "${name}\n\n名字空间: ${namespace}\n就绪: ${ready}\n状况: ${status}\n重启: ${restarts}\n容器: ${containers}\nCPU: ${cpu}\n内存: ${memory}";

  static String m21(name, capacity, accessModes, reclaimPolicy, status, claim,
          storageClass, reason) =>
      "${name}\n容量: ${capacity}\n访问模式: ${accessModes}\n回收策略: ${reclaimPolicy}\n状态: ${status}\n声明: ${claim}\n存储类: ${storageClass}\n原因: ${reason}\n";

  static String m22(
          name, ns, status, volume, capacity, accessModes, storageClass) =>
      "${name}\n名字空间: ${ns}\n状态: ${status}\n卷名称: ${volume}\n容量: ${capacity}\n访问模式: ${accessModes}\n存储类: ${storageClass}";

  static String m23(name, ns, revision, appVer, updated, status, chart) =>
      "${name}\n名字空间: ${ns}\nRevision: ${revision}\n程序版本: ${appVer}\n更新: ${updated}\n状态: ${status}\nChart: ${chart}";

  static String m24(name, ns, type, data) =>
      "${name}\n名字空间: ${ns}\n类型: ${type}\n数据: ${data}";

  static String m25(name, ns, secrets) =>
      "${name}\n名字空间: ${ns}\n秘钥: ${secrets}";

  static String m26(name, ns, type, clusterIP, externalIP, ports) =>
      "${name}\n名字空间: ${ns}\n类: ${type}\n集群 IP: ${clusterIP}\n外部 IP: ${externalIP}\n端口: ${ports}";

  static String m27(name, ns, ready, upToDate, available) =>
      "${name}\n名字空间: ${ns}\n就绪: ${ready}\nUp to date: ${upToDate}\n可用: ${available}";

  static String m28(name, provisioner, reclaimPolicy, mountOptions,
          volumeBindingMode, allowVolumeExpansion) =>
      "${name}\n分配器: ${provisioner}\n回收策略: ${reclaimPolicy}\n存储卷绑定模式: ${volumeBindingMode}\n允许卷扩展: ${allowVolumeExpansion}";

  static String m29(number) => "总计: ${number}";

  static String m30(type, name) => "将要删除 ${type} ${name}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add_cluster": MessageLookupByLibrary.simpleMessage("添加集群"),
        "age": MessageLookupByLibrary.simpleMessage("年龄"),
        "all": MessageLookupByLibrary.simpleMessage("全部"),
        "appName": MessageLookupByLibrary.simpleMessage("k8z"),
        "appearance": MessageLookupByLibrary.simpleMessage("外观"),
        "applications": MessageLookupByLibrary.simpleMessage("应用程序"),
        "arsure": MessageLookupByLibrary.simpleMessage("你确认吗?"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "clusters": MessageLookupByLibrary.simpleMessage("集群"),
        "config": MessageLookupByLibrary.simpleMessage("配置"),
        "config_map_text": m0,
        "config_maps": MessageLookupByLibrary.simpleMessage("ConfigMaps"),
        "container_runtime": m1,
        "cpu": MessageLookupByLibrary.simpleMessage("CPU"),
        "crds": MessageLookupByLibrary.simpleMessage("自定资源定义"),
        "crds_text": m2,
        "current_cluster": MessageLookupByLibrary.simpleMessage("当前群集"),
        "daemon_sets": MessageLookupByLibrary.simpleMessage("DaemonSets"),
        "debug_flushdb": MessageLookupByLibrary.simpleMessage("清空数据库"),
        "debug_flushdb_desc":
            MessageLookupByLibrary.simpleMessage("将会清理所有数据库中的数据"),
        "debug_flushdb_done": MessageLookupByLibrary.simpleMessage("数据库已清空"),
        "delete": MessageLookupByLibrary.simpleMessage("删除"),
        "delete_failed": m4,
        "deleted": m5,
        "deployment_text": m6,
        "deployments": MessageLookupByLibrary.simpleMessage("Deployments"),
        "discovery_and_lb": MessageLookupByLibrary.simpleMessage("服务发现与负载均衡"),
        "edit": MessageLookupByLibrary.simpleMessage("编辑"),
        "empyt_context": MessageLookupByLibrary.simpleMessage(
            "无法从 kubeconfig 读取集群信息, contexts 字段可能为空"),
        "endpoint_text": m7,
        "endpoints": MessageLookupByLibrary.simpleMessage("端点 (endpoints)"),
        "error": MessageLookupByLibrary.simpleMessage("错误"),
        "event_text": m8,
        "events": MessageLookupByLibrary.simpleMessage("事件"),
        "external_ip": m9,
        "general": MessageLookupByLibrary.simpleMessage("常规"),
        "general_debug": MessageLookupByLibrary.simpleMessage("调试"),
        "general_debug_sqlview": MessageLookupByLibrary.simpleMessage("sql 视图"),
        "general_language": MessageLookupByLibrary.simpleMessage("语言"),
        "general_language_en": MessageLookupByLibrary.simpleMessage("英语"),
        "general_language_ja": MessageLookupByLibrary.simpleMessage("日本语"),
        "general_language_null": MessageLookupByLibrary.simpleMessage("跟随系统"),
        "general_language_zh": MessageLookupByLibrary.simpleMessage("中文"),
        "helm": MessageLookupByLibrary.simpleMessage("Helm"),
        "ingress_text": m10,
        "ingresses": MessageLookupByLibrary.simpleMessage("入口 (ingresses)"),
        "internel_ip": m11,
        "items_number": m12,
        "last_warning_events": m13,
        "load_file": MessageLookupByLibrary.simpleMessage("加载文件"),
        "load_metrics_error": m14,
        "loading_metrics": MessageLookupByLibrary.simpleMessage("加载指标..."),
        "manual_load_kubeconfig":
            MessageLookupByLibrary.simpleMessage("加载 kubeconfig 文件"),
        "memory": MessageLookupByLibrary.simpleMessage("Memory"),
        "more": MessageLookupByLibrary.simpleMessage("更多"),
        "name": MessageLookupByLibrary.simpleMessage("名称"),
        "namespaces": MessageLookupByLibrary.simpleMessage("名字空间"),
        "next_step": MessageLookupByLibrary.simpleMessage("下一步"),
        "no_current_cluster": MessageLookupByLibrary.simpleMessage("没有选择任何集群"),
        "node_arch": m15,
        "node_kernel": m16,
        "node_os_image": m17,
        "node_roles": m18,
        "node_version": m19,
        "nodes": MessageLookupByLibrary.simpleMessage("节点"),
        "nodes_desc": MessageLookupByLibrary.simpleMessage("节点可以是虚拟机或物理机。"),
        "ok": MessageLookupByLibrary.simpleMessage("好的"),
        "overview": MessageLookupByLibrary.simpleMessage("概览"),
        "pod_text": m20,
        "pods": MessageLookupByLibrary.simpleMessage("Pods"),
        "pv_text": m21,
        "pvc_text": m22,
        "pvcs": MessageLookupByLibrary.simpleMessage("持久卷申领"),
        "pvs": MessageLookupByLibrary.simpleMessage("持久卷"),
        "release_text": m23,
        "releases": MessageLookupByLibrary.simpleMessage("Releases"),
        "resources": MessageLookupByLibrary.simpleMessage("资源"),
        "running": MessageLookupByLibrary.simpleMessage("运行中"),
        "save_clusters": MessageLookupByLibrary.simpleMessage("保存集群"),
        "secret_text": m24,
        "secrets": MessageLookupByLibrary.simpleMessage("Secrets"),
        "select_clusters": MessageLookupByLibrary.simpleMessage("选择需要的集群"),
        "service_account_text": m25,
        "service_accounts": MessageLookupByLibrary.simpleMessage("服务账号"),
        "service_text": m26,
        "services": MessageLookupByLibrary.simpleMessage("服务 (services)"),
        "settings": MessageLookupByLibrary.simpleMessage("设置"),
        "stateful_set_text": m27,
        "stateful_sets": MessageLookupByLibrary.simpleMessage("StatefulSets"),
        "status": MessageLookupByLibrary.simpleMessage("状态"),
        "storage": MessageLookupByLibrary.simpleMessage("存储"),
        "storage_class": MessageLookupByLibrary.simpleMessage("存储类"),
        "storage_class_text": m28,
        "theme_auto": MessageLookupByLibrary.simpleMessage("跟随系统"),
        "theme_dark": MessageLookupByLibrary.simpleMessage("深色模式"),
        "theme_light": MessageLookupByLibrary.simpleMessage("亮色模式"),
        "totals": m29,
        "version": MessageLookupByLibrary.simpleMessage("版本"),
        "will_delete": m30,
        "workloads": MessageLookupByLibrary.simpleMessage("负载")
      };
}
