using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Collections.Generic;

namespace Unit.Tests.ForEachGenericMethodExample
{
	[TestClass]
	public class ForEachGenericMethodTests {

		[TestMethod]
		public void Test_ForEach_Generic_Method_Works()
		{
			// Arrange
			List<Person> people = new List<Person>() {
				new Person() { Name = "Fred Flintstone", DOB = DateTime.Now.AddYears(-65) },
				new Person() { Name = "Homer Simpson", DOB = DateTime.Now.AddYears(-40) }
			};

			// Act  - loop over each person and set the age
			people.ForEach(
				p =>
				{
					p.Age = (DateTime.Now - p.DOB).TotalYears();
				}
			);

			// Assert
			Assert.AreEqual(65, people[0].Age);
			Assert.AreEqual(40, people[1].Age);
		}

	}
}
