import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1
import QtQuick.Layouts 1.15

Item {
  width: parent.width
  height: parent.height

  Column {
    id: defaultColumn  
    width: parent.width
    spacing: 10
    padding: 10

    RowLayout {
      id: selectInputRow
      spacing: 5

      Button {
          text: "Seleziona File di Input"
          onClicked: videofileDialog.open()
      }

      Label {
          id: selectedVideoLabel
          text: "Nessun file selezionato"
          textFormat: Text.WordWrap
      }

    }

    RowLayout {
      id: selectOutputRow
      spacing: 5
      
      Button {
          text: "Seleziona Destinazione"
          onClicked: destinationfileDialog.open()
      }

      Label {
          id: selectedDestinationLabel
          text: "Nessuna destinazione selezionata"
          textFormat: Text.WordWrap
      }
    }

    RowLayout{
      spacing: 5
      width: parent.width

      Item {
        // Spacer
        Layout.fillWidth: true
      }        

      Button {
        text: "Scegli area"
        onClicked: {
          if(videofileDialog.file != ""){
            QMLBridge.take_a_frame(videofileDialog.file)
            stackView.push("FrameAreaSelector.qml")
          }
        }
        Layout.alignment: Qt.AlignRight
        width: 10
      }

      Button {
          text: "Converti"
          onClicked: {
            convert()
          }
          Layout.alignment: Qt.AlignRight
      }

      // Spacer from Right
      Item {
        width: 16
      }

    }

  }

  function convert(){
    if(videofileDialog.file == ""){
      noVideoMessage.open()
      return
    } 

    if(destinationfileDialog.file == ""){
      noDestinationMessage.open()
      return
    } 
    
    QMLBridge.convert(videofileDialog.file, destinationfileDialog.file)
    QMLBridge.reset_selected_bbox()
    successMessage.open()
  }

  function onVideoSelected(props){
    selectedVideoLabel.text = props
  }

  function onDestinationFolderSelected(props){
    selectedDestinationLabel.text = props
  }

  
  // Dialogs

  FileDialog {
    id: videofileDialog
    title: "Seleziona videolezione"
    nameFilters: ["File Video (*.mp4 *.mov *.avi)"]
    onAccepted: onVideoSelected(videofileDialog.file)
  }

  FileDialog {
    id: destinationfileDialog
    title: "Seleziona dove salvare le slide"
    fileMode: FileDialog.SaveFile
    nameFilters : ["PDF (*.pdf)"]
    onAccepted: onDestinationFolderSelected(destinationfileDialog.file)
    
  }

  MessageDialog {
    id : noVideoMessage
    buttons: MessageDialog.Ok
    text: "Nessuna videolezione selezionata"
  }

  MessageDialog {
    id : noDestinationMessage
    buttons: MessageDialog.Ok
    text: "Nessuna destinazione slide selezionata"
  }

  MessageDialog {
    id : successMessage
    buttons: MessageDialog.Ok
    text: "PDF creato!"
  }
}
