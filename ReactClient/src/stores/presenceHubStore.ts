import { HubConnection, HubConnectionBuilder, LogLevel } from "@microsoft/signalr";
import { makeAutoObservable, runInAction } from "mobx";
import { toast } from "react-toastify";
import { broadcastCommentService } from "../common/services/BroadcastCommentService";
import { callerMessageService } from "../common/services/displayInforCaller";
import { messageService } from "../common/services/messageService";
import { IComment } from "../models/post";
import { IMember, IUser } from "../models/user";
import UserPeer from "../models/userPeer";
import { store } from "./stores";

export default class PresenceHubStore {
    usersOnline: UserPeer[]  = [];
    hubConnection: HubConnection | null = null;
    usernameCalling = '';

    constructor() {
        makeAutoObservable(this);
    }

    createHubConnection = (user: IUser) => {
        this.hubConnection = new HubConnectionBuilder()
            .withUrl(process.env.REACT_APP_HUB_URL + 'presence', {
                accessTokenFactory: () => user.token!
            })
            .withAutomaticReconnect()
            .configureLogging(LogLevel.Information)
            .build();

        this.hubConnection.start().catch(error => console.log('Error establishing the connection: ', error));

        this.hubConnection.on('UserIsOnline', (member : IMember) => {
            runInAction(() => {
                this.usersOnline.push(new UserPeer('', member));
                toast.info(member.displayName +' online');
            });            
        })

        this.hubConnection.on('UserIsOffline', (username: string) => {
            runInAction(() => {
                this.usersOnline = this.usersOnline.filter(x=>x.member?.userName !== username);
                toast.info(username +' offline');
            });            
        })

        this.hubConnection.on('GetOnlineUsers', (users: IMember[]) => {
            runInAction(() => {
                users.forEach(val=>{
                    const tonTai = this.usersOnline.some(x=>x.member?.userName === val.userName);
                    if(!tonTai){
                        this.usersOnline.push(new UserPeer('', val));
                    }                    
                })
            });
        })

        this.hubConnection.on('NewMessageReceived', (member: IMember) => {
            runInAction(() => {
                //de hien thi chatbox cua username send message
                messageService.sendMessage(member);
            });
        })

        // this.hubConnection.on('OnUpdateUserPeer', (user: UserPeer) => {
        //     runInAction(() =>{
        //         const index = this.usersOnline.findIndex(x=>x.member?.userName === user.member?.userName);
        //         if(index !== -1){//da co thi update lai
        //             this.usersOnline[index].peerId = user.peerId;
        //         }else{//chua co
        //             if(store.userStore.user?.username !== user.member?.userName)
        //                 this.usersOnline.push(user);
        //         }
        //     })            
        // })        

        this.hubConnection.on('DisplayInformationCaller', (userCalling: IMember, channelName: string) => {
            runInAction(() =>{
                this.usernameCalling = userCalling.userName;
                store.userStore.channelname = channelName
                callerMessageService.sendMessage(userCalling);//app.tsx
            })            
        })

        this.hubConnection.on('BroadcastComment', (comment: IComment) => {
            runInAction(() => {
                broadcastCommentService.sendComment(comment)// NewFeed.tsx
            });
        })

    }

    stopHubConnection = () => {
        this.hubConnection?.stop().catch(error => console.log('Error stopping connection: ', error));
    }

    updateUserPeer = async (peerId: string)=>{
        try {
            await this.hubConnection?.invoke('UpdateUserPeer', {peerId});
        } catch (error) {
            console.log(error);
        }  
    }

    callToOtherUsername = async (otherUsername: string, channelName: string)=>{
        try {
            await this.hubConnection?.invoke('CallToUsername',  otherUsername, channelName);
        } catch (error) {
            console.log(error);
        }  
    }
}