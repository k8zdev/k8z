@logic
Feature: CRD详情展示

  Scenario: 点击CRD后显示详细信息
    Given 集群中存在名为 "prometheuses.monitoring.coreos.com" 的CRD
    When 我点击该CRD查看详情
    Then 我应该看到该CRD的详细信息，包括group、version、kind、scope等字段
    And 我应该看到group值为 "monitoring.coreos.com"
    And 我应该看到version值为 "v1"
    And 我应该看到kind值为 "Prometheus"
    And 我应该看到scope值为 "Namespaced"

  Scenario: 查看集群作用域的CRD详情
    Given 集群中存在名为 "certificates.cert-manager.io" 的CRD
    When 我点击该CRD查看详情
    Then 我应该看到该CRD的scope为 "Cluster"
    And 我应该看到shortNames列表
    And 我应该看到plural和singular字段

  Scenario: 查看带有存储版本的CRD详情
    Given 集群中存在带有存储版本的CRD
    When 我点击该CRD查看详情
    Then 我应该看到storageVersion字段
    And 我应该看到version列表