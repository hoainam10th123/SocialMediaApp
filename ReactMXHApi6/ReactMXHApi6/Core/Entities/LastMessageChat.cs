using System.ComponentModel.DataAnnotations;

namespace ReactMXHApi6.Core.Entities
{
    public class LastMessageChat
    {
        [Key]
        public Guid Id { get; set; } = Guid.NewGuid();
        public string SenderId { get; set; }
        public string SenderUsername { get; set; }
        public AppUser Sender { get; set; }
        public string RecipientId { get; set; }
        public string RecipientUsername { get; set; }
        public AppUser Recipient { get; set; }
        public string Content { get; set; }
        public DateTime MessageLastDate { get; set; }
        public string GroupName { get; set; }
        public bool IsRead { get; set; } = false;
    }
}
