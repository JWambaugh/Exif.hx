package exif;
import haxe.io.BytesInput;
import haxe.io.Input;


/**
 * Currently only BytesInput and FileInput are supported
 */
@:forward(bigEndian, readByte, readUInt16, readInt16, readString, read, readInt32)
abstract AnyInput(Input)
{

	#if sys
	@:from 
	public static function fromFileInput(fileInput:sys.io.FileInput):AnyInput
	{
		return new AnyInput(fileInput);
	}
	#end
	
	@:from
	public static function fromBytesInput(bytesInput:BytesInput):AnyInput
	{
		return new AnyInput(bytesInput);
	}

	public inline function tell():Int
	{
		#if sys
		if ((this is sys.io.FileInput))
			return (cast this:sys.io.FileInput).tell();
		else
		#end
			return (cast this:BytesInput).position;		
	}
	
	public inline function seekBegin(offset:Int)
	{
		#if sys
		if ((this is sys.io.FileInput))
			(cast this:sys.io.FileInput).seek(offset, sys.io.FileSeek.SeekBegin);
		else
		#end
			(cast this:BytesInput).position = offset;
	}
	
	private function new(input:Input)
	{
		this = input;
	}
}