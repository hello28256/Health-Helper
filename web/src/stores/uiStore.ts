/**
 * UI 全局状态 —— 抽屉 / 模态框 / toast 等
 */
import { create } from 'zustand';

type Toast = { id: string; kind: 'success' | 'error' | 'info'; message: string };

type UiState = {
  chatDrawerOpen: boolean;
  toasts: Toast[];
  openChatDrawer: () => void;
  closeChatDrawer: () => void;
  toggleChatDrawer: () => void;
  pushToast: (kind: Toast['kind'], message: string) => void;
  dismissToast: (id: string) => void;
};

export const useUiStore = create<UiState>((set, get) => ({
  chatDrawerOpen: false,
  toasts: [],
  openChatDrawer: () => set({ chatDrawerOpen: true }),
  closeChatDrawer: () => set({ chatDrawerOpen: false }),
  toggleChatDrawer: () => set({ chatDrawerOpen: !get().chatDrawerOpen }),
  pushToast: (kind, message) => {
    const id = `t_${Date.now()}_${Math.random().toString(36).slice(2, 6)}`;
    set({ toasts: [...get().toasts, { id, kind, message }] });
    setTimeout(() => {
      set({ toasts: get().toasts.filter((t) => t.id !== id) });
    }, 3500);
  },
  dismissToast: (id) => set({ toasts: get().toasts.filter((t) => t.id !== id) }),
}));
