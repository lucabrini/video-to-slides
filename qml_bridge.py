from PyQt5.QtCore import QObject, pyqtSlot
from PyQt5.QtQuick import QQuickImageProvider
from utils import take_a_frame

from video_to_slides import VideoToSlides

class QMLBridge(QObject):
  
  def __init__(self):
    self.video_to_slides = VideoToSlides()
    super().__init__()
  
  @pyqtSlot(str, str)
  def convert(self, video_path, output_path):
    if(video_path == "" or output_path == "" ):
      return
    output_path = output_path[7:]
    self.video_to_slides.convert(video_path, output_path)

  @pyqtSlot(str)
  def take_a_frame(self, video_path):
    frame, width, height = take_a_frame(video_path)
    
    
class FrameImageProvider(QQuickImageProvider):
  
  def __init__(self):
    pass