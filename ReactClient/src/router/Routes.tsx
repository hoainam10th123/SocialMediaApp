import { createBrowserRouter, Navigate, RouteObject } from "react-router-dom";
import App from "../App";
import NotFound from "../common/components/NotFound";
import PrivateWrapper from "../common/components/PrivateRoute";
import ServerErrorView from "../features/errors/ServerError";
import TestErrors from "../features/errors/TestErrors";
import HomePage from "../features/home/Home";
import NewFeed from "../features/new-feed/NewFeed";
import Profile from "../features/profile/Profile";
import Login from "../features/user/Login";

export const routes: RouteObject[] = [
    {
        path: '/',
        element: <App />,
        children: [
            { path: '/', element: <HomePage /> },
            { path: 'login', element: <Login /> },
            { path: 'new-feed', element: <NewFeed /> },
            { path: 'profile', element: <PrivateWrapper><Profile /></PrivateWrapper> },
            { path: 'errors', element: <TestErrors /> },
            { path: 'server-error', element: <ServerErrorView /> },
            { path: 'not-found', element: <NotFound /> },
            { path: '*', element: <Navigate replace to='/not-found' /> },
        ]
    }
]

export const router = createBrowserRouter(routes);