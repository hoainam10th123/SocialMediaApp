import { observer } from "mobx-react-lite";
import { Button, Modal } from "react-bootstrap";
import { useStore } from "../../stores/stores";
import { openCallingAnswerService } from "../services/openCallingAnswer";

export default observer(function ModalMakeACallAnswer() {
    const { modalMakeACallAnswer, audioStore } = useStore();

    function traLoiCuocGoi(){   
        audioStore.setPlaying(false);     
        modalMakeACallAnswer.closeModal();
        // mo hop thoai call 1-1
        openCallingAnswerService.sendMessage(true);//app.tsx        
    }

    return (
        <>
            <Modal
                show={modalMakeACallAnswer.open}
                onHide={modalMakeACallAnswer.closeModal}
                backdrop="static"
                keyboard={false}
            >
                <Modal.Header closeButton>
                    <Modal.Title>{modalMakeACallAnswer.title}</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    Would you like to answer this call?
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="danger" onClick={() => {
                        audioStore.setPlaying(false);
                        modalMakeACallAnswer.closeModal();
                    }}>
                        Cancel
                    </Button>
                    <Button variant="success" onClick={traLoiCuocGoi}>Answer</Button>
                </Modal.Footer>
            </Modal>
        </>
    );
})