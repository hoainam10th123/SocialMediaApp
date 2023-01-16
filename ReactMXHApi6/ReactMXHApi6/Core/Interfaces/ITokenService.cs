using ReactMXHApi6.Core.Entities;

namespace ReactMXHApi6.Core.Interfaces
{
    public interface ITokenService
    {
        Task<string> CreateTokenAsync(AppUser appUser);
    }
}
