import { Alert } from "react-bootstrap";
import { useStore } from "../../stores/stores";

export default function ServerErrorView() {
    const { commonStore } = useStore();
    return (
        <>
            <div className="text-center">
                <h1>500 Internal server error</h1>
                <h4 className="text-danger">{commonStore.error?.message}</h4>
            </div>
            <Alert variant='primary'> <strong>Stack trace:</strong> {commonStore.error?.details}</Alert>
        </>
    );
}