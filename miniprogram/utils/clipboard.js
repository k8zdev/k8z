/**
 * 剪贴板工具
 * 封装微信小程序剪贴板相关 API
 */

/**
 * 复制文本到系统剪贴板
 * @param {string} text - 要复制的文本
 * @returns {Promise<boolean>}
 */
function copyToClipboard(text) {
  return new Promise((resolve) => {
    wx.setClipboardData({
      data: text,
      success() {
        resolve(true);
      },
      fail() {
        wx.showToast({ title: '复制失败，请重试', icon: 'none' });
        resolve(false);
      },
    });
  });
}

module.exports = {
  copyToClipboard,
};
