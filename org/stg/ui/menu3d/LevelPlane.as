package org.stg.ui.menu3d {
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.stg.ui.menu3d.asset.LevelPlaneAsset;	

	/**
	 * @author japanese cake
	 */
	public class LevelPlane extends Plane {
		
		public var asset	: LevelPlaneAsset;
		
		public function LevelPlane(material : MaterialObject3D = null, width : Number = 0, height : Number = 0, segmentsW : Number = 0, segmentsH : Number = 0) {
			super(material, width, height, segmentsW, segmentsH);
		}
	}
}
