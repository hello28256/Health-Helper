import path from 'path';
import express, { Router, Request, Response } from 'express';
import { openapiSpec } from '../docs/openapi';

/**
 * /api/docs —— 暴露 OpenAPI 3.0 spec（JSON）+ Swagger UI
 *
 * Swagger UI 资源从本地 node_modules/swagger-ui-dist 提供（生产构建后从 dist
 * 同目录），不依赖任何外网 CDN。
 */
export function buildDocsRouter(): Router {
  const router = Router();

  // Swagger UI 内部用 eval / Function() 动态生成脚本，受 app-level helmet CSP
  // (script-src 'self') 拦截会白屏。在 docs 子路由上清掉 CSP / X-Content-Type-Options
  // 让 swagger-ui-bundle.js 能跑起来。
  router.use((_req, res, next) => {
    res.removeHeader('Content-Security-Policy');
    res.removeHeader('X-Content-Type-Options');
    next();
  });

  // JSON 格式的 OpenAPI spec —— 给 Postman / Redoc / 自定义前端用
  router.get('/openapi.json', (_req: Request, res: Response) => {
    res.json(openapiSpec);
  });

  // Swagger UI 页面（资源走本地 node_modules）
  // 不缓存 HTML（开发期改了页面要能看到）
  router.get('/', (_req: Request, res: Response) => {
    res.set('Content-Type', 'text/html');
    res.set('Cache-Control', 'no-store, no-cache, must-revalidate');
    res.send(SWAGGER_HTML);
  });

  // 静态资源（CSS + JS）—— 不缓存，避免浏览器拿到旧版 bundle
  const distPath = path.dirname(require.resolve('swagger-ui-dist/package.json'));
  router.use(
    '/static',
    express.static(distPath, {
      setHeaders: (res) => {
        res.setHeader('Cache-Control', 'no-store');
      },
    }),
  );

  return router;
}

const SWAGGER_HTML = `<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Health Helper API · Swagger UI</title>
  <link rel="stylesheet" href="/api/docs/static/swagger-ui.css" />
  <link rel="icon" type="image/png" href="/api/docs/static/favicon-32x32.png" sizes="32x32" />
  <style>
    body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, sans-serif; }
    .swagger-ui .info { margin: 30px 0; }
    .swagger-ui .info .title { font-size: 2em; }
    /* 加载占位 —— Swagger 渲染前先看到这条 */
    #swagger-ui.loading {
      padding: 60px 20px;
      text-align: center;
      color: #777;
    }
    #swagger-ui.loading::before {
      content: '';
      display: inline-block;
      width: 14px;
      height: 14px;
      margin-right: 10px;
      border: 2px solid #3b4151;
      border-top-color: transparent;
      border-radius: 50%;
      animation: spin 0.8s linear infinite;
      vertical-align: middle;
    }
    @keyframes spin { to { transform: rotate(360deg); } }
  </style>
</head>
<body>
  <div id="swagger-ui" class="loading">Loading API documentation…</div>
  <script src="/api/docs/static/swagger-ui-bundle.js"></script>
  <script>
    (function() {
      function init() {
        if (typeof window.SwaggerUIBundle !== 'function') {
          document.getElementById('swagger-ui').textContent =
            'Swagger UI bundle failed to load (window.SwaggerUIBundle is ' +
            typeof window.SwaggerUIBundle + '). Check browser console.';
          return;
        }
        window.ui = SwaggerUIBundle({
          url: '/api/docs/openapi.json',
          dom_id: '#swagger-ui',
          deepLinking: true,
          presets: [SwaggerUIBundle.presets.apis],
          layout: 'BaseLayout',
        });
        document.getElementById('swagger-ui').classList.remove('loading');
      }
      if (document.readyState === 'complete') {
        init();
      } else {
        window.addEventListener('load', init);
      }
    })();
  </script>
</body>
</html>`;