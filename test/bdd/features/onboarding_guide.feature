Feature: 新手引导

  @logic
  Scenario: 加载 demo 集群后进入列表页时显示引导
    Given 应用已经启动
    And demo 集群已加载
    When 我进入集群列表页面
    Then 新手引导应该是激活状态
    And 当前步骤应该是欢迎步骤
    And 我应该看到 "Welcome to K8zDev!" 文本

  @logic
  Scenario: 引导未完成时每次进入列表页都弹窗
    Given 应用已经启动
    And demo 集群已加载
    And 新手引导未完成
    When 我进入集群列表页面 (第一次)
    Then 新手引导应该是激活状态
    When 我跳过引导
    When 我再次进入集群列表页面 (第二次)
    Then 新手引导应该是激活状态
