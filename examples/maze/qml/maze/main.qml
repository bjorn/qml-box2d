import Qt 4.7
import Box2D 1.0
import QtMobility.sensors 1.1

Rectangle {
    id: mainWindow

    width: 800
    height: 640
    color: "black"

    Image {
        id: screen;
        anchors.centerIn: parent
        width: 360
        height: 540
        rotation: -90

        source: "levels/woodbackground.png"
        fillMode: Image.Tile

        MazeGame {
            anchors.fill: parent
        }

        Accelerometer  {
            Component.onCompleted: {
                start()
                print(dataRate, availableDataRates)
            }
            onReadingChanged: {
                var r = reading
                //level.gravity = Qt.point(-r.x * 4, -r.y * 4)
                level.gravity = Qt.point(-r.y * 4, r.x * 4)
            }
        }
    }

    SequentialAnimation {
        id: closeAnim
        NumberAnimation { target: screen; property: "scale"; to: 0.1; }
    }
}
