using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Unit.Tests.EncryptConfigSectionByCertificate_Tests {
	
	public class X509EncryptionRunner {

		/// <summary>
		/// Encrypts the given sections of the configuration file.
		/// </summary>
		/// <param name="isWebConfig">
		/// Tells the method whether we're in a web context or an exe/assembly context.
		/// The method for reading the configuration files is different for each
		/// </param>
		/// <param name="sections">Sections to be encrypted, multiple sections can be passed</param>
		/// <returns>
		/// Returns true if encryption was necessary and the file saved as a result
		/// Returns false if encryption had already been applied
		/// </returns>
		/// <remarks>
		/// Note that the web configuration _should_ work but hasn't been explitily tested as 
		/// we're in the context of unit test (so executable configuration)
		/// </remarks>
		public static bool EncryptByCertificate(bool isWebConfig, params string[] sections) {
			string protectionProvider = "X509Provider";
			Configuration configFile = null;
			bool saveRequired = false;

			if (isWebConfig) {
				configFile = X509EncryptionRunner.OpenWebConfig();
			} else {
				configFile = X509EncryptionRunner.OpenExeConfig();
			}

			foreach (string section in sections) {
				ConfigurationSection configSection = configFile.GetSection(section);

				if (configSection == null) {
					throw new ArgumentException($"Configuration section '${configSection}' was not found.");
				}

				// No point encrypting if it's already been done
				if (!configSection.SectionInformation.IsProtected) {
					saveRequired = true;
					configSection.SectionInformation.ProtectSection(protectionProvider);
					configSection.SectionInformation.ForceSave = true;
				}

				if (saveRequired) {
					// Only save if there's a section which was not protected
					// ... again, no point taking the hit if we don't need to
					configFile.Save(ConfigurationSaveMode.Modified);
				}

			} // foreach

			return saveRequired;

		} // EncryptByCertificate


		/// <summary>
		/// Opens the configuration file for an executing assembly.
		/// </summary>
		/// <returns><see cref="Configuration"/></returns>
		protected static Configuration OpenExeConfig() {
			string configPath = null;
			Configuration configFile = null;
			ExeConfigurationFileMap exeFileMap = new ExeConfigurationFileMap();
			
			configPath = X509EncryptionRunner.GetConfigFileLocation();
			exeFileMap.ExeConfigFilename = configPath;
			configFile = ConfigurationManager.OpenMappedExeConfiguration(exeFileMap, ConfigurationUserLevel.None);

			return configFile;
		} // OpenExeConfig


		/// <summary>
		/// Opens the configuration file for a web application.
		/// </summary>
		/// <returns><see cref="Configuration"/></returns>
		protected static Configuration OpenWebConfig() {
			Configuration webConfig = null;

			// OpenWebConfiguration call will find the web.config file, we only need the directory (~)
			webConfig = System.Web.Configuration.WebConfigurationManager.OpenWebConfiguration("~");

			return webConfig;

		} // OpenWebConfig


		/// <summary>
		/// Gets the location of the app.config file
		/// </summary>
		/// <returns>Location of the "app.config" file</returns>
		protected static string GetConfigFileLocation() {
			string testPath = null;
			string configPath = null;
			
			// Get where the unit test is being executed (it's in the TestResults folder, not where the solution is)
			testPath = Assembly.GetExecutingAssembly().Location;
			
			// We don't want the filename included
			configPath = System.IO.Path.GetDirectoryName(testPath);

			// And finally find the config file we're actually trying to read
			configPath = System.IO.Path.Combine(configPath, "app.config");
			
			return configPath;

		} // GetConfigFileLocation


	} // X509EncryptionRunner



} // ns

