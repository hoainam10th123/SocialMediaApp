using AutoMapper;
using Microsoft.EntityFrameworkCore;
using ReactMXHApi6.Core.Entities;
using ReactMXHApi6.Core.Interfaces;
using ReactMXHApi6.Core.Params;
using ReactMXHApi6.Dtos;
using ReactMXHApi6.Helper;

namespace ReactMXHApi6.Infrastructure.Data
{
    public class CommentRepository : ICommentRepository
    {
        private readonly DataContext _context;
        private readonly IMapper _mapper;
        public CommentRepository(DataContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public void Add(Comment comment)
        {
            _context.Comments.Add(comment);
        }

        public async Task<Pagination<CommentDto>> GetCommentsPagination(CommentParams commentParams)
        {
            var query = _context.Comments.Where(cmt => cmt.PostId == commentParams.PostId)
                .Include(x => x.User)
                .AsQueryable();

            var totalItems = await query.CountAsync();

            var list = await query.Skip((commentParams.PageNumber - 1) * commentParams.PageSize)
                .Take(commentParams.PageSize)
                .ToListAsync();

            var items = _mapper.Map<List<Comment>, List<CommentDto>>(list);

            return new Pagination<CommentDto>(commentParams.PageNumber, commentParams.PageSize, totalItems, items);
        }
    }
}
