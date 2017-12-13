using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;

namespace NewCSharpFeatures.Tests {

	[TestClass]
	public class CSharp_71_Inferring_Tuple_Names {

		/// <summary>
		/// Old way with Item1, Item2, Item3
		/// </summary>
		[TestMethod]
		public void Old_Way_Tuples_Item1_Item2_Item3() {
			// Arrange
			Tuple<int, int, string> oldTuple = null;

			// Act
			oldTuple = new Tuple<int, int, string>(3, 4, "bob");

			// Assert
			Assert.AreEqual(3, oldTuple.Item1);
			Assert.AreEqual(4, oldTuple.Item2);
			Assert.AreEqual("bob", oldTuple.Item3);
		}
		
		/// <summary>
		/// New way inferred from what's being assigned to the Tuple :-)
		/// </summary>
		[TestMethod]
		public void New_Way_Tuple_Names_By_Inference() {
			// Arrange
			var point = new Point() { X = 3, Y = 4 };
			string s = "bob";

			// Act
			var newTuple = (point.X, point.Y, s);
			
			// Assert
			Assert.AreEqual(3, newTuple.X);
			Assert.AreEqual(4, newTuple.Y);
			Assert.AreEqual("bob", newTuple.s);
		}
		
		class Point {
			public int X { get; set; }
			public int Y { get; set; }
		}

	}

}
