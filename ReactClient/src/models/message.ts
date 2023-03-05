export interface IMessage{
    id: string;
    senderId: string;
    senderUsername: string;
    senderPhotoUrl: string;
    senderDisplayName: string;
    recipientId: string;
    recipientUsername: string;
    recipientPhotoUrl: string;
    recipientDisplayName: string;
    content: string;
    dateRead?: Date;
    messageSent: Date;
}