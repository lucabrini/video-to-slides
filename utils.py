import cv2 as cv


def take_a_frame(video_path):
  video_reader = cv.VideoCapture(video_path)
    
  frame_width = int(video_reader.get(cv.CAP_PROP_FRAME_WIDTH))
  frame_height = int(video_reader.get(cv.CAP_PROP_FRAME_HEIGHT))

  _, frame = video_reader.read()
  return frame, frame_width, frame_height