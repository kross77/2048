/**
 * Created by Administator on 14.10.14.
 */
package core.object {
import flash.geom.Point;

public class Tile implements IPositionObject{
    public var mergedFrom:Array;
    public var value:int;
    public var position:IPositionObject;
    public var previousPosition:Position;
    public function Tile(position:Object, value:int) {
        this.position = new Position(position.x, position.y);
        this.value = value || 2;

    }

    public function savePosition():void {
        previousPosition = Position.convert({ x: position.x, y: position.y });
    }

    public function updatePosition(cell:Cell):void {
        position = new Position(cell.x, cell.y);
    }

    public function get x():int {
        return position.x;
    }

    public function get y():int {
        return position.y;
    }

    public function serialize():Object{
        return{
            position:{
                x: position.x,
                y: position.y
            },
            value: this.value
        }
    }
}
}
