using ReactMXHApi6.Core.Entities;
using ReactMXHApi6.Dtos;

namespace ReactMXHApi6.Core.Interfaces
{
    public interface ILastMessageChatRepository
    {
        Task<LastMessageChat> GetLastMessageChat(string currentUsername, string recipientUsername);
        Task<List<LastMessageChatDto>> GetListLastMessageChat(string currentUsername);
        Task<int> GetUnread(string currentUsername);
        void Update(LastMessageChat lastMessageChat);
        void Add(LastMessageChat lastMessageChat);
    }
}
