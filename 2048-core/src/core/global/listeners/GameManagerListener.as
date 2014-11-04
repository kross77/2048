/**
 * Created by a.krasovsky on 04.11.2014.
 */
package core.global.listeners {
import core.GameManager;
import core.event.GameEvent;
import core.global.GlobalListener;

public class GameManagerListener extends GlobalListener {
    private var gm:GameManager;
    public function GameManagerListener(gameManager:GameManager) {
        this.gm = gameManager;
        super(gameManager);
        add(restartCallback, GameEvent.RESTART);
    }

    private function restartCallback(data:Object = null):void {
        gm.restart();
    }
}
}
