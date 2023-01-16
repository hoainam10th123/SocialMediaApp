export interface IUser {
    id: string;
    username: string;
    displayName: string;
    token: string;
    imageUrl: string;
}

export interface UserLogin {
    password: string;
    username: string;
}

export interface IMember {
    userName: string;
    displayName: string;
    lastActive?: Date | null;
    photoUrl?: string | null;
    right?: number;
}

export class Member implements IMember{
    userName = '';
    displayName = '';
    lastActive = null;
    photoUrl = null;
    right = 0;
    
    constructor(username: string, displayName: string, right: number){
        this.userName = username;
        this.displayName = displayName;
        this.right = right;
    }
}