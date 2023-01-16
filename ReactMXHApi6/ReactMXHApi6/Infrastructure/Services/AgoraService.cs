using AgoraIO.Media;
using ReactMXHApi6.Core.Interfaces;
using ReactMXHApi6.Dtos;
using ReactMXHApi6.Extensions;

namespace ReactMXHApi6.Infrastructure.Services
{
    public class AgoraService : IAgoraService
    {
        private readonly IConfiguration _config;
        public AgoraService(IConfiguration config)
        {
            _config = config;
        }

        public Task<string> CreateRtcToken(AppSetting setting)
        {
            var token = new AccessToken(_config["AgoraAppSettings:AppId"],
                _config["AgoraAppSettings:AppCertificate"],
                setting.ChannelName,
                setting.Uid);

            token.addPrivilege(Privileges.kJoinChannel, DateTime.Now.AddDays(1).ToDoUInt32DateTime());
            string result = token.build();
            return Task.FromResult(result);
        }
    }
}
