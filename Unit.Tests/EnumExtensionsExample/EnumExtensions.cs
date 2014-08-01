using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unit.Tests.EnumExtensions
{

	public enum MemberState : byte {
		Empty,
		Joined,
		ToBeVerified,
		Declined,
		Rejected,
		Suspended
	}

	public static class EnumExtensions {

		public static bool Has(this MemberState ms, params MemberState[] possibilities) {
			return possibilities.Contains(ms);
		}

		public static bool IsMember(this MemberState ms) {
			return ms.Has(MemberState.Joined);
		}

		public static bool IsNotAMember(this MemberState ms) {
			return ms.Has(MemberState.ToBeVerified, MemberState.Declined, MemberState.Rejected, MemberState.Suspended);
		}

	}

}
