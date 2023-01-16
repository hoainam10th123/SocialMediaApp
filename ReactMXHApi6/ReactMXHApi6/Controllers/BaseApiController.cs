using Microsoft.AspNetCore.Mvc;
using ReactMXHApi6.Core.Interfaces;
using ReactMXHApi6.Helper;

namespace ReactMXHApi6.Controllers
{
    [ServiceFilter(typeof(LogUserActivity))]
    [Route("api/[controller]")]
    [ApiController]
    public class BaseApiController : ControllerBase
    {
        private IUnitOfWork _unitOfWork;

        protected IUnitOfWork UnitOfWork => _unitOfWork ??= HttpContext.RequestServices.GetService<IUnitOfWork>();
    }
}
