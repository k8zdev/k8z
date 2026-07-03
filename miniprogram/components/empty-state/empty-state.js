Component({
  properties: {
    // 图标（emoji 或图片路径）
    icon: {
      type: String,
      value: '📋',
    },
    // 主文案
    text: {
      type: String,
      value: '暂无内容',
    },
    // 辅助文案
    subtext: {
      type: String,
      value: '',
    },
    // 操作按钮文案（为空则不显示按钮）
    actionText: {
      type: String,
      value: '',
    },
  },

  methods: {
    onAction() {
      this.triggerEvent('action');
    },
  },
});
