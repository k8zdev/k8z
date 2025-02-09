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

  static String m0(duration) => "\t\t耗时: ${duration}";

  static String m1(name, ns, data) => "${name}\n名字空间: ${ns}\n数据: ${data}";

  static String m2(arg) => "运行时:\t\t ${arg}";

  static String m3(name, kind, scope, shortNames) =>
      "${name}\n\n种类: ${kind}\n范围: ${scope}\n简称: ${shortNames}";

  static String m4(name, ns, ready, upToDate, available) =>
      "${name}\n名字空间: ${ns}\n就绪: ${ready}\nUp to date: ${upToDate}\n可用: ${available}\n";

  static String m5(error) => "删除失败, 错误: ${error}";

  static String m6(name) => "${name} 已删除";

  static String m7(name, ns, ready, upToDate, available) =>
      "${name}\n名字空间: ${ns}\n就绪: ${ready}\nUp to date: ${upToDate}\n可用: ${available}";

  static String m8(name, ns, endpoints) =>
      "${name}\n名字空间Namespace: ${ns}\nEndpoints: ${endpoints}";

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
      "${namespace} / ${name}\n\n类型: ${type}\n原因: ${reason}\n对象: ${kind}/${objName}\n最后发生: ${lastTimestamp}\n\n信息: ${message}\n";

  static String m10(path) => "已导出到 ${path}";

  static String m11(arg) => "外部 IP:\t\t ${arg}";

  static String m12(name, ns, className, hosts, address, ports) =>
      "${name}\n名字空间: ${ns}\n类: ${className}\n主机: ${hosts}\n地址: ${address}\n端口: ${ports}";

  static String m13(arg) => "内部 IP:\t\t ${arg}";

  static String m14(number) => " (${number} 项)";

  static String m15(n) => "最近 ${n} 警告";

  static String m16(error) => "加载指标错误: ${error}";

  static String m17(n) => "${n} 秒";

  static String m18(arg) => "架构\t\t: ${arg}";

  static String m19(os, arg) => "内核:\t\t ${os}/${arg}";

  static String m20(arg) => "系统镜像:\t\t ${arg}";

  static String m21(arg) => "角色:\t\t ${arg}";

  static String m22(arg) => "版本:\t\t ${arg}";

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
      "${name}\n\n名字空间: ${namespace}\n就绪: ${ready}\n状况: ${status}\n重启: ${restarts}\n容器: ${containers}\nCPU: ${cpu}\n内存: ${memory}";

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
      "${name}\n容量: ${capacity}\n访问模式: ${accessModes}\n回收策略: ${reclaimPolicy}\n状态: ${status}\n声明: ${claim}\n存储类: ${storageClass}\n原因: ${reason}\n";

  static String m25(
    name,
    ns,
    status,
    volume,
    capacity,
    accessModes,
    storageClass,
  ) =>
      "${name}\n名字空间: ${ns}\n状态: ${status}\n卷名称: ${volume}\n容量: ${capacity}\n访问模式: ${accessModes}\n存储类: ${storageClass}";

  static String m26(name, ns, revision, appVer, updated, status, chart) =>
      "${name}\n名字空间: ${ns}\nRevision: ${revision}\n程序版本: ${appVer}\n更新: ${updated}\n状态: ${status}\nChart: ${chart}";

  static String m27(name, ns, current, ready, available) =>
      "${name}\n名字空间: ${ns}\n当前: ${current}\n就绪: ${ready}\n可用: ${available}\n";

  static String m28(error) => "扩缩容失败, 错误: ${error}";

  static String m29(N) => "缩放至 ${N} 副本";

  static String m30(name, ns, type, data) =>
      "${name}\n名字空间: ${ns}\n类型: ${type}\n数据: ${data}";

  static String m31(name, ns, secrets) =>
      "${name}\n名字空间: ${ns}\n秘钥: ${secrets}";

  static String m32(name, ns, type, clusterIP, externalIP, ports) =>
      "${name}\n名字空间: ${ns}\n类: ${type}\n集群 IP: ${clusterIP}\n外部 IP: ${externalIP}\n端口: ${ports}";

  static String m33(name, ns, ready, upToDate, available) =>
      "${name}\n名字空间: ${ns}\n就绪: ${ready}\nUp to date: ${upToDate}\n可用: ${available}";

  static String m34(
    name,
    provisioner,
    reclaimPolicy,
    mountOptions,
    volumeBindingMode,
    allowVolumeExpansion,
  ) =>
      "${name}\n分配器: ${provisioner}\n回收策略: ${reclaimPolicy}\n存储卷绑定模式: ${volumeBindingMode}\n允许卷扩展: ${allowVolumeExpansion}\n挂载参数: ${mountOptions}";

  static String m35(date) => "赞助过期时间: \$${date}";

  static String m36(error) => "恢复购买失败, 错误: ${error}";

  static String m37(number) => "已打开 ${number} 个终端";

  static String m38(number) => "总计: ${number}";

  static String m39(type, name) => "将要删除 ${type} ${name}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "add_cluster": MessageLookupByLibrary.simpleMessage("添加集群"),
    "addresses": MessageLookupByLibrary.simpleMessage("地址"),
    "age": MessageLookupByLibrary.simpleMessage("年龄"),
    "all": MessageLookupByLibrary.simpleMessage("全部"),
    "annotations": MessageLookupByLibrary.simpleMessage("注解"),
    "apiVersion": MessageLookupByLibrary.simpleMessage("API版本"),
    "api_request_duration": m0,
    "api_timeout": MessageLookupByLibrary.simpleMessage("API 超时"),
    "appName": MessageLookupByLibrary.simpleMessage("k8z"),
    "appearance": MessageLookupByLibrary.simpleMessage("外观"),
    "applications": MessageLookupByLibrary.simpleMessage("应用程序"),
    "apply": MessageLookupByLibrary.simpleMessage("应用"),
    "args": MessageLookupByLibrary.simpleMessage("参数"),
    "arsure": MessageLookupByLibrary.simpleMessage("你确认吗?"),
    "blockOwnerDeletion": MessageLookupByLibrary.simpleMessage("阻塞属主删除"),
    "cancel": MessageLookupByLibrary.simpleMessage("取消"),
    "cluster_ip": MessageLookupByLibrary.simpleMessage("集群 IP"),
    "clusters": MessageLookupByLibrary.simpleMessage("集群"),
    "command": MessageLookupByLibrary.simpleMessage("命令"),
    "config": MessageLookupByLibrary.simpleMessage("配置"),
    "config_map_text": m1,
    "config_maps": MessageLookupByLibrary.simpleMessage("ConfigMaps"),
    "container": MessageLookupByLibrary.simpleMessage("容器"),
    "container_id": MessageLookupByLibrary.simpleMessage("容器 ID"),
    "container_runtime": m2,
    "containers": MessageLookupByLibrary.simpleMessage("容器"),
    "controller": MessageLookupByLibrary.simpleMessage("控制器"),
    "cpu": MessageLookupByLibrary.simpleMessage("CPU"),
    "crds": MessageLookupByLibrary.simpleMessage("自定资源定义"),
    "crds_text": m3,
    "creation_time": MessageLookupByLibrary.simpleMessage("创建时间"),
    "current_cluster": MessageLookupByLibrary.simpleMessage("当前群集"),
    "daemon_set_text": m4,
    "daemon_sets": MessageLookupByLibrary.simpleMessage("DaemonSets"),
    "data": MessageLookupByLibrary.simpleMessage("数据"),
    "debug_flushdb": MessageLookupByLibrary.simpleMessage("清空数据库"),
    "debug_flushdb_desc": MessageLookupByLibrary.simpleMessage("将会清理所有数据库中的数据"),
    "debug_flushdb_done": MessageLookupByLibrary.simpleMessage("数据库已清空"),
    "delete": MessageLookupByLibrary.simpleMessage("删除"),
    "delete_failed": m5,
    "delete_ok": MessageLookupByLibrary.simpleMessage("删除资源成功."),
    "delete_resource": MessageLookupByLibrary.simpleMessage("确认删除资源吗?"),
    "deleted": m6,
    "deployment_text": m7,
    "deployments": MessageLookupByLibrary.simpleMessage("Deployments"),
    "discovery_and_lb": MessageLookupByLibrary.simpleMessage("服务发现与负载均衡"),
    "dnsPolicy": MessageLookupByLibrary.simpleMessage("dns策略"),
    "documents": MessageLookupByLibrary.simpleMessage("文档"),
    "edit": MessageLookupByLibrary.simpleMessage("编辑"),
    "empty": MessageLookupByLibrary.simpleMessage("空"),
    "empyt_context": MessageLookupByLibrary.simpleMessage(
      "无法从 kubeconfig 读取集群信息, contexts 字段可能为空",
    ),
    "endpoint_text": m8,
    "endpoints": MessageLookupByLibrary.simpleMessage("端点 (endpoints)"),
    "ephemeral_containers": MessageLookupByLibrary.simpleMessage("临时容器"),
    "error": MessageLookupByLibrary.simpleMessage("错误"),
    "eula": MessageLookupByLibrary.simpleMessage("EULA"),
    "event_text": m9,
    "events": MessageLookupByLibrary.simpleMessage("事件"),
    "export": MessageLookupByLibrary.simpleMessage("导出"),
    "exported": m10,
    "external_ip": m11,
    "external_ips": MessageLookupByLibrary.simpleMessage("外部 IPs"),
    "external_name": MessageLookupByLibrary.simpleMessage("外部名称"),
    "feedback": MessageLookupByLibrary.simpleMessage("反馈"),
    "finalizers": MessageLookupByLibrary.simpleMessage("结束器"),
    "general": MessageLookupByLibrary.simpleMessage("常规"),
    "general_debug": MessageLookupByLibrary.simpleMessage("调试"),
    "general_debug_sqlview": MessageLookupByLibrary.simpleMessage("sql 视图"),
    "general_language": MessageLookupByLibrary.simpleMessage("语言"),
    "general_language_en": MessageLookupByLibrary.simpleMessage("英语"),
    "general_language_ja": MessageLookupByLibrary.simpleMessage("日本语"),
    "general_language_null": MessageLookupByLibrary.simpleMessage("跟随系统"),
    "general_language_zh": MessageLookupByLibrary.simpleMessage("中文"),
    "generation": MessageLookupByLibrary.simpleMessage("世代"),
    "get_terminal": MessageLookupByLibrary.simpleMessage("获取终端"),
    "helm": MessageLookupByLibrary.simpleMessage("Helm"),
    "hostNetwork": MessageLookupByLibrary.simpleMessage("主机网络"),
    "hostname": MessageLookupByLibrary.simpleMessage("主机名称"),
    "image": MessageLookupByLibrary.simpleMessage("镜像"),
    "imagePullPolicy": MessageLookupByLibrary.simpleMessage("镜像拉取策略"),
    "imagePullSecrets": MessageLookupByLibrary.simpleMessage("镜像拉取密钥"),
    "image_id": MessageLookupByLibrary.simpleMessage("镜像 ID"),
    "ingress_text": m12,
    "ingresses": MessageLookupByLibrary.simpleMessage("入口 (ingresses)"),
    "initContainers": MessageLookupByLibrary.simpleMessage("初始容器"),
    "internel_ip": m13,
    "items_number": m14,
    "kind": MessageLookupByLibrary.simpleMessage("种类"),
    "labels": MessageLookupByLibrary.simpleMessage("标签"),
    "last_warning_events": m15,
    "livenessProbe": MessageLookupByLibrary.simpleMessage("存活探针"),
    "load_balancer_ip": MessageLookupByLibrary.simpleMessage("负载均衡器 IP"),
    "load_file": MessageLookupByLibrary.simpleMessage("加载文件"),
    "load_metrics_error": m16,
    "loading_metrics": MessageLookupByLibrary.simpleMessage("加载指标..."),
    "logs": MessageLookupByLibrary.simpleMessage("日志"),
    "manual_load_kubeconfig": MessageLookupByLibrary.simpleMessage(
      "加载 kubeconfig 文件",
    ),
    "memory": MessageLookupByLibrary.simpleMessage("Memory"),
    "metadata": MessageLookupByLibrary.simpleMessage("元数据"),
    "more": MessageLookupByLibrary.simpleMessage("更多"),
    "n_seconds": m17,
    "name": MessageLookupByLibrary.simpleMessage("名称"),
    "namespace": MessageLookupByLibrary.simpleMessage("名字空间"),
    "namespaces": MessageLookupByLibrary.simpleMessage("名字空间"),
    "next_step": MessageLookupByLibrary.simpleMessage("下一步"),
    "no_current_cluster": MessageLookupByLibrary.simpleMessage("没有选择任何集群"),
    "node_arch": m18,
    "node_kernel": m19,
    "node_os_image": m20,
    "node_roles": m21,
    "node_shell": MessageLookupByLibrary.simpleMessage("节点 Shell"),
    "node_version": m22,
    "nodes": MessageLookupByLibrary.simpleMessage("节点"),
    "nodes_desc": MessageLookupByLibrary.simpleMessage("节点可以是虚拟机或物理机。"),
    "ok": MessageLookupByLibrary.simpleMessage("好的"),
    "overview": MessageLookupByLibrary.simpleMessage("概览"),
    "owner": MessageLookupByLibrary.simpleMessage("属主"),
    "pod_text": m23,
    "pods": MessageLookupByLibrary.simpleMessage("Pods"),
    "ports": MessageLookupByLibrary.simpleMessage("端口"),
    "privacy_policy": MessageLookupByLibrary.simpleMessage("隐私政策"),
    "pv_text": m24,
    "pvc_text": m25,
    "pvcs": MessageLookupByLibrary.simpleMessage("持久卷申领"),
    "pvs": MessageLookupByLibrary.simpleMessage("持久卷"),
    "readinessProbe": MessageLookupByLibrary.simpleMessage("就绪探针"),
    "release_text": m26,
    "releases": MessageLookupByLibrary.simpleMessage("Releases"),
    "replicasets": MessageLookupByLibrary.simpleMessage("副本集合 (RS)"),
    "replicasets_text": m27,
    "resourceVersion": MessageLookupByLibrary.simpleMessage("资源版本"),
    "resource_url": MessageLookupByLibrary.simpleMessage("资源 URL"),
    "resource_yaml": MessageLookupByLibrary.simpleMessage("资源 Yaml"),
    "resources": MessageLookupByLibrary.simpleMessage("资源"),
    "running": MessageLookupByLibrary.simpleMessage("运行中"),
    "save_clusters": MessageLookupByLibrary.simpleMessage("保存集群"),
    "scale": MessageLookupByLibrary.simpleMessage("缩放"),
    "scale_failed": m28,
    "scale_ok": MessageLookupByLibrary.simpleMessage("扩缩容成功"),
    "scale_to": m29,
    "secret_text": m30,
    "secrets": MessageLookupByLibrary.simpleMessage("Secrets"),
    "select_clusters": MessageLookupByLibrary.simpleMessage("选择需要的集群"),
    "selector": MessageLookupByLibrary.simpleMessage("选择器"),
    "selfLink": MessageLookupByLibrary.simpleMessage("selfLink"),
    "service_account_text": m31,
    "service_accounts": MessageLookupByLibrary.simpleMessage("服务账号"),
    "service_text": m32,
    "services": MessageLookupByLibrary.simpleMessage("服务 (services)"),
    "session_affinity": MessageLookupByLibrary.simpleMessage("会话亲和性"),
    "settings": MessageLookupByLibrary.simpleMessage("设置"),
    "since": MessageLookupByLibrary.simpleMessage("自"),
    "spec": MessageLookupByLibrary.simpleMessage("Spec"),
    "sponsor_desc": MessageLookupByLibrary.simpleMessage(
      "赞助我以便于我可以继续开发维护这款应用程序。",
    ),
    "sponsorme": MessageLookupByLibrary.simpleMessage("赞助我"),
    "start_debug": MessageLookupByLibrary.simpleMessage("开始调试"),
    "start_debug_desc": MessageLookupByLibrary.simpleMessage(
      "开始调试将会在 Pod 中创建一个临时容器, 并将 stdin, stdout, stderr 附加到它。",
    ),
    "startupProbe": MessageLookupByLibrary.simpleMessage("启动探针"),
    "stateful_set_text": m33,
    "stateful_sets": MessageLookupByLibrary.simpleMessage("StatefulSets"),
    "status": MessageLookupByLibrary.simpleMessage("状态"),
    "storage": MessageLookupByLibrary.simpleMessage("存储"),
    "storage_class": MessageLookupByLibrary.simpleMessage("存储类"),
    "storage_class_text": m34,
    "subscriptions_expired_at": m35,
    "subscriptions_iap_desc": MessageLookupByLibrary.simpleMessage(
      "如不取消, 订购将会自动续费。付款将在确认购买时向iTunes帐户收取。订阅自动续订, 除非自动续订在当前期限结束前至少24小时关闭。账户将在本期结束前的24小时内收取续费费用, 并确定续约费用。订购可由用户管理, 购买后可通过转到用户的帐户设置关闭自动续订。免费试用期的任何未使用部分（如果提供）在用户购买该出版物的订阅时将被没收。",
    ),
    "subscriptions_lifetime": MessageLookupByLibrary.simpleMessage("终身"),
    "subscriptions_monthly": MessageLookupByLibrary.simpleMessage("每月"),
    "subscriptions_purchased": MessageLookupByLibrary.simpleMessage("已购买"),
    "subscriptions_restorePurchases_failed": m36,
    "subscriptions_restore_purchases": MessageLookupByLibrary.simpleMessage(
      "恢复购买",
    ),
    "subscriptions_restore_success": MessageLookupByLibrary.simpleMessage(
      "恢复成功",
    ),
    "subscriptions_yearly": MessageLookupByLibrary.simpleMessage("每年"),
    "subsets": MessageLookupByLibrary.simpleMessage("子集"),
    "success": MessageLookupByLibrary.simpleMessage("成功"),
    "support": MessageLookupByLibrary.simpleMessage("支持"),
    "tail_lines": MessageLookupByLibrary.simpleMessage("尾部行数"),
    "terminal": MessageLookupByLibrary.simpleMessage("终端"),
    "terminals_opened": m37,
    "theme_auto": MessageLookupByLibrary.simpleMessage("跟随系统"),
    "theme_dark": MessageLookupByLibrary.simpleMessage("深色模式"),
    "theme_light": MessageLookupByLibrary.simpleMessage("亮色模式"),
    "totals": m38,
    "type": MessageLookupByLibrary.simpleMessage("类型"),
    "uid": MessageLookupByLibrary.simpleMessage("uid"),
    "version": MessageLookupByLibrary.simpleMessage("版本"),
    "will_delete": m39,
    "workloads": MessageLookupByLibrary.simpleMessage("负载"),
  };
}
