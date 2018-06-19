using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

/// See https://codereview.stackexchange.com/questions/119415/raise-an-event-sample-1
namespace Unit.Tests.EventHandling_Tests.PubSub {

	public class RaiseArgs : EventArgs {
		public RaiseArgs(string message) {
			this.Message = message;
		}
		public string Message = "";
	}

	public class Publisher {
		public delegate void EventHandler(object sender, RaiseArgs e);

		public event EventHandler Event;

		public void RaiseEvent(RaiseArgs e) {
			var handler = Event;
			if (handler != null) {
				handler(this, e);
			}
		}

		public void DoWork() {
			RaiseArgs args = new RaiseArgs("an event was raised");
			this.RaiseEvent(args);
		}
	}

	public class Listener {
		public bool EventWasRaised { get; set; } = false;

		public void Subscribe(Publisher publisher) {
			publisher.Event += HeardEvent;
		}

		public void HeardEvent(object sender, RaiseArgs e) {
			Console.Write(DateTime.Now.ToString());
			Console.Write(" :: ");
			Console.WriteLine(e.Message);
			this.EventWasRaised = true;
		}
	}

}
