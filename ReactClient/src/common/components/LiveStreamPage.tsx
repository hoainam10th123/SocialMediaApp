import { useEffect, useRef } from "react";
import { Col, Container, Row } from "react-bootstrap";
import { library } from '@fortawesome/fontawesome-svg-core';
import { faEye } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";

library.add(faEye)


export default function LiveStreamPage() {
    const userVideoRef = useRef<any>(null);
    useEffect(() =>{
        console.log("khoi tao")
        return ()=>{console.log("huy")}
    }, [])
    return (
        <Container>
            <Row>
                <Col md={8} style={{ position: 'relative' }}>
                    <video width='100%' ref={userVideoRef} controls />
                    <span className="badge bg-secondary" style={{ position: 'absolute', left: 14, top: 1 }}>
                        <FontAwesomeIcon icon={faEye} /> 102k
                    </span>
                </Col>
                <Col md={4}>
                    <ul style={{paddingLeft: 0, listStyle: 'none', marginTop: 5, overflow: 'auto', maxHeight: 500 }}>
                        <li>
                            <div className="d-flex margin">
                                <img style={{ marginRight: 6 }} height={50} src="/assets/user.png" alt="" className="rounded" />
                                <div style={{ backgroundColor: 'wheat', padding: 6, borderRadius: 10 }}>
                                    <div className="fw-bold">Hoai Nam Nguyen</div>
                                    <div>Noi dung comment. Noi dung comment. Noi dung comment</div>
                                </div>
                            </div>
                        </li>
                    </ul>
                </Col>
            </Row>
        </Container>
    )
}