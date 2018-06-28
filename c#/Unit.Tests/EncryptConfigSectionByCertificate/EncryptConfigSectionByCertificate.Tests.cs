using System;
using System.Configuration;
using System.Reflection;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Unit.Tests.EncryptConfigSectionByCertificate_Tests {

	[TestClass]
	public class X509_Encryption_Tests {

		/// <summary>
		/// In order to test the decryption we need to ensure the file has been encrypted first
		/// So we've combined the two tests into one in order to reliably force the tests to be run in order.
		/// </summary>
		[TestMethod]
		public void Can_Encrypt_Then_Decrypt() {
			// Assert
			this.Can_Encrypt();
			this.Can_Decrypt();
		}


		public void Can_Encrypt() {
			// Arrange
			string sectionToEncrypt = "Players";
			string before = this.ReadAppConfigFile();
			bool useWebConfig = false;

			// Act
			bool isOk = X509EncryptionRunner.EncryptByCertificate(useWebConfig, sectionToEncrypt);
			string after = this.ReadAppConfigFile();

			// Assert
			// Config files should now be different
			Assert.AreNotEqual<string>(before, after);
			
			// before should still be plain text
			Assert.IsTrue(before.Contains("Homer"));

			// after should include encrypted text
			Assert.IsTrue(after.Contains("EncryptedData"));
		}

		public void Can_Decrypt() {
			string encrypted = null;

			// Arrange
			encrypted = this.ReadAppConfigFile();

			// Act
			XmlSerializerSectionHandler.Config.Players players = this.GetPlayersSection();

			// Ensure it's set at what we set it initially
			Assert.AreEqual(2, players.Count);
			var homer = players[0];
			Assert.AreEqual("Homer", homer.FirstName);
			Assert.AreEqual("Simpson", homer.LastName);
			Assert.AreEqual("Leeds United", homer.SupportsTeam);

			// File should be encrypted naturally 
			// ... when reading through the config API it will decrypt it for us, 
			// ... but it _could_ already be decrypted so we check behind .NETs back
			Assert.IsTrue(encrypted.Contains("EncryptedData"));
		}


		/// <summary>
		/// Helper to inspect the content of the config file so we can check to see if it's been encrypted or not.
		/// </summary>
		/// <returns></returns>
		private string ReadAppConfigFile() {
			string configPath = null;
			string text = null;

			configPath = this.GetConfigFileLocation();
			text = System.IO.File.ReadAllText(configPath);

			return text;

		} // ReadAppConfigFile


		/// <summary>
		/// Helper to find the location of the configuration file (directly rather than as configuration)
		/// so we can inspect the underlying content of the file
		/// </summary>
		/// <returns>Location of the configuration file</returns>
		private string GetConfigFileLocation() {
			string testPath = null;
			string configPath = null;
			
			// Get where the unit test is being executed (it's in the TestResults folder, not where the solution is)
			testPath = Assembly.GetExecutingAssembly().Location;
			
			// We don't want the filename included
			configPath = System.IO.Path.GetDirectoryName(testPath);

			// And finally find the config file we're actually trying to read
			configPath = System.IO.Path.Combine(configPath, "app.config");
			
			return configPath;
		}


		/// <summary>
		/// Helper to load the section under test.
		/// </summary>
		/// <returns></returns>
		private XmlSerializerSectionHandler.Config.Players GetPlayersSection() {
			string configPath = null;
			Configuration configFile = null;

			configPath = this.GetConfigFileLocation();;
			configFile = ConfigurationManager.OpenExeConfiguration(configPath);

			var players = (XmlSerializerSectionHandler.Config.Players) ConfigurationManager.GetSection("Players");

			return players;
		}

	} // X509_Encryption_Tests

}
