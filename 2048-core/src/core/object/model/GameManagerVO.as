/**
 * Created by Administator on 20.10.14.
 */
package core.object.model {
import core.object.Grid;

public class GameManagerVO {
    public var score:int;
    public var won:Boolean;
    public var bestScore:int;
    public var terminated:Boolean;
    public var over:Boolean;
    public var size:int = 4;
    public var startTiles:int =2;
    public var grid:Grid;
    public function GameManagerVO() {
    }

    public function clone():GameManagerVO{
        var vObj:GameManagerVO = new GameManagerVO();
        vObj.score = this.score;
        vObj.won = this.won;
        vObj.bestScore = this.bestScore;
        vObj.terminated = this.terminated;
        vObj.over = this.over;
        vObj.size = this.size;
        vObj.startTiles = this.startTiles;
        vObj.grid = this.grid;
        return vObj;
    }
}
}
