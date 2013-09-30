DynamicAtlasCeatorAirDemo
=========================

AIR version of Dynamic Texture Atlas with saving to ApplicationStorageDirectory for reuse.

Web version with details can be found here
https://github.com/juwalbose/DynamicAtlasCreator

AIR version saves the created dynamic atlas into ApplicationStorageDirectory & tries to reuse it if found for all 
subsequent runs. DynamicAtlasCreator class remains the same with just minor changes to keep the created BitmapData 
in addition to the creation of the corresponding new XML data. Once saved these can be disposed by calling the dispose 
method.

ResourceManager class handles the saving & loading of the DynamicAtlas.

Thank you Daniel Sperl for the idea, inspiration & all the help. Thanking Ville Koskela for the wonderful Rectangle 
packing algorithm which enables this to work.
