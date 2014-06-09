// A small utility for recording and replaying a replay

var currentLevelId;
var best;
var current = []
var replayIndex = 0;

function openMazeDatabase() {
    return openDatabaseSync("MazeRecords", "1.0", "Local Maze High Scores",
                            2 *  // 2 minutes of gameplay
                            60 * // 60 seconds per minute
                            60 * // 60 frames per second
                            16); // 16 bytes per position (estimated)
}

function createMazeTables(tx) {
    tx.executeSql("CREATE TABLE IF NOT EXISTS BestLaps (" +
                  " level NUMBER," +
                  " frame NUMBER," +
                  " x NUMBER," +
                  " y NUMBER" +
                  ")");
}

function start(levelId) {
    if (typeof levelId != "number") {
        console.debug("Warning: invalid level ID:", levelId);
        return;
    }
    if (currentLevelId !== levelId) {
        currentLevelId = levelId;
        restore();
    }

    current = []
    replayIndex = 0;
}

function step(ball, ghostBall) {
    // Save the current position of the ball
    current.push(Qt.point(ball.x, ball.y));

    // Set the position of the best recording at this time
    if (best === undefined || best.length === 0)
        return;
    replayIndex = Math.min(replayIndex + 1, best.length - 1);
    ghostBall.x = best[replayIndex].x;
    ghostBall.y = best[replayIndex].y;
}

function finish() {
    // Remember the previous recording if it was better
    if (best === undefined || best.length > current.length) {
        best = current;
        save();
    }
}

function save() {
    print("save", currentLevelId);
    if (best === undefined || best.length === 0)
        return;

    var db = openMazeDatabase();
    var addEntryStr = "INSERT INTO BestLaps VALUES (?, ?, ?, ?)";

    function saveCurrentRecord(tx) {
        createMazeTables(tx);
        tx.executeSql("DELETE FROM BestLaps WHERE level = ?", [currentLevelId]);
        for (var i = 0; i < best.length; ++i) {
            tx.executeSql(addEntryStr, [currentLevelId,
                                        i,
                                        best[i].x,
                                        best[i].y]);
        }
    }

    db.transaction(saveCurrentRecord);
}

function restore() {
    print("restore", currentLevelId);
    var db = openMazeDatabase();

    function restorePreviousRecord(tx) {
        createMazeTables(tx);
        var rs = tx.executeSql("SELECT frame, x, y" +
                               " FROM BestLaps" +
                               " WHERE level = ?" +
                               " ORDER BY frame", [currentLevelId]);
        best = []
        for (var i = 0; i < rs.rows.length; ++i)
            best.push(Qt.point(rs.rows.item(i).x, rs.rows.item(i).y));
        if (best.length === 0)
            best = undefined;
    }

    db.transaction(restorePreviousRecord);
}
