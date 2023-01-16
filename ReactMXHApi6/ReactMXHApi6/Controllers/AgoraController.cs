using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ReactMXHApi6.Core.Interfaces;
using ReactMXHApi6.Dtos;

namespace ReactMXHApi6.Controllers
{
    //[Authorize]
    public class AgoraController : BaseApiController
    {
        private readonly IAgoraService _agoraService;
        public AgoraController(IAgoraService agoraService)
        {
            _agoraService = agoraService;
        }

        [HttpPost("get-rtc-token")]
        public async Task<IActionResult> GetRtcToken(AppSetting setting)
        {
            var token = await _agoraService.CreateRtcToken(setting);
            return Ok(new { token });
        }
    }
}
