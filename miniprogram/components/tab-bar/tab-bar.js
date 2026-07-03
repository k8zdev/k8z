Component({
  properties: {
    tabs: {
      type: Array,
      value: [],
    },
    active: {
      type: String,
      value: '',
    },
  },

  methods: {
    onTabChange(e) {
      const { key } = e.currentTarget.dataset;
      if (key === this.data.active) return;
      this.triggerEvent('change', { key });
    },
  },
});
