import { HubConnection, HubConnectionBuilder, LogLevel } from "@microsoft/signalr";
import { makeAutoObservable, runInAction } from "mobx";
import { store } from "./stores";

export default class GroupVideoCallHubStore {
    hubConnection: HubConnection | null = null;

    constructor() {
        makeAutoObservable(this);
    }

    createHubConnection = (otherUsername: string) => {
        
        this.hubConnection = new HubConnectionBuilder()
            .withUrl(process.env.REACT_APP_HUB_URL + 'groupvideo?user=' + otherUsername, {
                accessTokenFactory: () => store.userStore.user?.token!
            })
            .withAutomaticReconnect()
            .configureLogging(LogLevel.Information)
            .build();

        this.hubConnection.start().catch(error => console.log('Error establishing the connection: ', error));

        this.hubConnection.on('ReceiveMessageThread', (messages ) => {
            runInAction(() => {
                
            });
        })

        this.hubConnection.on('NewMessage', (message ) => {
            runInAction(() => {
                
            });
        })
  
    }

    stopHubConnection = () => {
        this.hubConnection?.stop().catch(error => console.log('Error stopping connection: ', error));
    }
}