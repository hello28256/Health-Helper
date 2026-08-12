import { Router, Request, Response } from 'express';
import { openapiSpec } from '../docs/openapi';

/**
 * /api/docs —— 暴露 OpenAPI 3.0 spec（JSON）+ Swagger UI
 *
 * Swagger UI 通过 CDN 加载，无需引入 npm 包。生产环境也可挂自己的 CDN。
 */
export function buildDocsRouter(): Router {
  const router = Router();

  // JSON 格式的 OpenAPI spec —— 给 Postman / Redoc / 自定义前端用
  router.get('/openapi.json', (_req: Request, res: Response) => {
    res.json(openapiSpec);
  });

  // Swagger UI 页面（CDN 加载，无需 npm 依赖）
  router.get('/', (_req: Request, res: Response) => {
    res.set('Content-Type', 'text/html').send(SWAGGER_HTML);
  });

  return router;
}

const SWAGGER_HTML = `<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8" />
  <title>Health Helper API · Swagger UI</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swagger-ui-dist@5/swagger-ui.css" />
  <style>
    body { margin: 0; }
    .swagger-ui .info { margin: 30px 0; }
    .swagger-ui .info .title { font-size: 2em; }
  </style>
</head>
<body>
  <div id="swagger-ui"></div>
  <script src="https://cdn.jsdelivr.net/npm/swagger-ui-dist@5/swagger-ui-bundle.js"></script>
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
