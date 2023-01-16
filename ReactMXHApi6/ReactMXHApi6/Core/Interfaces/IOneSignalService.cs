using ReactMXHApi6.Dtos;

namespace ReactMXHApi6.Core.Interfaces
{
    public interface IOneSignalService
    {
        Task<ResultOneSignal> CreateNotification(object body);
    }
}
