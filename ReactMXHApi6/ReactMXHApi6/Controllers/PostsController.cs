using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using ReactMXHApi6.Core.Entities;
using ReactMXHApi6.Core.Params;
using ReactMXHApi6.Dtos;
using ReactMXHApi6.Extensions;
using ReactMXHApi6.MLDataStructures;
using ReactMXHApi6.SignalR;

namespace ReactMXHApi6.Controllers
{
    [Authorize]
    public class PostsController : BaseApiController
    {
        private readonly IHubContext<PresenceHub> _presenceHub;
        private readonly IMapper _mapper;

        public PostsController(IHubContext<PresenceHub> presenceHub, IMapper mapper)
        {
            _presenceHub = presenceHub;
            _mapper = mapper;
        }

        [HttpPost]
        public async Task<IActionResult> AddPost()
        {
            var listImages = new List<ImageOfPost>();
            var contentValue = Request.Form.FirstOrDefault(x => x.Key == "content").Value.ToString();

            if (Request.ContentLength > 0)
            {
                var formCollection = await Request.ReadFormAsync();
                var files = formCollection.Files;
                if (files.Any())
                {
                    foreach (var file in files)
                    {
                        string uploadFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "images");
                        string uploadPath = Path.Combine(uploadFolder, file.FileName);
                        // close stream sau khi copy xong do khoi lenh using
                        using (var temp = new FileStream(uploadPath, FileMode.Create))
                        {
                            listImages.Add(new ImageOfPost { Path = "images/" + file.FileName });
                            await file.CopyToAsync(temp);
                        }
                    }
                }
            }
            // bai viet co noi dung
            if (!string.IsNullOrEmpty(contentValue))
            {
                var user = await UnitOfWork.UserRepository.GetUserByIdAsync(User.GetUserId());
                //ML Prediction category
                var labeler = new Labeler(MLStartRun.ModelPath);
                var category = labeler.TestPredictionForSingleIssue(new PostData { Id = "any-Id", NoiDung = contentValue });

                var post = new Post
                {
                    NoiDung = contentValue,
                    UserId = User.GetUserId(),
                    User = user,
                    Images = listImages,
                    Category = category,
                };

                UnitOfWork.PostRepository.Add(post);
                if (await UnitOfWork.Complete())
                {
                    await _presenceHub.Clients.All.SendAsync("SendPostToAllClient", _mapper.Map<PostDto>(post));
                    return Ok(new { status = 200 });// test return with data= {"status":200}
                }         
                else
                    return BadRequest("Error while add post");
            }
            else// bai viet khong co noi dung
            {
                var user = await UnitOfWork.UserRepository.GetUserByIdAsync(User.GetUserId());                

                var post = new Post
                {
                    UserId = User.GetUserId(),
                    User = user,
                    Images = listImages,
                    Category = Category.Default,
                };

                UnitOfWork.PostRepository.Add(post);
                if (await UnitOfWork.Complete())
                {
                    await _presenceHub.Clients.All.SendAsync("SendPostToAllClient", _mapper.Map<PostDto>(post));
                    return Ok(new { status = 200 });
                }
                else
                    return BadRequest("Error while add post");
            }
        }

        [HttpGet]
        // api/posts?pageNumber=1&pageSize=5
        public async Task<IActionResult> Get([FromQuery] PostParams specParams)
        {            
            return Ok(await UnitOfWork.PostRepository.GetPostsPagination(specParams));
        }
    }
}
