
namespace ReactMXHApi6.Dtos
{
    public class CommentDto
    {
        public int Id { get; set; }
        public string NoiDung { get; set; }
        public DateTime Created { get; set; }
        public string UserId { get; set; }
        public string DisplayName { get; set; }
        public string UserImageUrl { get; set; }
        public int PostId { get; set; }
    }
}
