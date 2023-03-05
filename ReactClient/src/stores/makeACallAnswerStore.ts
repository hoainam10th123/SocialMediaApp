import { makeAutoObservable } from "mobx";

export default class ModalMakeACallAnswerStore{
    open = false;
    title = '';
    
    constructor(){
        makeAutoObservable(this);
    }

    openModal =(title: string)=>{
        this.open = true;
        this.title = title;
    }

    closeModal = ()=>{
        this.open = false;
    }
}