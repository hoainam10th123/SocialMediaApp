import { useField } from "formik";
import { Form } from "react-bootstrap";

interface Props {
    placeholder: string;
    name: string;
    label?: string;
    type?: string;
}

export default function MyTextInput(props: Props) {
    const [field, meta] = useField(props);
    return (
        <Form.Group className="mb-3">
            <Form.Label htmlFor={props.name}>{props.label}</Form.Label>
            <input id={props.name} className="form-control" {...field} {...props} />
            {meta.touched && meta.error ? (
                <div className="text-danger">{meta.error}</div>
            ) : null}
        </Form.Group>
    );
}