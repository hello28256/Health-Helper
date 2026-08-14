// Vitest 全局 setup —— 每个 test 文件前加载
import '@testing-library/jest-dom/vitest';
import { afterEach, vi } from 'vitest';
import { cleanup } from '@testing-library/react';

// 每个测试后清理 DOM
afterEach(() => {
  cleanup();
  localStorage.clear();
  sessionStorage.clear();
  // 注意：不要 vi.restoreAllMocks() —— 会把 vi.hoisted 创建的 mock 实现也重置掉
  vi.clearAllMocks();
});

// 浏览器 API polyfills
if (typeof globalThis.crypto === 'undefined' || !globalThis.crypto.randomUUID) {
  // jsdom 没完整 randomUUID，给个简单 polyfill
  let counter = 0;
  Object.defineProperty(globalThis, 'crypto', {
    value: {
      randomUUID: () => `uuid-${++counter}-${Date.now()}`,
    },
  });
}
