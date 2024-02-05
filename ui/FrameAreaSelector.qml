import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1
import QtQuick.Layouts 1.15

Item {
  id: frameAreaSelector
  visible: true

  property real img_x_scale: 0
  property real img_y_scale: 0
  property real img_relative_mouse_x: 0
  property real img_relative_mouse_y: 0

  property int img_x_start: 0
  property int img_x_end: 0
  property int img_y_start: 0
  property int img_y_end: 0

  property int selection_x_start: 0
  property int selection_x_end: 0
  property int selection_y_start: 0
  property int selection_y_end: 0

  Image {
    id: frameImage
    source: "image://FrameImageProvider/img"
    anchors.fill: parent
    fillMode: Image.PreserveAspectFit

    MouseArea {
      id: selectionArea
      anchors.fill: parent

      onPressed: {
        if(isMouseInTheImageArea(frameImage, mouse)){
          mapToImage(mouse, frameImage)
          img_x_start = img_relative_mouse_x
          img_y_start = img_relative_mouse_y

          selection_x_start = mouse.x
          selection_y_start = mouse.y
        }
      }

      onPositionChanged: {
        if(isMouseInTheImageArea(frameImage, mouse)){
          mapToImage(mouse, frameImage)
          img_x_end = img_relative_mouse_x
          img_y_end = img_relative_mouse_y

          selection_x_end = mouse.x
          selection_y_end = mouse.y
        }
      }

      onReleased: {
        console.log(
          "Rettangolo selezionato: ",
          "start_x =", img_x_start, "end_x =", img_x_end, 
          "start_y =", img_y_start, "end_y =", img_y_end,
        )
      }
    }

    Rectangle {
      id:rectRoi
      opacity: 0.5
      x: selection_x_start
      y: selection_y_start
      width: selection_x_end - selection_x_start
      height:  selection_y_end - selection_y_start
      color: "#d2d2d2"
      border.color: "#ffffff"
    }
  }

  Button {
    text: "Okay"
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.bottomMargin: 10
    anchors.rightMargin: 10
    onClicked: {
      QMLBridge.save_selected_bbox(
        img_x_start,
        img_x_end,
        img_y_start,
        img_y_end
      )
      reset()
      stackView.pop()
    }
    Layout.alignment: Qt.AlignRight
  }

  function reset(){
    img_x_start = 0
    img_x_end = 0
    img_y_start = 0
    img_y_end = 0

    selection_x_start = 0
    selection_x_end = 0
    selection_y_start = 0
    selection_y_end = 0
  }

  function isMouseInTheImageArea(image: Image, mouse: MouseEvent){
    return (
      getXPosition(image) <= mouse.x && mouse.x <= getXPosition(image) + image.paintedWidth &&
      getYPosition(image) <= mouse.y && mouse.y <= getYPosition(image) + image.paintedHeight
    )
  }

  function mapToImage(mouse: MouseEvent, image: Image){    
    img_x_scale = image.paintedWidth / image.sourceSize.width
    img_y_scale = image.paintedHeight / image.sourceSize.height

    img_relative_mouse_x = Math.floor((mouse.x - getXPosition(image)) / img_x_scale)
    img_relative_mouse_y = Math.floor((mouse.y - getYPosition(image)) / img_y_scale)
  }

  function getXPosition(image : Image) {
    switch (image.horizontalAlignment) {
      case Image.AlignLeft:
          return 0
      case Image.AlignRight:
          return image.width - image.paintedWidth
      case Image.AlignHCenter:
      default:
          return (image.width - image.paintedWidth) * 0.5
    }
  }

  function getYPosition(image : Image) {
    switch (image.verticalAlignment) {
      case Image.AlignTop:
          return 0
      case Image.AlignBottom:
          return image.height - image.paintedHeight
      case Image.AlignVCenter:
      default:
          return (image.height - image.paintedHeight) * 0.5
    }
  }
}