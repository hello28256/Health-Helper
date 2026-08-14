import { BrowserRouter } from 'react-router-dom';
import { AppRouter } from './router';

/**
 * App —— 只负责挂 React Query + Router，业务路由都在 router.tsx 里
 */
export function App() {
  return (
    <BrowserRouter>
      <AppRouter />
    </BrowserRouter>
  );
}
