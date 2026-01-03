@logic @emergency
Feature: 紧急操作免费功能

  Background:
    Given 应用已初始化
    And 用户可以选择一个集群
    And 集群中有一个Pod

  Scenario: Free用户可以删除Pod（紧急操作）
    Given 用户是Free用户
    When 我选择要删除的Pod并点击删除
    Then 应该允许删除Pod
    And Pod被成功删除

  Scenario: Free用户可以扩缩容Pod（紧急操作）
    Given 用户是Free用户
    When 我选择要扩缩容的Pod并点击扩缩容
    Then 应该允许扩缩容Pod
    And Pod副本数被成功更新

  Scenario: Free用户可以访问Pod终端（紧急调试）
    Given 用户是Free用户
    When 我点击Pod终端按钮
    Then 应该允许打开Pod终端
    And Pod终端界面正常显示

  Scenario: Free用户可以查看实时日志（紧急调试）
    Given 用户是Free用户
    When 我点击查看Pod日志
    Then 应该允许显示实时日志
    And 日志内容正常显示

  Scenario: Free用户可以查看资源详情
    Given 用户是Free用户
    When 我点击查看资源详情
    Then 应该允许查看详情
    And 资源详情信息正常显示

  Scenario: Free用户可以删除所有类型的资源（紧急操作）
    Given 用户是Free用户
    And 资源类型是Service/Deployment/Ingress
    When 我点击删除资源
    Then 应该允许删除资源
    And 资源被成功删除

  Scenario: Pro用户也可以执行所有紧急操作
    Given 用户是Pro用户
    When 我执行删除Pod操作
    Then 应该允许删除Pod
    And Pod被成功删除
