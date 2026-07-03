/**
 * 微信登录 & 用户信息工具
 * 一期简化：匿名发布，无需强制登录
 * 预留登录能力，后续可按需启用
 */

/**
 * 微信登录，获取临时 code
 * @returns {Promise<string|null>}
 */
function wxLogin() {
  return new Promise((resolve) => {
    wx.login({
      success(res) {
        if (res.code) {
          resolve(res.code);
        } else {
          resolve(null);
        }
      },
      fail() {
        resolve(null);
      },
    });
  });
}

/**
 * 获取用户信息（需用户主动点击触发）
 * @returns {Promise<object|null>}
 */
function getUserProfile() {
  return new Promise((resolve) => {
    wx.getUserProfile({
      desc: '用于展示发布者昵称',
      success(res) {
        resolve(res.userInfo);
      },
      fail() {
        resolve(null);
      },
    });
  });
}

module.exports = {
  wxLogin,
  getUserProfile,
};
