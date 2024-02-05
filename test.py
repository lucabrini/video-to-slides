import math
import cv2 as cv
import numpy as np
from matplotlib import pyplot as plt

def main():
  
  # Args
  path = ""

  # Utility
  video_reader = cv.VideoCapture(path)
  frame_width = int(video_reader.get(cv.CAP_PROP_FRAME_WIDTH))
  frame_height = int(video_reader.get(cv.CAP_PROP_FRAME_HEIGHT))

  raw_frames_list = frame_sampling(video_reader)
  print(len(raw_frames_list))

  # Frame dimensions

  previous_frame = np.zeros((frame_height, frame_width, 3), np.uint8)

  counter = 0
  for current_frame in raw_frames_list:
    
    diff = cv.absdiff(previous_frame, current_frame)
    diff = cv.cvtColor(diff, cv.COLOR_BGR2GRAY)
    
    changed_pixel_number = np.sum(diff > 20)
    
    if(changed_pixel_number > 300):
      cv.imwrite("./dump/" + str(counter) + ".jpg", current_frame)
      print("Saved frame")
    
    counter = counter + 1
    previous_frame = current_frame
    print(counter)
    

def frame_sampling(video_reader : cv.VideoCapture, frames_per_second=1):
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
  
  
main()