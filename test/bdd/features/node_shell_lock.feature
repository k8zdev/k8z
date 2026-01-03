@logic @node-shell
Feature: Node Shell 功能锁定

  Background:
    Given 应用已初始化
    And 用户可以选择一个集群
    And 集群中有一个Node

  Scenario: Free用户点击Node Shell时显示Pro升级对话框
    Given 用户是Free用户
    When 我点击Node Shell按钮
    Then 应该显示"k8z Pro"升级对话框
    And 对话框描述显示"Node Shell访问需要升级到Pro"

  Scenario: Pro用户可以访问Node Shell
    Given 用户是Pro用户
    When 我点击Node Shell按钮
    Then 应该允许打开Node Shell
    And Node Shell终端界面正常显示

  Scenario: Free用户Node Shell按钮显示Pro锁定徽章
    Given 用户是Free用户
    When 我查看Node Shell按钮
    Then 应该显示锁形图标徽章
    And 锁形图标覆盖在按钮上

  Scenario: Pro用户Node Shell按钮不显示锁定徽章
    Given 用户是Pro用户
    When 我查看Node Shell按钮
    Then 不应该显示锁形图标徽章
    And 按钮显示为正常状态

  Scenario: 点击升级对话框中的"查看Pro计划"按钮
    Given 用户是Free用户
    And 显示了Pro升级对话框
    When 我点击"查看Pro计划"按钮
    Then 应该导航到付费墙页面

  Scenario: 点击升级对话框中的"取消"按钮关闭对话框
    Given 用户是Free用户
    And 显示了Pro升级对话框
    When 我点击"取消"按钮
    Then 对话框应该关闭
    And 不会打开Node Shell

  Scenario: Pro升级对话框显示6个Pro功能优势
    Given 用户是Free用户
    And 显示了Pro升级对话框
    When 我查看对话框内容
    Then 应该显示6个Pro功能优势列表
    And 列表包含"无限集群数量"
    And 列表包含"Node Shell访问权限"
    And 列表包含"YAML编辑和应用"
