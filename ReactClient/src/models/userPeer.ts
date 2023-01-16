import { IMember } from "./user";

export default class UserPeer {
    peerId: string = '';
    member: IMember | null = null;
    
    constructor(id: string, member: IMember){
        this.peerId = id;
        this.member = member;
    }
}