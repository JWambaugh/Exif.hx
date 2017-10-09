package exif;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.Input;
import haxe.io.Eof;
import exif.Tag;

class Exif{
	

	
	#if sys
	public static function readFile(f:String):Map<String,Dynamic>{

		var input = sys.io.File.read(f,true);
		var exif = readInput(input);
		input.close();
		return exif;
	}
	#end
	
	#if js
	public static function readArrayBuffer(arrayBuffer:js.html.ArrayBuffer):Map<String, Dynamic>
	{
		return readBytes(Bytes.ofData(arrayBuffer));
	}
	#end
	
	public static function readBytes(bytes:Bytes):Map<String, Dynamic>
	{
		return readInput(new BytesInput(bytes));
	}
	
	static function readInput(input:AnyInput):Map<String, Dynamic>
	{
		try {
			input.bigEndian = true;
			if(input.readByte() != 0xFF || input.readByte() != 0xD8){
				throw "SOI (start of image) not found!";
			}
			//trace('here');
		
			while(true){
				//first byte should be ff
				input.readByte();
				var marker = input.readByte();
				//trace("marker: "+marker+" POS:"+ input.tell());
				if(marker == 225){
					//we're in!
					return readExif(input);
					break;
				}
				else if(marker == 224){
					//skip it
					input.read(16);
				}
				else{
					//skip the block
					var len = input.readUInt16();
					//trace("skipping block "+(len-2));
					input.read(len-2);
				}

			}
		} catch (any:Dynamic) {
		}
		
		return null;
	}


	private static function readExif(i:AnyInput){
		var length = i.readUInt16();
		var exifMarker = i.readString(4);
		if(exifMarker!="Exif"){
			throw ("Exif marker not found!");
		}
		i.readInt16(); //should be 0000
		
		var tiffHeader = i.readUInt16();
		var tiffOffset = i.tell() - 2;

		switch (tiffHeader)
		{
			case 0x4949: i.bigEndian = false;
			case 0x4d4d: i.bigEndian = true;
			case _: throw 'Invalid TIFF header: $tiffHeader';
		}
		
		var b:Int;
		if((b = i.readInt16()) != 0x002A){
			throw 'Invalid bytes: got $b, expected ${0x002A}';
		}
		if((b = i.readInt32()) != 0x00000008){
			throw 'Invalid bytes: got $b, expected ${0x00000008}';
		}
		
		
		
		
		var tags = readEntries(i,tiffOffset);

		if(tags.exists("ExifIFDPointer")){
			i.seekBegin(tags.get("ExifIFDPointer")+tiffOffset);
			//trace("exif offset: "+i.tell());
			var xifTags = readEntries(i,tiffOffset);
			//merge exif tags into regular tags
			for(tag in xifTags.keys()){
				tags.set(tag,xifTags.get(tag));
			}
		}
		return tags;
	}

	private static function readEntries(i:AnyInput,tiffOffset:Int):Map<String,Dynamic>{
		var numEntries = i.readUInt16();
		var tags = new Map<String,Dynamic>();
		////trace("num: "+numEntries );
		for(x in 0...numEntries){
			////trace("count: "+x+" of "+numEntries);
			var tag = new Tag(i,tiffOffset);
			if(tag.getKey() == null)throw("unrecognized tag: "+tag.tagCode);
			tags.set(tag.getKey(),tag.data);
		}
		return tags;
	}

	

}