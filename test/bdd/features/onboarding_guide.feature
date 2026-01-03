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

  @skip-persistence
  Scenario: User skips guide at welcome step
    Given 应用已经启动
    And demo 集群已加载
    When 我进入集群列表页面
    Then 当前步骤应该是欢迎步骤
    When 我跳过引导
    Then 新手引导不应该再激活

  @skip-persistence
  Scenario: Skip record persists across app restarts
    Given 应用已经启动
    And demo 集群已加载
    And 我已经跳过了引导
    When 应用重启
    When 我进入集群列表页面
    Then 新手引导不应该再激活

  @skip-persistence
  Scenario: User can retry skipped guide from settings
    Given 应用已经启动
    And demo 集群已加载
    And 我已经跳过了引导
    When 我在设置页面选择重新开始引导
    When 我进入集群列表页面
    Then 新手引导应该是激活状态

  @back-navigation
  Scenario: Back from pod list returns to workloads overview
    Given 应用已经启动
    And demo 集群已加载
    And 我已经在工作负载页面
    When 我点击工作负载卡片
    And 我导航到 Pod 列表
    When 我点击返回按钮
    Then 我应该看到工作负载概览页面

  @back-navigation
  Scenario: Back from pod detail returns to pod list
    Given 应用已经启动
    And demo 集群已加载
    And 我已经在 Pod 列表页面
    When 我选择一个 Pod
    And 我进入 Pod 详情页
    When 我点击返回按钮
    Then 我应该看到 Pod 列表页面

  @back-navigation
  Scenario: Back from resources returns to pod detail
    Given 应用已经启动
    And demo 集群已加载
    And 我已经在 Pod 详情页
    When 我查看相关资源
    When 我点击返回按钮
    Then 我应该看到 Pod 详情页

  @back-navigation
  Scenario: Back from nodes returns to resources
    Given 应用已经启动
    And demo 集群已加载
    And 我已经在资源页面
    When 我导航到节点列表
    When 我点击返回按钮
    Then 我应该看到资源页面

  @back-navigation
  Scenario: Back from node detail returns to nodes list
    Given 应用已经启动
    And demo 集群已加载
    And 我已经在节点列表页面
    When 我选择一个节点
    And 我进入节点详情页
    When 我点击返回按钮
    Then 我应该看到节点列表页面

  @i18n
  Scenario: Guide displays in English locale
    Given 应用已经启动
    And demo 集群已加载
    And 语言设置为英文
    When 我进入集群列表页面
    Then 我应该看到英文欢迎文本

  @i18n
  Scenario: Guide displays in Chinese locale
    Given 应用已经启动
    And demo 集群已加载
    And 语言设置为中文
    When 我进入集群列表页面
    Then 我应该看到中文欢迎文本

  @i18n
  Scenario: Guide text updates when language changes
    Given 应用已经启动
    And demo 集群已加载
    And 语言设置为英文
    And 我正在查看新手引导
    When 我将语言切换为中文
    Then 我应该看到中文欢迎文本

  @extended-flow
  Scenario: User navigates through complete 8-step guide flow
    Given 应用已经启动
    And demo 集群已加载
    When 我进入集群列表页面
    Then 当前步骤应该是欢迎步骤
    When 我点击下一步
    Then 我应该看到工作负载概览步骤
    When 我点击下一步
    Then 我应该看到 Pod 列表步骤
    When 我点击下一步
    Then 我应该看到 Pod 详情步骤
    When 我点击下一步
    Then 我应该看到资源步骤
    When 我点击下一步
    Then 我应该看到节点列表步骤
    When 我点击下一步
    Then 我应该看到节点详情步骤
    When 我点击下一步
    Then 我应该看到集群选择步骤

  @dynamic-node
  Scenario: System dynamically selects first node
    Given 应用已经启动
    And demo 集群已加载
    When 我进入集群列表页面
    And 我导航到节点列表
    Then 系统应该选择第一个可用节点

  @dynamic-node
  Scenario: Node detail navigation uses API-fetched node name
    Given 应用已经启动
    And demo 集群已加载
    And 第一个节点名称是 "demo-node-1"
    When 我导航到节点列表
    When 我点击第一个节点
    Then 我应该看到 "demo-node-1" 的详情页
