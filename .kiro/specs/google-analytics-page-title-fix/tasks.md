# Google Analytics 页面标题修复实现计划

- [x] 1. 创建核心服务类和工具函数
  - 实现 `PageTitleManager` 类，负责页面标题的生成和格式化
  - 实现 `ContextInfoProvider` 类，提供当前集群、命名空间等上下文信息
  - 创建页面标题格式化的工具函数，支持多种标题格式
  - _需求: 1.1, 1.2, 1.3_

- [x] 1.1 实现 PageTitleManager 核心功能
  - 创建 `lib/services/page_title_manager.dart` 文件
  - 实现 `generatePageTitle` 方法，根据页面类型和上下文生成标题
  - 实现 `generateAnalyticsParameters` 方法，构建 Analytics 事件参数
  - 添加页面标题格式化的单元测试
  - _需求: 1.1, 3.1, 3.2, 3.3_

- [x] 1.2 实现 ContextInfoProvider 上下文信息提取
  - 创建 `lib/services/context_info_provider.dart` 文件
  - 实现 `getCurrentContext` 方法，提取当前页面的上下文信息
  - 实现 `getCurrentClusterName` 和 `getCurrentNamespace` 方法
  - 实现 `getCurrentLanguage` 方法，获取当前语言设置
  - _需求: 2.1, 2.2, 3.1, 3.2_

- [x] 2. 增强 Analytics 服务
  - 创建新的 `AnalyticsService` 类替代现有的 helper 函数
  - 实现 `logPageView` 方法，包含完整的页面标题和上下文信息
  - 实现错误处理和重试机制
  - 添加离线缓存功能
  - _需求: 4.1, 4.2, 4.3, 4.4_

- [x] 2.1 创建增强的 AnalyticsService 类
  - 创建 `lib/services/analytics_service.dart` 文件
  - 实现 `logPageView` 方法，整合页面标题和上下文信息
  - 实现 `logScreenTransition` 方法，记录页面导航事件
  - 添加事件参数验证和格式化功能
  - _需求: 4.1, 4.2, 4.3_

- [x] 2.2 实现错误处理和重试机制
  - 在 AnalyticsService 中添加重试逻辑，最多重试 3 次
  - 实现错误日志记录，使用 talker 记录失败事件
  - 添加网络状态检查，避免在无网络时重复尝试
  - 实现事件队列机制，支持批量上报
  - _需求: 4.4_

- [ ] 3. 创建路由观察器
  - 实现 `AnalyticsRouteObserver` 类，监听路由变化
  - 在路由变化时自动触发页面标题更新和 Analytics 事件
  - 集成到现有的 GoRouter 配置中
  - 确保与现有的 TalkerRouteObserver 兼容
  - _需求: 4.3, 5.1, 5.2_

- [ ] 3.1 实现 AnalyticsRouteObserver 路由监听
  - 创建 `lib/services/analytics_route_observer.dart` 文件
  - 实现 `didPush`、`didPop`、`didReplace` 方法
  - 在路由变化时提取页面信息并调用 AnalyticsService
  - 添加路由变化的防抖机制，避免频繁触发事件
  - _需求: 4.3, 5.2_

- [ ] 3.2 集成路由观察器到 GoRouter 配置
  - 修改 `lib/router.dart` 文件，添加 AnalyticsRouteObserver
  - 确保与现有 TalkerRouteObserver 的兼容性
  - 测试路由观察器在不同导航场景下的工作情况
  - 验证页面标题在路由变化时的正确更新
  - _需求: 5.1, 5.2_

- [ ] 4. 更新现有页面的 Analytics 调用
  - 替换所有现有的 `logScreenView` 调用为新的 `AnalyticsService.logPageView`
  - 为每个页面添加适当的上下文信息
  - 确保页面标题与 AppBar 显示的标题保持一致
  - 处理特殊页面（如详情页、设置页）的标题格式
  - _需求: 5.1, 5.3, 5.4_

- [ ] 4.1 更新主要页面的 Analytics 调用
  - 更新 `lib/router.dart` 中所有路由的 logScreenView 调用
  - 为集群页面、工作负载页面、资源页面添加上下文信息
  - 确保页面标题包含当前集群名称（如果适用）
  - 测试更新后的 Analytics 事件是否包含正确的页面标题
  - _需求: 5.1, 5.3_

- [ ] 4.2 处理详情页面和特殊页面
  - 更新资源详情页面的标题格式，包含资源类型和名称
  - 更新设置页面和子页面的标题格式
  - 处理错误页面和 NotFound 页面的标题
  - 确保所有页面都有合理的默认标题
  - _需求: 3.3, 3.4, 5.4_

- [ ] 5. 实现多语言标题支持
  - 修改页面标题生成逻辑，使用国际化文本
  - 确保 Analytics 事件包含当前语言信息
  - 处理语言切换时的标题更新
  - 添加默认语言回退机制
  - _需求: 2.1, 2.2, 2.3_

- [ ] 5.1 集成国际化文本到页面标题
  - 修改 PageTitleManager 使用 `S.of(context)` 获取本地化文本
  - 为每个页面类型定义标准的标题格式
  - 实现语言回退机制，当翻译缺失时使用英文
  - 在 Analytics 参数中包含当前语言标识符
  - _需求: 2.1, 2.2, 2.3_

- [ ] 5.2 处理动态标题更新
  - 实现语言切换时的标题自动更新
  - 处理集群切换时的标题上下文更新
  - 确保标题更新时触发新的 Analytics 事件
  - 添加标题变化的防抖机制
  - _需求: 1.2, 5.2_

- [ ] 6. 向后兼容性和迁移
  - 保持现有 `logScreenView` 函数的接口兼容性
  - 创建迁移指南和文档
  - 添加弃用警告但不破坏现有功能
  - 提供渐进式迁移路径
  - _需求: 所有需求的向后兼容性_

- [ ] 6.1 实现向后兼容的 helper 函数
  - 修改 `lib/common/helpers.dart` 中的 `logScreenView` 函数
  - 使其内部调用新的 AnalyticsService，但保持接口不变
  - 添加弃用注释，引导开发者使用新的 API
  - 确保现有代码无需修改即可获得改进的功能
  - _需求: 向后兼容性_

- [ ] 6.2 创建迁移文档和测试
  - 编写迁移指南，说明如何从旧 API 迁移到新 API
  - 创建示例代码展示新 API 的使用方法
  - 添加集成测试验证新旧 API 的兼容性
  - 测试在不同场景下的页面标题显示效果
  - _需求: 所有需求的验证_

- [ ] 7. 测试和验证
  - 编写单元测试覆盖所有新增的服务类
  - 创建集成测试验证 Analytics 事件的正确性
  - 进行端到端测试确保页面标题在 Google Analytics 中正确显示
  - 测试多语言和上下文切换场景
  - _需求: 所有需求的测试验证_

- [ ] 7.1 编写核心服务的单元测试
  - 为 PageTitleManager 创建单元测试，测试各种标题格式
  - 为 ContextInfoProvider 创建测试，验证上下文信息提取
  - 为 AnalyticsService 创建测试，验证事件参数构建
  - 测试错误处理和边界情况
  - _需求: 所有需求的单元测试_

- [ ] 7.2 创建集成测试和端到端验证
  - 创建集成测试验证路由变化时的 Analytics 事件
  - 测试多语言切换时的标题更新
  - 验证集群和命名空间切换时的上下文更新
  - 进行真实设备上的端到端测试，确认 Google Analytics 数据正确性
  - _需求: 所有需求的集成验证_