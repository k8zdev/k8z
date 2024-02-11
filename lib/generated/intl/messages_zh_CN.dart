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

  static String m0(namespace, name, type, reason, kind, ObjName, lastTimestamp,
          message) =>
      "${namespace} / ${name}\n\n类型: ${type}\n原因: ${reason}\n对象: ${kind}/${ObjName}\n最后发生: ${lastTimestamp}\n\n信息: ${message}\n";

  static String m1(n) => "最近 ${n} 警告";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add_cluster": MessageLookupByLibrary.simpleMessage("添加集群"),
        "all": MessageLookupByLibrary.simpleMessage("全部"),
        "appName": MessageLookupByLibrary.simpleMessage("k8z"),
        "appearance": MessageLookupByLibrary.simpleMessage("外观"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "clusters": MessageLookupByLibrary.simpleMessage("集群"),
        "current_cluster": MessageLookupByLibrary.simpleMessage("当前群集"),
        "debug_flushdb": MessageLookupByLibrary.simpleMessage("清空数据库"),
        "debug_flushdb_desc":
            MessageLookupByLibrary.simpleMessage("将会清理所有数据库中的数据"),
        "debug_flushdb_done": MessageLookupByLibrary.simpleMessage("数据库已清空"),
        "delete": MessageLookupByLibrary.simpleMessage("删除"),
        "edit": MessageLookupByLibrary.simpleMessage("编辑"),
        "empyt_context": MessageLookupByLibrary.simpleMessage(
            "无法从 kubeconfig 读取集群信息, contexts 字段可能为空"),
        "error": MessageLookupByLibrary.simpleMessage("错误"),
        "event_text": m0,
        "events": MessageLookupByLibrary.simpleMessage("事件"),
        "general": MessageLookupByLibrary.simpleMessage("常规"),
        "general_debug": MessageLookupByLibrary.simpleMessage("调试"),
        "general_debug_sqlview": MessageLookupByLibrary.simpleMessage("sql 视图"),
        "general_language": MessageLookupByLibrary.simpleMessage("语言"),
        "general_language_en": MessageLookupByLibrary.simpleMessage("英语"),
        "general_language_ja": MessageLookupByLibrary.simpleMessage("日本语"),
        "general_language_null": MessageLookupByLibrary.simpleMessage("跟随系统"),
        "general_language_zh": MessageLookupByLibrary.simpleMessage("中文"),
        "last_warning_events": m1,
        "load_file": MessageLookupByLibrary.simpleMessage("加载文件"),
        "manual_load_kubeconfig":
            MessageLookupByLibrary.simpleMessage("加载 kubeconfig 文件"),
        "more": MessageLookupByLibrary.simpleMessage("更多"),
        "name": MessageLookupByLibrary.simpleMessage("名称"),
        "next_step": MessageLookupByLibrary.simpleMessage("下一步"),
        "nodes": MessageLookupByLibrary.simpleMessage("节点"),
        "nodes_desc": MessageLookupByLibrary.simpleMessage("节点可以是虚拟机或物理机。"),
        "ok": MessageLookupByLibrary.simpleMessage("好的"),
        "overview": MessageLookupByLibrary.simpleMessage("概览"),
        "running": MessageLookupByLibrary.simpleMessage("运行中"),
        "save_clusters": MessageLookupByLibrary.simpleMessage("保存集群"),
        "select_clusters": MessageLookupByLibrary.simpleMessage("选择需要的集群"),
        "settings": MessageLookupByLibrary.simpleMessage("设置"),
        "status": MessageLookupByLibrary.simpleMessage("状态"),
        "theme_auto": MessageLookupByLibrary.simpleMessage("跟随系统"),
        "theme_dark": MessageLookupByLibrary.simpleMessage("深色模式"),
        "theme_light": MessageLookupByLibrary.simpleMessage("亮色模式"),
        "version": MessageLookupByLibrary.simpleMessage("版本")
      };
}
