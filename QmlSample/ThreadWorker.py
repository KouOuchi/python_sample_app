from PySide2 import QtCore
import time

class ThreadWorker(QtCore.QThread):

    notify_progress = QtCore.Signal(float)
    notify_is_running = QtCore.Signal(bool)
    notify_result = QtCore.Signal(list)

    primes = []
    should_stop = True
    mutex = None

    def init(self):
        self.primes = []

    def __init__(self, to_get_prime_max, parent = None):
        QtCore.QThread.__init__(self, parent)

        self.to_get_prime_max = to_get_prime_max
        self.mutex = QtCore.QMutex()
        self.init()

        QtCore.qDebug('ThreadWorker created.')

    def __del__(self):
        self.cancel(True)
        self.wait()

    def run(self):
        QtCore.qDebug("run : arg = {}".format(self.to_get_prime_max))

        self.cancel(False)

        QtCore.qDebug("run : start calculation..." + str(self.should_stop))

        try:
            for n in range(2, self.to_get_prime_max):

                for x in range(2, n):

                    if self.should_stop:
                        self.init()
                        return

                    if n % x == 0:
                        break
                else:
                    self.primes.append(n)

                progress = (n - 1) / (self.to_get_prime_max - 2)

                time.sleep(0.0001)

                self.notify_progress.emit(progress)

            self.notify_result.emit(self.primes)

        finally:
            QtCore.qDebug("run : start calculation end.")
            self.cancel(True)

    def cancel(self, stop):
        with QtCore.QMutexLocker(self.mutex):
            self.should_stop = stop
            self.notify_is_running.emit(not stop)

