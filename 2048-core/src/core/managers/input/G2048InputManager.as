/**
 * Created by Administator on 19.10.14.
 */
package core.managers.input {
import game.actions.GameAction;

public class G2048InputManager extends AbstractInputManager {
    public function G2048InputManager() {
        super();
    }

    public function move(direction:int):void{
        inputAction(GameAction.MOVE, direction);
    }

    public function restart():void{
        inputAction(GameAction.RESTART);
    }

    public function keepPlaying():void{
        inputAction(GameAction.KEEP_PLAYING);
    }
}
}
