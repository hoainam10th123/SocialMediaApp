using AutoMapper;
using ReactMXHApi6.Core.Interfaces;
using ReactMXHApi6.Infrastructure.Services;

namespace ReactMXHApi6.Infrastructure.Data
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly DataContext _context;
        private readonly IMapper _mapper;

        public UnitOfWork(DataContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public ICommentRepository CommentRepository => new CommentRepository(_context, _mapper);
        public IOneSignalRepository OneSignalRepository => new OneSignalRepository(_context);
        public IPostRepository PostRepository => new PostRepository(_context, _mapper);
        public ILastMessageChatRepository LastMessageChatRepository => new LastMessageChatRepository(_context, _mapper);
        public IUserRepository UserRepository => new UserRepository(_context, _mapper);
        public IMessageRepository MessageRepository => new MessageRepository(_context, _mapper);

        public void Dispose()
        {
            _context.Dispose();
        }
        public async Task<bool> Complete()
        {
            return await _context.SaveChangesAsync() > 0;
        }
        public bool HasChanges()
        {
            return _context.ChangeTracker.HasChanges();
        }
    }
}
