@logic @probabilistic
Feature: 概率性升级提示

  Background:
    Given 应用已初始化

  Scenario: 第1次打开应用不显示升级提示
    Given 这是第1次打开应用
    And 用户是Free用户
    When 应用初始化完成
    Then 不应该显示Pro升级对话框

  Scenario: 第9次打开应用不显示升级提示
    Given 这是第9次打开应用
    And 用户是Free用户
    When 应用初始化完成
    Then 不应该显示Pro升级对话框

  Scenario: 第10次打开应用显示升级提示
    Given 这是第10次打开应用
    And 用户是Free用户
    When 应用初始化完成
    Then 应该显示Pro升级对话框

  Scenario: 第11次打开应用不显示升级提示
    Given 这是第11次打开应用
    And 用户是Free用户
    When 应用初始化完成
    Then 不应该显示Pro升级对话框

  Scenario: 第12次打开应用不显示升级提示
    Given 这是第12次打开应用
    And 用户是Free用户
    When 应用初始化完成
    Then 不应该显示Pro升级对话框

  Scenario: 第13次打开应用显示升级提示
    Given 这是第13次打开应用
    And 用户是Free用户
    When 应用初始化完成
    Then 应该显示Pro升级对话框

  Scenario: 第16次打开应用显示升级提示
    Given 这是第16次打开应用
    And 用户是Free用户
    When 应用初始化完成
    Then 应该显示Pro升级对话框

  Scenario: 第19次打开应用显示升级提示
    Given 这是第19次打开应用
    And 用户是Free用户
    When 应用初始化完成
    Then 应该显示Pro升级对话框

  Scenario: Pro用户不会看到升级提示
    Given 这是第10次打开应用
    And 用户是Pro用户
    When 应用初始化完成
    Then 不应该显示Pro升级对话框

  Scenario: 应用打开计数器在每次启动时递增
    Given 应用打开计数器当前值为5
    When 应用启动时
    Then 应用打开计数器应该变为6

  Scenario: 检查是否应该显示升级提示
    Given 应用打开计数器为10
    And 用户是Free用户
    When 检查是否应该显示提示
    Then 应该返回true

  Scenario: 检查不应该显示升级提示的情况
    Given 应用打开计数器为11
    And 用户是Free用户
    When 检查是否应该显示提示
    Then 应该返回false

  Scenario: Pro用户检查是否应该显示提示始终返回false
    Given 应用打开计数器为10
    And 用户是Pro用户
    When 检查是否应该显示提示
    Then 应该返回false

  Scenario: 用户关闭升级对话框后计数器继续增加
    Given 这是第10次打开应用
    And 用户是Free用户
    When 应用初始化完成
    And 用户关闭了升级对话框
    Then 下一次打开应用时计数器应该为11
