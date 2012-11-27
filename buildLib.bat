set path="C:\Program Files\WinRAR\";%path%
del haxelib\*.zip
mkdir haxelib
mkdir haxelib\exif
xcopy  lib\*.* haxelib\exif /e /y
cd haxelib
winrar.exe a -afzip exif.zip exif
haxelib test exif.zip
cd ..
