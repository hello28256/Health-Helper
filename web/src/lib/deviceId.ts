/**
 * deviceId —— 浏览器持久化
 *
 * 同一浏览器复用同一个 deviceId，确保 session 持续。
 * 用户清掉 localStorage 后会重新生成。
 */
const KEY = 'hh.deviceId';

export function getDeviceId(): string {
  let id = localStorage.getItem(KEY);
  if (!id) {
    id = crypto.randomUUID();
    localStorage.setItem(KEY, id);
  }
  return id;
}

/** 单测 / 切换设备时手动设置 */
export function setDeviceId(id: string): void {
  localStorage.setItem(KEY, id);
}

export function clearDeviceId(): void {
  localStorage.removeItem(KEY);
}
