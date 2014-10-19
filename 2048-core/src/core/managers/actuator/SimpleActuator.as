/**
 * Created by Administator on 19.10.14.
 */
package core.managers.actuator {
import core.object.Grid;
import core.object.Tile;
import core.object.model.GameManagerVO;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import mx.core.UIComponent;

public class SimpleActuator extends UIComponent implements IActuator{
    private var container:Sprite;
    public function SimpleActuator() {
        container = new Sprite();
        addChild(container);
    }

    public function continueGame():void {
    }

    public function actuate(params:GameManagerVO):void {
        updateGrid(params.grid);
    }

    private function updateGrid(grid:Grid):void {
        container.removeChildren();
        for (var i:int = 0; i < grid.cells.length; i++) {
            var column:Array = grid.cells[i];
            for (var j:int = 0; j < column.length; j++) {

                var tile:Tile = column[j];
                createTile(tile, i, j);
            }

        }
    }

    private function createTile(tile:Tile, column:int, row:int):void {

        if(tile){
            var graficTile:Sprite = createFromTile(tile);
            graficTile.x = column*55;
            graficTile.y = row*55;
            container.addChild(graficTile);
        }
    }

    private function createFromTile(tile:Tile):Sprite {
        var sprite:Sprite = new Sprite();
        sprite.graphics.lineStyle(1, 0xccc);
        sprite.graphics.drawRect(0,0,50,50);
        var txt:TextField = new TextField();
        txt.text = String(tile.value);
        sprite.addChild(txt);
        txt.autoSize = TextFieldAutoSize.CENTER;
        txt.x = (50 - txt.textWidth)/2;
        txt.y = (50 - txt.textHeight)/2;
        return sprite;
    }
}
}
