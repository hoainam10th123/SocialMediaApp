using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using ReactMXHApi6.Core.Entities;
using ReactMXHApi6.Core.Interfaces;
using ReactMXHApi6.Dtos;

namespace ReactMXHApi6.SignalR
{
    [Authorize]
    public class MessageHub : Hub
    {
        private readonly IMapper _mapper;
        private readonly IHubContext<PresenceHub> _presenceHub;
        private readonly PresenceTracker _presenceTracker;
        private readonly IUnitOfWork _unitOfWork;
        private readonly IOneSignalService _oneSignalService;
        private readonly IConfiguration _config;

        public MessageHub(IMapper mapper, 
            IUnitOfWork unitOfWork, 
            IHubContext<PresenceHub> presenceHub, 
            PresenceTracker presenceTracker, 
            IOneSignalService oneSignalService, IConfiguration config)
        {
            _mapper = mapper;
            _unitOfWork = unitOfWork;
            _presenceTracker = presenceTracker;
            _presenceHub = presenceHub;
            _oneSignalService = oneSignalService;
            _config = config;
        }

        public override async Task OnConnectedAsync()
        {
            var httpContext = Context.GetHttpContext();
            var otherUser = httpContext.Request.Query["user"].ToString();
            var groupName = GetGroupName(Context.User.Identity.Name, otherUser);
            await Groups.AddToGroupAsync(Context.ConnectionId, groupName);
            var group = await AddToGroup(groupName);

            var messages = await _unitOfWork.MessageRepository.GetMessageThread(Context.User.Identity.Name, otherUser);

            await Clients.Caller.SendAsync("ReceiveMessageThread", messages);
        }

        public override async Task OnDisconnectedAsync(Exception exception)
        {
            var group = await RemoveFromMessageGroup();
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, group.Name);
            await base.OnDisconnectedAsync(exception);
        }

        public async Task SendMessage(CreateMessageDto createMessageDto)
        {
            var userName = Context.User.Identity.Name;
            if (userName == createMessageDto.RecipientUsername.ToLower())
                throw new HubException("You cannot send message to yourself");

            var sender = await _unitOfWork.UserRepository.GetUserByUsernameAsync(userName);
            var recipient = await _unitOfWork.UserRepository.GetUserByUsernameAsync(createMessageDto.RecipientUsername);
            if (recipient == null) throw new HubException("Not found user");

            var message = new Message
            {
                Sender = sender,
                Recipient = recipient,
                SenderUsername = sender.UserName,
                RecipientUsername = recipient.UserName,
                Content = createMessageDto.Content
            };
            var groupName = GetGroupName(sender.UserName, recipient.UserName);
            var group = await _unitOfWork.MessageRepository.GetMessageGroup(groupName);

            if (group.Connections.Any(x => x.UserName == recipient.UserName))
            {
                message.DateRead = DateTime.Now;
            }

            _unitOfWork.MessageRepository.AddMessage(message);
            await UpdateLastMessageChat(message);
            if (await _unitOfWork.Complete())
            {
                await Clients.Group(groupName).SendAsync("NewMessage", _mapper.Map<MessageDto>(message));
                var connections = await _presenceTracker.GetConnectionsForUser(createMessageDto.RecipientUsername);
                if(connections != null)
                {
                    var user = await _unitOfWork.UserRepository.GetMemberAsync(userName);
                    // gui tin hieu den RecipientUsername, de hien thi chatbox cua userName gui tin nhan
                    await _presenceHub.Clients.Clients(connections).SendAsync("NewMessageReceived", user, createMessageDto.Content);
                }
                //send push notification to user when chat 1-1
                var toPlayers = await _unitOfWork.OneSignalRepository.GetUserByUsername(createMessageDto.RecipientUsername);
                List<string> strTemp = new List<string>();
                foreach (var connection in toPlayers.PlayerIds)
                {
                    strTemp.Add(connection.PlayerId);
                }

                var toIds = strTemp.ToArray();

                if (toIds.Length > 0)
                {
                    var messageBody = $"😊 {sender.DisplayName} send a message to you";
                    var obj = new
                    {
                        android_channel_id = _config["OneSignal:AndroidChannelId"],
                        app_id = _config["OneSignal:AppId"],
                        headings = new { en = "Social app", es = "Title Spanish Message" },
                        contents = new { en = messageBody, es = "Spanish Message body" },
                        include_player_ids = toIds,
                        name = "INTERNAL_CAMPAIGN_NAME"
                    };
                    await _oneSignalService.CreateNotification(obj);
                }
            }           
        }

        /// <summary>
        /// Add last message chat when has message come on
        /// </summary>
        /// <param name="message"></param>
        private async Task UpdateLastMessageChat(Message message)
        {
            var lastMessageFromDb = await _unitOfWork.LastMessageChatRepository.GetLastMessageChat(message.SenderUsername, message.RecipientUsername);
            if (lastMessageFromDb != null)
            {
                lastMessageFromDb.Content = message.Content;
                lastMessageFromDb.MessageLastDate = message.MessageSent;
                //neu user online thi isRead = true, mac dinh la false
                //if (await _presenceTracker.CheckUsernameIsOnline(message.RecipientUsername!))
                //    lastMessageFromDb.IsRead = true;
                //else
                //    lastMessageFromDb.IsRead = false;
                _unitOfWork.LastMessageChatRepository.Update(lastMessageFromDb);
            }
            else
            {
                var lastMessageChat = new LastMessageChat
                {
                    Content = message.Content,
                    MessageLastDate = message.MessageSent,
                    Sender = message.Sender,
                    Recipient = message.Recipient,
                    SenderUsername = message.SenderUsername,
                    RecipientUsername = message.RecipientUsername,
                    GroupName = GetGroupName(message.SenderUsername!, message.RecipientUsername!)
                };
                //neu user online thi isRead = true, mac dinh la false
                //if (await _presenceTracker.CheckUsernameIsOnline(message.RecipientUsername!))
                //{
                //    lastMessageChat.IsRead = true;
                //}
                _unitOfWork.LastMessageChatRepository.Add(lastMessageChat);
            }
        }

        private string GetGroupName(string caller, string other)
        {
            var stringCompare = string.CompareOrdinal(caller, other) < 0;
            return stringCompare ? $"{caller}-{other}" : $"{other}-{caller}";
        }
        private async Task<Group> AddToGroup(string groupName)
        {
            var group = await _unitOfWork.MessageRepository.GetMessageGroup(groupName);
            var connection = new Connection(Context.ConnectionId, Context.User.Identity.Name);
            if (group == null)
            {
                group = new Group(groupName);
                _unitOfWork.MessageRepository.AddGroup(group);
            }
            group.Connections.Add(connection);

            if (await _unitOfWork.Complete()) return group;

            throw new HubException("Failed to join group");
        }
        private async Task<Group> RemoveFromMessageGroup()
        {
            var group = await _unitOfWork.MessageRepository.GetGroupForConnection(Context.ConnectionId);
            var connection = group.Connections.FirstOrDefault(x => x.ConnectionId == Context.ConnectionId);
            _unitOfWork.MessageRepository.RemoveConnection(connection);

            if (await _unitOfWork.Complete()) return group;

            throw new HubException("Fail to remove from group");
        }
    }
}
