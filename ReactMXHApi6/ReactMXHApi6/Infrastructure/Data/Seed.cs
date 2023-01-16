using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using ReactMXHApi6.Core.Entities;

namespace ReactMXHApi6.Infrastructure.Data
{
    public class Seed
    {
        public static async Task SeedUsers(UserManager<AppUser> userManager, DataContext context)
        {
            if (!await context.Posts.AnyAsync())
            {
                if (!await userManager.Users.AnyAsync())
                {
                    var users = new List<AppUser> {
                        new AppUser { 
                            UserName = "hoainam10th", 
                            DisplayName = "Nguyễn Hoài Nam", 
                            ImageUrl = "images/post2.jpg"
                        },
                        new AppUser{ UserName="ubuntu", DisplayName = "Ubuntu Nguyễn", ImageUrl = "images/post2.jpg"},
                        new AppUser{UserName="lisa", DisplayName = "Lisa" },
                        new AppUser{UserName="phathuong", DisplayName = "Phat Huong", ImageUrl = "images/user3.jpg" },
                        new AppUser{UserName="dat", DisplayName = "Nguyen Dat" },
                        new AppUser{UserName="datnguyen", DisplayName = "Nguyen Dat Phat", ImageUrl = "images/user3.jpg" },
                        new AppUser{UserName="datnguyen05", DisplayName = "Nguyen Thi Phat" },
                        new AppUser{UserName="tananlx", DisplayName = "Nguyen Tan An" },
                        new AppUser{UserName="datnguyen01", DisplayName = "Nguyen Dat Phat" },
                        new AppUser{UserName="hoaray", DisplayName = "Nguyen Thi Hoa Ray" },
                    };

                    foreach (var user in users)
                    {
                        await userManager.CreateAsync(user, "123456");
                    }
                }

                var posts = new List<Post>
                {
                    new Post{
                        NoiDung="01 Chung ta khong thuoc ve nhau." +
                        "Chung ta khong la cua nhau. Nu cuoi da mat, giot nuoc mat",
                        UserId = userManager.Users.FirstOrDefault().Id,
                    },
                    new Post{
                        NoiDung="02 Chung ta khong thuoc ve nhau." +
                        "Chung ta khong la cua nhau. Nu cuoi da mat, giot nuoc mat",
                        UserId = userManager.Users.FirstOrDefault().Id,
                    },
                    new Post{
                        NoiDung="03 Chung ta khong thuoc ve nhau." +
                        "Chung ta khong la cua nhau. Nu cuoi da mat, giot nuoc mat",
                        UserId = userManager.Users.FirstOrDefault().Id,
                    },
                    new Post{
                        NoiDung="04 Chung ta khong thuoc ve nhau." +
                        "Chung ta khong la cua nhau. Nu cuoi da mat, giot nuoc mat",
                        UserId = userManager.Users.FirstOrDefault().Id,
                    },                    
                    new Post{
                        NoiDung="05 Chung ta khong thuoc ve nhau." +
                        "Chung ta khong la cua nhau. Nu cuoi da mat, giot nuoc mat",
                        UserId = userManager.Users.FirstOrDefault().Id,
                    },
                    new Post{
                        NoiDung="06 Chung ta khong thuoc ve nhau." +
                        "Chung ta khong la cua nhau. Nu cuoi da mat, giot nuoc mat",
                        UserId = userManager.Users.FirstOrDefault().Id,
                    },new Post{
                        NoiDung="07 Chung ta khong thuoc ve nhau." +
                        "Chung ta khong la cua nhau. Nu cuoi da mat, giot nuoc mat",
                        UserId = userManager.Users.FirstOrDefault().Id,
                    },new Post{
                        NoiDung="08 Chung ta khong thuoc ve nhau." +
                        "Chung ta khong la cua nhau. Nu cuoi da mat, giot nuoc mat",
                        UserId = userManager.Users.FirstOrDefault().Id,
                    },
                    new Post{
                        NoiDung="09 Chung ta khong thuoc ve nhau." +
                        "Chung ta khong la cua nhau. Nu cuoi da mat, giot nuoc mat",
                        UserId = userManager.Users.FirstOrDefault().Id,
                    },
                    new Post{
                        NoiDung="10 Chung ta khong thuoc ve nhau." +
                        "Chung ta khong la cua nhau. Nu cuoi da mat, giot nuoc mat",
                        UserId = userManager.Users.FirstOrDefault().Id,
                    },
                    new Post{
                        NoiDung="11 Chung ta khong thuoc ve nhau." +
                        "Chung ta khong la cua nhau. Nu cuoi da mat, giot nuoc mat",
                        UserId = userManager.Users.FirstOrDefault().Id,
                    },
                    new Post{
                        NoiDung="12 Chung ta khong thuoc ve nhau." +
                        "Chung ta khong la cua nhau. Nu cuoi da mat, giot nuoc mat",
                        UserId = userManager.Users.FirstOrDefault().Id,
                    },
                    new Post{
                        NoiDung="13 Chung ta khong thuoc ve nhau." +
                        "Chung ta khong la cua nhau. Nu cuoi da mat, giot nuoc mat",
                        UserId = userManager.Users.FirstOrDefault().Id,
                    },
                    new Post{
                        NoiDung="14 Chung ta khong thuoc ve nhau." +
                        "Chung ta khong la cua nhau. Nu cuoi da mat, giot nuoc mat",
                        UserId = userManager.Users.FirstOrDefault().Id,
                    },new Post{
                        NoiDung="15 Chung ta khong thuoc ve nhau." +
                        "Chung ta khong la cua nhau. Nu cuoi da mat, giot nuoc mat",
                        UserId = userManager.Users.FirstOrDefault().Id,
                    },new Post{
                        NoiDung="16 Chung ta khong thuoc ve nhau." +
                        "Chung ta khong la cua nhau. Nu cuoi da mat, giot nuoc mat",
                        UserId = userManager.Users.FirstOrDefault().Id,
                    },new Post{
                        NoiDung="17 Chung ta khong thuoc ve nhau." +
                        "Chung ta khong la cua nhau. Nu cuoi da mat, giot nuoc mat",
                        UserId = userManager.Users.FirstOrDefault().Id,
                    },new Post{
                        NoiDung="18 Chung ta khong thuoc ve nhau." +
                        "Chung ta khong la cua nhau. Nu cuoi da mat, giot nuoc mat",
                        UserId = userManager.Users.FirstOrDefault().Id,
                    },
                    new Post{
                        NoiDung="19 Chung ta khong thuoc ve nhau." +
                        "Chung ta khong la cua nhau. Nu cuoi da mat, giot nuoc mat",
                        UserId = userManager.Users.FirstOrDefault().Id,
                    },
                    new Post{
                        NoiDung="20 Chung ta khong thuoc ve nhau." +
                        "Chung ta khong la cua nhau. Nu cuoi da mat, giot nuoc mat",
                        UserId = userManager.Users.FirstOrDefault().Id,
                    }
                };

                context.Posts.AddRange(posts);

                await context.SaveChangesAsync();
            }                      
        }
    }
}
