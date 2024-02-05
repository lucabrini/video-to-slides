from typing import Tuple
from PyQt5.QtCore import QObject, QSize, pyqtSlot, pyqtSignal, Qt
from PyQt5.QtGui import QImage
from PyQt5.QtQuick import QQuickImageProvider
import cv2 as cv
from bounding_box import BoundingBox
from utils import take_a_frame

from video_to_slides import VideoToSlides

class QMLBridge(QObject):
  
  frame : cv.Mat
  selected_bbox :  BoundingBox
  
  def __init__(self):
    self.video_to_slides = VideoToSlides()
    self.frame = None
    super().__init__()
  
  @pyqtSlot(str, str)
  def convert(self, video_path, output_path):
    if(video_path == "" or output_path == "" ):
      return
      
    output_path = output_path[7:]
    self.video_to_slides.convert(video_path, output_path, self.selected_bbox)
    
  @pyqtSlot(int, int, int, int)
  def save_selected_bbox(self, x_start, x_end, y_start, y_end ):
    self.selected_bbox = BoundingBox(x_start, x_end, y_start, y_end)
    

  @pyqtSlot(str)
  def take_a_frame(self, video_path):
    self.frame = take_a_frame(video_path)
    
    
class FrameImageProvider(QQuickImageProvider):
  imageChanged = pyqtSignal(QImage)
  
  def __init__(self, qml_bridge : QMLBridge):
    super(FrameImageProvider, self).__init__(QQuickImageProvider.Image)
    self.qml_bridge = qml_bridge
    self.frame = None
    
  def update_image(self, img):
    self.imageChanged.emit(img)
    self.frame = img
    
  def requestImage(self, id: str | None, requestedSize: QSize):
    img = cv.cvtColor(self.qml_bridge.frame, cv.COLOR_BGR2RGB)
    h,w,ch = img.shape
    q_img = QImage(img.data, w,h,w*ch, QImage.Format_RGB888)
    
    
    print(q_img)
    return q_img, q_img.rect().size()
