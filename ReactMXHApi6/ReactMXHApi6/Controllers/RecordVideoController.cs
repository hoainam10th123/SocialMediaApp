using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ReactMXHApi6.Extensions;

namespace ReactMXHApi6.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RecordVideoController : ControllerBase
    {
        [HttpPost]
        public async Task<IActionResult> SaveRecoredFile()
        {
            var formCollection = await Request.ReadFormAsync();
            var files = formCollection.Files;
            if (files.Any())
            {
                var file = files["video-blob"];
                string UploadFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "UploadedRecordFiles");
                string UniqueFileName = $"{User.GetUsername()}_{DateTime.Now.Year}_{DateTime.Now.Day}_{DateTime.Now.Minute}.webm";
                string UploadPath = Path.Combine(UploadFolder, UniqueFileName);

                using (var temp = new FileStream(UploadPath, FileMode.Create))
                {
                    await file.CopyToAsync(temp);// close stream sau khi copy xong do khoi lenh using
                }

                return NoContent();
            }
            else
            {
                return BadRequest("No file created");
            }
        }
    }
}
