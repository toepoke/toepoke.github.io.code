using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace NewCSharpFeatures.Tests {

	[TestClass]
	public class CSharp_6_Expression_Bodied_Members {

		/// <summary>
		/// See Person class, NewWay method
		/// </summary>
		[TestMethod]
		public void Expression_Bodied_Members() {
			// Arrange
			var p = new Person();

			// Act
			string oldWay = p.OldWay();
			string newWay = p.NewWay();

			// Assert
			Assert.AreEqual(oldWay, newWay);
		}

		class Person {
			public string Name { get; set; } = "Fred";

			public string OldWay() {
				return this.Name;
			}

			// Expression bodied member
			public string NewWay() => Name;
		}

	}

}
