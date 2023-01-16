import { Subject } from 'rxjs';
import { IMember } from '../../models/user';

const subject = new Subject<IMember>();
// dung de hien thi hop thoai cuoc goi den, dat tai app.tsx
export const callerMessageService = {
    sendMessage: (user: IMember) => subject.next(user),
    getMessage: () => subject.asObservable()
};