using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Collections.Generic;
using System.Diagnostics;

namespace Unit.Tests.Misc
{
	// nq ="No quotes" in string :-)
	[DebuggerDisplay("Name: {FullName,nq}")]
	public class Person {
		/// <summary>
		/// Illustrating you can ignore properties you are not interested in (e.g. local variables)
		/// </summary>
		[DebuggerBrowsable(DebuggerBrowsableState.Never)]
		private string _firstName = "";

		/// <summary>
		/// Illustrating you can ignore properties you are not interested in (e.g. local variables)
		/// </summary>
		[DebuggerBrowsable(DebuggerBrowsableState.Never)]
		private string _lastName = "";

		[DebuggerBrowsable(DebuggerBrowsableState.Never)]
		public string FirstName { 
			get { return this._firstName; } 
			set { this._firstName = value; } 
		}
		[DebuggerBrowsable(DebuggerBrowsableState.Never)]
		public string LastName { 
			get { return this._lastName; } 
			set { this._lastName = value; } 
		}

		public string FullName {
			get {
				return $"{FirstName} {LastName}";
			}
		}
	}

	/// <summary>
	/// Illustrates debugging improvements in VS2017, see https://blogs.msdn.microsoft.com/visualstudio/2017/10/05/7-hidden-gems-in-visual-studio-2017/ 
	/// </summary>
	[TestClass]
	public class VS2017DebuggerImprovements
	{
		[TestMethod]
		public void Can_Show_VS2017_Debugger_Enhancements() {
			// Arrange
			List<Person> people = new List<Person>() {
				new Person() { FirstName = "Fred", LastName = "Flintstone" },
				new Person() { FirstName = "Homer", LastName = "Simpson" }
			};

			// Act - places a breakpoint here and examine the "people" object
			Console.WriteLine("");

			// Assert - not required
		}
	}
}
