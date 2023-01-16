import { Button, Card } from "react-bootstrap";

export default function NotFound() {
    return (
        <div>
            <Card>
                <Card.Img variant="top" src="/assets/notfound.png" />
                <Card.Body>
                    <Card.Title className="text-danger">Not found</Card.Title>
                    <Card.Text>
                        your request is not found
                    </Card.Text>
                    <Button variant="primary">Go somewhere</Button>
                </Card.Body>
            </Card>
        </div>
    );
}