using ReactMXHApi6.Dtos;

namespace ReactMXHApi6.Core.Interfaces
{
    public interface IAgoraService
    {
        Task<string> CreateRtcToken(AppSetting setting);
    }
}
