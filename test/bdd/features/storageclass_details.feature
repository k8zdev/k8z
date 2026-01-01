@logic
Feature: StorageClass资源详情

  Scenario: 查看StorageClass详情页面
    Given 集群中存在名为 "standard" 的StorageClass
    When 我导航到StorageClass详情页面
    Then 我应该看到存储类名称 "standard"
    And 我应该看到分配器 "kubernetes.io/gce-pd"
    And 我应该看到回收策略 "Delete"
    And 我应该看到存储卷绑定模式 "WaitForFirstConsumer"
