namespace ReactMXHApi6.Core.Interfaces
{
    public interface IUnitOfWork : IDisposable
    {
        Task<bool> Complete();
        bool HasChanges();
        IPostRepository PostRepository { get; }
        IUserRepository UserRepository { get; }
        IMessageRepository MessageRepository { get; }
        ILastMessageChatRepository LastMessageChatRepository { get; }
        IOneSignalRepository OneSignalRepository { get; }
        ICommentRepository CommentRepository { get; }
    }
}
