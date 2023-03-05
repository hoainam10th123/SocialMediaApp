import { ErrorMessage, Formik, Form } from "formik";
import { observer } from "mobx-react-lite";
import { Button } from "react-bootstrap";
import * as yup from 'yup';
import MyTextInput from "../../common/form/MyTextInput";
import { useStore } from "../../stores/stores";

export default observer(function Login() {
    const { userStore } = useStore();
    
    const schema = yup.object().shape({
        username: yup.string().required(),
        password: yup.string().required(),
    });

    return (
        <div style={{marginTop: 5}} className="form-signin border border-primary">
            <Formik
                validationSchema={schema}
                initialValues={{ username: '', password: '', error: null }}
                onSubmit={(value, { setErrors }) => userStore.login(value)
                    .catch(err => setErrors({ error: err }))}
            >
                {({ handleSubmit, isValid, isSubmitting, dirty, errors }) => (
                    <Form style={{ backgroundColor: "white", padding: 10 }}
                        onSubmit={handleSubmit} autoComplete='off'>

                        <MyTextInput name="username" placeholder="Username" label="Username" />
                        <MyTextInput type="password" name="password" placeholder="Password" label="Password" />

                        <ErrorMessage name="error" render={() => <div className="text-danger">{errors.error}</div>} />

                        <Button className="w-100" disabled={isSubmitting || !dirty || !isValid} variant="primary" type="submit">
                            {isSubmitting ? 'Loading...' : 'Login'}
                        </Button>
                    </Form>
                )}
            </Formik>
        </div>
    );
})