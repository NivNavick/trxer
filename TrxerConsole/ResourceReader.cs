using System.IO;
using System.Reflection;

namespace TrxerConsole
{
    internal class ResourceReader
    {
        /// <summary>
        /// Loads text from specified resource.
        /// </summary>
        /// <param name="name">Resource value.</param>
        /// <returns>Resource text.</returns>
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

        /// <summary>
        /// Loads stream from specified resource.
        /// </summary>
        /// <param name="name">Resource value.</param>
        /// <returns>Resource stream.</returns>
        internal static Stream StreamFromResource(string name)
        {
            return Assembly.GetExecutingAssembly().GetManifestResourceStream("TrxerConsole." + name);
        }
    }
}
