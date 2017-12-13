using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace NewCSharpFeatures.Tests {

	[TestClass]
	public class CSharp_7_Out_keyword_Improvements {

		[TestMethod]
		public void Out_keyword_Improvements() {
			// Arrange / Act
			SetPoints(out var x, out int y);

			// Assert
			Assert.AreEqual(2, x);
			Assert.AreEqual(4, y);
		}

		protected void SetPoints(out int x, out int y) {
			x = 2;
			y = 4;
		}

	}

}
