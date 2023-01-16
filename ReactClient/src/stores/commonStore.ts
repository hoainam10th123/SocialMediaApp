import { makeAutoObservable } from "mobx";
import { ServerError } from "../models/serverError";

export default class CommonStore {
    error: ServerError | null = null;
    hide = false;

    constructor() {
        makeAutoObservable(this);
    }
    
    setServerError = (error: ServerError) => {
        this.error = error;
    }

    toogleHide = () =>{
        this.hide = !this.hide;
    }
}