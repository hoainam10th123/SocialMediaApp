namespace ReactMXHApi6.Dtos
{
    public class ResultOneSignal
    {
        public ResultOneSignal(int statusCode, string content)
        {
            StatusCode = statusCode;
            Content = content;
        }
        public int StatusCode { get; set; }
        public string Content { get; set; }
    }
}
