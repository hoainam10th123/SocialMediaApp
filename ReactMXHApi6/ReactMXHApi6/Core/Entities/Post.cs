using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ReactMXHApi6.Core.Entities
{
    public class Post
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }
        public Category Category { get; set; }// This is an issue label, for example "Sell"
        public string NoiDung { get; set; }
        public DateTime Created { get; set; } = DateTime.Now;
        public AppUser User { get; set; }
        public string UserId { get; set; }
        public ICollection<Comment> Comments { get; set; } = new List<Comment>();
        public ICollection<ImageOfPost> Images { get; set; } = new List<ImageOfPost>();        
    }

    public enum Category
    {
        Sell = 0,
        Game,
        Video,
        Default
    }
}
