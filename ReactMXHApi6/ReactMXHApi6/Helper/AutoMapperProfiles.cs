using AutoMapper;
using ReactMXHApi6.Core.Entities;
using ReactMXHApi6.Dtos;

namespace ReactMXHApi6.Helper
{
    public class AutoMapperProfiles : Profile
    {

        public AutoMapperProfiles(IConfiguration config)
        {
            CreateMap<LastMessageChat, LastMessageChatDto>()
                .ForMember(dest => dest.SenderDisplayName, opt => opt.MapFrom(src => src.Sender.DisplayName))
                .ForMember(dest => dest.SenderImgUrl, opt => opt.MapFrom(src => src.Sender.ImageUrl != null ? $"{config["BaseUrl"]}/{src.Sender.ImageUrl}" : null));

            CreateMap<AppUser, MemberDto>()
                .ForMember(dest => dest.ImageUrl, opt => opt.MapFrom(src => src.ImageUrl != null ? $"{config["BaseUrl"]}/{src.ImageUrl}" : null));

            CreateMap<Message, MessageDto>()
                .ForMember(dest => dest.SenderDisplayName, opt => opt.MapFrom(src => src.Sender.DisplayName))
                .ForMember(dest => dest.RecipientDisplayName, opt => opt.MapFrom(src => src.Recipient.DisplayName));

            CreateMap<Post, PostDto>()
                .ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.User.UserName))
                .ForMember(dest => dest.DisplayName, opt => opt.MapFrom(src => src.User.DisplayName))
                .ForMember(dest => dest.ImageUrl, opt => opt.MapFrom(src => src.User.ImageUrl != null ? $"{config["BaseUrl"]}/{src.User.ImageUrl}" : null ) );

            CreateMap<Comment, CommentDto>()               
                .ForMember(dest => dest.DisplayName, opt => opt.MapFrom(src => src.User.DisplayName))
                .ForMember(dest => dest.UserImageUrl, opt => opt.MapFrom(src => src.User.ImageUrl != null ? $"{config["BaseUrl"]}/{src.User.ImageUrl}" : null));

            CreateMap<ImageOfPost, ImageOfPostDto>()              
                .ForMember(dest => dest.Path, opt => opt.MapFrom(src => $"{config["BaseUrl"]}/{src.Path}"));
        }
    }
}
