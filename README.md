AIR-WwAquarium-AS3
==================

WwAquarium is an Aquarium app module for mobile devices
Built with Flash, Starling. Deployed via Adobe AIR to iOS and Android

To compile the project you will need to update the paths to the referenced libraries.  This includes:

Air DSK
starling.swc (included in the Creative Cloud Gaming SDK, so download this)

NOTE: You need to make sure application descriptor in WwAquarium-app.xml agrees with the 
version of the AIR SDK you are using...

<application xmlns="http://ns.adobe.com/air/application/3.9"> 

You also need to update the paths to these SWCs from the AIR-WwAquarium-FLA project:

WwAquarium_audio_swc.swc
WwAquarium_swc.swc
WwDebug_swc.swc
WwAquarium_Fish_Type_1_swc.swc
WwAquarium_Fish_Type_2_swc.swc
WwAquarium_Decor_swc.swc

NOTE: Choose Project->Clean... to make sure the libraries are recognized.


Christmas Tree: http://graphicssoft.about.com/od/freedownloads/ig/Free-Christmas-Graphics/Christmas-Tree-Graphic.htm
Santa Hat: http://dryicons.com/icon/christmas-icons-set/santa-hat/ (non-commercial, for now)
