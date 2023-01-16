using ReactMXHApi6.Core.Entities;
using ReactMXHApi6.Core.Params;
using ReactMXHApi6.Dtos;
using ReactMXHApi6.Helper;

namespace ReactMXHApi6.Core.Interfaces
{
    public interface ICommentRepository
    {
        void Add(Comment comment);
        Task<Pagination<CommentDto>> GetCommentsPagination(CommentParams commentParams);
    }
}
