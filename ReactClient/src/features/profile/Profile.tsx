import { useEffect, useState } from "react";
import { Button, Col, Row } from "react-bootstrap";
import agent from "../../api/agent";
import Post from "../../common/components/Post";
import { IUser } from "../../models/user";

export default function Profile() {

    const [token, setToken] = useState('')

    async function addPost(){
        const formData = new FormData()
        formData.append('content', 'hoainam10th 123')
        await agent.Posts.addPost(formData)
    }

    useEffect(()=>{
        let user: IUser | null = JSON.parse(localStorage.getItem('user')!);
        if(user){
            setToken(user.token)
        }
    },[token])

    return (
        <>
            <div className="header-profile">
                <div className="text-center" style={{ position: 'relative' }}>
                    <img src="/assets/netcore-react.png" className="rounded fit-img" alt="" />
                    <div className="img-block">
                        <img src="/assets/user.png" className="rounded-circle" style={{ maxWidth: 150, border: '4px solid green' }} />
                    </div>
                </div>
                <h2 className="text-center text-primary">hoai nam nguyen</h2>
            </div>
            <div className="body-profile">
                <Row>
                    <Col md={4}>
                        <div className="card">
                            <div className="card-header text-primary">Information</div>
                            <div className="card-body">
                                <div>
                                    <strong>Tên đăng nhập:</strong>
                                    <p>hoainam10th</p>
                                </div>
                                <div>
                                    <strong>Online lần cuối</strong>
                                    <p>1 phut ago</p>
                                </div>
                                <div>
                                    <strong>Ngày tham gia</strong>
                                    <p>12/10/2022</p>
                                </div>
                            </div>
                        </div>
                    </Col>
                    <Col md={8}>
                        <Button variant="primary" onClick={addPost}>Add post</Button>
                    </Col>
                </Row>
            </div>            
        </>
    )
}