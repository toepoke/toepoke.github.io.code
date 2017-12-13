using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace NewCSharpFeatures.Tests {

	[TestClass]
	public class CSharp_72_Reference_Sematics_With_Value_Types {

		/// <summary>
		/// The "in" modifier stipulates the function should _pass_by_reference_ (rather than value) and 
		/// does _not_ modify the given parameter.
		/// The compile treats modification inside the method as an error.
		/// </summary>
		/// <seealso cref="https://docs.microsoft.com/en-gb/dotnet/csharp/reference-semantics-with-value-types"/>
		[TestMethod]
		public void In_Parameters() {
			// Arrange - local function for illustration
			double multi(in double value1, in double value2) {
				// value += 1		=> compile error
				return value1 * value2;
			}

			// Act
			double answer = multi(2, 2);

			// Assert
			Assert.AreEqual(4, answer);
		}

	}

}
