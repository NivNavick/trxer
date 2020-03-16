namespace TrxReporter
{
	using System.IO;
	using System.Reflection;


	internal class ResourceReader
	{
		internal static string LoadTextFromResource(string name)
		{
			string result = string.Empty;
			using (var reader = new StreamReader(StreamFromResource(name)))
			{
				result = reader.ReadToEnd();
			}
			return result;
		}


		internal static Stream StreamFromResource(string name)
		{
			return Assembly.GetExecutingAssembly().GetManifestResourceStream("TrxReporter." + name);
		}
	}
}
