import './App.css';
import { ToastContainer } from 'react-toastify';
import ModalContainer from './common/modals/ModalContainer';
import { Button, Container } from 'react-bootstrap';
import MenuBar from './common/components/MenuBar';
import { Outlet } from 'react-router-dom';
import ModalMakeACallAnswer from './common/modals/ModalMakeACallAnswer';
import { useStore } from './stores/stores';
import { observer } from 'mobx-react-lite';
import { useEffect, useRef } from 'react';
import FriendList from './common/components/friendList/FriendList';
import { callerMessageService } from './common/services/displayInforCaller';
import { openCallingAnswerService } from './common/services/openCallingAnswer';
import CallOneToOneModal from './common/components/CallOneToOne';

function App() {
  const { userStore, presenceHubStore, modalMakeACallAnswer, audioStore, modalStore } = useStore();
  const buttonRef = useRef<any>(null);
  const buttonCallOneToOneRef = useRef<any>(null);

  useEffect(() => {
    if (userStore.user) {
      presenceHubStore.createHubConnection(userStore.user);
    }

    callerMessageService.getMessage().subscribe(userCaller => {
      //tuong tac dom 1 cach gian tiep, tuong tu nhu user click vao button play
      //su dung buoc trung gian nay de ngan ngua loi: play() failed because the user didn't interact with the document first.
      buttonRef.current.click();
      modalMakeACallAnswer.openModal('A call from '+ userCaller.displayName);      
    });

    // open modal call 1-1
    openCallingAnswerService.getMessage().subscribe(data => {
      if(data) buttonCallOneToOneRef.current.click();
    })

  }, [userStore])

  return (
    <>      
      <Button style={{display: 'none'}} onClick={() => modalStore.openModal("Call One-One", <CallOneToOneModal />)} ref={buttonCallOneToOneRef}>Call 1-1</Button> 
      <Button style={{display: 'none'}} onClick={audioStore.toogle} ref={buttonRef}>Play</Button> 
      <ToastContainer position='bottom-right' hideProgressBar theme='colored' />
      <ModalMakeACallAnswer />
      <ModalContainer />
      <MenuBar />
      <Container>
        <Outlet />
      </Container>

      {userStore.isLoggedIn ? (
        <div style={{ position: 'relative' }}>
          <FriendList />
        </div>
      ) : null}
    </>
  );
}

export default observer(App);
