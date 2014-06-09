import Qt 4.7
import Box2D 1.0

Body {
    id: hole
    bodyType: Body.Static

    fixtures: Circle {
        id: circle
        sensor: true
        radius: 15
        x: radius
        y: radius

        onContactChanged: {
            if (other.parent != ball || ball.state == "gone")
                return;

            var distX = Math.abs(ball.x - hole.x - circle.x)
            var distY = Math.abs(ball.y - hole.y - circle.y)
            var dist = Math.sqrt(distX * distX + distY * distY)

            if (Math.abs(dist < circle.radius)) {
                ball.disappearTo(ball.parent.mapFromItem(hole,
                                                         circle.x,
                                                         circle.y))
            }
        }

        Image {
            anchors.centerIn: parent
            source: "hole.png"
        }
    }
}
