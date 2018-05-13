using System.Collections.Specialized;
using System.Configuration;
using System.Security.Cryptography.X509Certificates;
using System.Security.Cryptography.Xml;
using System.Xml;

namespace Unit.Tests.EncryptConfigSectionByCertificate {

	/// <summary>
	/// Provider for encrypting the web.config based on a certificate.
	/// </summary>
	public class X509ProtectedConfigurationProvider: ProtectedConfigurationProvider {
		private X509Certificate2 _certificate = null;
		
		/// <summary>
		/// Called by the .NET framework when it's ready to encrypt or decrypt data in the configuration files.
		/// </summary>
		/// <param name="name">Name of the section</param>
		/// <param name="config">Config associated with the provider (the X509Provider in our case)</param>
		public override void Initialize(string name, NameValueCollection config) {
			base.Initialize(name, config);

			// Get the thumbprint from the configuration as we'll need it to search for the certificate later on
			string thumbprint = config["thumbprint"];

			_certificate = FindCertificate(StoreLocation.LocalMachine, thumbprint);
			if (_certificate == null) {
				// try current user instead
				_certificate = FindCertificate(StoreLocation.CurrentUser, thumbprint);
			}

			// if "_certificate" is still null it will cause the encryption to throw a wobbler .. which is what we want

		} // Initialize


		/// <summary>
		/// Called by the .NET framework to encrypt the confiugration element
		/// </summary>
		/// <param name="node">Decrypted data</param>
		/// <returns>Encrypted data</returns>
		public override XmlNode Encrypt(XmlNode node) {
			XmlDocument xDoc = new XmlDocument();
			xDoc.PreserveWhitespace = true;
			xDoc.LoadXml(node.OuterXml);

			// Encrypt the section
			EncryptedXml eXml = new EncryptedXml();
			EncryptedData eData = eXml.Encrypt(xDoc.DocumentElement, _certificate);

			return eData.GetXml();
		} // Encrypt


		/// <summary>
		/// Called by the .NET framework to decrypt the configuration element
		/// </summary>
		/// <param name="encryptedNode">Encrypted data</param>
		/// <returns>Decrypted data</returns>
		public override XmlNode Decrypt(XmlNode encryptedNode) {
			XmlDocument xDoc = encryptedNode.OwnerDocument;
			EncryptedXml eXml = new EncryptedXml(xDoc);

			eXml.DecryptDocument();

			return xDoc.DocumentElement;
		} // Decrypt


		/// <summary>
		/// Attempts to find a certificate in the given location with the given thumbprint.
		/// </summary>
		/// <param name="inLocation">Store location to look in</param>
		/// <param name="thumbprint">Certificate thumbprint to find</param>
		/// <returns>
		/// On success (found) returns the certificate
		/// On failure (not found) returns null
		/// </returns>
		private X509Certificate2 FindCertificate(StoreLocation inLocation, string thumbprint) {
			X509Store certStore = new X509Store(inLocation);
			X509Certificate2Collection hits = null;

			try {
				certStore.Open(OpenFlags.ReadOnly);
				hits = certStore.Certificates.Find(X509FindType.FindByThumbprint, thumbprint, true/*valid certs only*/);
				if (hits.Count > 0) {
					return hits[0];
				}
				// not found
				return null;
			}
			finally {
				if (certStore != null) {
					certStore.Close();
					certStore = null;
				}
			}

		} // FindCertificate
	
	} // CertificateProtectedConfigurationProvider

}
