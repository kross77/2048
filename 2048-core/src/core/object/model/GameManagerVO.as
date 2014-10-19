/**
 * Created by Administator on 20.10.14.
 */
package core.object.model {
public class GameManagerVO {
    public var score:int;
    public var won:Boolean;
    public var bestScore:int;
    public var terminated:Boolean;
    public var over:Boolean;
    public var size:int = 4;
    public var startTiles:int =2;
    public function GameManagerVO() {
    }
}
}
