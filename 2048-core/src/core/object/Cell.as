/**
 * Created by Administator on 14.10.14.
 */
package core.object {
public class Cell implements IPositionObject{
    private var _x:int;
    private var _y:int;

    public function Cell(x:int, y:int) {
        _x = x;
        _y = y;
    }

    public static function fromObject(param:Object):Cell {
        return new Cell(param.x, param.y);
    }


    public function get x():int {
        return _x;
    }

    public function get y():int {
        return _y;
    }
}
}
