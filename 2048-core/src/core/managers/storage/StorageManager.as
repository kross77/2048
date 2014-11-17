/**
 * Created by Administator on 19.10.14.
 */
package core.managers.storage {
public class StorageManager implements IStorageManager {
    public var steps:Array = [];
    public function StorageManager() {
    }

    public function clearGameState():void {
    }

    public function getGameState(step:int = 0):Object {
        return steps[steps.length-step];
    }

    public function getBestScore():int {
        return 0;
    }

    public function setBestScore(score:int):void {
    }

    public function setGameState(state:Object):void {
        steps.push(state);
    }

    public function undo(serialize:Object):Object {
        var state:Object = steps.pop();
        if(serialize != state){ return state };
        return steps.pop();
    }
}
}
