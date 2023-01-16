import { Col, Row, Carousel, Card, Alert } from "react-bootstrap";

export default function HomePage() {
    return (
        <Row>
            <Col md={12}>
                <Carousel>
                    <Carousel.Item>
                        <img
                            className="d-block w-100"
                            src="/assets/cafedev_net_core.png"
                            alt="First slide"
                        />
                        <Carousel.Caption>
                            <h3>Dot Net 6</h3>
                            <p>Nulla vitae elit libero, a pharetra augue mollis interdum.</p>
                        </Carousel.Caption>
                    </Carousel.Item>
                    <Carousel.Item>
                        <img
                            className="d-block w-100"
                            src="/assets/netcore_Angular.jpg"
                            alt="Second slide"
                        />

                        <Carousel.Caption>
                            <h3>Dot Net Core & Angular</h3>
                            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
                        </Carousel.Caption>
                    </Carousel.Item>
                    <Carousel.Item>
                        <img
                            className="d-block w-100"
                            src="/assets/netcore-react.png"
                            alt="Third slide"
                        />

                        <Carousel.Caption>
                            <h3>Dot Net Core & React</h3>
                            <p>Praesent commodo cursus magna, vel scelerisque nisl consectetur.</p>
                        </Carousel.Caption>
                    </Carousel.Item>
                </Carousel>
            </Col>

            <Col>
                <Alert variant='primary'>
                    Social network use React & .Net Core & WebRTC
                </Alert>
            </Col>
            
            <Col md={12}>
                <Row>
                    <Col>
                        <Card>
                            <Card.Img variant="top" src="logo512.png" />
                            <Card.Body>
                                <Card.Title>React 18</Card.Title>
                                <Card.Text>
                                A JavaScript library for building user interfaces.
                                </Card.Text>
                                <ul>
                                    <li>typescript</li>
                                    <li>react-bootstrap (UI)</li>
                                    <li>react-router-dom (v6)</li>
                                    <li>react-toastify (notification)</li>
                                    <li>yup (validation)</li>
                                    <li>formik (form)</li>
                                    <li>mobx (state managment)</li>
                                    <li>signalr (real-time)</li>
                                    <li>fontawesome (ico)</li>
                                    <li>axios (call api)</li>
                                </ul>
                            </Card.Body>
                        </Card>
                    </Col>
                    <Col>
                        <Card>
                            <Card.Img variant="top" src="/assets/cafedev_net_core.png" />
                            <Card.Body>
                                <Card.Title>.Net 6</Card.Title>
                                <Card.Text>
                                .NET 6 delivers the final parts of the .NET unification plan that started with .NET 5. 
                                .NET 6 unifies the SDK, base libraries, and runtime across mobile, desktop, IoT, and cloud apps. 
                                In addition to this unification, the .NET 6 ecosystem offers:
                                </Card.Text>
                                <ul>
                                    <li>
                                    <strong>Simplified development:</strong> Getting started is easy. New language features in C# 10 reduce the amount of code you need to write. And investments in the web stack and minimal APIs make it easy to quickly write smaller, faster microservices.
                                    </li>
                                    <li>
                                    <strong>Better performance:</strong> .NET 6 is the fastest full stack web framework, which lowers compute costs if you're running in the cloud.
                                    </li>
                                    <li>
                                    <strong>Ultimate productivity: </strong> .NET 6 and Visual Studio 2022 provide hot reload, new git tooling, intelligent code editing, robust diagnostics and testing tools, and better team collaboration.
                                    </li>
                                </ul>
                            </Card.Body>
                        </Card>
                        <Card>
                            <Card.Img variant="top" src="/assets/WebRTC.png" />
                            <Card.Body>
                                <Card.Title>WebRTC (PeerJS) Real-time communication for the web</Card.Title>
                                <Card.Text>
                                With WebRTC, you can add real-time communication capabilities to your application that works on top of an open standard.
                                It supports video, voice, and generic data to be sent between peers, allowing developers to build powerful voice- and video-communication solutions. 
                                The technology is available on all modern browsers as well as on native clients for all major platforms. 
                                The technologies behind WebRTC are implemented as an open web standard and available as regular JavaScript APIs in all major browsers. 
                                For native clients, like Android and iOS applications, a library is available that provides the same functionality. 
                                The WebRTC project is open-source and supported by Apple, Google, Microsoft and Mozilla, amongst others. 
                                This page is maintained by the Google WebRTC team.
                                </Card.Text>
                            </Card.Body>
                        </Card>
                    </Col>
                </Row>
            </Col>
        </Row>
    )
}