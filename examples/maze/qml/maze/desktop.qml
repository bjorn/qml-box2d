import Qt 4.7
import Box2D 1.0

Rectangle {
    id: mainWindow

    width: 360
    height: 540
    color: "black"

    Image {
        id: screen;
        anchors.centerIn: parent
        width: 360
        height: 540

        source: "levels/woodbackground.png"
        fillMode: Image.Tile

        MazeGame {
            anchors.fill: parent
        }
    }

    SequentialAnimation {
        id: closeAnim
        NumberAnimation { target: screen; property: "scale"; to: 0.1; }
    }
}
