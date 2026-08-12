// 运动类型种子数据 —— MET 值来自 Compendium of Physical Activities
// 覆盖最常见的 9 种运动

import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

interface SeedType {
  id: string;
  displayNameZh: string;
  displayNameEn: string;
  met: number;
  notes: string;
  iconKey: string;
}

const EXERCISE_TYPES: SeedType[] = [
  {
    id: 'walking',
    displayNameZh: '散步',
    displayNameEn: 'Walking',
    met: 3.5,
    iconKey: 'walk',
    notes:
      '【强度】低。\n【适合人群】几乎所有人。\n【注意事项】\n- 饭后 30 分钟散步有助于消化\n- 穿着舒适运动鞋，避免硬地面长时间行走\n- 心率建议保持在最大心率的 50-60%',
  },
  {
    id: 'running',
    displayNameZh: '跑步',
    displayNameEn: 'Running',
    met: 9.8,
    iconKey: 'run',
    notes:
      '【强度】中-高。\n【适合人群】健康成年人。\n【注意事项】\n- 跑前充分热身 5-10 分钟\n- 注意膝关节和脚踝，避免硬地长时间跑\n- 配速循序渐进，每公里比走路多消耗约 5 倍热量\n- 建议每增加 10 分钟跑量不超过 10%',
  },
  {
    id: 'cycling',
    displayNameZh: '骑车',
    displayNameEn: 'Cycling',
    met: 7.5,
    iconKey: 'bike',
    notes:
      '【强度】中。\n【适合人群】几乎所有人，对膝关节友好。\n【注意事项】\n- 调整坐垫高度，使脚踏到底时膝盖微弯\n- 注意交通安全，佩戴头盔\n- 室内动感单车 MET 值更高（约 8.5）',
  },
  {
    id: 'swimming',
    displayNameZh: '游泳',
    displayNameEn: 'Swimming',
    met: 7.0,
    iconKey: 'swim',
    notes:
      '【强度】中-高。\n【适合人群】几乎所有人，对关节极友好。\n【注意事项】\n- 不同泳姿消耗不同：自由泳 > 蛙泳 > 仰泳\n- 饭后 1 小时再下水，避免抽筋\n- 不会游泳者不建议单独下水',
  },
  {
    id: 'yoga',
    displayNameZh: '瑜伽',
    displayNameEn: 'Yoga',
    met: 3.0,
    iconKey: 'yoga',
    notes:
      '【强度】低-中。\n【适合人群】几乎所有人。\n【注意事项】\n- 动作不必追求到位，听从身体的极限\n- 高血压/颈椎病人群避免倒立体式\n- 练习前后 1 小时不要饱食',
  },
  {
    id: 'hiit',
    displayNameZh: 'HIIT 间歇训练',
    displayNameEn: 'HIIT',
    met: 8.0,
    iconKey: 'hiit',
    notes:
      '【强度】高。\n【适合人群】有运动基础者。\n【注意事项】\n- 初学者从低强度开始，每周不超过 3 次\n- 每次训练 15-20 分钟即可\n- 心脏病人群请先咨询医生',
  },
  {
    id: 'strength',
    displayNameZh: '力量训练',
    displayNameEn: 'Strength Training',
    met: 5.0,
    iconKey: 'dumbbell',
    notes:
      '【强度】中。\n【适合人群】健康成年人。\n【注意事项】\n- 从轻重量开始，掌握正确动作再加重\n- 大肌群训练后休息 48 小时再练\n- 训练时保持正常呼吸，不要憋气',
  },
  {
    id: 'basketball',
    displayNameZh: '篮球',
    displayNameEn: 'Basketball',
    met: 6.5,
    iconKey: 'basketball',
    notes:
      '【强度】中-高。\n【适合人群】有运动基础者。\n【注意事项】\n- 比赛前充分热身，避免崴脚\n- 注意补水，运动中每 15 分钟少量饮水\n- 佩戴护具（护膝、护踝）',
  },
  {
    id: 'badminton',
    displayNameZh: '羽毛球',
    displayNameEn: 'Badminton',
    met: 5.5,
    iconKey: 'badminton',
    notes:
      '【强度】中。\n【适合人群】几乎所有人。\n【注意事项】\n- 注意肩部和手腕热身\n- 场地防滑，避免急停\n- 运动前后充分拉伸肩部',
  },
];

async function main(): Promise<void> {
  console.log('[DEBUG] Seeding exercise types...');
  for (const t of EXERCISE_TYPES) {
    await prisma.exerciseType.upsert({
      where: { id: t.id },
      create: t,
      update: {
        displayNameZh: t.displayNameZh,
        displayNameEn: t.displayNameEn,
        met: t.met,
        notes: t.notes,
        iconKey: t.iconKey,
      },
    });
    console.log(`  ✓ ${t.id} (${t.displayNameZh}, MET=${t.met})`);
  }
  console.log(`[DEBUG] Seeded ${EXERCISE_TYPES.length} exercise types`);
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error('[DEBUG] Seed failed:', e);
    await prisma.$disconnect();
    process.exit(1);
  });
