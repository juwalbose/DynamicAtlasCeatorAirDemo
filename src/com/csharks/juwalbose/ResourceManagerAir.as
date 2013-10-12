/**
 *
 * Copyright 2013 Juwal Bose, Csharks Games. All rights reserved.
 *
 * Email: juwal@csharks.com
 * Blog: http://csharksgames.blogspot.com
 * Twitter: @juwalbose
 
 * You may redistribute, use and/or modify this source code freely
 * but this copyright statement must not be removed from the source files.
 *
 * The package structure of the source code must remain unchanged.
 * Mentioning the author in the binary distributions is highly appreciated.
 *
 * If you use this utility it would be nice to hear about it so feel free to drop
 * an email.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. *
 *
 */
package com.csharks.juwalbose
{
	import com.adobe.images.PNGEncoder;
	import com.csharks.juwalbose.utils.DynamicAtlasCreator;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.utils.ByteArray;
	
	import starling.utils.AssetManager;
	
	public class ResourceManagerAir
	{
		public static var  assets:AssetManager=new AssetManager(1);
		public static var initialised:Boolean=false;
		private static var loader:Loader;
		
		[Embed(source = "../../../../assets/assets.xml", mimeType = "application/octet-stream")]
		private static const XhdpiXml:Class;
		private static var data:XML;
		private static var XhdpiPng:Bitmap;
		public static var scaleRatio:Number=1;
		
		private static var file:File=new File();
		//name for saving texture image & xml
		private static var atlasName:String="dacad";
		
		public static function initialise(_scaleRatio:Number):void{
		
			initialised=false;
			var intConv:uint=_scaleRatio*10;
			scaleRatio=intConv/10;
			
			var hasSavedAtlas:Boolean=false;
			file=File.applicationStorageDirectory.resolvePath(atlasName+scaleRatio.toString()+".png");
			//trace(file.nativePath,file.exists);
			if(file.exists){
				file=File.applicationStorageDirectory.resolvePath(atlasName+scaleRatio.toString()+".xml");
				//trace(file.nativePath,file.exists);
				if(file.exists){
					//load those files instead
					hasSavedAtlas=true;
				}
			}
			
			if(hasSavedAtlas){
				loadSavedAtlas();
			}else{
				loadImage("media/assets.png");
			}
			
		}
		
		private static function loadImage(fileName:String):void
		{
			loader = new Loader();
			var urlReq:URLRequest = new URLRequest(fileName);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
			loader.load(urlReq);
		}
		private static function creationComplete(result:String):void {  
			if(result=="success"){
				//initialised=true;
				saveAtlas();
			}
			DynamicAtlasCreator.creationComplete.remove(creationComplete);
			
			System.disposeXML(data);
			data=null;
			XhdpiPng.bitmapData.dispose();
			XhdpiPng=null;
		
		}
		
		
		private static function loaded(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaded);
			XhdpiPng=e.target.content as Bitmap;
			loader.unloadAndStop(true);
			loader=null;
			
			
			assets.verbose = false;//Capabilities.isDebugger;
			data=XML(new XhdpiXml());
			
			DynamicAtlasCreator.creationComplete.add(creationComplete);
			DynamicAtlasCreator.createFrom(XhdpiPng.bitmapData,data,scaleRatio,assets,atlasName);
		}
		private static function saveAtlas():void{//Users/<userName>/Library/Application Support/<applicationID>/Local Store
			trace("saving atlas");
			file=File.applicationStorageDirectory.resolvePath(atlasName+scaleRatio.toString()+".xml");
			var filestream:FileStream=new FileStream();
			filestream.open(file,FileMode.WRITE);
			filestream.writeUTFBytes(DynamicAtlasCreator.finalXML);
			filestream.close();
			// Encode the image as a PNG.
			var pngEncoder:PNGEncoder = new PNGEncoder();
			var imageByteArray:ByteArray = PNGEncoder.encode(DynamicAtlasCreator.finalAtlas);
			
			var imageFile:File = File.applicationStorageDirectory.resolvePath(atlasName+scaleRatio.toString()+".png");
			
			// Write the image data to a file.
			var imageFileStream:FileStream = new FileStream();
			imageFileStream.open(imageFile, FileMode.WRITE);
			imageFileStream.writeBytes(imageByteArray);
			imageFileStream.close();  
			
			imageByteArray=null;
			pngEncoder=null;
			
			//dispose explicitly
			DynamicAtlasCreator.dispose();
			
			//load Now
			loadSavedAtlas();
		}
		private static function loadSavedAtlas():void{
			trace("loading saved atlas");
			assets.verbose = Capabilities.isDebugger;
			assets.enqueue(File.applicationStorageDirectory.resolvePath(atlasName+scaleRatio.toString()+".png"),
				File.applicationStorageDirectory.resolvePath(atlasName+scaleRatio.toString()+".xml"));
			
			assets.loadQueue(function(ratio:Number):void
			{
				
				if (ratio == 1)
				{
					initialised=true;
				}
			});
			
		}
		
	}
}