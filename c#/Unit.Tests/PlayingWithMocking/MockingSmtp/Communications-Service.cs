using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Misc.Tests.PlayingWithMocking.MockingSmtp
{
	/// <summary>
	/// Mimics a "real" part of the system that would be used in the "real world".
	/// In unit test land we give it a mocked out interface
	/// </summary>
	public class CommunicationsService
	{
		private readonly ISmtpClient _smtpClient = null;
		private readonly List<string> _sentLog = null;

		public CommunicationsService(ISmtpClient smtpClient)
		{
			_smtpClient = smtpClient;
			_sentLog = new List<string>();
		}

		public void SendHelloMessage(string to)
		{
			string subject = "Hello You.";
			string body = "Welcome to our service";
			string from = "test@junge.f9.co.uk";

			this._smtpClient.Send(from, to, subject, body);

			_sentLog.Add(to);
		}

		public List<string> GetSentLog()
		{
			return _sentLog;
		}
	}
}
