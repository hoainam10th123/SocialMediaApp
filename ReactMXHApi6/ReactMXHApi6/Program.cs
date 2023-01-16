
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using ReactMXHApi6;
using ReactMXHApi6.Core.Entities;
using ReactMXHApi6.Extensions;
using ReactMXHApi6.Infrastructure.Data;
using ReactMXHApi6.Middleware;
using ReactMXHApi6.SignalR;

var MyAllowSpecificOrigins = "_myAllowSpecificOrigins";
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddCors(options =>
{
    options.AddPolicy(name: MyAllowSpecificOrigins,
                      builder =>
                      {
                          builder.WithOrigins("http://localhost:3000")
                                      .AllowAnyHeader()
                                      .AllowAnyMethod()
                                      .AllowCredentials();
                      });
});

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddApplicationServices(builder.Configuration);
builder.Services.AddIdentityServices(builder.Configuration);
builder.Services.AddSignalR();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

//Machine learning Train Model and save to file *.zip
//MLStartRun.BuildAndTrainModel(MyTrainerStrategy.OVAAveragedPerceptronTrainer);
//MLStartRun.TestSingleLabelPrediction();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
else if(app.Environment.IsProduction())
{
    app.UseHttpsRedirection();
}

app.UseMiddleware<ExceptionMiddleware>();

//--publish app----
app.UseDefaultFiles();
app.UseStaticFiles();
//-----------------
app.UseRouting();
app.UseCors(MyAllowSpecificOrigins);

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    try
    {
        var context = scope.ServiceProvider.GetRequiredService<DataContext>();
        var userManager = scope.ServiceProvider.GetRequiredService<UserManager<AppUser>>();
        await context.Database.MigrateAsync();
        await Seed.SeedUsers(userManager, context);
    }
    catch (Exception ex)
    {
        app.Logger.LogError(ex, "An error occurred during migration");
    }
}

app.MapHub<PresenceHub>("hubs/presence");
app.MapHub<MessageHub>("hubs/message");
//app.MapFallbackToController("Index", "Fallback");

await app.RunAsync();

