import os
import PyQt5

dirname = os.path.dirname(PyQt5.__file__)
plugin_path = os.path.join(dirname, 'plugins', 'platforms')
os.environ['QT_QPA_PLATFORM_PLUGIN_PATH'] = plugin_path

import sys
import DemoAppQrc # this module is generated from my qrc
from MyOperationPanel import MyOperationPanel
from PyQt5.QtWidgets import QApplication
from PyQt5.QtCore import QUrl
from PyQt5.QtQml import QQmlApplicationEngine,qmlRegisterType

app = QApplication(sys.argv)
engine = QQmlApplicationEngine(app)

qmlRegisterType(MyOperationPanel, 'MyOperationPanel', 1, 0, 'MyOperationPanel')

#engine.addImportPath('qrc:/')
engine.load(QUrl('qrc:/qml/RootWindow.qml'))
if len(engine.rootObjects()) <= 0:
    print("Loading QML Error.")
    sys.exit(0)

win = engine.rootObjects()[0]
win.show()
app.exec_()

