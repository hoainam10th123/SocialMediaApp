using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ReactMXHApi6.Core.Entities;
using ReactMXHApi6.Core.Interfaces;
using ReactMXHApi6.Dtos;
using ReactMXHApi6.Extensions;

namespace ReactMXHApi6.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AccountController : ControllerBase
    {
        private readonly ITokenService _tokenService;
        private readonly UserManager<AppUser> _userManager;
        private readonly SignInManager<AppUser> _signInManager;
        private readonly IConfiguration _config;

        public AccountController(UserManager<AppUser> userManager, 
            SignInManager<AppUser> signInManager, 
            ITokenService tokenService, IConfiguration config)
        {
            _tokenService = tokenService;
            _userManager = userManager;
            _signInManager = signInManager;
            _config = config;
        }

        [HttpPost("login")]
        public async Task<ActionResult<UserDto>> Login(LoginDto loginDto)
        {
            var user = await _userManager.Users
                .SingleOrDefaultAsync(x => x.UserName == loginDto.Username.ToLower());

            if (user == null)
            {
                ModelState.AddModelError("username", "Invalid Username");
                return ValidationProblem();
            }

            var result = await _signInManager.CheckPasswordSignInAsync(user, loginDto.Password, false);

            if (!result.Succeeded)
            {
                ModelState.AddModelError("password", "Invalid password");
                return ValidationProblem();
            }

            return new UserDto
            {
                Id = user.Id,
                DisplayName = user.DisplayName,
                Token = await _tokenService.CreateTokenAsync(user),
                Username = user.UserName,
                ImageUrl = user.ImageUrl != null ? $"{_config["BaseUrl"]}/{user.ImageUrl}" : null,
            };
        }

        [HttpGet]
        public async Task<ActionResult<UserDto>> GetCurrentUser()
        {
            var user = await _userManager.Users.FirstOrDefaultAsync(x => x.UserName == User.GetUsername());
            if (user == null) return BadRequest("CurrentUser == null");
            return new UserDto
            {
                Id = user.Id,
                DisplayName = user.DisplayName,
                Token = await _tokenService.CreateTokenAsync(user),
                Username = user.UserName
            };
        }
    }
}
