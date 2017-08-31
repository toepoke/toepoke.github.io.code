using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Unit.Tests.Misc {
	
	/// <summary>
	/// We put this together as we saw something odd, which was an "@" character
	/// in a parameter defintiion and we want to make sure there was something we'd not come across.
	/// OUTCOME: 
	/// It makes no difference - whilst I'm surprised it's legal, it is :)
	/// I'm guessing this is to flag that a variable is being used as part of a query into 
	/// a stored proc.
	/// </summary>
	[TestClass]
	public class AtSigns_In_Variables {

		[TestMethod]
		public void Does_AtSign_Do_Anything() {
			// Arrange
			string s = "Bob";

			// Act
			Does_AtSign_Do_Anything_Parameterised(ref s);
			
			// Assert
			Assert.AreEqual("Bob was here", s);
		}

		private void Does_AtSign_Do_Anything_Parameterised(ref string @query) {
			if (string.IsNullOrEmpty(query)) {
				return;
			}

			query += " was here";
		}

	} // class

} // namespace
