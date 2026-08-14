import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { exercisesApi } from '@/api/exercises';

export function useExerciseTypes() {
  return useQuery({
    queryKey: ['exercises', 'types'],
    queryFn: () => exercisesApi.types(),
    staleTime: Infinity,
  });
}

export function useExercises(from?: string, to?: string) {
  return useQuery({
    queryKey: ['exercises', 'list', from, to],
    queryFn: () => exercisesApi.list(from, to),
  });
}

export function useCreateExercise() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: exercisesApi.create,
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['exercises'] });
    },
  });
}

export function useTodaySteps() {
  return useQuery({
    queryKey: ['steps', 'today'],
    queryFn: () => exercisesApi.todaySteps(),
    refetchInterval: 60_000,
  });
}

export function useReportSteps() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: exercisesApi.reportSteps,
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['steps'] });
    },
  });
}
