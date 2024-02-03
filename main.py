from PyQt5.QtCore import QUrl
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtWidgets import QApplication
from PyQt5.QtQml import QQmlApplicationEngine
from qml_bridge import FrameImageProvider, QMLBridge

from video_to_slides import VideoToSlides

if __name__ == "__main__":
    import sys

    videoToSlideBackend = VideoToSlides()

    app = QApplication(sys.argv)


    bridge = QMLBridge()

    engine = QQmlApplicationEngine()
    # engine.addImageProvider("FrameImageProvider", FrameImageProvider())
    engine.rootContext().setContextProperty("QMLBridge", bridge)
  
    engine.load(QUrl.fromLocalFile("./ui.qml"))

    sys.exit(app.exec_())
