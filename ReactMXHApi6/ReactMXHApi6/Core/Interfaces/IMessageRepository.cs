using ReactMXHApi6.Core.Entities;
using ReactMXHApi6.Dtos;

namespace ReactMXHApi6.Core.Interfaces
{
    public interface IMessageRepository
    {
        void AddGroup(Group group);
        void AddMessage(Message message);
        Task<Connection> GetConnection(string connectionId);
        Task<Group> GetGroupForConnection(string connectionId);
        Task<Group> GetMessageGroup(string groupName);
        Task<IEnumerable<MessageDto>> GetMessageThread(string currentUsername, string recipientUsername);
        Task<IEnumerable<MessageDto>> GetMessageThreadDescending(string currentUsername, string recipientUsername);
        void RemoveConnection(Connection connection);
    }
}
