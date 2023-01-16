namespace ReactMXHApi6.Helper
{
    public class Pagination<T> where T : class
    {
        public Pagination(int pageNumber, int pageSize, int count, IReadOnlyList<T> data)
        {
            PageNumber = pageNumber;
            PageSize = pageSize;
            Count = count;
            TotalPages = (int)Math.Ceiling(count / (double)pageSize);
            Data = data;
        }
        public int TotalPages { get; set; }
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
        public int Count { get; set; }
        public IReadOnlyList<T> Data { get; set; }
    }
}
