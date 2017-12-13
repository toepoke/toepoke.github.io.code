using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace NewCSharpFeatures.Tests {

	[TestClass]
	public class CSharp_7_Local_Functions {

		[TestMethod]
		public void Local_Functions() {
			string LocalFunctionTest() {
				return "this is a local function test";
			}

			// Arrange
			string localFunctionTestCall = "";

			// Act
			localFunctionTestCall = LocalFunctionTest();

			// Assert
			Assert.AreEqual("this is a local function test", localFunctionTestCall);
			
		}

	}

}
