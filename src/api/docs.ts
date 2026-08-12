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

  // JSON 格式的 OpenAPI spec —— 给 Postman / Redoc / 自定义前端用
  router.get('/openapi.json', (_req: Request, res: Response) => {
    res.json(openapiSpec);
  });

  // Swagger UI 页面（资源走本地 node_modules）
  router.get('/', (_req: Request, res: Response) => {
    res.set('Content-Type', 'text/html').send(SWAGGER_HTML);
  });

  // 静态资源（CSS + JS）—— 用绝对路径避免 cwd 影响
  const distPath = path.dirname(require.resolve('swagger-ui-dist/package.json'));
  router.use('/static', express.static(distPath));

  return router;
}

const SWAGGER_HTML = `<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8" />
  <title>Health Helper API · Swagger UI</title>
  <link rel="stylesheet" href="/api/docs/static/swagger-ui.css" />
  <link rel="icon" type="image/png" href="/api/docs/static/favicon-32x32.png" sizes="32x32" />
  <style>
    body { margin: 0; }
    .swagger-ui .info { margin: 30px 0; }
    .swagger-ui .info .title { font-size: 2em; }
  </style>
</head>
<body>
  <div id="swagger-ui"></div>
  <script src="/api/docs/static/swagger-ui-bundle.js"></script>
  <script>
    window.onload = () => {
      window.ui = SwaggerUIBundle({
        url: '/api/docs/openapi.json',
        dom_id: '#swagger-ui',
        deepLinking: true,
        presets: [SwaggerUIBundle.presets.apis],
        layout: 'BaseLayout',
      });
    };
  </script>
</body>
</html>`;