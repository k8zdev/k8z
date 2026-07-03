const { copyToClipboard } = require('../../utils/clipboard');
const { copyCode: apiCopyCode } = require('../../utils/api');

Component({
  properties: {
    // 口令数据
    code: {
      type: Object,
      value: {},
    },
    // 是否显示删除按钮（仅在"我的记录"中使用）
    showDelete: {
      type: Boolean,
      value: false,
    },
  },

  observers: {
    'code'(val) {
      if (!val) return;
      // 预计算展示数据
      this.setData({
        _id: val.id || '',
        _codeText: val.code_text || '',
        _status: val.status || 'active',
        _createdAt: val.created_at || '',
        _copyCount: val.copy_count || 0,
        _maskedText: this._maskCode(val.code_text || ''),
        _formattedTime: this._formatTime(val.created_at || ''),
      });
    },
  },

  data: {
    _id: '',
    _codeText: '',
    _status: 'active',
    _createdAt: '',
    _copyCount: 0,
    _maskedText: '',
    _formattedTime: '',
  },

  methods: {
    /**
     * 脱敏展示口令内容（仅显示前 8 位）
     */
    _maskCode(text) {
      if (!text) return '';
      if (text.length <= 8) return text;
      return text.slice(0, 8) + '···';
    },

    /**
     * 格式化时间
     */
    _formatTime(timeStr) {
      if (!timeStr) return '';
      const d = new Date(timeStr);
      const now = new Date();
      const diff = now - d;

      if (diff < 60000) return '刚刚';
      if (diff < 3600000) return `${Math.floor(diff / 60000)} 分钟前`;
      if (diff < 86400000) return `${Math.floor(diff / 3600000)} 小时前`;

      const month = String(d.getMonth() + 1).padStart(2, '0');
      const day = String(d.getDate()).padStart(2, '0');
      const hours = String(d.getHours()).padStart(2, '0');
      const minutes = String(d.getMinutes()).padStart(2, '0');
      return `${month}-${day} ${hours}:${minutes}`;
    },

    /**
     * 复制口令
     */
    async onCopyCode() {
      const { _codeText, _id } = this.data;

      if (!_codeText) {
        wx.showToast({ title: '口令内容为空', icon: 'none' });
        return;
      }

      // 1. 复制到剪贴板
      const copied = await copyToClipboard(_codeText);
      if (!copied) return;

      // 2. 调后端标记已复制
      try {
        await apiCopyCode(_id);

        // 3. 更新本地状态
        this.setData({ _status: 'copied' });

        // 4. 通知父组件
        this.triggerEvent('copied', { id: _id });

        wx.showToast({ title: '已复制，去拼多多组队吧', icon: 'success', duration: 2000 });
      } catch (err) {
        // 复制标记失败不影响主流程（剪贴板已复制成功）
        console.error('标记复制失败:', err);

        // 仍然更新本地状态以提供即时反馈
        this.setData({ _status: 'copied' });
        this.triggerEvent('copied', { id: _id });

        wx.showToast({ title: '已复制，去拼多多组队吧', icon: 'success', duration: 2000 });
      }
    },

    /**
     * 删除口令
     */
    onDeleteCode() {
      wx.showModal({
        title: '确认删除',
        content: '删除后无法恢复，确定要删除这条口令吗？',
        success: (res) => {
          if (res.confirm) {
            this.triggerEvent('delete', { id: this.data._id });
          }
        }
      });
    },
  },
});
