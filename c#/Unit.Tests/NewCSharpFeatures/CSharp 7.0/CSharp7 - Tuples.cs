using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace NewCSharpFeatures.Tests {

	/// <summary>
	/// Note tuple support isn't part of VS 2017 at time of writing (v15.5.0).
	/// You can use it via NuGet - "install-package System.ValueTuple"
	/// </summary>
	[TestClass]
	public class CSharp_7_Tuples {

		[TestMethod]
		public void Deconstruct_As_Object() {
			// Arrange / Act
			(int x, int y) points = this.GetPoints();

			// Assert
			Assert.AreEqual(100, points.x);
			Assert.AreEqual(200, points.y);
		}

		[TestMethod]
		public void Deconstruct_By_Variable_Declaration() {
			// Arrange / Act
			(int x1, int y1) = this.GetPoints();

			// Assert
			Assert.AreEqual(100, x1);
			Assert.AreEqual(200, y1);
		}

		[TestMethod]
		public void Deconstruct_By_Inferrence_With_Var() {
			// Arrange / Act
			var (x1, y1) = this.GetPoints();

			// Assert
			Assert.AreEqual(100, x1);
			Assert.AreEqual(200, y1);
		}


		protected (int x, int y) GetPoints() {
			return (100, 200);
		}

	}

}
