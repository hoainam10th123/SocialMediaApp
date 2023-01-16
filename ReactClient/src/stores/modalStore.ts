import { makeAutoObservable } from "mobx"

interface Modal{
    title: string;
    open: boolean;
    body: JSX.Element | null;
}

export default class ModalStore{
    modal: Modal = {title:'', open: false, body: null}
    
    constructor(){
        makeAutoObservable(this);
    }

    openModal =(title: string, content: JSX.Element)=>{
        this.modal.title = title;
        this.modal.open = true;
        this.modal.body = content;
    }

    closeModal = ()=>{
        this.modal.open = false;
        this.modal.body = null;
    }
}