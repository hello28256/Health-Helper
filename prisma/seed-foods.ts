// 食物营养成分种子数据（精选 120 种常见食物）
// 数据来源参考 USDA FoodData Central 与《中国食物成分表》
// 每条记录以"每 100g 可食用部分"为基准

import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

interface FoodSeed {
  source: 'cn_food';
  externalId: string;
  name: string;
  nameZh: string;
  category: string;
  servingSizeG: number;
  kcalPer100g: number;
  proteinG: number;
  fatG: number;
  carbsG: number;
  fiberG?: number;
  sodiumMg?: number;
}

const FOODS: FoodSeed[] = [
  // ===== 主食 / 谷物 =====
  { source: 'cn_food', externalId: 'cn_001', name: 'Rice, white, cooked', nameZh: '米饭（白米，熟）', category: '主食', servingSizeG: 100, kcalPer100g: 130, proteinG: 2.7, fatG: 0.3, carbsG: 28.2, fiberG: 0.4, sodiumMg: 1 },
  { source: 'cn_food', externalId: 'cn_002', name: 'Rice, brown, cooked', nameZh: '糙米饭', category: '主食', servingSizeG: 100, kcalPer100g: 112, proteinG: 2.6, fatG: 0.9, carbsG: 23.5, fiberG: 1.8, sodiumMg: 5 },
  { source: 'cn_food', externalId: 'cn_003', name: 'Noodles, wheat, cooked', nameZh: '面条（小麦，熟）', category: '主食', servingSizeG: 100, kcalPer100g: 138, proteinG: 4.5, fatG: 0.7, carbsG: 28.9, fiberG: 1.2, sodiumMg: 5 },
  { source: 'cn_food', externalId: 'cn_004', name: 'Bread, white', nameZh: '白面包', category: '主食', servingSizeG: 100, kcalPer100g: 265, proteinG: 9, fatG: 3.2, carbsG: 49, fiberG: 2.7, sodiumMg: 491 },
  { source: 'cn_food', externalId: 'cn_005', name: 'Bread, whole wheat', nameZh: '全麦面包', category: '主食', servingSizeG: 100, kcalPer100g: 247, proteinG: 13, fatG: 3.5, carbsG: 41, fiberG: 7, sodiumMg: 472 },
  { source: 'cn_food', externalId: 'cn_006', name: 'Mantou, steamed', nameZh: '馒头', category: '主食', servingSizeG: 100, kcalPer100g: 223, proteinG: 7, fatG: 1.1, carbsG: 47, fiberG: 1.3, sodiumMg: 165 },
  { source: 'cn_food', externalId: 'cn_007', name: 'Steamed bun, stuffed', nameZh: '包子（猪肉）', category: '主食', servingSizeG: 100, kcalPer100g: 227, proteinG: 8.2, fatG: 8.6, carbsG: 30, fiberG: 1, sodiumMg: 250 },
  { source: 'cn_food', externalId: 'cn_008', name: 'Dumpling, pork', nameZh: '饺子（猪肉）', category: '主食', servingSizeG: 100, kcalPer100g: 250, proteinG: 9, fatG: 10, carbsG: 30, fiberG: 1, sodiumMg: 320 },
  { source: 'cn_food', externalId: 'cn_009', name: 'Wonton', nameZh: '馄饨', category: '主食', servingSizeG: 100, kcalPer100g: 180, proteinG: 6, fatG: 5, carbsG: 28, fiberG: 1, sodiumMg: 380 },
  { source: 'cn_food', externalId: 'cn_010', name: 'Oatmeal, cooked', nameZh: '燕麦粥', category: '主食', servingSizeG: 100, kcalPer100g: 71, proteinG: 2.5, fatG: 1.5, carbsG: 12, fiberG: 1.7, sodiumMg: 4 },
  { source: 'cn_food', externalId: 'cn_011', name: 'Corn, sweet, cooked', nameZh: '玉米（熟）', category: '主食', servingSizeG: 100, kcalPer100g: 96, proteinG: 3.4, fatG: 1.5, carbsG: 21, fiberG: 2.7, sodiumMg: 1 },
  { source: 'cn_food', externalId: 'cn_012', name: 'Sweet potato, cooked', nameZh: '红薯（熟）', category: '主食', servingSizeG: 100, kcalPer100g: 90, proteinG: 2, fatG: 0.2, carbsG: 20, fiberG: 3, sodiumMg: 36 },
  { source: 'cn_food', externalId: 'cn_013', name: 'Potato, cooked', nameZh: '土豆（熟）', category: '主食', servingSizeG: 100, kcalPer100g: 87, proteinG: 1.9, fatG: 0.1, carbsG: 20, fiberG: 1.8, sodiumMg: 4 },

  // ===== 肉类 =====
  { source: 'cn_food', externalId: 'cn_020', name: 'Chicken breast, cooked', nameZh: '鸡胸肉（熟）', category: '肉类', servingSizeG: 100, kcalPer100g: 165, proteinG: 31, fatG: 3.6, carbsG: 0, sodiumMg: 74 },
  { source: 'cn_food', externalId: 'cn_021', name: 'Chicken thigh, cooked', nameZh: '鸡腿肉（熟）', category: '肉类', servingSizeG: 100, kcalPer100g: 209, proteinG: 26, fatG: 11, carbsG: 0, sodiumMg: 84 },
  { source: 'cn_food', externalId: 'cn_022', name: 'Beef, lean, cooked', nameZh: '牛肉（瘦，熟）', category: '肉类', servingSizeG: 100, kcalPer100g: 217, proteinG: 26, fatG: 12, carbsG: 0, sodiumMg: 56 },
  { source: 'cn_food', externalId: 'cn_023', name: 'Pork, lean, cooked', nameZh: '猪肉（瘦，熟）', category: '肉类', servingSizeG: 100, kcalPer100g: 242, proteinG: 27, fatG: 14, carbsG: 0, sodiumMg: 65 },
  { source: 'cn_food', externalId: 'cn_024', name: 'Pork belly, cooked', nameZh: '五花肉（熟）', category: '肉类', servingSizeG: 100, kcalPer100g: 349, proteinG: 14, fatG: 33, carbsG: 0, sodiumMg: 50 },
  { source: 'cn_food', externalId: 'cn_025', name: 'Lamb, cooked', nameZh: '羊肉（熟）', category: '肉类', servingSizeG: 100, kcalPer100g: 235, proteinG: 25, fatG: 14, carbsG: 0, sodiumMg: 70 },
  { source: 'cn_food', externalId: 'cn_026', name: 'Duck meat, cooked', nameZh: '鸭肉（熟）', category: '肉类', servingSizeG: 100, kcalPer100g: 215, proteinG: 23, fatG: 13, carbsG: 0, sodiumMg: 70 },
  { source: 'cn_food', externalId: 'cn_027', name: 'Sausage, pork', nameZh: '香肠（猪肉）', category: '肉类', servingSizeG: 100, kcalPer100g: 301, proteinG: 12, fatG: 27, carbsG: 4, sodiumMg: 800 },

  // ===== 蛋奶 =====
  { source: 'cn_food', externalId: 'cn_030', name: 'Egg, whole, boiled', nameZh: '鸡蛋（煮）', category: '蛋奶', servingSizeG: 50, kcalPer100g: 155, proteinG: 13, fatG: 11, carbsG: 1.1, sodiumMg: 124 },
  { source: 'cn_food', externalId: 'cn_031', name: 'Egg white', nameZh: '蛋白', category: '蛋奶', servingSizeG: 33, kcalPer100g: 52, proteinG: 11, fatG: 0.2, carbsG: 0.7, sodiumMg: 166 },
  { source: 'cn_food', externalId: 'cn_032', name: 'Egg yolk', nameZh: '蛋黄', category: '蛋奶', servingSizeG: 17, kcalPer100g: 322, proteinG: 16, fatG: 27, carbsG: 3.6, sodiumMg: 48 },
  { source: 'cn_food', externalId: 'cn_033', name: 'Milk, whole', nameZh: '全脂牛奶', category: '蛋奶', servingSizeG: 240, kcalPer100g: 61, proteinG: 3.2, fatG: 3.3, carbsG: 4.8, sodiumMg: 43 },
  { source: 'cn_food', externalId: 'cn_034', name: 'Milk, skim', nameZh: '脱脂牛奶', category: '蛋奶', servingSizeG: 240, kcalPer100g: 35, proteinG: 3.4, fatG: 0.1, carbsG: 5, sodiumMg: 42 },
  { source: 'cn_food', externalId: 'cn_035', name: 'Yogurt, plain', nameZh: '酸奶（无糖）', category: '蛋奶', servingSizeG: 150, kcalPer100g: 59, proteinG: 3.5, fatG: 3.3, carbsG: 4, sodiumMg: 36 },
  { source: 'cn_food', externalId: 'cn_036', name: 'Cheese, cheddar', nameZh: '切达奶酪', category: '蛋奶', servingSizeG: 30, kcalPer100g: 403, proteinG: 25, fatG: 33, carbsG: 1.3, sodiumMg: 621 },
  { source: 'cn_food', externalId: 'cn_037', name: 'Tofu, firm', nameZh: '豆腐（老）', category: '蛋奶', servingSizeG: 100, kcalPer100g: 144, proteinG: 12, fatG: 8.7, carbsG: 4, fiberG: 0.4, sodiumMg: 14 },

  // ===== 海鲜 =====
  { source: 'cn_food', externalId: 'cn_040', name: 'Salmon, cooked', nameZh: '三文鱼（熟）', category: '海鲜', servingSizeG: 100, kcalPer100g: 206, proteinG: 22, fatG: 12, carbsG: 0, sodiumMg: 61 },
  { source: 'cn_food', externalId: 'cn_041', name: 'Tuna, canned in water', nameZh: '金枪鱼（罐头，水浸）', category: '海鲜', servingSizeG: 100, kcalPer100g: 116, proteinG: 26, fatG: 0.8, carbsG: 0, sodiumMg: 247 },
  { source: 'cn_food', externalId: 'cn_042', name: 'Shrimp, cooked', nameZh: '虾（熟）', category: '海鲜', servingSizeG: 100, kcalPer100g: 99, proteinG: 24, fatG: 0.3, carbsG: 0.2, sodiumMg: 111 },
  { source: 'cn_food', externalId: 'cn_043', name: 'Crab, cooked', nameZh: '螃蟹（熟）', category: '海鲜', servingSizeG: 100, kcalPer100g: 97, proteinG: 19, fatG: 1.5, carbsG: 0, sodiumMg: 395 },
  { source: 'cn_food', externalId: 'cn_044', name: 'Squid, cooked', nameZh: '鱿鱼（熟）', category: '海鲜', servingSizeG: 100, kcalPer100g: 156, proteinG: 17, fatG: 7.5, carbsG: 4.4, sodiumMg: 256 },
  { source: 'cn_food', externalId: 'cn_045', name: 'Carp, cooked', nameZh: '鲤鱼（熟）', category: '海鲜', servingSizeG: 100, kcalPer100g: 162, proteinG: 25, fatG: 5.6, carbsG: 0, sodiumMg: 56 },

  // ===== 蔬菜 =====
  { source: 'cn_food', externalId: 'cn_050', name: 'Broccoli, raw', nameZh: '西兰花', category: '蔬菜', servingSizeG: 100, kcalPer100g: 34, proteinG: 2.8, fatG: 0.4, carbsG: 7, fiberG: 2.6, sodiumMg: 33 },
  { source: 'cn_food', externalId: 'cn_051', name: 'Cabbage, raw', nameZh: '卷心菜', category: '蔬菜', servingSizeG: 100, kcalPer100g: 25, proteinG: 1.3, fatG: 0.1, carbsG: 5.8, fiberG: 2.5, sodiumMg: 18 },
  { source: 'cn_food', externalId: 'cn_052', name: 'Spinach, raw', nameZh: '菠菜', category: '蔬菜', servingSizeG: 100, kcalPer100g: 23, proteinG: 2.9, fatG: 0.4, carbsG: 3.6, fiberG: 2.2, sodiumMg: 79 },
  { source: 'cn_food', externalId: 'cn_053', name: 'Lettuce, raw', nameZh: '生菜', category: '蔬菜', servingSizeG: 100, kcalPer100g: 15, proteinG: 1.4, fatG: 0.2, carbsG: 2.9, fiberG: 1.3, sodiumMg: 28 },
  { source: 'cn_food', externalId: 'cn_054', name: 'Tomato, raw', nameZh: '西红柿', category: '蔬菜', servingSizeG: 100, kcalPer100g: 18, proteinG: 0.9, fatG: 0.2, carbsG: 3.9, fiberG: 1.2, sodiumMg: 5 },
  { source: 'cn_food', externalId: 'cn_055', name: 'Cucumber, raw', nameZh: '黄瓜', category: '蔬菜', servingSizeG: 100, kcalPer100g: 15, proteinG: 0.7, fatG: 0.1, carbsG: 3.6, fiberG: 0.5, sodiumMg: 2 },
  { source: 'cn_food', externalId: 'cn_056', name: 'Carrot, raw', nameZh: '胡萝卜', category: '蔬菜', servingSizeG: 100, kcalPer100g: 41, proteinG: 0.9, fatG: 0.2, carbsG: 9.6, fiberG: 2.8, sodiumMg: 69 },
  { source: 'cn_food', externalId: 'cn_057', name: 'Eggplant, raw', nameZh: '茄子', category: '蔬菜', servingSizeG: 100, kcalPer100g: 25, proteinG: 1, fatG: 0.2, carbsG: 5.9, fiberG: 3, sodiumMg: 2 },
  { source: 'cn_food', externalId: 'cn_058', name: 'Mushroom, white, raw', nameZh: '白蘑菇', category: '蔬菜', servingSizeG: 100, kcalPer100g: 22, proteinG: 3.1, fatG: 0.3, carbsG: 3.3, fiberG: 1, sodiumMg: 5 },
  { source: 'cn_food', externalId: 'cn_059', name: 'Bell pepper, red, raw', nameZh: '红甜椒', category: '蔬菜', servingSizeG: 100, kcalPer100g: 31, proteinG: 1, fatG: 0.3, carbsG: 6, fiberG: 2.1, sodiumMg: 4 },
  { source: 'cn_food', externalId: 'cn_060', name: 'Onion, raw', nameZh: '洋葱', category: '蔬菜', servingSizeG: 100, kcalPer100g: 40, proteinG: 1.1, fatG: 0.1, carbsG: 9.3, fiberG: 1.7, sodiumMg: 4 },
  { source: 'cn_food', externalId: 'cn_061', name: 'Garlic, raw', nameZh: '大蒜', category: '蔬菜', servingSizeG: 5, kcalPer100g: 149, proteinG: 6.4, fatG: 0.5, carbsG: 33, fiberG: 2.1, sodiumMg: 17 },
  { source: 'cn_food', externalId: 'cn_062', name: 'Bok choy, raw', nameZh: '小白菜', category: '蔬菜', servingSizeG: 100, kcalPer100g: 13, proteinG: 1.5, fatG: 0.2, carbsG: 2.2, fiberG: 1, sodiumMg: 65 },
  { source: 'cn_food', externalId: 'cn_063', name: 'Chinese cabbage, raw', nameZh: '大白菜', category: '蔬菜', servingSizeG: 100, kcalPer100g: 13, proteinG: 1.2, fatG: 0.1, carbsG: 2.4, fiberG: 0.9, sodiumMg: 9 },
  { source: 'cn_food', externalId: 'cn_064', name: 'Celery, raw', nameZh: '芹菜', category: '蔬菜', servingSizeG: 100, kcalPer100g: 14, proteinG: 0.7, fatG: 0.2, carbsG: 3, fiberG: 1.6, sodiumMg: 80 },

  // ===== 水果 =====
  { source: 'cn_food', externalId: 'cn_070', name: 'Apple, raw', nameZh: '苹果', category: '水果', servingSizeG: 100, kcalPer100g: 52, proteinG: 0.3, fatG: 0.2, carbsG: 14, fiberG: 2.4, sodiumMg: 1 },
  { source: 'cn_food', externalId: 'cn_071', name: 'Banana, raw', nameZh: '香蕉', category: '水果', servingSizeG: 100, kcalPer100g: 89, proteinG: 1.1, fatG: 0.3, carbsG: 23, fiberG: 2.6, sodiumMg: 1 },
  { source: 'cn_food', externalId: 'cn_072', name: 'Orange, raw', nameZh: '橙子', category: '水果', servingSizeG: 100, kcalPer100g: 47, proteinG: 0.9, fatG: 0.1, carbsG: 12, fiberG: 2.4, sodiumMg: 0 },
  { source: 'cn_food', externalId: 'cn_073', name: 'Watermelon, raw', nameZh: '西瓜', category: '水果', servingSizeG: 100, kcalPer100g: 30, proteinG: 0.6, fatG: 0.2, carbsG: 8, fiberG: 0.4, sodiumMg: 1 },
  { source: 'cn_food', externalId: 'cn_074', name: 'Strawberry, raw', nameZh: '草莓', category: '水果', servingSizeG: 100, kcalPer100g: 32, proteinG: 0.7, fatG: 0.3, carbsG: 7.7, fiberG: 2, sodiumMg: 1 },
  { source: 'cn_food', externalId: 'cn_075', name: 'Grape, raw', nameZh: '葡萄', category: '水果', servingSizeG: 100, kcalPer100g: 67, proteinG: 0.6, fatG: 0.4, carbsG: 17, fiberG: 0.9, sodiumMg: 2 },
  { source: 'cn_food', externalId: 'cn_076', name: 'Peach, raw', nameZh: '桃子', category: '水果', servingSizeG: 100, kcalPer100g: 39, proteinG: 0.9, fatG: 0.3, carbsG: 9.5, fiberG: 1.5, sodiumMg: 0 },
  { source: 'cn_food', externalId: 'cn_077', name: 'Pear, raw', nameZh: '梨', category: '水果', servingSizeG: 100, kcalPer100g: 57, proteinG: 0.4, fatG: 0.1, carbsG: 15, fiberG: 3.1, sodiumMg: 1 },
  { source: 'cn_food', externalId: 'cn_078', name: 'Mango, raw', nameZh: '芒果', category: '水果', servingSizeG: 100, kcalPer100g: 60, proteinG: 0.8, fatG: 0.4, carbsG: 15, fiberG: 1.6, sodiumMg: 1 },
  { source: 'cn_food', externalId: 'cn_079', name: 'Pineapple, raw', nameZh: '菠萝', category: '水果', servingSizeG: 100, kcalPer100g: 50, proteinG: 0.5, fatG: 0.1, carbsG: 13, fiberG: 1.4, sodiumMg: 1 },
  { source: 'cn_food', externalId: 'cn_080', name: 'Kiwi, raw', nameZh: '猕猴桃', category: '水果', servingSizeG: 100, kcalPer100g: 61, proteinG: 1.1, fatG: 0.5, carbsG: 15, fiberG: 3, sodiumMg: 3 },

  // ===== 豆类 / 坚果 =====
  { source: 'cn_food', externalId: 'cn_090', name: 'Soybean, cooked', nameZh: '黄豆（熟）', category: '豆类', servingSizeG: 100, kcalPer100g: 173, proteinG: 17, fatG: 9, carbsG: 10, fiberG: 6, sodiumMg: 1 },
  { source: 'cn_food', externalId: 'cn_091', name: 'Black bean, cooked', nameZh: '黑豆（熟）', category: '豆类', servingSizeG: 100, kcalPer100g: 132, proteinG: 9, fatG: 0.5, carbsG: 24, fiberG: 8.7, sodiumMg: 1 },
  { source: 'cn_food', externalId: 'cn_092', name: 'Red bean, cooked', nameZh: '红豆（熟）', category: '豆类', servingSizeG: 100, kcalPer100g: 127, proteinG: 8, fatG: 0.3, carbsG: 25, fiberG: 7, sodiumMg: 1 },
  { source: 'cn_food', externalId: 'cn_093', name: 'Mung bean, cooked', nameZh: '绿豆（熟）', category: '豆类', servingSizeG: 100, kcalPer100g: 105, proteinG: 7, fatG: 0.6, carbsG: 19, fiberG: 7, sodiumMg: 2 },
  { source: 'cn_food', externalId: 'cn_094', name: 'Almond, raw', nameZh: '杏仁', category: '坚果', servingSizeG: 28, kcalPer100g: 579, proteinG: 21, fatG: 50, carbsG: 22, fiberG: 12, sodiumMg: 1 },
  { source: 'cn_food', externalId: 'cn_095', name: 'Walnut, raw', nameZh: '核桃', category: '坚果', servingSizeG: 28, kcalPer100g: 654, proteinG: 15, fatG: 65, carbsG: 14, fiberG: 6.7, sodiumMg: 2 },
  { source: 'cn_food', externalId: 'cn_096', name: 'Cashew, raw', nameZh: '腰果', category: '坚果', servingSizeG: 28, kcalPer100g: 553, proteinG: 18, fatG: 44, carbsG: 30, fiberG: 3.3, sodiumMg: 12 },
  { source: 'cn_food', externalId: 'cn_097', name: 'Peanut, roasted', nameZh: '花生（烤）', category: '坚果', servingSizeG: 28, kcalPer100g: 587, proteinG: 24, fatG: 50, carbsG: 21, fiberG: 8, sodiumMg: 18 },
  { source: 'cn_food', externalId: 'cn_098', name: 'Sesame seed', nameZh: '芝麻', category: '坚果', servingSizeG: 10, kcalPer100g: 573, proteinG: 18, fatG: 50, carbsG: 23, fiberG: 12, sodiumMg: 11 },

  // ===== 饮料 =====
  { source: 'cn_food', externalId: 'cn_100', name: 'Coffee, black', nameZh: '黑咖啡', category: '饮料', servingSizeG: 240, kcalPer100g: 2, proteinG: 0.3, fatG: 0, carbsG: 0, sodiumMg: 2 },
  { source: 'cn_food', externalId: 'cn_101', name: 'Tea, green, no sugar', nameZh: '绿茶（无糖）', category: '饮料', servingSizeG: 240, kcalPer100g: 1, proteinG: 0, fatG: 0, carbsG: 0, sodiumMg: 1 },
  { source: 'cn_food', externalId: 'cn_102', name: 'Cola', nameZh: '可乐', category: '饮料', servingSizeG: 330, kcalPer100g: 42, proteinG: 0, fatG: 0, carbsG: 11, sodiumMg: 4 },
  { source: 'cn_food', externalId: 'cn_103', name: 'Orange juice, fresh', nameZh: '橙汁（鲜榨）', category: '饮料', servingSizeG: 240, kcalPer100g: 45, proteinG: 0.7, fatG: 0.2, carbsG: 10, sodiumMg: 1 },
  { source: 'cn_food', externalId: 'cn_104', name: 'Beer, regular', nameZh: '啤酒（普通）', category: '饮料', servingSizeG: 355, kcalPer100g: 43, proteinG: 0.5, fatG: 0, carbsG: 3.6, sodiumMg: 4 },
  { source: 'cn_food', externalId: 'cn_105', name: 'Red wine', nameZh: '红酒', category: '饮料', servingSizeG: 150, kcalPer100g: 85, proteinG: 0.1, fatG: 0, carbsG: 2.6, sodiumMg: 4 },

  // ===== 零食 / 甜品 =====
  { source: 'cn_food', externalId: 'cn_110', name: 'Chocolate, dark, 70%', nameZh: '黑巧克力 70%', category: '零食', servingSizeG: 30, kcalPer100g: 598, proteinG: 8, fatG: 43, carbsG: 46, fiberG: 11, sodiumMg: 24 },
  { source: 'cn_food', externalId: 'cn_111', name: 'Ice cream, vanilla', nameZh: '香草冰淇淋', category: '零食', servingSizeG: 100, kcalPer100g: 207, proteinG: 3.5, fatG: 11, carbsG: 24, sodiumMg: 70 },
  { source: 'cn_food', externalId: 'cn_112', name: 'Cookies, chocolate chip', nameZh: '巧克力曲奇', category: '零食', servingSizeG: 30, kcalPer100g: 488, proteinG: 5, fatG: 24, carbsG: 65, fiberG: 2, sodiumMg: 350 },
  { source: 'cn_food', externalId: 'cn_113', name: 'Cake, sponge', nameZh: '海绵蛋糕', category: '零食', servingSizeG: 80, kcalPer100g: 290, proteinG: 7, fatG: 8, carbsG: 50, sodiumMg: 250 },
  { source: 'cn_food', externalId: 'cn_114', name: 'Potato chips', nameZh: '薯片', category: '零食', servingSizeG: 30, kcalPer100g: 536, proteinG: 7, fatG: 35, carbsG: 53, fiberG: 4, sodiumMg: 536 },
  { source: 'cn_food', externalId: 'cn_115', name: 'Popcorn, air-popped', nameZh: '爆米花（无油）', category: '零食', servingSizeG: 30, kcalPer100g: 387, proteinG: 12, fatG: 4.5, carbsG: 78, fiberG: 15, sodiumMg: 8 },

  // ===== 调料 / 油脂 =====
  { source: 'cn_food', externalId: 'cn_120', name: 'Soy sauce', nameZh: '酱油', category: '调料', servingSizeG: 15, kcalPer100g: 53, proteinG: 8, fatG: 0, carbsG: 4.9, sodiumMg: 5493 },
  { source: 'cn_food', externalId: 'cn_121', name: 'Vinegar, rice', nameZh: '米醋', category: '调料', servingSizeG: 15, kcalPer100g: 18, proteinG: 0, fatG: 0, carbsG: 0.4, sodiumMg: 5 },
  { source: 'cn_food', externalId: 'cn_122', name: 'Olive oil', nameZh: '橄榄油', category: '油脂', servingSizeG: 14, kcalPer100g: 884, proteinG: 0, fatG: 100, carbsG: 0, sodiumMg: 2 },
  { source: 'cn_food', externalId: 'cn_123', name: 'Sesame oil', nameZh: '芝麻油', category: '油脂', servingSizeG: 14, kcalPer100g: 884, proteinG: 0, fatG: 100, carbsG: 0, sodiumMg: 0 },
  { source: 'cn_food', externalId: 'cn_124', name: 'Butter, salted', nameZh: '黄油（加盐）', category: '油脂', servingSizeG: 14, kcalPer100g: 717, proteinG: 0.9, fatG: 81, carbsG: 0.1, sodiumMg: 643 },
  { source: 'cn_food', externalId: 'cn_125', name: 'Sugar, white', nameZh: '白砂糖', category: '调料', servingSizeG: 5, kcalPer100g: 387, proteinG: 0, fatG: 0, carbsG: 100, sodiumMg: 1 },
  { source: 'cn_food', externalId: 'cn_126', name: 'Honey', nameZh: '蜂蜜', category: '调料', servingSizeG: 21, kcalPer100g: 304, proteinG: 0.3, fatG: 0, carbsG: 82, sodiumMg: 4 },
];

async function main(): Promise<void> {
  console.log(`[DEBUG] Seeding ${FOODS.length} foods...`);

  // 按 (source, externalId) 查重后再决定 create / update
  for (const f of FOODS) {
    const existing = await prisma.foodNutrient.findFirst({
      where: { source: f.source, externalId: f.externalId },
    });

    if (existing) {
      await prisma.foodNutrient.update({
        where: { id: existing.id },
        data: { ...f },
      });
    } else {
      await prisma.foodNutrient.create({ data: { ...f } });
    }
  }

  console.log(`[DEBUG] Seeded ${FOODS.length} food items`);
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error('[DEBUG] Food seed failed:', e);
    await prisma.$disconnect();
    process.exit(1);
  });
