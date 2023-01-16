using ReactMXHApi6.Core.Entities;

namespace ReactMXHApi6.Dtos
{
    public class LastMessageChatDto
    {
        public Guid Id { get; set; }
        public string SenderId { get; set; }
        public string SenderUsername { get; set; }
        public string SenderDisplayName { get; set; }
        public string SenderImgUrl { get; set; }
        public string RecipientId { get; set; }
        public string RecipientUsername { get; set; }
        public string Content { get; set; }
        public DateTime MessageLastDate { get; set; }
        public string GroupName { get; set; }
        public bool IsRead { get; set; } = false;        
    }
}
