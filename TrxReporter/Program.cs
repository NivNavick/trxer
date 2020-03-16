namespace TrxReporter
{
    using Fclp;
    using System;
	using System.IO;
	using System.Linq;
	using System.Xml;
	using System.Xml.Xsl;


	class Program
	{

		private const string XSLT = "Reporter.xslt";
		private const string HTMLExt = ".html";


		static void Main(string[] args)
		{
			string trxPath = null;
			string outPath = null;
			string title = null;

			var p = new FluentCommandLineParser();

			p.Setup<string>('i', "input")
				.Callback(v => trxPath = v)
				.Required()
				.WithDescription("Path to the .trx file");

			p.Setup<string>('o', "output")
				.Callback(v => outPath = v)
				.WithDescription("Optional path of output HTML file");

			p.Setup<string>('t', "title")
				.Callback(v => title = v)
				.SetDefault("Test Report")
				.WithDescription("Optional title of report");

			var parameters = p.Parse(args);

			if (parameters.HasErrors)
			{
				Console.WriteLine(parameters.ErrorText);
				return;
			}

			if (String.IsNullOrEmpty(outPath))
			{
				outPath = Path.Combine(
					Path.GetDirectoryName(Path.GetFullPath(trxPath)),
					Path.GetFileName(trxPath) + HTMLExt
					);
			}
			else
			{
				if (!outPath.EndsWith(HTMLExt, StringComparison.InvariantCultureIgnoreCase))
				{
					outPath = Path.Combine(outPath, Path.GetFileName(trxPath) + HTMLExt);
				}
			}

			Console.WriteLine($"... transforming {trxPath}");

			Transform(trxPath, outPath, title, PrepareXsl());
		}


		private static void Transform(string fileName, string outPath, string title, XmlDocument xsl)
		{
			var compiled = new XslCompiledTransform(true);
			compiled.Load(xsl, new XsltSettings(true, true), null);

			var args = new XsltArgumentList();
			args.AddExtensionObject("urn:Pens", new Pens());

			args.AddParam("ReportTitle", String.Empty, title);

			Console.WriteLine("... transforming");
			using (var writer = new StreamWriter(outPath))
			{
				compiled.Transform(fileName, args, writer);
			}

			Console.WriteLine($"... {outPath}");
		}


		private static XmlDocument PrepareXsl()
		{
			Console.WriteLine("... loading xslt template");
			var doc = new XmlDocument();
			doc.Load(ResourceReader.StreamFromResource(XSLT));
			MergeCss(doc);
			MergeJavaScript(doc);
			return doc;
		}


		private static void MergeJavaScript(XmlDocument doc)
		{
			Console.WriteLine("... loading javascript");
			var script = doc.GetElementsByTagName("script")[0];
			var src = script.Attributes["src"];
			script.Attributes.Remove(src);
			script.InnerText = ResourceReader.LoadTextFromResource(src.Value);
		}


		private static void MergeCss(XmlDocument doc)
		{
			Console.WriteLine("... loading css");
			var head = doc.GetElementsByTagName("head")[0];
			var links = doc.GetElementsByTagName("link");

			foreach (var link in links.Cast<XmlNode>().ToList())
			{
				var style = doc.CreateElement("style");
				style.InnerText = ResourceReader.LoadTextFromResource(link.Attributes["href"].Value);
				head.ReplaceChild(style, link);
			}
		}
	}
}
