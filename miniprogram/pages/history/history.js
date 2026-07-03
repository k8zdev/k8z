const api = require('../../utils/api');

Page({
  data: {
    activeTab: 'published',
    publishedCodes: [],
    copiedCodes: [],
    page: 1,
    pageSize: 20,
    hasMore: true,
    refreshing: false,
    loadingMore: false,
    initialLoading: true,
  },

  onLoad() {
    this.loadData();
  },

  /**
   * 切换 Tab
   */
  onTabSwitch(e) {
    const tab = e.currentTarget.dataset.tab;
    if (tab === this.data.activeTab) return;
    this.setData({
      activeTab: tab,
      page: 1,
      hasMore: true,
    });
    this.loadData();
  },

  /**
   * 加载数据
   */
  async loadData(reset = false) {
    if (reset) {
      this.setData({ page: 1, hasMore: true });
    }

    if (this.data.loadingMore || (!reset && !this.data.hasMore)) return;

    const page = reset ? 1 : this.data.page;

    if (page === 1 && !this.data.refreshing) {
      this.setData({ initialLoading: true });
    }

    try {
      const res = await api.getMyCodes({ page, pageSize: this.data.pageSize });
      const { data = [], total = 0 } = res;

      // 按状态分拆数据（后端可能混合返回或分开返回，这里做兼容处理）
      const published = (data || []).filter(item =>
        item.role === 'publisher' || item.type === 'published' || !item.role
      );
      const copied = (data || []).filter(item =>
        item.role === 'copier' || item.type === 'copied'
      );

      const key = this.data.activeTab === 'published' ? 'publishedCodes' : 'copiedCodes';
      const currentList = this.data[key];

      this.setData({
        [key]: reset ? published : [...currentList, ...published],
        copiedCodes: reset ? copied : [...this.data.copiedCodes, ...copied],
        page,
        hasMore: data.length >= this.data.pageSize,
        initialLoading: false,
      });
    } catch (err) {
      console.error('加载记录失败:', err);
      this.setData({ initialLoading: false });
    }
  },

  /**
   * 下拉刷新
   */
  async onRefresh() {
    this.setData({ refreshing: true });
    await this.loadData(true);
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
      this.loadData();
      this.setData({ loadingMore: false });
    });
  },

  /**
   * 删除口令
   */
  async onCodeDelete(e) {
    const { id } = e.detail;

    try {
      await api.deleteCode(id);

      const publishedCodes = this.data.publishedCodes.filter(c => c.id !== id);
      this.setData({ publishedCodes });

      wx.showToast({ title: '已删除', icon: 'success' });
    } catch (err) {
      console.error('删除失败:', err);
      wx.showToast({ title: '删除失败，请重试', icon: 'none' });
    }
  },

  /**
   * 口令被复制后更新状态
   */
  onCodeCopied(e) {
    const { id } = e.detail;
    const publishedCodes = this.data.publishedCodes.map(c => {
      if (c.id === id) {
        return { ...c, status: 'copied' };
      }
      return c;
    });
    this.setData({ publishedCodes });
  },
});
