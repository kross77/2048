/**
 * Created by Administator on 21.10.14.
 */
package core.managers.actuator {
import core.managers.actuator.ui.GridUI;
import core.object.Grid;
import core.object.Tile;
import core.object.model.GameManagerVO;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import flash.utils.ByteArray;

import mx.core.UIComponent;

public class JSONActuator extends UIComponent implements IActuator {
    [Embed(source="data/config.json", mimeType="application/octet-stream")]
    private var ConfigJsonFile:Class;
    private var gridUI:GridUI = new GridUI();

    private var container:Sprite;

    private var jsonParams:Object;

    public function JSONActuator() {
        var bytes:ByteArray = new ConfigJsonFile();
        var json:String = bytes.readUTFBytes(bytes.length);
        trace(json);
        jsonParams = JSON.parse(json);
        gridUI.setParamsFromObject(jsonParams.grid);

        addChild(gridUI);
        container = new Sprite();
        addChild(container);
    }

    public function continueGame():void {
    }

    public function actuate(params:GameManagerVO):void {
        gridUI.redraw(params.grid);
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

        if (tile) {
            var graficTile:Sprite = createFromTile(tile);
            var cellParams:Object = jsonParams.grid.rect;
            var gridParams:Object = jsonParams.grid;
            graficTile.x = gridParams.borderWeight + column * (cellParams.width + gridParams.borderWeight);
            graficTile.y = gridParams.borderWeight + row * (jsonParams.grid.rect.width + gridParams.borderWeight);
            container.addChild(graficTile);
        }
    }

    private function createFromTile(tile:Tile):Sprite {
        var sprite:Sprite = new Sprite();

        sprite.graphics.beginFill(getBackgroundColorForTile(tile));
        sprite.graphics.drawRoundRect(0, 0, jsonParams.grid.rect.width, jsonParams.grid.rect.width, jsonParams.grid.rect.cornerRadius);
        var txt:TextField = new TextField();
        txt.text = String(tile.value);
        sprite.addChild(txt);
        txt.setTextFormat(getTextFieldFormat())
        txt.autoSize = TextFieldAutoSize.CENTER;
        txt.x = (jsonParams.grid.rect.width - txt.textWidth) / 2;
        txt.y = (jsonParams.grid.rect.width - txt.textHeight) / 2;
        txt.textColor = getTextColorForTile(tile);

        return sprite;
    }

    private function getTextFieldFormat():TextFormat {
        var tf:TextFormat = new TextFormat("Arial", 20);
        return tf;
    }

    private function getBackgroundColorForTile(tile:Tile):uint {
        var cellsParam:Object = jsonParams.grid.cells;
        return cellsParam[String(tile.value)].background;
    }

    private function getTextColorForTile(tile:Tile):uint {
        var cellsParam:Object = jsonParams.grid.cells;
        return cellsParam[String(tile.value)].color;
    }
}
}
