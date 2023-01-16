using ReactMXHApi6.Core.Entities;
using ReactMXHApi6.Dtos;

namespace ReactMXHApi6.Core.Interfaces
{
    public interface IUserRepository
    {
        Task<AppUser> GetUserByUsernameAsync(string username);
        Task<AppUser> GetUserByIdAsync(string id);
        Task<MemberDto> GetMemberAsync(string username);
        Task<List<MemberDto>> GetUsersOnlineAsync(string currentUsername, string[] userOnline);
    }
}
