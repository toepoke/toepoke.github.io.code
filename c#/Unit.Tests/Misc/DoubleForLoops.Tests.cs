using System;
using System.Collections.Generic;
using System.Diagnostics;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Unit.Tests.Misc {
	[TestClass]
	public class DoubleForLoops_Tests {

		[TestMethod]
		public void Double_ForEach_Loop_Example() {
			var customers = GetTestCustomers();
			var orders = GetTestOrders();
			
			Debug.WriteLine("foreach: EXPANDED METHOD");
			Debug.Indent();
			foreach (var customer in customers) {
				foreach (var order in orders) {
					if (customer.CustomerId == order.CustomerId) {
						Debug.WriteLine($"{order.OrderId}: {customer.Name} bought {order.Product}");
					}
				}
			}
			Debug.Unindent();
			
			Debug.WriteLine("foreach: COMPRESSED METHOD");
			Debug.Indent();
			foreach (var customer in customers)
			foreach (var order in orders) {
				if (customer.CustomerId == order.CustomerId) {
						Debug.WriteLine($"{order.OrderId}: {customer.Name} bought {order.Product}");
				}
			}
			Debug.Unindent();

			Debug.WriteLine("foreach: VERY COMPRESSED METHOD");
			Debug.Indent();
			foreach (var customer in customers)
			foreach (var order in orders)
			if (customer.CustomerId == order.CustomerId) {
					Debug.WriteLine($"{order.OrderId}: {customer.Name} bought {order.Product}");
			}
			Debug.Unindent();

		}

		[TestMethod]
		public void Double_ForN_Loop_Example() {
			var customers = GetTestCustomers();
			var orders = GetTestOrders();
			
			Debug.WriteLine("for: VERY COMPRESSED METHOD");
			Debug.Indent();
			for (int c=0; c < customers.Count; c++)
			for (int o=0; o < orders.Count; o++)
			if (customers[c].CustomerId == orders[o].CustomerId) {
					Debug.WriteLine($"{orders[o].OrderId}: {customers[c].Name} bought {orders[o].Product}");
			}
			Debug.Unindent();

		}

		private List<Customer> GetTestCustomers() {
			return new List<Customer>() {
				new Customer() { CustomerId = "CU_Batman", Name = "Bruce Wayne" },
				new Customer() { CustomerId = "CU_Spidey", Name = "Peter Parker" }
			};
		}

		private List<Order> GetTestOrders() {
			return new List<Order>() {
				new Order() { CustomerId = "CU_Batman", OrderId = "ORD_100", Product = "Batmobile" },
				new Order() { CustomerId = "CU_Batman", OrderId = "ORD_101", Product = "Spikey Flingy Things" },
				new Order() { CustomerId = "CU_Spidey", OrderId = "ORD_200", Product = "Suit" },
				new Order() { CustomerId = "CU_Spidey", OrderId = "ORD_201", Product = "Starch" },
				new Order() { CustomerId = "CU_Spidey", OrderId = "ORD_203", Product = "Wundaweb" },
			};
		}

		private class Customer {
			public string CustomerId { get; set; }
			public string Name { get; set; }
		}

		private class Order {
			public string OrderId { get; set; }
			public string CustomerId { get; set; }
			public string Product { get; set; }
		}



	}
}
