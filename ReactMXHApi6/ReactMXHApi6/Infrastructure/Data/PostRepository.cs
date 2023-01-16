using AutoMapper;
using Microsoft.EntityFrameworkCore;
using ReactMXHApi6.Core.Entities;
using ReactMXHApi6.Core.Interfaces;
using ReactMXHApi6.Core.Params;
using ReactMXHApi6.Dtos;
using ReactMXHApi6.Helper;

namespace ReactMXHApi6.Infrastructure.Data
{
    public class PostRepository: IPostRepository
    {
        private readonly DataContext _context;
        private readonly IMapper _mapper;
        public PostRepository(DataContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<Post> GetPostById(int postId)
        {
            return await _context.Posts.SingleOrDefaultAsync(x=>x.Id == postId);
        }

        public void Add(Post message)
        {
            _context.Posts.Add(message);
        }

        public async Task<Pagination<PostDto>> GetPostsPagination(PostParams postParams)
        {
            var query = _context.Posts
                .Include(x => x.Images)
                .Include(x=>x.User)
                .Include(x=>x.Comments)
                .ThenInclude(x=>x.User)
                .AsQueryable();

            var totalItems = await query.CountAsync();

            var list = await query.Skip((postParams.PageNumber - 1) * postParams.PageSize)
                .Take(postParams.PageSize)
                .ToListAsync();

            var items = _mapper.Map<List<Post>, List<PostDto>>(list);

            return new Pagination<PostDto>(postParams.PageNumber, postParams.PageSize, totalItems, items);
        }
    }
}
