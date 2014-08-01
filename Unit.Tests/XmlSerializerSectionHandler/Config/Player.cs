using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace Unit.Tests.XmlSerializerSectionHandler.Config
{
	
	public class Player {
		public string FirstName { get; set; }
		public string LastName { get; set; }
		public string SupportsTeam { get; set; }
		
	}

	[XmlRoot("Players")]
	public class Players: List<Player> {

		public Players() {
			this.PlayerItems = new List<Player>();
		}

		[XmlElement("Player")]
		public List<Player> PlayerItems { get; set; }

	}

}
