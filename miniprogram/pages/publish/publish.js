const api = require('../../utils/api');

Page({
  data: {
    codeText: '',
    submitting: false,
  },

  onCodeInput(e) {
    this.setData({ codeText: e.detail.value });
  },

  async onSubmit() {
    const codeText = this.data.codeText.trim();

    if (!codeText) {
      wx.showToast({ title: '请输入福袋口令', icon: 'none' });
      return;
    }

    if (codeText.length < 2) {
      wx.showToast({ title: '口令内容太短，请检查', icon: 'none' });
      return;
    }

    this.setData({ submitting: true });

    try {
      await api.createCode(codeText);

      wx.showToast({ title: '发布成功', icon: 'success' });

      // 延迟返回列表页，让用户看到成功提示
      setTimeout(() => {
        wx.navigateBack();
      }, 1000);
    } catch (err) {
      console.error('发布口令失败:', err);
      wx.showToast({
        title: err.data?.message || '发布失败，请重试',
        icon: 'none',
        duration: 2500,
      });
    } finally {
      this.setData({ submitting: false });
    }
  },
});
