import cv2 as cv


def take_a_frame(video_path) -> cv.Mat:
  video_reader = cv.VideoCapture(video_path)

  _, frame = video_reader.read()
  return frame