import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { dietApi } from '@/api/diet';

export function useSearchFoods(q: string) {
  return useQuery({
    queryKey: ['foods', 'search', q],
    queryFn: () => dietApi.searchFoods({ q, limit: 20 }),
    enabled: q.length > 0,
    staleTime: 60_000,
  });
}

export function useDietSummary(date?: string) {
  return useQuery({
    queryKey: ['diet', 'summary', date],
    queryFn: () => dietApi.summary(date),
  });
}

export function useDietRecords(from: string, to: string) {
  return useQuery({
    queryKey: ['diet', 'records', from, to],
    queryFn: () => dietApi.listRecords(from, to),
  });
}

export function useCreateDietRecord() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: dietApi.createRecord,
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['diet'] });
    },
  });
}
