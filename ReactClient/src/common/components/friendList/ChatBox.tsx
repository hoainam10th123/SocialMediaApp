import { Card } from "react-bootstrap";
import { library } from '@fortawesome/fontawesome-svg-core'
import { faClose, faMinus, faVideo } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useEffect, useRef } from "react";
import { observer, useLocalObservable } from "mobx-react-lite";
import { useStore } from "../../../stores/stores";
import { IMember } from "../../../models/user";
import MessageHubStore from "../../../stores/messageHubStore";
import * as Yup from 'yup';
import { Formik, Form, Field, FieldProps } from "formik";
import { IMessage } from "../../../models/message";
import CallOneToOnePage from "../CallOneToOne";

library.add(faMinus, faClose, faVideo)

interface Props {
    user: IMember;
}

export default observer(function ChatBox({ user }: Props) {
    const messagesEndRef = useRef<any>(null);
    const { userOnlineStore: { removeUserChatBox, addMiniChatBox }, userStore, modalStore, presenceHubStore } = useStore();
    //local state of every chat-box, the same as: const [messageHub] = useState(() => new MessageHubStore())
    const messageHub = useLocalObservable(() => new MessageHubStore())

    const scrollToBottom = () => {
        messagesEndRef.current?.scrollIntoView({ behavior: "smooth" })
    }

    useEffect(() => {
        messageHub.createHubConnection(user.userName);

        var chatBox = document.getElementById(user.userName);
        chatBox!.style.right = user.right + "px";

        return () => {
            messageHub.stopHubConnection();
        }
    }, [])

    useEffect(() => {
        scrollToBottom()
    }, [messageHub.messages.length]);

    function callToOtherUser(otherUsername: string){
        modalStore.openModal("Call One-One", <CallOneToOnePage />);
        //channel la user goi di
        presenceHubStore.callToOtherUsername(otherUsername, userStore.user?.username!);
    }

    return (
        <div id={user.userName} className="chat-box">
            <Card className="border-primary">
                <Card.Header className="d-flex align-items-center">
                    <img height={50} src="/assets/user.png" alt="" className="rounded-circle" />
                    <div className="text-primary">{user.displayName}</div>
                    <div className="child-right">
                        <a className="mr-5" onClick={() => callToOtherUser(user.userName)}><FontAwesomeIcon icon={faVideo} /></a>
                        <a className="mr-5" onClick={() => addMiniChatBox(user)}><FontAwesomeIcon icon={faMinus} /></a>
                        <a className="mr-5" onClick={() => removeUserChatBox(user.userName)}><FontAwesomeIcon icon={faClose} /></a>
                    </div>
                </Card.Header>

                <Card.Body>
                    <ul style={{ height: 300, overflow: 'auto' }} className="chat">
                        {messageHub.messages.map((message: IMessage, index) => (
                            <li className="mr-5" key={index} >
                                <div className={message.senderUsername === user.userName ? 'd-flex' : 'parent-sent'}>
                                    {message.recipientUsername === userStore.user?.username ? (
                                        <img height={40} src="/assets/user.png" alt="" className="mr-5 rounded-circle" />
                                    ) : null}

                                    <div className="message-body">{message.content}</div>
                                </div>
                            </li>
                        ))}
                        <div ref={messagesEndRef} />
                    </ul>
                </Card.Body>

                <Card.Footer>
                    <Formik
                        onSubmit={(values, { resetForm }) => messageHub.sendMessage(values).then(() => resetForm())}
                        initialValues={{ recipientUsername: user.userName, content: '' }}
                        validationSchema={Yup.object().shape({
                            content: Yup.string().required()
                        })}
                    >
                        {({ isValid, handleSubmit }) => (
                            <Form>
                                <Field name='content'>
                                    {(props: FieldProps) => (
                                        <div className="mb-3">
                                            <input className="form-control"
                                                type='text'
                                                placeholder='Enter to submit'
                                                {...props.field}
                                                onKeyPress={e => {                                                    
                                                    if (e.key === 'Enter') {
                                                        e.preventDefault();
                                                        isValid && handleSubmit();
                                                    }
                                                }}
                                            />
                                        </div>
                                    )}
                                </Field>
                            </Form>
                        )}
                    </Formik>
                </Card.Footer>
            </Card>
        </div>
    );
})