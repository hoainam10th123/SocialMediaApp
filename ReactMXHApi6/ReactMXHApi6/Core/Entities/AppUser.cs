using Microsoft.AspNetCore.Identity;

namespace ReactMXHApi6.Core.Entities
{
    public class AppUser : IdentityUser
    {
        public string DisplayName { get; set; }
        public string ImageUrl { get; set; }
        public DateTime LastActive { get; set; } = DateTime.Now;
        public ICollection<Post> Posts { get; set; } = new List<Post>();
        public ICollection<Comment> Comments { get; set; } = new List<Comment>();
        public ICollection<Message> MessagesSent { get; set; }
        public ICollection<Message> MessagesReceived { get; set; }
        public ICollection<LastMessageChat> LastMessageChatsSent { get; set; }
        public ICollection<LastMessageChat> LastMessageChatsReceived { get; set; }
        public ICollection<PlayerIds> PlayerIds { get; set; } = new List<PlayerIds>();
    }
}
