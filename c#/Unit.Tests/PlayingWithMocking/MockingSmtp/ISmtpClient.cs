using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Net.Mail;

namespace Misc.Tests.PlayingWithMocking.MockingSmtp
{
	/// <summary>
	/// SmtpClient interface which mimics the "real" SmtpClient object, which we can then mock out
	/// </summary>
	public interface ISmtpClient {
		void Send(string from, string recipients, string subject, string body);
		void Send(MailMessage message);
	}


	/// <summary>
	/// Acts as a pass-through class that enables us to use a fake SMTP or real SMTP object.
	/// Note we don't declare a FakeSmtpClient as that's where the Mock comes in (we built it on demand)
	/// </summary>
	public class ConcreteSmtpClient : ISmtpClient
	{
		private readonly SmtpClient _smtpClient = null;

		public ConcreteSmtpClient(SmtpClient smtpClient) {
			this._smtpClient = smtpClient;
		}

		public void Send(string from, string recipients, string subject, string body) {
			this._smtpClient.Send(from, recipients, subject, body);
		}

		public void Send(MailMessage message) {
			this._smtpClient.Send(message);
		}
	}

}
