import { useEffect, useRef, useState } from "react";
import { Button, Col, Container, Row } from "react-bootstrap";

export default function CallGroupPage() {
    const userVideoRef = useRef<any>(null);
    const [layout, setLayout] = useState(1);
    useEffect(() =>{
        console.log("khoi tao")
        return ()=>{console.log("huy")}
    }, [])
    
    return (
        <Container>
            <Row>
                <Col md={8}>
                    {
                        layout === 1 ? <video width='100%' ref={userVideoRef} controls /> : layout === 2 ? (
                            <Row>
                                <Col><video width='100%' ref={userVideoRef} controls /></Col>
                                <Col><video width='100%' ref={userVideoRef} controls /></Col>
                            </Row>
                        ) : layout === 3 ? (
                            <>
                                <Row>
                                    <Col><video width='100%' ref={userVideoRef} controls /></Col>
                                    <Col><video width='100%' ref={userVideoRef} controls /></Col>
                                </Row>
                                <Row>
                                    <Col><video width='100%' ref={userVideoRef} controls /></Col>
                                </Row>
                            </>
                        ) : (
                            <>
                                <Row>
                                    <Col><video width='100%' ref={userVideoRef} controls /></Col>
                                    <Col><video width='100%' ref={userVideoRef} controls /></Col>
                                </Row>
                                <Row>
                                    <Col><video width='100%' ref={userVideoRef} controls /></Col>
                                    <Col><video width='100%' ref={userVideoRef} controls /></Col>
                                </Row>
                            </>
                        )
                    }
                </Col>

                <Col md={4}>
                    <ul style={{ paddingLeft: 0, listStyle: 'none', marginTop: 5, overflow: 'auto', maxHeight: 500 }}>
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
            <Row>
                <Col>
                    <Button variant="primary" onClick={() => setLayout(1)}>1 layout</Button>
                    <Button variant="primary" onClick={() => setLayout(2)}>2 layout</Button>
                    <Button variant="primary" onClick={() => setLayout(3)}>3 layout</Button>
                    <Button variant="primary" onClick={() => setLayout(4)}>4 layout</Button>
                </Col>
            </Row>
        </Container>
    )
}