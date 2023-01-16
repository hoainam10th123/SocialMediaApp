using ReactMXHApi6.Core.Entities;

namespace ReactMXHApi6.Dtos
{
    public class PostDto
    {
        public int Id { get; set; }
        public string NoiDung { get; set; }
        public DateTime Created { get; set; }
        public ICollection<CommentDto> Comments { get; set; }
        public ICollection<ImageOfPostDto> Images { get; set; }
        public string UserName { get; set; }
        public string DisplayName { get; set; }
        public string ImageUrl { get; set; }
        public Category Category { get; set; }// This is an issue label, for example "Sell"
    }
}
