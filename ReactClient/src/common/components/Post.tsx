import { Card, ListGroup } from "react-bootstrap";
import { library } from '@fortawesome/fontawesome-svg-core';
import { faCircle } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { IPost } from "../../models/post";
import moment from "moment";
import { observer } from "mobx-react-lite";
import { useStore } from "../../stores/stores";
import * as Yup from 'yup';
import { Formik, Form, Field, FieldProps } from "formik";
import agent from "../../api/agent";
import { useEffect } from "react";
import { broadcastCommentService } from "../services/BroadcastCommentService";

library.add(faCircle)

interface Props {
    token: string;
    post: IPost | undefined;
}

export default observer(function Post({ post, token }: Props) {

    const { userStore } = useStore();

    async function addComment(noidung:string, postId: number){
        await agent.Comments.addComment(noidung, postId)
    }

    return (
        <Card className="border border-primary" style={{ margin: 5 }}>
            <Card.Header className="d-flex align-items-center">
                <div style={{ position: 'relative', marginRight: 10 }}>
                    <img className="rounded-circle" height={60} width={60} src={post?.imageUrl || "/assets/user.png"} alt="" />
                    <span className="online lb-pos"><FontAwesomeIcon icon={faCircle} /></span>
                </div>
                <div>
                    <div className="text-primary">{post!.displayName}</div>
                    <div className="text-muted">{moment(post?.created).fromNow()}</div>
                </div>
            </Card.Header>

            <Card.Body>
                <Card.Title>{post!.noiDung}</Card.Title>
                <Card.Text>
                    {token}
                </Card.Text>
            </Card.Body>

            <Card.Footer>
                {/* comment form */}
                <div className="d-flex">
                    <div style={{ position: 'relative', marginRight: 10 }}>
                        <img className="rounded-circle" height={40} width={40} src={userStore.user?.imageUrl || "/assets/user.png"} alt="" />
                    </div>

                    <div style={{width:'100%'}}>
                        <Formik
                            onSubmit={(values, { resetForm }) => addComment(values.noidung, values.postId!).then(() => resetForm())}
                            initialValues={{ postId: post?.id, noidung: '' }}
                            validationSchema={Yup.object().shape({
                                noidung: Yup.string().required()
                            })}
                        >
                            {({ isValid, handleSubmit }) => (
                                <Form>
                                    <Field name='noidung'>
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
                    </div>
                </div>

                {/* List comment */}
                <ListGroup variant="flush">
                    {
                        post?.comments.map((cmt, index) => (
                            <ListGroup.Item key={index} className="d-flex align-items-center">
                                <div style={{ position: 'relative', marginRight: 10 }}>
                                    <img className="rounded-circle" height={40} width={40} src={cmt.userImageUrl || "/assets/user.png"} alt="" />
                                </div>
                                <div>
                                    <div className="text-primary">{cmt.displayName}</div>
                                    <div>{cmt.noiDung}</div>
                                </div>
                            </ListGroup.Item>
                        ))
                    }
                </ListGroup>
            </Card.Footer>
        </Card>
    )
})