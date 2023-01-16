using ReactMXHApi6.Core.Interfaces;
using ReactMXHApi6.Dtos;
using RestSharp;
using System.Text.Json;

namespace ReactMXHApi6.Infrastructure.Services
{
    public class OneSignalService : IOneSignalService
    {
        private readonly IConfiguration _config;
        public OneSignalService(IConfiguration config)
        {
            _config = config;
        }

        /// <summary>
        /// Sends notifications to your users
        /// </summary>
        /// <param name="body">include_player_ids = string[], contents: object, name = INTERNAL_CAMPAIGN_NAME </param>
        /// <returns>ResultOneSignal</returns>
        public Task<ResultOneSignal> CreateNotification(object body)
        {
            var json = JsonSerializer.Serialize(body);
            var client = new RestClient("https://onesignal.com/api/v1/notifications");
            var request = new RestRequest("", Method.Post);
            request.AddHeader("Accept", "application/json");
            request.AddHeader("Authorization", $"Basic {_config["OneSignal:RestAPI"]}");
            request.AddHeader("Content-Type", "application/json");
            request.AddParameter("application/json", json, ParameterType.RequestBody);
            var response = client.Execute(request);

            return Task.FromResult(new ResultOneSignal((int)response.StatusCode, response.Content!));
        }
    }
}
