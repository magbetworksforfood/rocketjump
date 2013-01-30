/**
 * Created with IntelliJ IDEA.
 * User: magbetjke
 * Date: 1/30/13
 * Time: 11:27 PM
 * To change this template use File | Settings | File Templates.
 */
package cntrl {
import utils.*;

import flash.events.Event;
import flash.filesystem.File;
import flash.net.FileFilter;

import model.LandscapeModel;
import model.MainModel;
import model.TileModel;

import mx.collections.VectorCollection;

import mx.controls.Alert;

public class GlobalController {

    private static var _instance:GlobalController;

    public static function get instance():GlobalController {
        if (!_instance) _instance = new GlobalController(new SingletonData());
        return _instance;
    }

    public function GlobalController(singletonData:SingletonData):void {
        if (!singletonData) {
            throw new ArgumentError('Singleton class!!! Use instance getter');
        }
    }

    private var mainModel:MainModel;

    public function init(model:MainModel):void {
        this.mainModel = model;
    }

    public function select(landscape:LandscapeModel):void {
        if (mainModel) {
            mainModel.selectedLandscape = landscape;
        }
    }

    public function importConfig():void {
        if (mainModel) {
            startImportConfig()
        }
    }

    public function exportConfig():void {
        if (mainModel) {
            startExportConfig();
        }
    }

    private function startImportConfig():void {
        try {
            var file:File = mainModel.file;
            file.browseForOpen('Открыть файл...', [new FileFilter('XML', '*.xml')]);
            file.addEventListener(Event.SELECT, openFile);
        }
        catch (error:Error) {
            Alert.show('Неудача!' + '\n' + error.message);
        }
    }



    private function startExportConfig():void {
        try {
            var file:File = mainModel.file;
            file.browseForSave('Сохранить как');
            file.addEventListener(Event.SELECT, saveFile);
        }
        catch (error:Error) {
            Alert.show('Неудача!' + '\n' + error.message);
        }
    }

    private function saveFile(event:Event):void {
        var file:File = mainModel.file;
        file.removeEventListener(Event.SELECT, saveFile);

        if (!file.extension || file.extension != "xml") {
            file.nativePath += ".xml";
        }

        FileUtil.saveXML(createXML(), file);
    }

    private function createXML():XML {
        var xml:XML = <landscapes/>;
        for each (var landscape:LandscapeModel in mainModel.landscapes) {
            var landscapeNode:XML = <landscape/>;
            landscapeNode.@index = landscape.index;
            xml.appendChild(landscapeNode);
            for each (var tile:TileModel in landscape.tiles) {
                var tileNode:XML = <tile/>;
                tileNode.@index = tile.index;
                tileNode.@width = tile.width;
                tileNode.@height = tile.height;
                tileNode.@length = tile.length;
                landscapeNode.appendChild(tileNode);
            }
        }

        return xml;
    }

    private function parseXML(xml:XML):Vector.<LandscapeModel> {
        var landscapes:Vector.<LandscapeModel> = new <LandscapeModel>[];

        for each (var landscapeNode:XML in xml.children()) {
            var landscape:LandscapeModel = new LandscapeModel(landscapeNode.@index);
            for each (var tileNode:XML in landscapeNode.children()) {
                var tile:TileModel = new TileModel(tileNode.@index);
                tile.width = tileNode.@width;
                tile.height = tileNode.@height;
                tile.length = tileNode.@length;
                landscape.tiles.push(tile);
            }
            landscapes.push(landscape);
        }

        return landscapes;
    }

    private function openFile(event:Event):void {
        var file:File = mainModel.file;
        file.removeEventListener(Event.SELECT, openFile);

        mainModel.landscapes = new VectorCollection(parseXML(FileUtil.loadXML(file)));
    }
}
}

class SingletonData {
    public function SingletonData():void {
        //private class constructor
    }
}
