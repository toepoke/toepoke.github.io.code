using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace NewCSharpFeatures.Tests {

	[TestClass]
	public class CSharp_6_Exception_Filters {

		public TestContext TestContext { get; set; }

		/// <summary>
		/// In essence we can conditionally handle exceptions, nice!
		/// </summary>
		[TestMethod]
		public void Exception_Filters() {
			
			try {
				throw new System.Exception("Test one");
//				throw new System.Exception("Test two");
			}	
			catch (System.Exception e) when (e.Message == "Test one") {
				this.TestContext.WriteLine("Test one");
			}
			catch (System.Exception e) when (e.Message == "Test two") {
				this.TestContext.WriteLine("Test two");
			}
		}

	}

}
