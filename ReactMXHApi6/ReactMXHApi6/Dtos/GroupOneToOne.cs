namespace ReactMXHApi6.Dtos
{
    public class GroupOneToOne
    {
        public string GroupName { get; set; }
        public string[] UserInGroups { get; set; } //only 2 username in a group
    }
}
