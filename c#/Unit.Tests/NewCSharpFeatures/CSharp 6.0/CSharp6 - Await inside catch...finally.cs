using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Threading.Tasks;

namespace NewCSharpFeatures.Tests {

	[TestClass]
	public class CSharp_6_Await_Inside_Catch_Finally {
		
		public TestContext TestContext { get; set; }

		/// <summary>
		/// In essence you can now have an "await" inside a catch and finally block
		/// </summary>
		[TestMethod]
		public async Task Await_Inside_Catch_Finally() {
			// Arrange
			
			try {
				await Task.Run(() => throw new System.Exception("Testing 123....") );
			}
			catch (Exception e) {
				// Clean-up ???
				this.TestContext.WriteLine($"{e.Message}");
				await Task.Delay(3);
			}
			finally {
				// Completed
				await Task.Delay(20);
			}
		}

	}

}
