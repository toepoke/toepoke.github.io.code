using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Configuration;
using System.Linq;

namespace Unit.Tests.XmlSerializerSectionHandler
{
	[TestClass]
	public class XmlSerializerTests
	{
		[TestMethod]
		public void Can_Read_Typed_AppConfig_Data()
		{
			// Arrange - Read config section
			var players = (Config.Players) ConfigurationManager.GetSection("Players");

			// Act - Not required

			// Assert - 
			Assert.IsTrue(players.Any());
			Assert.AreEqual(2, players.Count());
	  
			var player1 = players[0];
			Assert.AreEqual("Homer", player1.FirstName);
			Assert.AreEqual("Simpson", player1.LastName);
			Assert.AreEqual("Leeds United", player1.SupportsTeam);

		}
	}
}
