@logic
Feature: 集群数量限制

  Background:
    Given 应用已初始化

  Scenario: Pro用户可以添加无限数量集群
    Given 用户是Pro用户
    When 检查是否可以添加集群
    Then 返回true和null提示信息

  Scenario: Pro用户检查是否可以添加集群
    Given 用户是Pro用户
    When 检查是否可以添加集群
    Then 应该允许添加集群

  Scenario: Free用户未达限制时可以添加集群
    Given 用户是Free用户
    And 用户被祖父条款保护
    When 检查是否可以添加集群
    Then 返回true和null提示信息

  Scenario: Free用户达限制且无祖父条款保护
    Given 用户是Free用户
    And 用户未被祖父条款保护
    When 检查是否可以添加集群
    Then 返回false和集群限制提示信息
