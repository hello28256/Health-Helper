/**
 * OpenAPI 3.0 规范 —— Health Helper API
 *
 * 这个文件导出完整 OpenAPI 文档对象（src/docs/openapi-spec.json 是构建产物）。
 * 文档可直接喂给 Swagger UI、Redoc、Postman 等工具。
 *
 * 设计原则：
 * - 单一事实源：所有 endpoint、schema、error code 都在这里集中描述
 * - 与运行代码 1:1 对应：每个 path 都标注对应的源码路径
 */

export const openapiSpec = {
  openapi: '3.0.3',
  info: {
    title: 'Health Helper API',
    version: '0.1.0',
    description:
      'Cross-platform health tracking API — exercise, steps, diet, mood, and AI mental health chat. ' +
      'Single account syncs across iOS, Android, and Web clients.',
    contact: { name: 'Health Helper' },
  },
  servers: [
    { url: 'http://localhost:3000', description: 'Local development' },
    { url: 'https://api.health-helper.example.com', description: 'Production (placeholder)' },
  ],
  tags: [
    { name: 'Auth', description: '注册、登录、token 刷新与登出' },
    { name: 'Users', description: '用户资料（身高/体重/生日）' },
    { name: 'Exercises', description: '运动记录 + 卡路里计算（服务端权威）' },
    { name: 'Steps', description: '每日步数（max-value 策略）' },
    { name: 'Diet', description: '食物库 + 饮食记录 + 营养汇总' },
    { name: 'Mood', description: '心理健康 · 情绪记录与趋势' },
    { name: 'Chat', description: 'AI 心理对话（带医疗免责声明）' },
  ],
  components: {
    securitySchemes: {
      bearerAuth: {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
        description: 'Access token from /api/auth/login or /api/auth/register',
      },
    },
    schemas: {
      // ===== 通用 =====
      Error: {
        type: 'object',
        required: ['error'],
        properties: {
          error: {
            type: 'object',
            required: ['code', 'message'],
            properties: {
              code: { type: 'string', example: 'VALIDATION_ERROR' },
              message: { type: 'string' },
              details: { type: 'object', additionalProperties: true },
            },
          },
        },
      },
      PublicUser: {
        type: 'object',
        properties: {
          id: { type: 'string', format: 'uuid' },
          email: { type: 'string', format: 'email' },
          displayName: { type: 'string', nullable: true },
          heightCm: { type: 'number', nullable: true },
          weightKg: { type: 'number', nullable: true },
          birthDate: { type: 'string', format: 'date-time', nullable: true },
          createdAt: { type: 'string', format: 'date-time' },
        },
      },
      AuthResult: {
        type: 'object',
        properties: {
          user: { $ref: '#/components/schemas/PublicUser' },
          accessToken: { type: 'string' },
          refreshToken: { type: 'string' },
        },
      },
      // ===== 运动 =====
      ExerciseType: {
        type: 'object',
        properties: {
          id: { type: 'string', example: 'running' },
          displayNameZh: { type: 'string', example: '跑步' },
          displayNameEn: { type: 'string', example: 'Running' },
          met: { type: 'number', description: '代谢当量 MET，用于卡路里计算', example: 9.8 },
          notes: { type: 'string', description: '运动安全注意事项' },
        },
      },
      ExerciseRecord: {
        type: 'object',
        properties: {
          id: { type: 'string', format: 'uuid' },
          userId: { type: 'string', format: 'uuid' },
          typeId: { type: 'string' },
          startedAt: { type: 'string', format: 'date-time' },
          durationSec: { type: 'integer', example: 1800 },
          distanceKm: { type: 'number', nullable: true },
          calories: { type: 'number', description: '服务端按 MET × weightKg × duration 计算' },
          createdAt: { type: 'string', format: 'date-time' },
        },
      },
      DailyStep: {
        type: 'object',
        properties: {
          userId: { type: 'string' },
          date: { type: 'string', example: '2026-08-12' },
          steps: { type: 'integer', example: 12000 },
          source: { type: 'string', enum: ['ios_pedometer', 'android_sensor', 'manual'], nullable: true },
          updatedAt: { type: 'string', format: 'date-time' },
        },
      },
      // ===== 饮食 =====
      Food: {
        type: 'object',
        properties: {
          id: { type: 'integer' },
          name: { type: 'string' },
          nameZh: { type: 'string', nullable: true },
          category: { type: 'string', nullable: true },
          servingSizeG: { type: 'number', nullable: true },
          kcalPer100g: { type: 'number', nullable: true },
          proteinG: { type: 'number', nullable: true },
          fatG: { type: 'number', nullable: true },
          carbsG: { type: 'number', nullable: true },
          fiberG: { type: 'number', nullable: true },
          sodiumMg: { type: 'number', nullable: true },
        },
      },
      DietRecord: {
        type: 'object',
        properties: {
          id: { type: 'string', format: 'uuid' },
          userId: { type: 'string' },
          foodId: { type: 'integer' },
          mealType: { type: 'string', enum: ['breakfast', 'lunch', 'dinner', 'snack'] },
          consumedAt: { type: 'string', format: 'date-time' },
          servings: { type: 'number' },
          food: { $ref: '#/components/schemas/Food' },
          consumed: {
            type: 'object',
            description: '服务端按 servings × servingSizeG/100 × per100g 计算',
            properties: {
              kcal: { type: 'number' },
              proteinG: { type: 'number' },
              fatG: { type: 'number' },
              carbsG: { type: 'number' },
              fiberG: { type: 'number' },
              sodiumMg: { type: 'number' },
            },
          },
        },
      },
      DailyNutritionSummary: {
        type: 'object',
        properties: {
          date: { type: 'string', example: '2026-08-12' },
          kcal: { type: 'number' },
          proteinG: { type: 'number' },
          fatG: { type: 'number' },
          carbsG: { type: 'number' },
          fiberG: { type: 'number' },
          sodiumMg: { type: 'number' },
          recordCount: { type: 'integer' },
          byMeal: {
            type: 'object',
            additionalProperties: {
              type: 'object',
              properties: {
                kcal: { type: 'number' },
                recordCount: { type: 'integer' },
              },
            },
          },
        },
      },
      // ===== 情绪 =====
      MoodRecord: {
        type: 'object',
        properties: {
          id: { type: 'string' },
          userId: { type: 'string' },
          mood: {
            type: 'string',
            enum: ['happy', 'calm', 'sad', 'anxious', 'angry', 'tired', 'grateful', 'excited'],
          },
          score: { type: 'integer', minimum: 1, maximum: 10, nullable: true },
          note: { type: 'string', nullable: true },
          recordedAt: { type: 'string', format: 'date-time' },
        },
      },
      MoodTrendPoint: {
        type: 'object',
        properties: {
          date: { type: 'string' },
          avgScore: { type: 'number', nullable: true },
          recordCount: { type: 'integer' },
          dominantMood: { type: 'string' },
        },
      },
      // ===== Chat =====
      ChatMessage: {
        type: 'object',
        properties: {
          id: { type: 'string' },
          userId: { type: 'string' },
          role: { type: 'string', enum: ['user', 'assistant'] },
          content: { type: 'string' },
          createdAt: { type: 'string', format: 'date-time' },
        },
      },
      ChatSendResult: {
        type: 'object',
        properties: {
          userMessage: { $ref: '#/components/schemas/ChatMessage' },
          assistantMessage: { $ref: '#/components/schemas/ChatMessage' },
        },
      },
    },
    responses: {
      Unauthorized: {
        description: 'Missing or invalid access token',
        content: {
          'application/json': {
            schema: { $ref: '#/components/schemas/Error' },
            example: { error: { code: 'UNAUTHORIZED', message: 'Missing Authorization header' } },
          },
        },
      },
      ValidationError: {
        description: 'Request body or query failed Zod validation',
        content: {
          'application/json': {
            schema: { $ref: '#/components/schemas/Error' },
            example: {
              error: {
                code: 'VALIDATION_ERROR',
                message: 'Invalid request body',
                details: { fieldErrors: {}, formErrors: [] },
              },
            },
          },
        },
      },
      NotFound: {
        description: 'Resource does not exist',
        content: {
          'application/json': {
            schema: { $ref: '#/components/schemas/Error' },
          },
        },
      },
    },
  },
  paths: {
    // ===== Auth =====
    '/api/auth/register': {
      post: {
        tags: ['Auth'],
        summary: '注册新账号',
        description: '首次注册，返回 access + refresh token 并在服务端存 refresh token 哈希',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['email', 'password', 'deviceId'],
                properties: {
                  email: { type: 'string', format: 'email' },
                  password: { type: 'string', minLength: 8, maxLength: 128 },
                  deviceId: { type: 'string', minLength: 1, maxLength: 128, description: '用于多端独立 refresh token' },
                  displayName: { type: 'string', maxLength: 64 },
                },
              },
            },
          },
        },
        responses: {
          '201': {
            description: 'Created',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/AuthResult' } } },
          },
          '400': { $ref: '#/components/responses/ValidationError' },
          '409': {
            description: 'Email already registered',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },
    '/api/auth/login': {
      post: {
        tags: ['Auth'],
        summary: '登录',
        description: '同端重复登录会撤销旧 refresh token 并签发新的（rotation）',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['email', 'password', 'deviceId'],
                properties: {
                  email: { type: 'string', format: 'email' },
                  password: { type: 'string' },
                  deviceId: { type: 'string' },
                },
              },
            },
          },
        },
        responses: {
          '200': {
            description: 'OK',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/AuthResult' } } },
          },
          '401': {
            description: 'Invalid credentials (不区分邮箱/密码错误，避免账号枚举)',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },
    '/api/auth/refresh': {
      post: {
        tags: ['Auth'],
        summary: '刷新 access token',
        description: '用 refresh token 换取新 access + refresh（rotation：旧 refresh 立即撤销）',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['refreshToken', 'deviceId'],
                properties: {
                  refreshToken: { type: 'string' },
                  deviceId: { type: 'string' },
                },
              },
            },
          },
        },
        responses: {
          '200': { description: 'OK', content: { 'application/json': { schema: { $ref: '#/components/schemas/AuthResult' } } } },
          '401': { $ref: '#/components/responses/Unauthorized' },
        },
      },
    },
    '/api/auth/logout': {
      post: {
        tags: ['Auth'],
        summary: '登出（撤销当前端 refresh token）',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['refreshToken', 'deviceId'],
                properties: {
                  refreshToken: { type: 'string' },
                  deviceId: { type: 'string' },
                },
              },
            },
          },
        },
        responses: {
          '204': { description: 'No Content（幂等：找不到/已撤销也返回 204）' },
        },
      },
    },
    // ===== Users =====
    '/api/users/me': {
      get: {
        tags: ['Users'],
        summary: '获取当前用户资料',
        security: [{ bearerAuth: [] }],
        responses: {
          '200': {
            description: 'OK',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/PublicUser' } } },
          },
          '401': { $ref: '#/components/responses/Unauthorized' },
        },
      },
      patch: {
        tags: ['Users'],
        summary: '更新用户资料',
        description: '部分更新 —— 体重 weightKg 用于卡路里计算',
        security: [{ bearerAuth: [] }],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                properties: {
                  displayName: { type: 'string', maxLength: 64 },
                  heightCm: { type: 'number', minimum: 50, maximum: 250 },
                  weightKg: { type: 'number', minimum: 20, maximum: 300 },
                  birthDate: { type: 'string', format: 'date-time' },
                },
              },
            },
          },
        },
        responses: {
          '200': { description: 'OK', content: { 'application/json': { schema: { $ref: '#/components/schemas/PublicUser' } } } },
          '400': { $ref: '#/components/responses/ValidationError' },
          '401': { $ref: '#/components/responses/Unauthorized' },
        },
      },
    },
    // ===== Exercises =====
    '/api/exercises/types': {
      get: {
        tags: ['Exercises'],
        summary: '列出所有运动类型（含 MET + 注意事项）',
        security: [{ bearerAuth: [] }],
        responses: {
          '200': {
            description: 'OK',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    types: { type: 'array', items: { $ref: '#/components/schemas/ExerciseType' } },
                  },
                },
              },
            },
          },
        },
      },
    },
    '/api/exercises': {
      get: {
        tags: ['Exercises'],
        summary: '查询运动记录',
        security: [{ bearerAuth: [] }],
        parameters: [
          { name: 'from', in: 'query', schema: { type: 'string', format: 'date-time' } },
          { name: 'to', in: 'query', schema: { type: 'string', format: 'date-time' } },
        ],
        responses: {
          '200': {
            description: 'OK',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: { records: { type: 'array', items: { $ref: '#/components/schemas/ExerciseRecord' } } },
                },
              },
            },
          },
        },
      },
      post: {
        tags: ['Exercises'],
        summary: '创建运动记录',
        description: 'calories 由服务端按 MET 公式权威计算（**不接受客户端传入 calories**）',
        security: [{ bearerAuth: [] }],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['typeId', 'startedAt', 'durationSec'],
                properties: {
                  typeId: { type: 'string', example: 'running' },
                  startedAt: { type: 'string', format: 'date-time' },
                  durationSec: { type: 'integer', minimum: 0, maximum: 86400 },
                  distanceKm: { type: 'number' },
                  clientId: { type: 'string', description: '幂等键（避免重复上报）' },
                },
              },
            },
          },
        },
        responses: {
          '201': {
            description: 'Created',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/ExerciseRecord' } } },
          },
          '400': { $ref: '#/components/responses/ValidationError' },
          '404': { $ref: '#/components/responses/NotFound' },
        },
      },
    },
    '/api/exercises/steps': {
      post: {
        tags: ['Steps'],
        summary: '上报每日步数',
        description: '同日多次上报采用 **max-value 策略**（避免移动端 OS 回退）',
        security: [{ bearerAuth: [] }],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['steps'],
                properties: {
                  date: { type: 'string', format: 'date-time', description: '默认今天' },
                  steps: { type: 'integer', minimum: 0, maximum: 200000 },
                  source: { type: 'string', enum: ['ios_pedometer', 'android_sensor', 'manual'] },
                },
              },
            },
          },
        },
        responses: {
          '201': { description: 'Created', content: { 'application/json': { schema: { $ref: '#/components/schemas/DailyStep' } } } },
          '400': { $ref: '#/components/responses/ValidationError' },
        },
      },
    },
    '/api/exercises/steps/today': {
      get: {
        tags: ['Steps'],
        summary: '查询今日步数',
        security: [{ bearerAuth: [] }],
        responses: {
          '200': {
            description: 'OK',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/DailyStep' } } },
          },
        },
      },
    },
    // ===== Diet =====
    '/api/diet/foods': {
      get: {
        tags: ['Diet'],
        summary: '搜索食物营养库',
        parameters: [
          { name: 'q', in: 'query', schema: { type: 'string' }, description: '匹配 nameZh 或 name' },
          { name: 'category', in: 'query', schema: { type: 'string' } },
          { name: 'limit', in: 'query', schema: { type: 'integer', minimum: 1, maximum: 100, default: 20 } },
          { name: 'offset', in: 'query', schema: { type: 'integer', minimum: 0, default: 0 } },
        ],
        responses: {
          '200': {
            description: 'OK',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: { foods: { type: 'array', items: { $ref: '#/components/schemas/Food' } } },
                },
              },
            },
          },
        },
      },
    },
    '/api/diet/records': {
      get: {
        tags: ['Diet'],
        summary: '查询某时间段的饮食记录',
        security: [{ bearerAuth: [] }],
        parameters: [
          { name: 'from', in: 'query', required: true, schema: { type: 'string', format: 'date-time' } },
          { name: 'to', in: 'query', required: true, schema: { type: 'string', format: 'date-time' } },
        ],
        responses: {
          '200': {
            description: 'OK',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: { records: { type: 'array', items: { $ref: '#/components/schemas/DietRecord' } } },
                },
              },
            },
          },
        },
      },
      post: {
        tags: ['Diet'],
        summary: '记录一餐',
        description: '服务端计算 consumed = servings × servingSizeG/100 × per100g',
        security: [{ bearerAuth: [] }],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['foodId', 'mealType', 'servings'],
                properties: {
                  foodId: { type: 'integer' },
                  mealType: { type: 'string', enum: ['breakfast', 'lunch', 'dinner', 'snack'] },
                  consumedAt: { type: 'string', format: 'date-time' },
                  servings: { type: 'number', minimum: 0, maximum: 20 },
                },
              },
            },
          },
        },
        responses: {
          '201': { description: 'Created', content: { 'application/json': { schema: { $ref: '#/components/schemas/DietRecord' } } } },
          '400': { $ref: '#/components/responses/ValidationError' },
        },
      },
    },
    '/api/diet/summary': {
      get: {
        tags: ['Diet'],
        summary: '查询某日营养汇总',
        security: [{ bearerAuth: [] }],
        parameters: [
          { name: 'date', in: 'query', schema: { type: 'string', format: 'date-time' }, description: '默认今天' },
        ],
        responses: {
          '200': {
            description: 'OK',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/DailyNutritionSummary' } } },
          },
        },
      },
    },
    // ===== Mood =====
    '/api/mood': {
      get: {
        tags: ['Mood'],
        summary: '查询情绪记录',
        security: [{ bearerAuth: [] }],
        parameters: [
          { name: 'from', in: 'query', schema: { type: 'string', format: 'date-time' } },
          { name: 'to', in: 'query', schema: { type: 'string', format: 'date-time' } },
        ],
        responses: {
          '200': {
            description: 'OK',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: { records: { type: 'array', items: { $ref: '#/components/schemas/MoodRecord' } } },
                },
              },
            },
          },
        },
      },
      post: {
        tags: ['Mood'],
        summary: '记录一次情绪',
        security: [{ bearerAuth: [] }],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['mood'],
                properties: {
                  mood: {
                    type: 'string',
                    enum: ['happy', 'calm', 'sad', 'anxious', 'angry', 'tired', 'grateful', 'excited'],
                  },
                  score: { type: 'integer', minimum: 1, maximum: 10 },
                  note: { type: 'string', maxLength: 2000 },
                  recordedAt: { type: 'string', format: 'date-time' },
                },
              },
            },
          },
        },
        responses: {
          '201': { description: 'Created', content: { 'application/json': { schema: { $ref: '#/components/schemas/MoodRecord' } } } },
        },
      },
    },
    '/api/mood/trend': {
      get: {
        tags: ['Mood'],
        summary: '查询情绪趋势（按日聚合）',
        security: [{ bearerAuth: [] }],
        parameters: [
          { name: 'from', in: 'query', required: true, schema: { type: 'string', format: 'date-time' } },
          { name: 'to', in: 'query', required: true, schema: { type: 'string', format: 'date-time' } },
        ],
        responses: {
          '200': {
            description: 'OK',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    trend: { type: 'array', items: { $ref: '#/components/schemas/MoodTrendPoint' } },
                  },
                },
              },
            },
          },
        },
      },
    },
    // ===== Chat =====
    '/api/chat/messages': {
      post: {
        tags: ['Chat'],
        summary: '发送 AI 对话',
        description:
          'AI 回复带 **医疗免责声明**（你不是医生 / 不能替代专业诊断）。' +
          '服务端未配置 ANTHROPIC_API_KEY / OPENAI_API_KEY 时返回 503 AI_DISABLED；' +
          '上游 AI 失败时返回 502 AI_UPSTREAM_ERROR。',
        security: [{ bearerAuth: [] }],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['content'],
                properties: {
                  content: { type: 'string', minLength: 1, maxLength: 4000 },
                },
              },
            },
          },
        },
        responses: {
          '201': { description: 'Created', content: { 'application/json': { schema: { $ref: '#/components/schemas/ChatSendResult' } } } },
          '400': { $ref: '#/components/responses/ValidationError' },
          '502': {
            description: 'AI upstream error',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
          '503': {
            description: 'AI disabled (no API key configured)',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },
    '/api/chat/history': {
      get: {
        tags: ['Chat'],
        summary: '查询历史对话',
        security: [{ bearerAuth: [] }],
        parameters: [
          { name: 'limit', in: 'query', schema: { type: 'integer', minimum: 1, maximum: 200, default: 50 } },
        ],
        responses: {
          '200': {
            description: 'OK',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: { history: { type: 'array', items: { $ref: '#/components/schemas/ChatMessage' } } },
                },
              },
            },
          },
        },
      },
    },
  },
};
