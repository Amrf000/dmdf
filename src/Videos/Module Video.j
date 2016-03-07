library ModuleVideosVideo

	/**
	 * \brief Every video should implement this module to provide a global instance.
	 */
	module Video
		private static thistype m_video

		public static method initVideo takes nothing returns nothing
			set thistype.m_video = thistype.create.evaluate()
		endmethod

		public static method video takes nothing returns thistype
			return thistype.m_video
		endmethod
	endmodule

endlibrary