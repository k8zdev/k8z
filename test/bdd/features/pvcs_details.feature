@logic
Feature: PVCs详情页

  Scenario: 查看PVC详情页面
    Given 应用中已加载集群
    And 集群中有持久卷声明资源
    When 我导航到PVC详情页面
    Then 我应该看到PVC状态
    And 我应该看到存储容量
    And 我应该看到访问模式
    And 我应该看到存储类名称
    And 我应该看到卷名称
    And 我应该看到卷模式