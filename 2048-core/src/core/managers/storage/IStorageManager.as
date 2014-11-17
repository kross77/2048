/**
 * Created by Administator on 13.10.14.
 */
package core.managers.storage {
public interface IStorageManager {
    function clearGameState():void;

    function getGameState(step:int = 0):Object;

    function getBestScore():int;

    function setBestScore(score:int):void;

    function setGameState(state:Object):void;

    function undo(serialize:Object):Object;
}
}
