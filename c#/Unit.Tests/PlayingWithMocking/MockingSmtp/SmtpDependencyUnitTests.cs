using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Net.Mail;
using NSubstitute;
using System.Collections.Generic;
using System.Linq;

namespace Misc.Tests.PlayingWithMocking.MockingSmtp
{

	[TestClass]
	public class SmtpDependencyUnitTests {
		private readonly string PICK_UP_DIRECTORY = Environment.GetEnvironmentVariable("TEMP", EnvironmentVariableTarget.User);
		private readonly SmtpClient _localSmtp = null;

		public SmtpDependencyUnitTests() {
			// Ensure nothing use the real email delivery!
			_localSmtp = new System.Net.Mail.SmtpClient();
			_localSmtp.DeliveryMethod = SmtpDeliveryMethod.SpecifiedPickupDirectory;
			_localSmtp.PickupDirectoryLocation = PICK_UP_DIRECTORY;
		}

		[TestInitialize]
		public void Setup() {
		}

		[TestMethod]
		public void WeCanUseMockedSmtpDependency() {
			// Arrange
			var smtp = Substitute.For<ISmtpClient>();
			var commsService = new CommunicationsService(smtp);

			// Act
			commsService.SendHelloMessage("test@junge.f9.co.uk");
			
			// Assert
			Assert.AreEqual(1, commsService.GetSentLog().Count);
			Assert.AreEqual("test@junge.f9.co.uk", commsService.GetSentLog()[0]);

			// Ensure send call was run as expected
			smtp.Received().Send("test@junge.f9.co.uk", "test@junge.f9.co.uk", "Hello You.", "Welcome to our service");
		}

		[TestMethod]
		public void WeCanUseRealSmtpDependency()
		{
			// Arrange
			ClearPickupDirectory();
			var concreteSmtp = new ConcreteSmtpClient(this._localSmtp);
			var commsService = new CommunicationsService(concreteSmtp);

			// Act
			commsService.SendHelloMessage("test@junge.f9.co.uk");

			// Assert
			Assert.IsTrue(this.HasEmails());
		}


		protected void ClearPickupDirectory() {
			EnsurePickupDirectoryExists();
			var emailFiles = System.IO.Directory.EnumerateFiles(PICK_UP_DIRECTORY, "*.eml");
			foreach (string emailFile in emailFiles) {
				System.IO.File.Delete(emailFile);
			}
		}

		protected bool HasEmails() {
			EnsurePickupDirectoryExists();
			var emailFiles = System.IO.Directory.EnumerateFiles(PICK_UP_DIRECTORY, "*.eml");
			return emailFiles.Any();
		}

		protected void EnsurePickupDirectoryExists() {
			if (!System.IO.Directory.Exists(PICK_UP_DIRECTORY)) {
				throw new Exception(string.Format("Pickupdirectory '{0}' does not exist.", PICK_UP_DIRECTORY));
			}
		}

	} // class

} // namespace


// Arrange

// Act

// Assert
