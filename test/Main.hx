package ;

import exif.Exif;

class Main{


	public static function main(){
		var tags = Exif.readFile('test.jpg');
		trace(Std.string(tags));
	}
}



