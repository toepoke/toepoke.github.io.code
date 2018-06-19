using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Unit.Tests.EventHandling_Tests {
	
	[TestClass]
	public class PubSub_Tests {

		[TestMethod]
		public void When_Event_Is_Raised_By_Publisher_It_Is_Caught_By_The_Listener() {
			// Arrange
			int attempts = 0, maxAttempts = 1;
			PubSub.Publisher publisher = new PubSub.Publisher();
			PubSub.Listener listener = new PubSub.Listener();
			
			// Act
			listener.Subscribe(publisher);

			// Emulate a process firing an event
			publisher.DoWork();
			while (!listener.EventWasRaised && attempts < maxAttempts) {
				System.Threading.Thread.Sleep(1000);
				attempts++;
			}

			// Assert
			Assert.IsTrue(listener.EventWasRaised);
		}
	}

}
