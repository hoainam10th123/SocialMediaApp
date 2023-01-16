import { HubConnection, HubConnectionBuilder, LogLevel } from "@microsoft/signalr";
import { makeAutoObservable, runInAction } from "mobx";
import { IMessage } from "../models/message";
import { store } from "./stores";

export default class MessageHubStore {
    hubConnection: HubConnection | null = null;
    messages: IMessage[] = [];

    constructor(){
        makeAutoObservable(this);
    }

    createHubConnection = (otherUsername: string) => {
        
        this.hubConnection = new HubConnectionBuilder()
            .withUrl(process.env.REACT_APP_HUB_URL + 'message?user=' + otherUsername, {
                accessTokenFactory: () => store.userStore.user?.token!
            })
            .withAutomaticReconnect()
            .configureLogging(LogLevel.Information)
            .build();

        this.hubConnection.start().catch(error => console.log('Error establishing the connection: ', error));

        this.hubConnection.on('ReceiveMessageThread', (messages: IMessage[]) => {
            runInAction(() => {
                this.messages = messages;
            });
        })

        this.hubConnection.on('NewMessage', (message: IMessage) => {
            runInAction(() => {
                this.messages.push(message);
            });
        })
  
    }

    stopHubConnection = () => {
        this.hubConnection?.stop().catch(error => console.log('Error stopping connection: ', error));
    }

    sendMessage = async (createMessage: any) => {
        try {
            await this.hubConnection?.invoke('SendMessage', createMessage);
        } catch (error) {
            console.log(error);
        }
    }
}