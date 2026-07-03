const api = require('../../utils/api');

Page({
  data: {
    codes: [],
    page: 1,
    pageSize: 20,
    total: 0,
    hasMore: true,
    refreshing: false,
    loadingMore: false,
    initialLoading: true,
  },

  onLoad() {
    this.loadCodes();
  },

  onShow() {
    // 从发布页返回时刷新列表（非首次加载）
    if (!this.data.initialLoading) {
      this.onRefresh();
    }
  },

  /**
   * 加载口令列表
   */
  async loadCodes(reset = false) {
    if (reset) {
      this.setData({ page: 1, hasMore: true });
    }

    if (this.data.loadingMore || (!reset && !this.data.hasMore)) return;

    const page = reset ? 1 : this.data.page;

    if (page === 1 && !this.data.refreshing) {
      this.setData({ initialLoading: true });
    }

    try {
      const res = await api.getCodes({ page, pageSize: this.data.pageSize });
      const { data = [], total = 0 } = res;

      this.setData({
        codes: reset ? data : [...this.data.codes, ...data],
        total,
        page,
        hasMore: data.length >= this.data.pageSize,
        initialLoading: false,
      });
    } catch (err) {
      console.error('加载口令列表失败:', err);
      this.setData({ initialLoading: false });

      if (this.data.codes.length === 0) {
        wx.showToast({ title: '加载失败，下拉刷新重试', icon: 'none' });
      }
    }
  },

  /**
   * 下拉刷新
   */
  async onRefresh() {
    this.setData({ refreshing: true });
    await this.loadCodes(true);
    this.setData({ refreshing: false });
  },

  /**
   * 滚动加载更多
   */
  onLoadMore() {
    if (this.data.loadingMore || !this.data.hasMore) return;
    this.setData({
      loadingMore: true,
      page: this.data.page + 1,
    }, () => {
      this.loadCodes();
      this.setData({ loadingMore: false });
    });
  },

  /**
   * 跳转发布页
   */
  onGoPublish() {
    wx.navigateTo({ url: '/pages/publish/publish' });
  },

  /**
   * 口令被复制后，从列表中移除
   */
  onCodeCopied(e) {
    const { id } = e.detail;
    const codes = this.data.codes.filter(c => c.id !== id);
    const total = Math.max(0, this.data.total - 1);
    this.setData({ codes, total });
  },
});
