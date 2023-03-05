import { ILocalVideoTrack, IRemoteVideoTrack, ILocalAudioTrack, IRemoteAudioTrack } from "agora-rtc-sdk-ng";
import React, { useRef, useEffect } from "react";
import { Card } from "react-bootstrap";

export interface VideoPlayerProps {
    videoTrack: ILocalVideoTrack | IRemoteVideoTrack | undefined;
    audioTrack: ILocalAudioTrack | IRemoteAudioTrack | undefined;
    label: string;
}

const MediaPlayer = (props: VideoPlayerProps) => {
    const container = useRef<HTMLDivElement>(null);

    useEffect(() => {
        if (!container.current) return;
        props.videoTrack?.play(container.current);
        return () => {
            props.videoTrack?.stop();
        };
    }, [container, props.videoTrack]);

    useEffect(() => {
        if (props.audioTrack) {
            props.audioTrack?.play();
        }
        return () => {
            props.audioTrack?.stop();
        };
    }, [props.audioTrack]);

    return (
        <Card style={{ position: 'relative' }} className='border border-primary'>
            <div ref={container} className="video-player" style={{ width: "100%", height: "400px" }}></div>
            <span className="badge bg-danger" style={{ position: 'absolute', left: 1, top: 1 }}>
                {props.label}
            </span>
        </Card>
    );
}

export default MediaPlayer;