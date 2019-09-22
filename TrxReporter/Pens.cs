/// <summary>
/// Moved inline C# from XSL to this class because .NET Core can't compiled inline code.
/// This class is registered in the main program with AddExtensionObject
/// </summary>

namespace TrxReporter
{
	using System;
	using System.Text;
	using System.Text.RegularExpressions;

	public class Pens
	{

		public string ExtractImageUrl(string text)
		{
			var match = Regex.Match(
				text,
				"('|\")([^\\s]+(\\.(?i)(jpg|png|gif|bmp)))('|\")",
				RegexOptions.IgnoreCase);

			if (match.Success)
			{
				return match.Value.Replace("\'", string.Empty).Replace("\"", string.Empty).Replace("\\", "\\\\");
			}

			return string.Empty;
		}


		/// <summary>
		/// Format output written by SpedFlow/Gherkin including images
		/// </summary>
		/// <param name="output"></param>
		/// <returns></returns>
		public string FormatOutput(string output)
		{
			var builder = new StringBuilder();
			foreach (var line in output.Split("\n"))
			{
				if (line.StartsWith("->"))
				{
					var esc = "->" + line.Substring(2).Replace("<", "&lt;").Replace(">", "&gt;");
					builder.Append($"<span class=\"traceMessage\">{esc}</span><br/>\n");
				}
				else
				{
					var esc = line.Replace("<", "&lt;").Replace(">", "&gt;");
					builder.Append($"{esc}</br>\n");
				}
			}

			return builder.ToString()
				.Replace("HTMLREPORT_START_", "<br/><img onclick=\"OpenInPictureBox(this)\" src=")
				.Replace("HTMLREPORT_END_", "/><br/>");

		}


		public string GetShortDateTime(string time)
		{
			if (string.IsNullOrEmpty(time))
			{
				return string.Empty;
			}

			return DateTime.Parse(time).ToString();
		}


		public string GetYear()
		{
			return DateTime.Now.Year.ToString();
		}


		/// <summary>
		/// Custom name from test name and storage directory, extracting
		/// the Bamboo build part of the directory path.
		/// </summary>
		/// <param name="name"></param>
		/// <param name="storage"></param>
		/// <returns></returns>
		public string MakeCustomName (string name, string storage)
		{
			var parts = storage.Split(System.IO.Path.DirectorySeparatorChar);
			if (parts.Length > 1)
			{
				return parts[2] + " - " + name.Substring(name.IndexOf('@') + 1);
			}

			return name;
		}


		public string RemoveAssemblyName(string asm)
		{
			int idx = asm.IndexOf(',');
			if (idx == -1)
				return asm;
			return asm.Substring(0, idx);
		}


		public string RemoveNamespace(string asm)
		{
			int coma = asm.IndexOf(',');
			return asm.Substring(coma + 2, asm.Length - coma - 2);
		}


		public string ToExactTimeDefinition(string duration)
		{
			if (string.IsNullOrEmpty(duration))
			{
				return string.Empty;
			}

			return ToExactTime(TimeSpan.Parse(duration).TotalMilliseconds);
		}


		public string ToExactTimeDefinition(string start, string finish)
		{
			var datetime = DateTime.Parse(finish) - DateTime.Parse(start);
			return ToExactTime(datetime.TotalMilliseconds);
		}


		private string ToExactTime(double ms)
		{
			if (ms < 1000)
				return ms + " ms";

			if (ms >= 1000 && ms < 60000)
				return string.Format("{0:0.00} seconds", TimeSpan.FromMilliseconds(ms).TotalSeconds);

			if (ms >= 60000 && ms < 3600000)
				return string.Format("{0:0.00} minutes", TimeSpan.FromMilliseconds(ms).TotalMinutes);

			return string.Format("{0:0.00} hours", TimeSpan.FromMilliseconds(ms).TotalHours);
		}
	}
}
