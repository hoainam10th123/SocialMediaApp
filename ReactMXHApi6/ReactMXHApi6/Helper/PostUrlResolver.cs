using AutoMapper;
using ReactMXHApi6.Core.Entities;
using ReactMXHApi6.Dtos;

namespace ReactMXHApi6.Helper
{
    //khong su dung class nay
    public class PostUrlResolver : IValueResolver<AppUser, PostDto, string>
    {
        private readonly IConfiguration _config;
        public PostUrlResolver(IConfiguration config)
        {
            _config = config;
        }

        public string Resolve(AppUser source, PostDto destination, string destMember, ResolutionContext context)
        {
            if (!string.IsNullOrEmpty(source.ImageUrl))
            {
                return _config["BaseUrl"] + source.ImageUrl;
            }

            return null;
        }
    }
}
