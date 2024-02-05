import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: main
    visible: true
    width: 640
    height: 480
    title: "Video to Slide"

   /*  BusyIndicator {
        id: loadingIndicator
        anchors.centerIn: parent
        running: main.loading // Bind the running property to the loading Boolean
    } */
    StackView {
      id: stackView
      anchors.fill: parent

      initialItem: Loader {
        source: "Home.qml"
      }
    }
}
