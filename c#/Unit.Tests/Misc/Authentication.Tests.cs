using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Linq;
using System.DirectoryServices.AccountManagement;
using ssp = System.Security.Principal;

namespace Unit.Tests.Misc
{
	[TestClass]
	public class Authentcation_Tests {
		
		/// <summary>
		/// Illustrates getting group information from claims.
		/// The following _should_ also work in an MVC application controller.
		/// </summary>
		/// <remarks>
		/// Inspired by : http://www.visualstuart.net/blog2/2011/10/get-your-current-windowsidentity-name-and-groups/
		/// </remarks>
		[TestMethod]
		public void Can_Get_Claims()	{
			var user = ssp.WindowsIdentity.GetCurrent();
			var claims = user.Claims.ToList();
			Type ntAccount = typeof(ssp.NTAccount);
			
			Assert.IsNotNull(user);
			Assert.IsNotNull(claims);
			Assert.IsTrue(claims.Any());
			Assert.IsNotNull(user.Groups);
			Assert.IsTrue(user.Groups.Any());
			
			Console.WriteLine("Username: {0}", user.Name);
			foreach (var group in user.Groups) {
				Console.WriteLine("Group: {0}", group.Translate(ntAccount).ToString() );
			}
		}


		/// <summary>
		/// Illustrates how to establish if someone is within a given role in Active Directory
		/// </summary>
		/// <seealso cref="https://msdn.microsoft.com/en-us/library/86wd8zba(v=vs.110).aspx"/>
		[TestMethod]
		public void Can_Check_IsInRole() {
			const string ROLE_NAME = "Everyone";
			bool isInRole = System.Threading.Thread.CurrentPrincipal.IsInRole(ROLE_NAME);

			Assert.IsTrue(isInRole);
		}


		[TestMethod]
		public void Can_Get_Manager() {
			// Arrange

			// As the below is public in Git, you have to fill these in!
			const string DOMAIN = "";
			const string QUERY_USERNAME = DOMAIN + "";

			if (string.IsNullOrEmpty(DOMAIN) || string.IsNullOrEmpty(QUERY_USERNAME)) {
				Assert.Inconclusive("Active Directory query parameters have not been set.");
				return;
			}


			// Act
			using (PrincipalContext ctx = new PrincipalContext(ContextType.Domain, DOMAIN)) {
				UserPrincipalExtension person = UserPrincipalExtension.FindByIdentity(ctx, QUERY_USERNAME);

				string managerName = person.Manager;
				Console.WriteLine("User: {0}", QUERY_USERNAME);

				while (managerName != "") {
					UserPrincipalExtension manager = UserPrincipalExtension.FindByIdentity(ctx, IdentityType.DistinguishedName, managerName);

					managerName = manager.Manager;
					if (managerName != "") {
						Console.WriteLine("Maanger: {0}", managerName);
					}

				} // while

			} // using

			// Assert - skipped as not appropriate

		} // Can_Get_Manager


		/// <summary>
		/// To get additional meta-data from Active Directory we need to use "ExtensionGet", which is a "protected"
		/// property in "UserPrincipal".
		/// Workaround is to inherit your own version so you get access to the protected member.
		/// </summary>
		/// <remarks>
		/// Inspired from - https://stackoverflow.com/questions/15608241/c-sharp-look-up-a-users-manager-in-active-directory
		/// </remarks>
		[DirectoryRdnPrefix("CN")]
		[DirectoryObjectClass("Person")]
		protected class UserPrincipalExtension: UserPrincipal {

			public UserPrincipalExtension(PrincipalContext ctx) : base(ctx)	{
			}

			public UserPrincipalExtension(PrincipalContext ctx, string samAccountName, string password, bool enabled) 
			 : base(ctx, samAccountName, password, enabled) {
			}

			[DirectoryProperty("manager")]
			public string Manager {
				get {
					var manager = ExtensionGet("manager");
					if (!manager.Any()) {
						return "";
					}
					return manager[0] as string;
				}
				set {
					throw new NotSupportedException("Updating 'Manager' property is not supported.");
				}
			}

			public static new UserPrincipalExtension FindByIdentity(PrincipalContext ctx, string identity) {
				return (UserPrincipalExtension) FindByIdentityWithType(ctx, typeof(UserPrincipalExtension), identity);
			}

			public static new UserPrincipalExtension FindByIdentity(PrincipalContext context, IdentityType identityType, string identityValue) {
				return (UserPrincipalExtension)FindByIdentityWithType(context, typeof(UserPrincipalExtension), identityType, identityValue);
	    }

		} // UserPrincipalExtension

	} // Authentcation_Tests

} // namespace
