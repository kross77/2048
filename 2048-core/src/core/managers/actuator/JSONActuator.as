/**
 * Created by Administator on 21.10.14.
 */
package core.managers.actuator {
import animation.easy.MergeEase;

import com.greensock.TweenLite;
import com.greensock.easing.Ease;
import com.greensock.easing.Elastic;
import com.greensock.easing.Expo;
import com.greensock.easing.Power0;
import com.greensock.easing.Power1;

import core.global.GlobalDispatcherSingleton;

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

import spark.components.Label;

public class JSONActuator extends UIComponent implements IActuator {
    [Embed(source="data/config.json", mimeType="application/octet-stream")]
    private var ConfigJsonFile:Class;
    private var gridUI:GridUI = new GridUI();

    private var container:Sprite;

    private var jsonParams:Object;
    private var mergeAnimation:Array = [];
    private var scoreLabel:TextField = new TextField();

    public function JSONActuator() {
        var bytes:ByteArray = new ConfigJsonFile();
        var json:String = bytes.readUTFBytes(bytes.length);
        trace(json);
        jsonParams = JSON.parse(json);
        gridUI.setParamsFromObject(jsonParams.grid);

        GlobalDispatcherSingleton.instance.addGlobalListener(gridUI);

        addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
        addChild(gridUI);
        container = new Sprite();
        addChild(container);
       // addChild(scoreLabel);
    }

    public function continueGame():void {
    }

    public function actuate(params:GameManagerVO):void {

        var grid:Grid = params.grid;

        if(gridUI.grid == null || grid.size != gridUI.grid.size){
            gridUI.redraw(grid);
        }

        gridUI.updateGrid(grid);
        scoreLabel.text = String(params.score);
        if(params.over){
            gridUI.disable();
        }
        this.width = gridUI.width;
        this.height = gridUI.height;

    }

    private function creationCompleteHandler(event:FlexEvent):void {
        updateUIPosition();
    }

    private function updateUIPosition():void {
       /* if (systemManager) {
            var stage:Stage = systemManager.stage;
            gridUI.x = container.x = (stage.stageWidth - gridUI.width) / 2;
            gridUI.y = container.y = (stage.stageHeight - gridUI.height) / 2;
        }*/

        //gridUI.x = container.x = (- gridUI.width) / 2;
        //gridUI.y = container.y = (- gridUI.height) / 2;
    }
}
}
