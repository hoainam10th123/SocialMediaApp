using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ReactMXHApi6.Core.Params;

namespace ReactMXHApi6.Controllers
{
    [Authorize]
    public class LastMessageChatsController : BaseApiController
    {
        [HttpGet]
        public async Task<IActionResult> Get([FromQuery] LastMessageChatParams specParams)
        {
            specParams.CurrentUserName = User.Identity.Name;
            var list = await UnitOfWork.LastMessageChatRepository.GetListLastMessageChat(specParams.CurrentUserName);
            return Ok(list);
        }
    }
}
