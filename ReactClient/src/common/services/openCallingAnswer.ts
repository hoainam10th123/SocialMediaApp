import { Subject } from 'rxjs';

const subject = new Subject<boolean>();
//hien thi hop thoai Chat video 1-1
export const openCallingAnswerService = {
    sendMessage: (val: boolean) => subject.next(val),
    getMessage: () => subject.asObservable()
};