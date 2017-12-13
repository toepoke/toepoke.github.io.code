using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace NewCSharpFeatures.Tests {

	[TestClass]
	public class CSharp_72_Leading_Underscores {

		[TestMethod]
		public void Leading_Underscores_In_Binary() {
			// Arrange
			int binaryOld = 0;
			int binaryNew = 0;

			// Act - 0b => binary
			binaryOld = 0b0100_0001;		// c# 7.1 couldn't have a leading underscore
			binaryNew = 0b_0100_0001;
			
			// Assert
			Assert.AreEqual(65, binaryOld);
			Assert.AreEqual(65, binaryNew);
		}

		[TestMethod]
		public void Leading_Underscores_In_Hex() {
			// Arrange
			int hexOld = 0;
			int hexNew = 0;

			// Act - =x => binary
			hexOld = 0x41ff;
			hexNew = 0x_41_ff;
			
			// Assert
			Assert.AreEqual(16895, hexOld);
			Assert.AreEqual(16895, hexNew);
		}

	}

}
