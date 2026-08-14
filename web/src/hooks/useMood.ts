import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { moodApi } from '@/api/mood';

export function useMoodList(from?: string, to?: string) {
  return useQuery({
    queryKey: ['mood', 'list', from, to],
    queryFn: () => moodApi.list(from, to),
  });
}

export function useCreateMood() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: moodApi.create,
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['mood'] });
    },
  });
}

export function useMoodTrend(from: string, to: string) {
  return useQuery({
    queryKey: ['mood', 'trend', from, to],
    queryFn: () => moodApi.trend(from, to),
  });
}
