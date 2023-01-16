using AutoMapper;
using Microsoft.EntityFrameworkCore;
using ReactMXHApi6.Core.Entities;
using ReactMXHApi6.Core.Interfaces;
using ReactMXHApi6.Dtos;

namespace ReactMXHApi6.Infrastructure.Data
{
    public class LastMessageChatRepository : ILastMessageChatRepository
    {
        private readonly DataContext _context;
        private readonly IMapper _mapper;
        public LastMessageChatRepository(DataContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<LastMessageChat> GetLastMessageChat(string currentUsername, string recipientUsername)
        {
            var lastMessages = await _context.LastMessageChats.FirstOrDefaultAsync(x =>
            x.SenderUsername == currentUsername && x.RecipientUsername == recipientUsername ||
            x.SenderUsername == recipientUsername && x.RecipientUsername == currentUsername);
            return lastMessages;
        }

        /// <summary>
        /// group name = hoainam10th-lisa, containGroupName = hoainam10th
        /// </summary>
        /// <param name="containGroupName"></param>
        /// <returns></returns>
        public async Task<List<LastMessageChatDto>> GetListLastMessageChat(string currentUsername)
        {
            var lastMessages = await _context.LastMessageChats
                .Include(x => x.Sender)
                .Include(x => x.Recipient)
                .Where(x => x.GroupName!.Contains(currentUsername)).ToListAsync();
            return _mapper.Map<List<LastMessageChat>, List<LastMessageChatDto>>(lastMessages);
        }

        public async Task<int> GetUnread(string currentUsername)
        {
            var lastMessages = await _context.LastMessageChats
                .Where(x => x.GroupName!.Contains(currentUsername) && x.IsRead == false).ToListAsync();
            return lastMessages.Count;
        }

        public void Update(LastMessageChat lastMessageChat)
        {
            _context.Entry(lastMessageChat).State = EntityState.Modified;
        }

        public void Add(LastMessageChat lastMessageChat)
        {
            _context.LastMessageChats.Add(lastMessageChat);
        }
    }
}
