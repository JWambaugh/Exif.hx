
package exif;

class Tag {
	public var tagCode:Int;
	public var dataType:Int;
	public var data:Dynamic;
	
	public function new(i:AnyInput,tiffOffset:Int){
		data = null;
		//trace("____________\n Position: "+i.tell());
		var entryOffset = i.tell();
		tagCode = i.readUInt16();
		//trace("TagCode: "+tagCode);
		dataType = i.readUInt16();

		//trace("type: "+dataType);
		var length = i.readInt32();
		//trace("length: "+length);
		if(dataType == 1 || dataType == 7){
			if(length == 1){
				data = i.readByte();
				i.readByte();
				i.readUInt16();//need to take up 4 bytes
			}else{
				var dataPos = tiffOffset + i.readInt32();
				//trace("dataPos:" +dataPos);
				var pos = i.tell();
				dataPos = length > 4 ? dataPos : (entryOffset + 8);
				i.seekBegin(dataPos);
				data = [];
				for(x in 0...length){
					data.push(i.readByte());
				}
				i.seekBegin(pos);
			}
		}
		else if(dataType == 2){
			var dataPos = tiffOffset + i.readInt32();
			//trace("dataPos:" +dataPos);
			var pos = i.tell();
			dataPos = length > 4 ? dataPos : (entryOffset + 8);
			i.seekBegin(dataPos);
			data = i.readString(length-1);
			i.seekBegin(pos);
		}

		else if(dataType == 3){
			if(length == 1){
				data = i.readUInt16();
				i.readUInt16();//need to take up 4 bytes
			}else{
				//trace("here");
				var dataPos = tiffOffset + i.readInt32();
				//trace("dataPos:" +dataPos);
				var pos = i.tell();
				dataPos = length > 2 ? dataPos : (entryOffset + 8);
				i.seekBegin(dataPos);
				data=[];
				for(x in 0...length){
					data.push(i.readUInt16());
				}
				i.seekBegin(pos);
			}
		}
		else if(dataType == 4 || dataType == 9){
			if(length == 1){
				data = i.readInt32();
			}else{
				//trace("here");
				var dataPos = tiffOffset + i.readInt32();
				//trace("dataPos:" +dataPos);
				var pos = i.tell();
				i.seekBegin(dataPos);
				data=[];
				for(x in 0...length){
					data.push(i.readInt32());
				}
				i.seekBegin(pos);
			}
			
		}
		else if(dataType == 5||dataType == 10){
			//trace("here");
			var dataPos = tiffOffset + i.readInt32();
			//trace("dataPos:" +dataPos);
			var pos = i.tell();
			i.seekBegin(dataPos);
			if(length ==1){
				data = i.readInt32()/i.readInt32();
			}else{
				data=[];
				for(x in 0...length){
					data.push(i.readInt32()/i.readInt32());
				}
			}
			i.seekBegin(pos);
		
			
		}else{
			i.readInt32();
		}
		
		//trace("key: "+getKey()+" val: "+data);
		
		
	}
		
	public function getKey(){
		return switch(tagCode){
			// version tags
			case 0x9000 : "ExifVersion";			// EXIF version
			case 0xA000 : "FlashpixVersion";		// Flashpix format version

			// colorspace tags
			case 0xA001 : "ColorSpace";			// Color space information tag

			// image configuration
			case 0xA002 : "PixelXDimension";		// Valid width of meaningful image
			case 0xA003 : "PixelYDimension";		// Valid height of meaningful image
			case 0x9101 : "ComponentsConfiguration";	// Information about channels
			case 0x9102 : "CompressedBitsPerPixel";	// Compressed bits per pixel

			// user information
			case 0x927C : "MakerNote";			// Any desired information written by the manufacturer
			case 0x9286 : "UserComment";			// Comments by user

			// related file
			case 0xA004 : "RelatedSoundFile";		// Name of related sound file

			// date and time
			case 0x9003 : "DateTimeOriginal";		// Date and time when the original image was generated
			case 0x9004 : "DateTimeDigitized";		// Date and time when the image was stored digitally
			case 0x9290 : "SubsecTime";			// Fractions of seconds for DateTime
			case 0x9291 : "SubsecTimeOriginal";		// Fractions of seconds for DateTimeOriginal
			case 0x9292 : "SubsecTimeDigitized";		// Fractions of seconds for DateTimeDigitized

			// picture-taking conditions
			case 0x829A : "ExposureTime";		// Exposure time (in seconds)
			case 0x829D : "FNumber";			// F number
			case 0x8822 : "ExposureProgram";		// Exposure program
			case 0x8824 : "SpectralSensitivity";		// Spectral sensitivity
			case 0x8827 : "ISOSpeedRatings";		// ISO speed rating
			case 0x8828 : "OECF";			// Optoelectric conversion factor
			case 0x9201 : "ShutterSpeedValue";		// Shutter speed
			case 0x9202 : "ApertureValue";		// Lens aperture
			case 0x9203 : "BrightnessValue";		// Value of brightness
			case 0x9204 : "ExposureBias";		// Exposure bias
			case 0x9205 : "MaxApertureValue";		// Smallest F number of lens
			case 0x9206 : "SubjectDistance";		// Distance to subject in meters
			case 0x9207 : "MeteringMode"; 		// Metering mode
			case 0x9208 : "LightSource";			// Kind of light source
			case 0x9209 : "Flash";			// Flash status
			case 0x9214 : "SubjectArea";			// Location and area of main subject
			case 0x920A : "FocalLength";			// Focal length of the lens in mm
			case 0xA20B : "FlashEnergy";			// Strobe energy in BCPS
			case 0xA20C : "SpatialFrequencyResponse";	// 
			case 0xA20E : "FocalPlaneXResolution"; 	// Number of pixels in width direction per FocalPlaneResolutionUnit
			case 0xA20F : "FocalPlaneYResolution"; 	// Number of pixels in height direction per FocalPlaneResolutionUnit
			case 0xA210 : "FocalPlaneResolutionUnit"; 	// Unit for measuring FocalPlaneXResolution and FocalPlaneYResolution
			case 0xA214 : "SubjectLocation";		// Location of subject in image
			case 0xA215 : "ExposureIndex";		// Exposure index selected on camera
			case 0xA217 : "SensingMethod"; 		// Image sensor type
			case 0xA300 : "FileSource"; 			// Image source (3 == DSC)
			case 0xA301 : "SceneType"; 			// Scene type (1 == directly photographed)
			case 0xA302 : "CFAPattern";			// Color filter array geometric pattern
			case 0xA401 : "CustomRendered";		// Special processing
			case 0xA402 : "ExposureMode";		// Exposure mode
			case 0xA403 : "WhiteBalance";		// 1 = auto white balance; 2 = manual
			case 0xA404 : "DigitalZoomRation";		// Digital zoom ratio
			case 0xA405 : "FocalLengthIn35mmFilm";	// Equivalent foacl length assuming 35mm film camera (in mm)
			case 0xA406 : "SceneCaptureType";		// Type of scene
			case 0xA407 : "GainControl";			// Degree of overall image gain adjustment
			case 0xA408 : "Contrast";			// Direction of contrast processing applied by camera
			case 0xA409 : "Saturation"; 			// Direction of saturation processing applied by camera
			case 0xA40A : "Sharpness";			// Direction of sharpness processing applied by camera
			case 0xA40B : "DeviceSettingDescription";	// 
			case 0xA40C : "SubjectDistanceRange";	// Distance to subject

			// other tags
			
			case 0xA420 : "ImageUniqueID";		// Identifier assigned uniquely to each image
			case 0x0100 : "ImageWidth";
			case 0x0101 : "ImageHeight";
			case 0x8769 : "ExifIFDPointer";
			case 0x8825 : "GPSInfoIFDPointer";
			case 0xA005 : "InteroperabilityIFDPointer";
			case 0x0102 : "BitsPerSample";
			case 0x0103 : "Compression";
			case 0x0106 : "PhotometricInterpretation";
			case 0x0112 : "Orientation";
			case 0x0115 : "SamplesPerPixel";
			case 0x011C : "PlanarConfiguration";
			case 0x0212 : "YCbCrSubSampling";
			case 0x0213 : "YCbCrPositioning";
			case 0x011A : "XResolution";
			case 0x011B : "YResolution";
			case 0x0128 : "ResolutionUnit";
			case 0x0111 : "StripOffsets";
			case 0x0116 : "RowsPerStrip";
			case 0x0117 : "StripByteCounts";
			case 0x0201 : "JPEGInterchangeFormat";
			case 0x0202 : "JPEGInterchangeFormatLength";
			case 0x012D : "TransferFunction";
			case 0x013E : "WhitePoint";
			case 0x013F : "PrimaryChromaticities";
			case 0x0211 : "YCbCrCoefficients";
			case 0x0214 : "ReferenceBlackWhite";
			case 0x0132 : "DateTime";
			case 0x010E : "ImageDescription";
			case 0x010F : "Make";
			case 0x0110 : "Model";
			case 0x0131 : "Software";
			case 0x013B : "Artist";
			case 0x8298 : "Copyright";
			default:null;
		}
	}




}