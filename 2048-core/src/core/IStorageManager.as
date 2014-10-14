/**
 * Created by Administator on 13.10.14.
 */
package core {
public interface IStorageManager {
    function clearGameState():void;

    function getGameState():Object;

    function getBestScore():int;

    function setBestScore(score:int):void;

    function setGameState(state:Object):void;
}
}
