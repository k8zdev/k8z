@logic @yaml-edit
Feature: YAML 编辑和应用锁定

  Background:
    Given 应用已初始化
    And 用户可以选择一个集群
    And 集群中有一个资源

  Scenario: Free用户点击YAML编辑按钮时显示Pro升级对话框
    Given 用户是Free用户
    When 我点击YAML编辑按钮
    Then 应该显示"k8z Pro"升级对话框
    And 对话框描述显示"YAML编辑需要升级到Pro"

  Scenario: Pro用户可以编辑YAML
    Given 用户是Pro用户
    When 我点击YAML编辑按钮
    Then 应该打开YAML编辑器
    And 编辑器显示当前资源的YAML内容

  Scenario: Free用户点击Apply按钮时显示Pro升级对话框
    Given 用户是Free用户
    And YAML编辑器已打开
    When 我点击Apply按钮
    Then 应该显示"k8z Pro"升级对话框
    And YAML更改不会被应用

  Scenario: Pro用户可以Apply YAML更改
    Given 用户是Pro用户
    And YAML编辑器已打开
    And 我已修改YAML内容
    When 我点击Apply按钮
    Then 应该应用YAML更改
    And 资源被成功更新

  Scenario: Free用户YAML编辑按钮显示Pro锁定徽章
    Given 用户是Free用户
    When 我查看YAML编辑按钮
    Then 应该显示锁形图标徽章
    And 锁形图标覆盖在按钮上

  Scenario: Pro用户YAML编辑按钮不显示锁定徽章
    Given 用户是Pro用户
    When 我查看YAML编辑按钮
    Then 不应该显示锁形图标徽章
    And 按钮显示为正常状态

  Scenario: Free用户查看资源详情可以查看YAML但无法编辑
    Given 用户是Free用户
    And 我打开了资源详情页面
    When 我查看YAML内容
    Then 应该显示YAML内容
    And YAML内容为只读状态
    And 编辑按钮显示锁定徽章

  Scenario: Free用户在YAML编辑器中查看内容但无法应用更改
    Given 用户是Free用户
    And 我已打开YAML编辑器
    When 我查看Apply按钮
    Then Apply按钮应该显示锁定徽章
    And 点击Apply按钮显示升级对话框
