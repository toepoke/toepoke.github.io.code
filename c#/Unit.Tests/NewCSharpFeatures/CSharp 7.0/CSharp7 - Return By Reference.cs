using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace NewCSharpFeatures.Tests {

	[TestClass]
	public class CSharp_7_Return_By_Reference {

		private int[] _ages = new int[] { 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50 };

		/// <summary>
		/// In essence you can return to a memory reference!??!
		/// Not entirely sure why you'd want to use this ...
		/// </summary>
		[TestMethod]
		public void Return_By_Reference() {
			// Arrange / Act
			int x = SetByRef(1) = 99;

			// Assert
			Assert.AreEqual(99, _ages[1]);
			Assert.AreEqual(99, x);
		}

		ref int SetByRef(int position) {
			return ref _ages[position];
		}

	}

}
