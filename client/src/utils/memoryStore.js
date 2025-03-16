class MemoryStore {
  constructor() {
    this.stores = new Map();
    this.subscriptions = new Map();
    this.loadPersistedData();
  }

  // 初始化加载持久化数据
  loadPersistedData() {
    ['department_id_cache', 'department_users_cache'].forEach(key => {
      const value = localStorage.getItem(key);
      if (value) this.set(key, JSON.parse(value));
    });
  }

  // 获取或创建命名空间
  getNamespace(namespace) {
    if (!this.stores.has(namespace)) {
      this.stores.set(namespace, new Map());
    }
    return this.stores.get(namespace);
  }

  // 数据订阅
  subscribe(key, callback) {
    if (!this.subscriptions.has(key)) {
      this.subscriptions.set(key, new Set());
    }
    this.subscriptions.get(key).add(callback);
    return () => this.unsubscribe(key, callback);
  }

  // 取消订阅
  unsubscribe(key, callback) {
    if (this.subscriptions.has(key)) {
      this.subscriptions.get(key).delete(callback);
    }
  }

  // 带持久化的设置方法
  set(key, value, options = { persist: false }) {
    const [namespace, itemKey] = key.includes(':') ? key.split(':') : ['global', key];
    const store = this.getNamespace(namespace);
    store.set(itemKey, value);

    // 触发订阅回调
    if (this.subscriptions.has(key)) {
      this.subscriptions.get(key).forEach(cb => cb(value));
    }

    // 自动持久化
    if (options.persist) {
      localStorage.setItem(key, JSON.stringify(value));
    }
  }

  get(key) {
    const [namespace, itemKey] = key.includes(':') ? key.split(':') : ['global', key];
    const store = this.getNamespace(namespace);
    return store.get(itemKey);
  }

  has(key) {
    const [namespace, itemKey] = key.includes(':') ? key.split(':') : ['global', key];
    const store = this.getNamespace(namespace);
    return store.has(itemKey);
  }

  delete(key) {
    const [namespace, itemKey] = key.includes(':') ? key.split(':') : ['global', key];
    const store = this.getNamespace(namespace);
    store.delete(itemKey);
    localStorage.removeItem(key);
  }
}

// 单例模式导出
export default new MemoryStore();