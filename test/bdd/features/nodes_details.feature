@logic
Feature: Nodes Details Page

  Scenario: View Node details with complete information
    Given 应用内没有集群
    When 我选择并加载一个有效的 kubeconfig 文件
    Then 集群中有一个可用的节点
    And 我点击节点
    And 我应该看到节点详情页面
    And 我应该看到操作系统信息
    And 我应该看到架构信息
    And 我应该看到内核版本
    And 我应该看到容器运行时版本
    And 我应该看到 IP 地址
    And 我应该看到 Pod CIDR
    And 我应该看到节点容量
    And 我应该看到节点状态
