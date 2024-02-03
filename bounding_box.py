class BoundingBox:
  def __init__(self, x_start, x_end, y_start, y_end):
    self.x_start = x_start
    self.x_end = x_end
    self.y_start = y_start
    self.y_end = y_end
    
  def get_width(self):
    return abs(self.x_start - self.x_end)
  
  def get_height(self):
    return abs(self.y_start - self.y_end)