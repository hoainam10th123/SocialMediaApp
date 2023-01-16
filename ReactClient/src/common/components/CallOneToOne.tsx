import { useEffect, useRef } from "react";
import { Col, Container, Row } from "react-bootstrap";
import { useStore } from "../../stores/stores";
import { observer } from "mobx-react-lite";
import AgoraRTC from "agora-rtc-sdk-ng";
import useAgora from "../../hooks/useAgora";
import agent from "../../api/agent";
import { toast } from "react-toastify";
import MediaPlayer from "./MediaPlayer";

const client = AgoraRTC.createClient({ codec: 'h264', mode: 'rtc' });

export default observer(function CallOneToOneModal() {
    
    const {
        localAudioTrack, localVideoTrack, leave, join, joinState, remoteUsers
    } = useAgora(client);

    const { userStore } = useStore();

    useEffect(() => {
        //channel la user goi di
        const chanelName = userStore.channelname?? userStore.user?.username;

        agent.Agora.getRtcToken({ uid: userStore.user?.username, channelName: chanelName }).then(res => {
            try {
                join('9c29102f9b5749988c092d4d9bab52e9', chanelName, res.token, userStore.user?.username);
            } catch (error) {
                console.error(error);
                toast.error('Error while join channel agora');
            }
        }).catch((err) => {
            console.error('An error occurred while retrieving token. ', err);
            toast.error('error while get token agora');
        });

        return () => { 
            leave();
            userStore.setChannel(null);
            // tra lai duong day ranh, ko code phan nay
        }

    }, [])
    
    return (
        <Container>
            <Row className="justify-content-center">
            <Col>
                {joinState && localVideoTrack ? (
                    <MediaPlayer label={`Local ${client.uid?.toString()!}`} videoTrack={localVideoTrack} audioTrack={localAudioTrack}></MediaPlayer>
                ) : null}
            </Col>
            <Col>
                {remoteUsers.map(user => (
                    <MediaPlayer key={user.uid} label={`Remote ${user.uid.toString()}`} videoTrack={user.videoTrack} audioTrack={user.audioTrack}></MediaPlayer>
                ))}
            </Col>
            </Row>
        </Container>
    )
})