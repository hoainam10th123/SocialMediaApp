using Force.Crc32;

namespace AgoraIO.Media
{
    public class AccessToken
    {
        private string _appId;
        private string _appCertificate;
        private string _channelName;
        private string _uid;
        private uint _ts;
        private uint _salt;
        private byte[] _signature;
        private uint _crcChannelName;
        private uint _crcUid;
        private byte[] _messageRawContent;
        public PrivilegeMessage message = new PrivilegeMessage();

        public AccessToken(string appId, string appCertificate, string channelName, string uid)
        {
            _appId = appId;
            _appCertificate = appCertificate;
            _channelName = channelName;
            _uid = uid;
        }

        public AccessToken(string appId, string appCertificate, string channelName, string uid, uint ts, uint salt)
        {
            _appId = appId;
            _appCertificate = appCertificate;
            _channelName = channelName;
            _uid = uid;
            _ts = ts;
            _salt = salt;
        }

        public void addPrivilege(Privileges kJoinChannel, uint expiredTs)
        {
            message.messages.Add((ushort)kJoinChannel, expiredTs);
        }

        public string build()
        {
            //if (!Utils.isUUID(this.appId))
            //{
            //    return "";
            //}

            //if (!Utils.isUUID(this.appCertificate))
            //{
            //    return "";
            //}

            _messageRawContent = Utils.pack(message);
            _signature = generateSignature(_appCertificate
                    , _appId
                    , _channelName
                    , _uid
                    , _messageRawContent);

            _crcChannelName = Crc32Algorithm.Compute(_channelName.GetByteArray());
            _crcUid = Crc32Algorithm.Compute(_uid.GetByteArray());

            PackContent packContent = new PackContent(_signature, _crcChannelName, _crcUid, _messageRawContent);
            byte[] content = Utils.pack(packContent);
            return getVersion() + _appId + Utils.base64Encode(content);
        }
        public static String getVersion()
        {
            return "006";
        }

        public static byte[] generateSignature(String appCertificate
                , String appID
                , String channelName
                , String uid
                , byte[] message)
        {

            using (var ms = new MemoryStream())
            using (BinaryWriter baos = new BinaryWriter(ms))
            {
                baos.Write(appID.GetByteArray());
                baos.Write(channelName.GetByteArray());
                baos.Write(uid.GetByteArray());
                baos.Write(message);
                baos.Flush();

                byte[] sign = DynamicKeyUtil.encodeHMAC(appCertificate, ms.ToArray(), "SHA256");
                return sign;
            }
        }
    }
}
