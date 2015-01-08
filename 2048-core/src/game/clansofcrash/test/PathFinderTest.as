/**
 * Created by a.krasovsky on 08.01.2015.
 */
package game.clansofcrash.test {
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Point;

import game.component.Pathfinder;

public class PathFinderTest extends Sprite{
    public function PathFinderTest() {
        var map:Array = [
            [0, 0, 1, 1, 0, 0, 0, 0, 0, 0],
            [0, 0, 1, 1, 0, 0, 0, 0, 0, 0],
            [0, 0, 1, 1, 0, 1, 1, 0, 0, 0],
            [0, 0, 1, 1, 0, 1, 1, 0, 0, 0],
            [0, 0, 0, 0, 0, 1, 1, 0, 0, 0],
            [0, 0, 1, 1, 0, 1, 1, 0, 0, 0],
            [0, 0, 1, 1, 0, 1, 1, 0, 0, 0],
            [0, 0, 1, 1, 0, 1, 1, 0, 0, 0],
            [0, 0, 1, 1, 0, 1, 1, 0, 0, 0],
            [0, 0, 1, 1, 0, 0, 0, 0, 0, 0]];
        drawMap(map);
        var pt:Pathfinder = new Pathfinder();
        pt.loadMap(map, 10, 10);
        var path:Array = pt.getPath(new Point(1, 1), new Point(8, 8), false);

        drawPath(path);
    }

    private function drawMap(map:Array):void {
        var mapSprite:Shape = new Shape();
        addChild(mapSprite);
        mapSprite.graphics.beginFill(0x000000, .3);
        for (var i:int = 0; i < map.length; i++) {
            var xLayer:Array = map[i];
            for (var j:int = 0; j < xLayer.length; j++) {
                var blockValue:int = xLayer[j];
                if(blockValue == 1){
                    mapSprite.graphics.drawRect(i*10, j*10, 10, 10);
                }
            }
        }

    }

    private function drawPath(path:Array):void {
        var myShape:Shape = new Shape();
        addChild(myShape);

        myShape.graphics.lineStyle(2, 0x990000, 5);

        for (var i:int = 0; i < path.length; i++) {
            trace(path[i].x, path[i].y);
            myShape.graphics.lineTo(5+path[i].x * 10, 5+path[i].y * 10);
        }
    }
}
}
