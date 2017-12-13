using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace NewCSharpFeatures.Tests {
	
	[TestClass]
	public class CSharp_6_Auto_Property_Initialisers {

		/// <summary>
		/// See Person class for illustration
		/// </summary>
		[TestMethod]
		public void Auto_Property_Initialisers() {
			// Arrange
			var p = new Person();

			// Act - N/A
			
			// Assert
				// Note that the constructor _wins_
				Assert.AreEqual("Betty Rubble", p.Name);
		}

		class Person {
			public Person() {
				this.Name = "Betty Rubble";
			}
			public string Name { get; set; } = "Fred Flintstone";
		}

	}

}
