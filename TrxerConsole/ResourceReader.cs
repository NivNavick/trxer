using System.IO;
using System.Reflection;

namespace TrxerConsole
{
    internal class ResourceReader
    {
        internal static string LoadTextFromResource(string name)
        {
            string result = string.Empty;
            using (StreamReader sr = new StreamReader(
                   StreamFromResource(name)))
            {
                result = sr.ReadToEnd();
            }
            return result;
        }

        internal static Stream StreamFromResource(string name)
        {
            return Assembly.GetExecutingAssembly().GetManifestResourceStream("TrxerConsole." + name);
        }
    }
}
