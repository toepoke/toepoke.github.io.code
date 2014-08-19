using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unit.Tests.ForEachGenericMethodExample
{
	public class Person {
		public string Name { get; set; }
		public DateTime DOB { get; set; }
		public int Age { get; set; }
	}

	public static class TimeSpan_Extensions {

		/// <summary>
		/// This method is for demostration purposes only.
		/// I _do_not_ recommend using this method for any production code whatsoever, I will guarantee bugs! 
		/// </summary>
		/// <param name="ts"></param>
		/// <returns></returns>
		public static int TotalYears(this TimeSpan ts) {
			return (int)ts.TotalDays / 365;
		}
	}

}
