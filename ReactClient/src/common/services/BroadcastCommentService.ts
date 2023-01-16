import { Subject } from 'rxjs';
import { IComment } from '../../models/post';

const subject = new Subject<IComment>();
//hien thi comment ngoai ui new-feed
export const broadcastCommentService = {
    sendComment: (val: IComment) => subject.next(val),
    getComment: () => subject.asObservable()
};