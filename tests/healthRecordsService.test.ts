// HealthRecordsService 单元测试
// TDD：先写测试，再写实现

import {
  HealthRecordsService,
  createHealthRecordsService,
} from '../src/services/healthRecordsService';
import { ValidationError } from '../src/utils/errors';

// ===== Prisma mock =====
//
// mock 用 Map 存 healthRecord，按 (userId|metric|startAtIso) 主键去重。
// 真实实现里可以再考虑 source/version 维度，但 MVP 用同一时刻取最新即可。
// eslint-disable-next-line @typescript-eslint/no-explicit-any
function createPrismaMock() {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const records: any[] = [];

  return {
    healthRecord: {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      create: async ({ data }: any) => {
        const rec = {
          id: `hr_${records.length + 1}`,
          ...data,
          endAt: data.endAt ?? null,
          raw: data.raw ?? null,
          createdAt: new Date(),
        };
        records.push(rec);
        return rec;
      },
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      findMany: async ({ where, orderBy, take }: any) => {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        let rows = records.filter((r: any) => r.userId === where.userId);
        if (where.metric) rows = rows.filter((r: any) => r.metric === where.metric);
        if (where.startAt?.gte || where.startAt?.lte) {
          const from = where.startAt.gte;
          const to = where.startAt.lte;
          rows = rows.filter((r: any) => {
            if (from && r.startAt < from) return false;
            if (to && r.startAt > to) return false;
            return true;
          });
        }
        if (orderBy?.startAt === 'desc') rows.sort((a: any, b: any) => b.startAt - a.startAt);
        if (orderBy?.startAt === 'asc') rows.sort((a: any, b: any) => a.startAt - b.startAt);
        if (typeof take === 'number') rows = rows.slice(0, take);
        return rows;
      },
      findFirst: async ({ where, orderBy }: any) => {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        let rows = records.filter((r: any) => r.userId === where.userId);
        if (where.metric) rows = rows.filter((r: any) => r.metric === where.metric);
        if (orderBy?.startAt === 'desc') rows.sort((a: any, b: any) => b.startAt - a.startAt);
        return rows[0] ?? null;
      },
    },
  };
}

describe('HealthRecordsService', () => {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  let mock: any;
  let svc: HealthRecordsService;

  beforeEach(() => {
    mock = createPrismaMock();
    svc = new HealthRecordsService(mock);
  });

  describe('record (batch insert)', () => {
    it('inserts a batch of records and returns DTOs', async () => {
      const userId = 'u1';
      const records = [
        {
          metric: 'heart_rate' as const,
          value: 72,
          unit: 'bpm',
          startAt: new Date('2026-08-10T08:00:00Z'),
          source: 'ios_healthkit',
        },
        {
          metric: 'sleep' as const,
          value: 420,
          unit: 'min',
          startAt: new Date('2026-08-10T22:00:00Z'),
          endAt: new Date('2026-08-11T05:00:00Z'),
          source: 'ios_healthkit',
        },
      ];

      const result = await svc.record({ userId, records });

      expect(result).toHaveLength(2);
      expect(result[0]?.metric).toBe('heart_rate');
      expect(result[1]?.metric).toBe('sleep');
      expect(result[1]?.endAt).toEqual(new Date('2026-08-11T05:00:00Z'));
    });

    it('rejects empty batch', async () => {
      await expect(svc.record({ userId: 'u1', records: [] })).rejects.toThrow(ValidationError);
    });

    it('rejects batch larger than 500', async () => {
      const records = Array.from({ length: 501 }, (_, i) => ({
        metric: 'heart_rate' as const,
        value: i,
        unit: 'bpm',
        startAt: new Date(2026, 0, 1, 0, i),
        source: 'ios_healthkit',
      }));
      await expect(svc.record({ userId: 'u1', records })).rejects.toThrow(ValidationError);
    });

    it('rejects invalid metric enum', async () => {
      await expect(
        svc.record({
          userId: 'u1',
          records: [
            // @ts-expect-error testing runtime validation
            { metric: 'blood_sugar', value: 5, unit: 'mmol/L', startAt: new Date(), source: 'manual' },
          ],
        }),
      ).rejects.toThrow(ValidationError);
    });

    it('rejects endAt < startAt', async () => {
      await expect(
        svc.record({
          userId: 'u1',
          records: [
            {
              metric: 'sleep' as const,
              value: 60,
              unit: 'min',
              startAt: new Date('2026-08-10T22:00:00Z'),
              endAt: new Date('2026-08-10T21:00:00Z'),
              source: 'ios_healthkit',
            },
          ],
        }),
      ).rejects.toThrow(ValidationError);
    });
  });

  describe('list', () => {
    beforeEach(async () => {
      await svc.record({
        userId: 'u1',
        records: [
          {
            metric: 'heart_rate' as const,
            value: 72,
            unit: 'bpm',
            startAt: new Date('2026-08-08T08:00:00Z'),
            source: 'ios_healthkit',
          },
          {
            metric: 'heart_rate' as const,
            value: 80,
            unit: 'bpm',
            startAt: new Date('2026-08-10T08:00:00Z'),
            source: 'ios_healthkit',
          },
          {
            metric: 'sleep' as const,
            value: 420,
            unit: 'min',
            startAt: new Date('2026-08-09T22:00:00Z'),
            source: 'ios_healthkit',
          },
        ],
      });
    });

    it('filters by metric', async () => {
      const result = await svc.list({
        userId: 'u1',
        metric: 'heart_rate',
        from: new Date('2026-08-01T00:00:00Z'),
        to: new Date('2026-08-31T23:59:59Z'),
      });
      expect(result).toHaveLength(2);
      expect(result.every((r) => r.metric === 'heart_rate')).toBe(true);
    });

    it('filters by time range', async () => {
      const result = await svc.list({
        userId: 'u1',
        metric: 'heart_rate',
        from: new Date('2026-08-09T00:00:00Z'),
        to: new Date('2026-08-11T00:00:00Z'),
      });
      expect(result).toHaveLength(1);
      expect(result[0]?.value).toBe(80);
    });

    it('scopes strictly by userId (no cross-user leak)', async () => {
      const otherSvc = new HealthRecordsService(createPrismaMock());
      const result = await otherSvc.list({
        userId: 'u2',
        metric: 'heart_rate',
        from: new Date('2026-08-01'),
        to: new Date('2026-08-31'),
      });
      expect(result).toHaveLength(0);
    });
  });

  describe('latest', () => {
    beforeEach(async () => {
      await svc.record({
        userId: 'u1',
        records: [
          {
            metric: 'weight' as const,
            value: 65.5,
            unit: 'kg',
            startAt: new Date('2026-08-01T08:00:00Z'),
            source: 'manual',
          },
          {
            metric: 'weight' as const,
            value: 64.8,
            unit: 'kg',
            startAt: new Date('2026-08-08T08:00:00Z'),
            source: 'manual',
          },
        ],
      });
    });

    it('returns the latest record by startAt', async () => {
      const result = await svc.latest({ userId: 'u1', metric: 'weight' });
      expect(result).not.toBeNull();
      expect(result?.value).toBe(64.8);
    });

    it('returns null when no record exists', async () => {
      const result = await svc.latest({ userId: 'u1', metric: 'spo2' });
      expect(result).toBeNull();
    });
  });

  describe('factory', () => {
    it('createHealthRecordsService returns instance', () => {
      expect(createHealthRecordsService()).toBeInstanceOf(HealthRecordsService);
    });
  });
});