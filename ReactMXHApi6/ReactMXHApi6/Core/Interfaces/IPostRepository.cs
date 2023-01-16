using ReactMXHApi6.Core.Entities;
using ReactMXHApi6.Core.Params;
using ReactMXHApi6.Dtos;
using ReactMXHApi6.Helper;

namespace ReactMXHApi6.Core.Interfaces
{
    public interface IPostRepository
    {
        void Add(Post message);
        Task<Post> GetPostById(int postId);
        Task<Pagination<PostDto>> GetPostsPagination(PostParams postParams);
    }
}
