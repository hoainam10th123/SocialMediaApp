import { observer } from "mobx-react-lite";
import { useEffect } from "react";
import { Card } from "react-bootstrap";
import { useStore } from "../../../stores/stores";
import ChatBox from "./ChatBox";
import { library } from '@fortawesome/fontawesome-svg-core';
import { faEdit, faToggleOn } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import MiniChatBox from "./Mini-chatBox";
import { IMember } from "../../../models/user";
import { messageService } from "../../services/messageService";

library.add(faEdit, faToggleOn)


export default observer(function FriendList() {

    const { userOnlineStore: { 
        userChatBox,
        miniChatBox, 
        setUserChatBox,
        addUserChatBox 
    }, commonStore:{hide, toogleHide}, presenceHubStore } = useStore();

    useEffect(() => {
        const userTempChatBox: IMember[] = JSON.parse(localStorage.getItem('chatboxusers')!);
        setUserChatBox(userTempChatBox); 

        const subscription = messageService.getMessage().subscribe((member: IMember) => {
            addUserChatBox(member);
        });

        return () => {
            subscription.unsubscribe();
        }     
    }, [])

    return (
        <>
            <Card style={{ 
                width: '18rem',
                position:'fixed',
                maxWidth: 350,
                right: 25,
                bottom: 1,
                zIndex: 222
            }} className={hide ? 'hidden' : undefined}>
                <Card.Header>
                    User online {presenceHubStore.usersOnline.length}                    
                </Card.Header>
                <Card.Body>
                    {presenceHubStore.usersOnline.map((member, index) => (
                        <div
                            onClick={() => addUserChatBox(member.member!)}
                            key={index}
                            style={{ color: 'blue', padding: 5, borderRadius: 8, backgroundColor: 'whitesmoke' }}>
                            {member.member!.displayName}
                        </div>
                    ))}
                </Card.Body>
            </Card>
            <div>
                {userChatBox.map((user, index) => (
                    <ChatBox key={index} user={user} />
                ))}
            </div>

            <div style={{ position: 'relative' }}>
                <div className="mini-list d-flex flex-column">
                    {miniChatBox.map((user, index) => (
                        <MiniChatBox key={index} user={user} />
                    ))}

                    <div style={{ margin: 5 }}>
                        <div className="edit d-flex align-items-center justify-content-center rounded-circle">
                            <FontAwesomeIcon icon={faEdit} />
                        </div>
                    </div>
                    <div style={{ margin: 5 }}>
                        <div onClick={toogleHide} className="edit d-flex align-items-center justify-content-center rounded-circle">
                            <FontAwesomeIcon icon={faToggleOn} />
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
})