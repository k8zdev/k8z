App({
  onLaunch() {
    // 获取系统信息
    const systemInfo = wx.getSystemInfoSync();
    this.globalData.systemInfo = systemInfo;
    this.globalData.statusBarHeight = systemInfo.statusBarHeight;
  },

  globalData: {
    systemInfo: null,
    statusBarHeight: 0,
    userInfo: null,
    // API 基础地址，生产环境需替换
    apiBaseUrl: 'https://api.k8z.dev',
    // 后端接口未就绪前使用 mock 数据，联调时改为 false
    useMock: true,
  },
});
