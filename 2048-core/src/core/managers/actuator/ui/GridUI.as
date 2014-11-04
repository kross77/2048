/**
 * Created by Administator on 21.10.14.
 */
package core.managers.actuator.ui {
import animation.easy.MergeEase;

import com.bit101.components.PushButton;

import com.greensock.TweenLite;

import core.event.GameEvent;
import core.global.GlobalListener;
import core.global.IGlobalListener;
import core.global.globalEvent;
import core.global.listeners.GridUIGlobalListener;

import core.managers.actuator.TileSprite;
import core.object.Grid;
import core.object.Tile;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.utils.setTimeout;
import mx.core.UIComponent;
import spark.components.Button;

public class GridUI extends UIComponent implements IGlobalListener{
    public var background:uint;
    public var cornerRadius:int;
    public var borderWeight:int;
    public var rect:GridEmptyRectangleUI = new GridEmptyRectangleUI();
    private var container:Sprite = new Sprite();
    private var _grid:Grid;
    private var jsonGridParams:Object;
    private var fadeButton:PushButton = new PushButton();
    private var fade:Sprite;
    public var disabled:Boolean;

    public function GridUI() {
        addChild(container);
    }

    private function createFade():void {
        fade = new Sprite();
        fade.graphics.beginFill(0xFFFFFF, .8);
        var width:int =  this.width = borderWeight + (rect.width + borderWeight) * grid.size;
        var height:int = this.height = borderWeight + (rect.height + borderWeight) * grid.size;
        fade.graphics.drawRect(0, 0, width, height);
        addChild(fade);
        createFadeButton(fade);

        //fade.visible = false;
    }

    private function createFadeButton(parent:Sprite):void {
        fadeButton.label = "Play";
        fadeButton.x = (parent.width - fadeButton.width)/2;
        fadeButton.y = (parent.height - fadeButton.height)/2;
        parent.addChild(fadeButton);

        fadeButton.addEventListener(MouseEvent.CLICK, fadeButtonClickHandler);
    }

    public function setParamsFromObject(params:Object):void {
        jsonGridParams = params;
        for (var propertyName:String in params) {
            if (propertyName != "rect") {
                if (this.hasOwnProperty(propertyName)) {
                    this[propertyName] = params[propertyName];
                }
            } else {
                setEmptyRectangleParams(params[propertyName]);
            }

        }
    }

    private function setEmptyRectangleParams(params:Object):void {
        for (var propertyName:String in params) {
            if (rect.hasOwnProperty(propertyName)) {
                rect[propertyName] = params[propertyName];
            }

        }
    }

    public function redraw(grid:Grid):void {

        _grid = grid;
        if(!fade){
            createFade();
        }
        graphics.clear();

        //draw background rectangle
        graphics.beginFill(background);
        var width:int =  this.width = borderWeight + (rect.width + borderWeight) * grid.size;
        var height:int = this.height = borderWeight + (rect.height + borderWeight) * grid.size;
        graphics.drawRoundRect(0, 0, width, height, cornerRadius, cornerRadius);
        //draw empty rectangles
        for (var i:int = 0; i < _grid.size; i++) {
            for (var j:int = 0; j < _grid.size; j++) {
                rect.drawIn(graphics, i, j, borderWeight);
            }
        }

    }

    public function get grid():Grid {
        return _grid;
    }

    public function updateGrid(grid:Grid):void {
        if(disabled){
            enable();
        }
        container.removeChildren();
        for (var i:int = 0; i < grid.cells.length; i++) {
            var column:Array = grid.cells[i];
            for (var j:int = 0; j < column.length; j++) {

                var tile:Tile = column[j];
                var tileSprite:TileSprite = createTile(tile, i, j);
                if(tileSprite){
                    var isNewTile:Boolean = tile.previousPosition == null;
                    if(isNewTile){
                        if(tile.mergedFrom == null){
                            tileSprite.alpha = 0;
                            setTimeout(tileSprite.show, 200);
                        }else{
                            tileSprite.show(MergeEase.ease, .5);
                        }
                    }else{
                        TweenLite.to(tileSprite, .3, {x: columPosition(i), y: rowPositon(j)});
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
        return borderWeight + row * (rect.width + borderWeight);
    }

    private function columPosition(column:int):int {
        return borderWeight + column * (rect.width + borderWeight);
    }

    private function createFromTile(tile:Tile):TileSprite {
        var sprite:TileSprite = new TileSprite();
        sprite.draw(tile, jsonGridParams);
        return sprite;
    }



    public function disable():void {
        fade.alpha = 0;
        fade.visible = true;
        TweenLite.to(fade, .5, {alpha: 1});
        disabled = true;
    }

    public function enable():void {
        TweenLite.to(fade, .5, {
            alpha: 0,
            onComplete: function():void{
                    fade.visible = false;
                    disabled = false;
                }
            }
        );
    }

    private function fadeButtonClickHandler(event:MouseEvent):void {
        globalEvent(GameEvent.RESTART);
    }

    private var _gridUIGlobalListener:GridUIGlobalListener;
    public function get listener():GlobalListener {
        if(!_gridUIGlobalListener) {
            _gridUIGlobalListener = new GridUIGlobalListener(this);
        }
        return _gridUIGlobalListener;
    }
}
}
