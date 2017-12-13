using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace NewCSharpFeatures.Tests {

	[TestClass]
	public class CSharp_6_Null_Conditional_Operators {

		[TestMethod]
		public void Can_Access_Null_Member_Safely() {
			// Arrange
			Person p = new Person();

			// Act
			string name = p?.Name;

			// Assert
			Assert.AreEqual(null, name);
		}

		[TestMethod]
		public void Can_Access_Null_Child_Member_Safely() {
			// Arrange
			Person p = new Person();

			// Act
			string town = p?.Address?.Town;

			// Assert
			Assert.AreEqual(null, town);
		}

		[TestMethod]
		public void Can_Access_Null_Child_Member_Safely_With_Tertiary_Argument() {
			// Arrange
			Person p = new Person();

			// Act
			string name = p?.Address?.Country ?? "UK";

			// Assert
			Assert.AreEqual("UK", name);
		}


		class Person {
			public string Name { get; set; }
			public Address Address { get; set; }
		}

		class Address {
			public string Town { get; set; } = "Not specified";
			public string Country { get; set; } = null;
		}

	}

}
