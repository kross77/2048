/**
 * Created by Administator on 19.10.14.
 */
package core.object {
public class Position implements IPositionObject {
    private var _x:int;
    private var _y:int;
    public function Position(x:int, y:int) {
        _x = x;
        _y = y;
    }

    public function get x():int {
        return _x;
    }

    public function get y():int {
        return _y;
    }

    public static function convert(param:Object):Position
    {
        return new Position(param.x, param.y);
    }
}
}
