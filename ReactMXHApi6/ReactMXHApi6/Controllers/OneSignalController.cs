using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ReactMXHApi6.Core.Entities;
using ReactMXHApi6.Core.Interfaces;

namespace ReactMXHApi6.Controllers
{
    [Authorize]
    public class OneSignalController : BaseApiController
    {
        private readonly IOneSignalService _oneSignalService;
        public OneSignalController(IOneSignalService oneSignalService)
        {
            _oneSignalService = oneSignalService;
        }

        [HttpPost("send-notification")]
        public async Task<IActionResult> SendNotitfication(object param)
        {
            return Ok(await _oneSignalService.CreateNotification(param));
        }

        [HttpPost("post-player-id/{id}")]
        public async Task<IActionResult> SendNotitfication(string id)
        {
            if (!string.IsNullOrEmpty(id) || id != "null")
            {
                var existPlayers = await UnitOfWork.OneSignalRepository.GetUserByUsername(User.Identity.Name);
                if (existPlayers != null)
                {
                    var isExist = existPlayers.PlayerIds.SingleOrDefault(x => x.PlayerId == id);

                    if (isExist == null)
                    {
                        var currentUser = await UnitOfWork.UserRepository.GetUserByUsernameAsync(User.Identity.Name);
                        var player = new PlayerIds { PlayerId = id, User = currentUser, Username = User.Identity.Name };
                        UnitOfWork.OneSignalRepository.AddPlayerId(player);
                        await UnitOfWork.Complete();
                    }
                }
            }            

            return NoContent();
        }
    }
}
