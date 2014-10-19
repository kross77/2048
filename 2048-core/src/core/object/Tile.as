/**
 * Created by Administator on 14.10.14.
 */
package core.object {
import flash.geom.Point;

public class Tile implements IPositionObject{
    public var mergedFrom:*;
    private var _x:int;
    private var _y:int;
    public var value:int;
    public var position:IPositionObject;
    public var previousPosition:Position;
    public function Tile(position:Object, value:int) {
        this.position = new Position(position.x, position.y);
        this.value = value || 2;

    }

    public function savePosition():void {
        previousPosition = Position.convert({ x: _x, y: _y });
    }

    public function updatePosition(cell:Cell):void {
        _x = position.x;
        _y = position.y;
    }

    public function get x():int {
        return _x;
    }

    public function get y():int {
        return _y;
    }

    public function serialize():Object{
        return{
            position:{
                x: _x,
                y: _y
            },
            value: this.value
        }
    }
}
}
