/**
 * Created by Administator on 21.10.14.
 */
package core.managers.actuator {
import com.greensock.TweenLite;

import core.managers.actuator.ui.GridUI;
import core.object.Grid;
import core.object.Tile;
import core.object.model.GameManagerVO;

import flash.display.Sprite;

import flash.display.Sprite;
import flash.display.Stage;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.utils.ByteArray;
import flash.utils.setTimeout;

import mx.core.UIComponent;
import mx.events.FlexEvent;

public class JSONActuator extends UIComponent implements IActuator {
    [Embed(source="data/config.json", mimeType="application/octet-stream")]
    private var ConfigJsonFile:Class;
    private var gridUI:GridUI = new GridUI();

    private var container:Sprite;

    private var jsonParams:Object;
    private var mergeAnimation:Array = [];

    public function JSONActuator() {
        var bytes:ByteArray = new ConfigJsonFile();
        var json:String = bytes.readUTFBytes(bytes.length);
        trace(json);
        jsonParams = JSON.parse(json);
        gridUI.setParamsFromObject(jsonParams.grid);
        addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);

        addChild(gridUI);
        container = new Sprite();
        addChild(container);
    }

    public function continueGame():void {
    }

    public function actuate(params:GameManagerVO):void {
        var grid:Grid = params.grid;
        if(gridUI.grid == null || grid.size != gridUI.grid.size){
            gridUI.redraw(grid);
        }
        updateGrid(grid);

    }

    private function updateGrid(grid:Grid):void {
        container.removeChildren();
        for (var i:int = 0; i < grid.cells.length; i++) {
            var column:Array = grid.cells[i];
            for (var j:int = 0; j < column.length; j++) {

                var tile:Tile = column[j];
                var tileSprite:TileSprite = createTile(tile, i, j);
                if(tileSprite){
                    var isNewTile:Boolean = tile.previousPosition == null;

                    TweenLite.to(tileSprite, .5, {x: columPosition(i), y: rowPositon(j)});
                    if(isNewTile){
                        if(tile.mergedFrom == null){
                            setTimeout(tileSprite.show, .5);
                        }else{
                            tileSprite.show();
                        }

                    }
                }

            }

        }
    }

    private function createTile(tile:Tile, column:int, row:int):TileSprite {

        if (tile) {
            var graficTile:TileSprite = createFromTile(tile);
            //see if we have merged
            if(tile.mergedFrom){
                var tile1:Tile = tile.mergedFrom[0];
                var tile2:Tile = tile.mergedFrom[1];
                var s1:TileSprite = createTile(tile1, tile1.x, tile1.y);
                var s2:TileSprite = createTile(tile2, tile2.x, tile2.y);
  //              mergeAnimation.push([s1, .5, {x: columPosition(column), y: rowPositon(row)}]);
//                mergeAnimation.push([s2, .5, {x: columPosition(column), y: rowPositon(row)}]);
               TweenLite.to(s1, .5, {x: columPosition(column), y: rowPositon(row)});
                TweenLite.to(s2, .5, {x: columPosition(column), y: rowPositon(row)});
            }
            if(tile.previousPosition){
                graficTile.x = columPosition(tile.previousPosition.x);
                graficTile.y = rowPositon(tile.previousPosition.y);
            }else{
                graficTile.x = columPosition(column);
                graficTile.y = rowPositon(row);
            }

            container.addChild(graficTile);
            return graficTile;
        }

        return null;


    }

    private function rowPositon(row:int):int {
        var cellParams:Object = jsonParams.grid.rect;
        var gridParams:Object = jsonParams.grid;
        return gridParams.borderWeight + row * (jsonParams.grid.rect.width + gridParams.borderWeight);
    }

    private function columPosition(column:int):int {
        var cellParams:Object = jsonParams.grid.rect;
        var gridParams:Object = jsonParams.grid;
        return gridParams.borderWeight + column * (cellParams.width + gridParams.borderWeight);
    }

    private function createFromTile(tile:Tile):TileSprite {
        var sprite:TileSprite = new TileSprite();
        sprite.draw(tile, jsonParams.grid);
        return sprite;
    }



    private function creationCompleteHandler(event:FlexEvent):void {
        updateUIPosition();
    }

    private function updateUIPosition():void {
        if (systemManager) {
            var stage:Stage = systemManager.stage;
            gridUI.x = container.x = (stage.stageWidth - gridUI.width) / 2;
            gridUI.y = container.y = (stage.stageHeight - gridUI.height) / 2;
        }
    }
}
}
