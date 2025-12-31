@logic
Feature: 集群管理

  Scenario: 加载 kubeconfig 文件后显示集群
    Given 应用内没有集群
    When 我选择并加载一个有效的 kubeconfig 文件
    Then 我应该在集群列表中看到 "kind-k8z"
