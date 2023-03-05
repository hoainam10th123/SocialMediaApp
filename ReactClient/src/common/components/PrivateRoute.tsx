import Login from "../../features/user/Login";
import { useStore } from "../../stores/stores";

export default function PrivateWrapper({ children }: { children: JSX.Element }) {
    const { userStore: { isLoggedIn } } = useStore();
    return isLoggedIn ? children : <Login />;
};