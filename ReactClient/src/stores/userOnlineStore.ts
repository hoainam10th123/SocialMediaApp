import { makeAutoObservable, reaction, runInAction } from "mobx";
import { IMember, Member } from "../models/user";

export default class UserOnlineStore {
    userChatBox: IMember[] = [];
    miniChatBox: IMember[] = [];

    constructor() {
        makeAutoObservable(this);
        reaction(
            () => this.userChatBox,
            () => {
                this.calculateRightPositionChatBox();
            }
        )
    }

    setUserChatBox = (members: IMember[])=>{
        this.userChatBox = members;
    }

    calculateRightPositionChatBox = () =>{
        if(this.userChatBox)
            this.userChatBox.forEach((user, index) =>{
                if(index % 2 === 0){
                    user.right = 250;
                }else{
                    user.right = 250 + 325;
                }
            })
        else this.userChatBox = [];
    }

    addMiniChatBox= (user: IMember) => {
        this.miniChatBox.push(user);
        this.userChatBox = this.userChatBox.filter(x=>x.userName !== user.userName);
    }

    restoreMiniChatBox = (user: IMember)=>{
        this.miniChatBox = this.miniChatBox.filter(x=>x.userName !== user.userName);
        this.addUserChatBox(user);        
    }

    removeMiniChatBox = (username: string) => {
        this.miniChatBox = this.miniChatBox.filter(x=>x.userName !== username);
    }

    get UserChatBox(){
        return this.userChatBox;
    }

    addUserChatBox = (user: IMember) => {
        switch ((this.UserChatBox.length + 1) % 2) {
            case 0:
                runInAction(() =>{
                    const tonTai = this.userChatBox.some(x=>x.userName === user.userName);
                    if(!tonTai){
                        this.userChatBox.push(new Member(user.userName, user.displayName, 250 + 325));
                        localStorage.setItem('chatboxusers', JSON.stringify(this.userChatBox)); 
                    }                                      
                })                
                break;
            case 1:
                runInAction(() =>{
                    const tonTai = this.userChatBox.some(x=>x.userName === user.userName);
                    if(!tonTai){
                        this.userChatBox.push(new Member(user.userName, user.displayName, 250));
                        localStorage.setItem('chatboxusers', JSON.stringify(this.userChatBox)); 
                    }
                })                
                break;
        }
    }

    removeUserChatBox = (username: string) => {
        this.userChatBox = this.userChatBox.filter(x => x.userName !== username);
        localStorage.setItem('chatboxusers', JSON.stringify(this.userChatBox));      
    }
}