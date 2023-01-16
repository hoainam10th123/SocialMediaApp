import { Subject } from 'rxjs';
import { IMember } from '../../models/user';

const subject = new Subject<IMember>();
//de hien thi chatbox nhan tu ham sendMessage cua server (SignalR/MessageHub)
export const messageService = {
    sendMessage: (user: IMember) => subject.next(user),
    getMessage: () => subject.asObservable()
};