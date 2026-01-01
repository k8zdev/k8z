@logic
Feature: 持久卷详情

  Scenario: 查看持久卷详情
    Given 集群中有持久卷资源
    When 我点击一个持久卷
    Then 我应该看到持久卷详情页面
    And 我应该看到持久卷的状态
    And 我应该看到持久卷的容量
    And 我应该看到持久卷的访问模式
    And 我应该看到持久卷的回收策略
