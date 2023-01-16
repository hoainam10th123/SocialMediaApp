namespace ReactMXHApi6.Dtos
{
    public class MemberDto
    {
        public string UserName { get; set; }
        public string DisplayName { get; set; }
        public DateTime LastActive { get; set; }
        public string ImageUrl { get; set; }
        public int UnReadMessageCount { get; set; } = 0;
    }
}
