Exif.hx
=======

Exif meta tag parser for haxe.

Usage
=======

Library supports reading Exif from ```sys.io.FileInput``` and ```haxe.io.BytesInput```

```haxe
// if you are targeting js, first obtain an js.html.ArrayBuffer with JPEG binary data
var exif = Exif.readArrayBuffer(jpegArrayBuffer);
// if you are targeting sys target (neko / cpp / cppia) or in macro and reading from a file
var exif = Exif.readFile("image.jpg"); 
// if you are targeting cross just read directly from haxe.io.Bytes
var exif = Exif.readBytes(jpegBytes);
// to get exif data
if (exif != null) { //if exif data can not be extracted null will be returned
    var orientation:Null<Int> = exif.get("Orientation");
    //do smth :)
}
```

License
=======

Copyright (c) 2012, Jordan CM Wambaugh
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.