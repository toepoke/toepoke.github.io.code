using Microsoft.VisualStudio.TestTools.UnitTesting;
using static System.Console;

namespace NewCSharpFeatures.Tests {

	[TestClass]
	public class CSharp_6_Using_Statement_For_Static_Methods {

		[TestMethod]
		public void Using_Statement_For_Static_Methods() {
			WriteLine("See line #2 - Note how we don't need to write System.Console.WriteLine");
		}

	}

}
