using System.ComponentModel.DataAnnotations;

namespace ReactMXHApi6.Dtos
{
    public class LoginDto
    {
        [Required]
        [StringLength(20, MinimumLength = 6)]
        public string Username { get; set; }
        [Required]        
        public string Password { get; set; }
    }
}
