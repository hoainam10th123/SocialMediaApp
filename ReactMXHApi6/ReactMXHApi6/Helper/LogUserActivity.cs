using Microsoft.AspNetCore.Mvc.Filters;
using ReactMXHApi6.Core.Interfaces;
using ReactMXHApi6.Extensions;

namespace ReactMXHApi6.Helper
{
    public class LogUserActivity : IAsyncActionFilter
    {
        public async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
        {
            var resultContext = await next();

            if (!resultContext.HttpContext.User.Identity.IsAuthenticated) return;

            var userId = resultContext.HttpContext.User.GetUserId();
            var repo = resultContext.HttpContext.RequestServices.GetService<IUnitOfWork>();
            //GetService: Microsoft.Extensions.DependencyInjection in .Net 5
            var user = await repo.UserRepository.GetUserByIdAsync(userId);
            user.LastActive = DateTime.Now;
            await repo.Complete();//add this: services.AddScoped<LogUserActivity>(); [ServiceFilter(typeof(LogUserActivity))] dat truoc controller base
        }
    }
}
