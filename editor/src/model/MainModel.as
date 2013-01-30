package model {
import flash.filesystem.File;

import mx.collections.VectorCollection;

    import model.GlobalConfig;

    public class MainModel {

        private var _landscapes:VectorCollection;
        [Bindable]
        public var selectedLandscape:LandscapeModel;
        [Bindable]
        public var selectedTile:TileModel;

        public var file:File = File.documentsDirectory;

        public function MainModel() {
            init();
        }

        private function init():void {
            var landscapes:Vector.<LandscapeModel> = new <LandscapeModel>[];

            for (var i:uint = 0; i < GlobalConfig.LANDSCAPES_COUNT; i++) {
                landscapes.push(new LandscapeModel(i, false));
            }

            this.landscapes = new VectorCollection(landscapes);
        }


        [Bindable]
        public function get landscapes():VectorCollection {
            return _landscapes;
        }

        public function set landscapes(value:VectorCollection):void {
            if (_landscapes != value) {
                _landscapes = value;

                if (_landscapes && _landscapes.length) {
                    selectedLandscape = _landscapes[0];
                }
            }
        }
    }
}
