using AutoMapper;
using Microsoft.EntityFrameworkCore;
using ReactMXHApi6.Core.Interfaces;
using ReactMXHApi6.Helper;
using ReactMXHApi6.Infrastructure.Data;
using ReactMXHApi6.Infrastructure.Services;
using ReactMXHApi6.SignalR;

namespace ReactMXHApi6.Extensions
{
    public static class ApplicationServiceExtensions
    {
        public static IServiceCollection AddApplicationServices(this IServiceCollection services, IConfiguration config)
        {
            services.AddSingleton<PresenceTracker>();
            services.AddScoped<IUnitOfWork, UnitOfWork>();
            services.AddScoped<ITokenService, TokenService>();
            services.AddScoped<IOneSignalService, OneSignalService>();
            services.AddScoped<IAgoraService, AgoraService>();
            services.AddScoped<LogUserActivity>();

            services.AddAutoMapper(typeof(AutoMapperProfiles).Assembly);
            // AutoMapper with params DI
            services.AddSingleton(provider => new MapperConfiguration(cfg =>
            {
                cfg.AddProfile(new AutoMapperProfiles(provider.CreateScope().ServiceProvider.GetService<IConfiguration>()));

            }).CreateMapper());

            services.AddDbContext<DataContext>(options =>
            {
                options.UseSqlServer(config.GetConnectionString("DefaultConnection"));
            });

            return services;
        }
    }
}
