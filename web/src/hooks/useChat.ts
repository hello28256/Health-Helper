import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { chatApi } from '@/api/chat';

export function useChatHistory(limit = 50) {
  return useQuery({
    queryKey: ['chat', 'history', limit],
    queryFn: () => chatApi.history(limit),
  });
}

export function useSendMessage() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: chatApi.send,
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['chat', 'history'] });
    },
  });
}
