import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1
import QtQuick.Layouts 1.15


Item {
  width: parent.width
  height: parent.height

   Image {
    id: frameImage
    source: "../dataset/frame.png" // Sostituisci con il percorso alla tua immagine
    anchors.fill: parent
    fillMode: Image.PreserveAspectFit
  }

  MouseArea {
    id: selectionArea
    anchors.fill: parent
    drag.target: frameImage // Specifica l'elemento da trascinare

    // Variabili per mantenere le coordinate del rettangolo
    property int x_start: 0
    property int x_end: 0
    property int y_start: 0
    property int y_end: 0

    onPressed: {
        // Salva le coordinate iniziali
        x_start = mouse.x
        y_start = mouse.y
    }

    onPositionChanged: {
        // Calcola le dimensioni del rettangolo in base allo spostamento del mouse
        x_end = mouse.x
        y_end = mouse.y
    }

    onReleased: {
        // Gestisci il rettangolo selezionato
        console.log("Rettangolo selezionato: start_x =", x_start, "end_x =", x_end, "start_y =", y_start, "end_y =", y_end,)

        // Puoi fare ulteriori operazioni qui, ad esempio, aprire una finestra di dialogo con le coordinate del rettangolo
        //var dialog = Qt.createQmlObject('
        //  import QtQuick.Dialogs 1.3; Rectangle { width: 200; height: 100; color: "white"; Text { anchors.centerIn: parent; text: "Rettangolo selezionato:\\nX = " + startX + "\\nY = " + startY + "\\nWidth = " + width + "\\nHeight = " + height; } }', selectionArea, "dynamicSnippet1");
        //dialog.show();

        // Reimposta le variabili per la prossima selezione
        x_start = 0
        y_start = 0
        x_end = 0
        y_end = 0
    }
  }

  Rectangle {
        id:rectRoi
        opacity: 0.7
        x: selectionArea.x_start
        y: selectionArea.y_start
        width: selectionArea.x_end - selectionArea.x_start
        height: selectionArea.y_end - selectionArea.y_start
        color: "#d2d2d2"
 
        MouseArea {
            id:roiarea
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
 
            onClicked:{
 
                console.log("Right Button Clicked");
            }
        }
    }
}