/**
 * Mock 数据模块
 * 在后端接口就绪前，使用 mock 数据进行前端开发和调试
 *
 * 使用方式：在 api.js 中引入，当后端不可用时切换到 mock
 * 或通过 app.globalData.useMock = true 控制
 */

/**
 * 生成唯一 ID
 */
function genId() {
  return 'mock_' + Date.now().toString(36) + '_' + Math.random().toString(36).slice(2, 8);
}

/**
 * Mock 口令数据
 */
const mockCodes = [
  {
    id: 'mock_001',
    code_text: '￥P8sK2m9x￥复制这段口令打开拼多多',
    status: 'active',
    copy_count: 3,
    created_at: new Date(Date.now() - 5 * 60000).toISOString(),
  },
  {
    id: 'mock_002',
    code_text: '￥X7tL3n4w￥差2人成团，速来！复制后打开拼多多',
    status: 'active',
    copy_count: 1,
    created_at: new Date(Date.now() - 30 * 60000).toISOString(),
  },
  {
    id: 'mock_003',
    code_text: '￥Q9rM5j6k￥福袋助力，互帮互助',
    status: 'active',
    copy_count: 5,
    created_at: new Date(Date.now() - 120 * 60000).toISOString(),
  },
  {
    id: 'mock_004',
    code_text: '￥A2bN8c1d￥复制打开拼多多，领现金红包',
    status: 'active',
    copy_count: 0,
    created_at: new Date(Date.now() - 180 * 60000).toISOString(),
  },
];

/**
 * Mock 我的发布记录
 */
const mockPublishedCodes = [
  {
    id: 'mock_pub_001',
    code_text: '￥MyLuckyBag001￥福袋口令，复制打开拼多多',
    status: 'copied',
    copy_count: 1,
    created_at: new Date(Date.now() - 3600000).toISOString(),
  },
  {
    id: 'mock_pub_002',
    code_text: '￥MyLuckyBag002￥差3人成团，互帮互助一起领',
    status: 'active',
    copy_count: 2,
    created_at: new Date(Date.now() - 7200000).toISOString(),
  },
  {
    id: 'mock_pub_003',
    code_text: '￥MyLuckyBag003￥福袋助力，谢谢大家',
    status: 'expired',
    copy_count: 0,
    created_at: new Date(Date.now() - 86400000).toISOString(),
  },
];

/**
 * 模拟网络延迟
 */
function delay(ms = 300) {
  return new Promise(resolve => setTimeout(resolve, ms + Math.random() * 200));
}

/**
 * 分页截取
 */
function paginate(list, page, pageSize) {
  const start = (page - 1) * pageSize;
  return {
    data: list.slice(start, start + pageSize),
    total: list.length,
    page,
    page_size: pageSize,
  };
}

const mockApi = {
  async getCodes({ page = 1, pageSize = 20 } = {}) {
    await delay();
    const active = mockCodes.filter(c => c.status === 'active');
    return paginate(active, page, pageSize);
  },

  async createCode(codeText) {
    await delay(500);
    const newCode = {
      id: genId(),
      code_text: codeText,
      status: 'active',
      copy_count: 0,
      created_at: new Date().toISOString(),
    };
    mockCodes.unshift(newCode);
    mockPublishedCodes.unshift({ ...newCode });
    return { id: newCode.id, status: newCode.status, created_at: newCode.created_at };
  },

  async copyCode(id) {
    await delay(200);
    const code = mockCodes.find(c => c.id === id);
    if (code) {
      code.status = 'copied';
    }
    return { success: true };
  },

  async getMyCodes({ page = 1, pageSize = 20 } = {}) {
    await delay();
    return paginate(mockPublishedCodes, page, pageSize);
  },

  async deleteCode(id) {
    await delay(300);
    const idx = mockPublishedCodes.findIndex(c => c.id === id);
    if (idx !== -1) {
      mockPublishedCodes.splice(idx, 1);
    }
    const idx2 = mockCodes.findIndex(c => c.id === id);
    if (idx2 !== -1) {
      mockCodes.splice(idx2, 1);
    }
    return { success: true };
  },
};

module.exports = { mockApi };
