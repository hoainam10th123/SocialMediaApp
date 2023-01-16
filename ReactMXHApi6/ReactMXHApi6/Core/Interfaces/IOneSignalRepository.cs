using ReactMXHApi6.Core.Entities;

namespace ReactMXHApi6.Core.Interfaces
{
    public interface IOneSignalRepository
    {
        void AddPlayerId(PlayerIds player);
        Task<AppUser> GetUserByUsername(string username);
    }
}
