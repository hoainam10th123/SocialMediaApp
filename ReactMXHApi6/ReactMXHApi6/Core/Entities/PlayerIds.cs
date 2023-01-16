using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ReactMXHApi6.Core.Entities
{
    public class PlayerIds
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }
        public string PlayerId { get; set; }
        public AppUser User { get; set; }
        public string Username { get; set; }
    }
}
