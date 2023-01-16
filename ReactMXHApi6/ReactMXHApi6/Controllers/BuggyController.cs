using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ReactMXHApi6.Dtos;

namespace ReactMXHApi6.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BuggyController : ControllerBase
    {
        [HttpGet("not-found")]
        public ActionResult GetNotFound()
        {
            return NotFound();
        }

        [HttpGet("bad-request")]
        public ActionResult GetBadRequest()
        {
            return BadRequest("You have a bad request");
        }

        [HttpGet("server-error")]
        public ActionResult GetServerError()
        {
            throw new Exception("This is a server error");
        }

        [HttpGet("unauthorised")]
        public ActionResult GetUnauthorised()
        {
            return Unauthorized();
        }

        [HttpPost("validation-error")]
        public ActionResult GetValidationError(LoginDto loginDto)
        {
            return Ok();
        }
    }
}
