@logic
Feature: Pro 功能锁定

  Background:
    Given 应用已初始化RevenueCat SDK

  Scenario: 未订阅用户被视为Free用户
    Given 用户没有任何有效的订阅
    Then 用户的状态应该是 "Free"

  Scenario: 有有效月度订阅的用户是Pro用户
    Given 用户有有效的月度订阅
    Then 用户的状态应该是 "Pro"

  Scenario: 有有效年度订阅的用户是Pro用户
    Given 用户有有效的年度订阅
    Then 用户的状态应该是 "Pro"

  Scenario: 有终身订阅的用户是Pro用户
    Given 用户有终身订阅
    Then 用户的状态应该是 "Pro"

  Scenario: 订阅已过期的用户被视为Free用户
    Given 用户有已过期的订阅
    Then 用户的状态应该是 "Free"

  Scenario: RevenueCat信息为null时是Free用户
    Given RevenueCat客户信息不可用
    Then 用户的状态应该是 "Free"
