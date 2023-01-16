using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using ReactMXHApi6.Core.Entities;

namespace ReactMXHApi6.Infrastructure.Data
{
    public class DataContext : IdentityDbContext<AppUser>
    {
        public DataContext(DbContextOptions options) : base(options) { }

        public DbSet<Post> Posts { get; set; }
        public DbSet<Comment> Comments { get; set; }
        public DbSet<Group> Groups { get; set; }
        public DbSet<Connection> Connections { get; set; }
        public DbSet<Message> Messages { get; set; }
        public DbSet<LastMessageChat> LastMessageChats { get; set; }
        public DbSet<PlayerIds> PlayerIds { get; set; }
        public DbSet<ImageOfPost> ImageOfPosts { get; set; }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            builder.Entity<Message>()
                .HasOne(u => u.Recipient)
                .WithMany(m => m.MessagesReceived)
                .HasForeignKey(u => u.RecipientId)
                .OnDelete(DeleteBehavior.Restrict);

            builder.Entity<Message>()
                .HasOne(u => u.Sender)
                .WithMany(m => m.MessagesSent)
                .HasForeignKey(u=> u.SenderId)
                .OnDelete(DeleteBehavior.Restrict);

            //Quan hệ 1-n, bảng Post và AppUser
            builder.Entity<Post>()
                .HasOne(p => p.User)
                .WithMany(u => u.Posts)
                .HasForeignKey(p => p.UserId);

            // 1 user có nhiều comment. 1-n
            builder.Entity<Comment>()
                .HasOne(p => p.User)
                .WithMany(u => u.Comments)
                .HasForeignKey(p => p.UserId);

            builder.Entity<Comment>()
                .HasOne(p => p.Post)
                .WithMany(u => u.Comments)
                .HasForeignKey(p => p.PostId);

            builder.Entity<LastMessageChat>()
                .HasOne(u => u.Recipient)
                .WithMany(m => m.LastMessageChatsReceived)
                .HasForeignKey(u => u.RecipientId)
                .OnDelete(DeleteBehavior.Restrict);

            builder.Entity<LastMessageChat>()
                .HasOne(u => u.Sender)
                .WithMany(m => m.LastMessageChatsSent)
                .HasForeignKey(u => u.SenderId)
                .OnDelete(DeleteBehavior.Restrict);
        }
    }
}
