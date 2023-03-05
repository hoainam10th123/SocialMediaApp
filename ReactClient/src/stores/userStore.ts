import { makeAutoObservable, reaction } from "mobx";
import agent from "../api/agent";
import { IUser, UserLogin } from "../models/user";
import { router } from "../router/Routes";
import { store } from "./stores";

export default class UserStore {
    user: IUser | null = JSON.parse(localStorage.getItem('user')!);
    appLoaded = false;
    channelname: String | null = null

    constructor() {
        makeAutoObservable(this);

        reaction(
            () => this.user,
            user => {
                if (user) {
                    localStorage.setItem('user', JSON.stringify(user))
                } else {
                    localStorage.removeItem('user')
                }
            }
        )
    }

    get isLoggedIn() {
        return !!this.user;
    }

    setChannel = (channelName: String | null) => {
        this.channelname = channelName
    }

    login = async (creds: UserLogin) => {
        try {
            const user = await agent.Account.login(creds);
            this.setUser(user);
            store.presenceHubStore.createHubConnection(user);
            router.navigate('/new-feed');
        } catch (error) {
            throw error;
        }
    }

    logout = () => {
        this.setUser(null);
        store.presenceHubStore.stopHubConnection();
        router.navigate('/');
    }

    getUser = async () => {
        try {            
            const user = JSON.parse(window.localStorage.getItem('user')!);
            if(!user) await agent.Account.current();            
            this.setUser(user);
        } catch (error) {
            console.log(error);
        }
    }

    setUser = (user: IUser | null) => {
        this.user = user;
    }

    setAppLoaded = () => {
        this.appLoaded = true;
    }
}