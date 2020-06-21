from PySide2.QtQuick import QQuickItem
from PySide2 import QtCore
import sys
from ThreadWorker import ThreadWorker

class MyOperationPanel(QQuickItem):

    TO_GET_PRIME_MAX = 1000

    worker = None

    progress = 0.0
    running = False
    result = []

    def __init__(self, parent=None):
        super().__init__(parent)       

    @QtCore.Slot(result=int)
    def is_running(self):
        ret = 0

        if self.worker:
            if self.running:
                ret = ret | 1<<0
            if self.progress == 1.0:
                ret = ret | 1<<1

        return ret

    @QtCore.Slot(result=int)
    def get_result(self):
        """
        call is_runnning() in advance
        """
        print("result()")

        if self.worker:
            return len(self.result)
        return 0

    @QtCore.Slot(result=bool)
    def boost(self):
        try:
            self.thread = QtCore.QThread(None)
            self.worker = ThreadWorker(self.TO_GET_PRIME_MAX)
            self.worker.moveToThread(self.thread)

            self.worker.notify_progress.connect(self.accept_progress)
            self.worker.notify_is_running.connect(self.accept_is_running)
            self.worker.notify_result.connect(self.accept_result)

            self.worker.start()

        except Exception as e:
            print(e)
            return False

        return True

    @QtCore.Slot(result=bool)
    def cancel_boost(self):
        try:
            self.worker.cancel(True)
            return True

        except Exception as e:
            print(e)
            return false

    @QtCore.Slot(float)
    def accept_progress(self, p):
        self.progress = p

    @QtCore.Slot(bool)
    def accept_is_running(self, p):
        self.running = p

    @QtCore.Slot(list)
    def accept_result(self, p):
        self.result = p

    @QtCore.Slot(result=str)
    def progress_text(self):
        #print(self.progress)
        return str(round(self.progress*100.0)) + '%'


