package exif;
import sys.io.File;
import sys.io.FileInput;
import haxe.io.Eof;
import exif.Tag;

class Exif{
	



	public static function readFile(f:String):Map<String,Dynamic>{

		var input = File.read(f,true);
		input.bigEndian = true;
		if(input.readByte() != 0xFF || input.readByte() != 0xD8){
			throw("SOI (start of image) not found!");
		}
		//trace('here');
		try{
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
		}catch(e:Eof){
			return null;
		}
		return null;
	}


	private static function readExif(i:FileInput){
		var length = i.readUInt16();
		var exifMarker = i.readString(4);
		if(exifMarker!="Exif"){
			throw ("Exif marker not found!");
		}
		i.readInt16();//should be 0000
		var tiffHeader = i.readUInt16();
		if(tiffHeader == 0x4949){
			//trace("little endian");
			i.bigEndian = false;
		}
		if(tiffHeader == 0x4D4D){
			//trace("big endian");
			i.bigEndian = true;
		}
		else{
			throw('TIFF header not recognizable!');
		}
		var tiffOffset = i.tell()-2;

		if(i.readInt16() != 0x002A){
			throw "Read error";
		}
		if(i.readInt16() != 0x0000){
			throw "Read error";
		}
		if(i.readInt16() != 0x0008){
			throw "Read error";
		}
		var tags = readEntries(i,tiffOffset);

		if(tags.exists("ExifIFDPointer")){
			i.seek(tags.get("ExifIFDPointer")+tiffOffset,SeekBegin);
			//trace("exif offset: "+i.tell());
			var xifTags = readEntries(i,tiffOffset);
			//merge exif tags into regular tags
			for(tag in xifTags.keys()){
				tags.set(tag,xifTags.get(tag));
			}
		}
		return tags;
	}

	private static function readEntries(i:FileInput,tiffOffset:Int):Map<String,Dynamic>{
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