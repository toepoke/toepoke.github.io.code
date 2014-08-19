using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Serialization;
using System.Xml.XPath;

namespace Unit.Tests.XmlSerializerSectionHandler
{
	/// <summary>
	/// Deserialises a node of web.config into a typed class, for details see:
	///		http://blog.codinghorror.com/the-last-configuration-section-handler/
	/// </summary>
	public class XmlSerializerSectionHandler : IConfigurationSectionHandler {
		public object Create(object parent, object configContext, XmlNode section)
		{
			XPathNavigator nav = section.CreateNavigator();
			string typeName = (string)nav.Evaluate("string(@type)");
			Type t = Type.GetType(typeName);
			XmlSerializer ser = new XmlSerializer(t);
			XmlNodeReader xnr = new XmlNodeReader(section);
			object deSerialised = null;

			deSerialised = ser.Deserialize(xnr);

			return deSerialised;
		} // Create
	}
}
