DynamicAtlasCeatorAirDemo
=========================

AIR version of Dynamic Texture Atlas with saving to ApplicationStorageDirectory for reuse.

Web version with details can be found here
https://github.com/juwalbose/DynamicAtlasCreator

AIR version saves the created dynamic atlas into ApplicationStorageDirectory & tries to reuse it if found for all 
subsequent runs. DynamicAtlasCreator class remains the same with just minor changes to keep the created BitmapData 
in addition to the creation of the corresponding new XML data. Once saved these can be disposed by calling the dispose 
method. Supports texture 'frame' as well thus creating an optimised atlas.

ResourceManager class handles the saving & loading of the DynamicAtlas.

Other dependencies are Starling, AS3 Signals, TweenLite (can be removed by using Juggler instead)

Usage

DynamicAtlasCreator.creationComplete.add(creationComplete);//AS3 Signal will be dispatched

DynamicAtlasCreator.createFrom(bitmapData,xml,scale,assets,atlasName);

Where 
bitmapData > the super texture atlas image BitmapData

xml > super atlas XML

scale > the ratio to scale down to. eg, for 1024 x 768 this can be 0.5

assets > default Starling AssetManager class which will be populated with new textures

atlasName > the file name for saving the atlas texture & xml. atlas xml needs to store reference to texture name.

Thank you Daniel Sperl for the idea, inspiration & all the help. Thanking Ville Koskela for the wonderful Rectangle 
packing algorithm which enables this to work.
