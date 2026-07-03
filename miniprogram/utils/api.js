/**
 * API 请求封装
 * 基于微信小程序 wx.request 的 Promise 封装
 *
 * 当 app.globalData.useMock = true 时使用 mock 数据，
 * 方便在后端接口就绪前独立开发前端页面。
 */

const app = getApp();

// 延迟加载 mock 模块，避免循环依赖
let _mockApi = null;
function getMockApi() {
  if (!_mockApi) {
    _mockApi = require('./mock').mockApi;
  }
  return _mockApi;
}

function useMock() {
  return app && app.globalData && app.globalData.useMock;
}

/**
 * 基础请求方法
 * @param {string} path - API 路径（不含 base URL）
 * @param {object} options - 请求选项
 * @returns {Promise}
 */
function request(path, options = {}) {
  const {
    method = 'GET',
    data = {},
    header = {},
    showLoading = false,
  } = options;

  if (showLoading) {
    wx.showLoading({ title: '加载中...', mask: true });
  }

  return new Promise((resolve, reject) => {
    wx.request({
      url: `${app.globalData.apiBaseUrl}${path}`,
      method,
      data,
      header: {
        'Content-Type': 'application/json',
        ...header,
      },
      success(res) {
        if (res.statusCode >= 200 && res.statusCode < 300) {
          resolve(res.data);
        } else {
          const err = new Error(res.data?.message || `请求失败 (${res.statusCode})`);
          err.statusCode = res.statusCode;
          err.data = res.data;
          reject(err);
        }
      },
      fail(err) {
        wx.showToast({ title: '网络异常，请重试', icon: 'none' });
        reject(err);
      },
      complete() {
        if (showLoading) {
          wx.hideLoading();
        }
      },
    });
  });
}

// ---- 口令相关 API ----

/**
 * 获取可用口令列表
 * @param {object} params - { page, pageSize }
 */
function getCodes({ page = 1, pageSize = 20 } = {}) {
  if (useMock()) return getMockApi().getCodes({ page, pageSize });
  return request('/api/v1/codes', {
    method: 'GET',
    data: { page, page_size: pageSize },
  });
}

/**
 * 发布新口令
 * @param {string} codeText - 口令文本
 */
function createCode(codeText) {
  if (useMock()) return getMockApi().createCode(codeText);
  return request('/api/v1/codes', {
    method: 'POST',
    data: { code_text: codeText },
    showLoading: true,
  });
}

/**
 * 标记口令已被复制
 * @param {string} id - 口令 ID
 */
function copyCode(id) {
  if (useMock()) return getMockApi().copyCode(id);
  return request(`/api/v1/codes/${id}/copy`, {
    method: 'POST',
  });
}

/**
 * 获取我的口令记录
 * @param {object} params - { page, pageSize }
 */
function getMyCodes({ page = 1, pageSize = 20 } = {}) {
  if (useMock()) return getMockApi().getMyCodes({ page, pageSize });
  return request('/api/v1/codes/mine', {
    method: 'GET',
    data: { page, page_size: pageSize },
  });
}

/**
 * 删除我发布的口令
 * @param {string} id - 口令 ID
 */
function deleteCode(id) {
  if (useMock()) return getMockApi().deleteCode(id);
  return request(`/api/v1/codes/${id}`, {
    method: 'DELETE',
    showLoading: true,
  });
}

module.exports = {
  getCodes,
  createCode,
  copyCode,
  getMyCodes,
  deleteCode,
};
