using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Unit.Tests.EnumExtensions
{

	/// <summary>
	/// Test cases for the enum extensions (yes, the coverage could be better, but this is here for illustration only :)
	/// </summary>
	[TestClass]
	public class EnumExtensionTests {

		[TestMethod]
		public void Is_Member_Works_As_Expected()
		{
			// Arrange
			MemberState bobFluqi = MemberState.Joined;

			// Act 
			bool isMember = bobFluqi.IsMember();

			// Assert
			Assert.IsTrue(isMember);
		}

		[TestMethod]
		public void Is_Not_Member_Works_As_Expected()
		{
			// Arrange
			MemberState bobFluqi = MemberState.Rejected;

			// Act 
			bool isNotMember = bobFluqi.IsNotAMember();

			// Assert
			Assert.IsTrue(isNotMember);
		}


	}

}
