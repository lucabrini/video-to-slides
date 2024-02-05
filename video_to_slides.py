import io
import math
import cv2 as cv
import numpy as np
from reportlab.pdfgen import canvas
from reportlab.lib.utils import ImageReader

from bounding_box import BoundingBox

class VideoToSlides:
  

  def convert(self, video_path, dump_path, bounding_box : BoundingBox):
    
    video_reader = cv.VideoCapture(video_path)
    
    frame_width = int(video_reader.get(cv.CAP_PROP_FRAME_WIDTH))
    frame_height = int(video_reader.get(cv.CAP_PROP_FRAME_HEIGHT))
    
    # This will be passed from the upper function
    
    raw_frames_list = self.frame_sampling(video_reader)
    slides_frame = self.find_slides_frames(raw_frames_list, bounding_box)
    
    self.dump_slides(slides_frame, dump_path, bounding_box)
    
    
  def frame_sampling(self, video_reader : cv.VideoCapture, frames_per_second=1):
    frame_list = []
    frame_rate = video_reader.get(cv.CAP_PROP_FPS)
    
    current_frame_count = 0
    
    while True:
      ready, frame = video_reader.read()
      if not ready:
        break
      
      # Sampling frames: selecting only one per $frames_per_second
      if current_frame_count % (math.floor(frame_rate/frames_per_second)) == 0:
        frame_list.append(frame)
      
      current_frame_count += 1
      
    return frame_list
    
    
    
  def find_slides_frames(self, raw_frames_list, box : BoundingBox):
    frame_height = box.get_height()
    frame_width = box.get_width()
    print(frame_height, frame_width)
    
    previous_frame = np.zeros((frame_height, frame_width, 3), np.uint8)

    slides_frames = []

    counter = 0
    for current_frame in raw_frames_list:
      
      current_frame = self.extract_roi(current_frame, box)

      different = self.compare_frames(previous_frame, current_frame)
      if different:
        slides_frames.append(current_frame)
      
      counter = counter + 1
      previous_frame = current_frame
      print(counter)
    
    return slides_frames



  def compare_frames(self, previous_frame, current_frame):
    diff = cv.absdiff(previous_frame, current_frame)
    diff = cv.cvtColor(diff, cv.COLOR_BGR2GRAY)
      
    changed_pixel_number = np.sum(diff > 20)
    
    return changed_pixel_number > 300



  def dump_slides(self, slides_frames, path, box : BoundingBox ):
    slides_pdf = canvas.Canvas(path, pagesize=(box.get_width(), box.get_height()))
    
    for slide_frame in slides_frames:
      _, buffer = cv.imencode(".png", slide_frame)
      slide_image_reader = ImageReader(io.BytesIO(buffer))
      slides_pdf.drawImage(slide_image_reader, 0, 0)
      slides_pdf.showPage()
    
    slides_pdf.save()
      


  def sharpen(self, img):
    # In the Image Processing course, there was an exam question about the Laplacian Kernel
    # I gave the wrong answer, so now I will remember this kernel forever
    laplacian_value_kernel = np.array([
      [0, -1, 0],
      [-1, 5, -1],
      [0, -1, 0],
    ])
    
    return cv.filter2D(img, cv.CV_64F, laplacian_value_kernel)

  def upscale(self, img: cv.typing.MatLike, out_height=720):
    height, width, _ = img.shape
    
    if( out_height > height ):
      scale_factor = out_height / height
      width = int(width * scale_factor)
      height = out_height
      
      return cv.resize(img, [height, width], interpolation=cv.INTER_AREA)
    
    else:
      return img

  def extract_roi(self, img, bounding_box):
    return img[bounding_box.y_start:bounding_box.y_end, bounding_box.x_start:bounding_box.x_end]
  