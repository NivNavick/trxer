namespace TrxReporter
{
	using System;
	using System.IO;
	using System.Linq;
	using System.Xml;
	using System.Xml.Xsl;


	class Program
	{

		private const string XSLT = "TrxReporter.xslt";
		private const string HTMLExt = ".html";


		static void Main(string[] args)
		{
			if (!args.Any())
			{
				Console.WriteLine("Usage: dotnet .\\TrxReporter.dll <trx-path> <output-path>");
				return;
			}

			var trxPath = args[0];
			string outPath;
			if (args.Length > 1)
			{
				if (args[1].EndsWith(HTMLExt, StringComparison.InvariantCultureIgnoreCase))
				{
					outPath = args[1];
				}
				else
				{
					outPath = Path.Combine(args[1], Path.GetFileName(trxPath) + HTMLExt);
				}
			}
			else
			{
				outPath = Path.Combine(
					Path.GetDirectoryName(Path.GetFullPath(trxPath)),
					Path.GetFileName(trxPath) + HTMLExt
					);
			}

			Console.WriteLine($"... transforming {trxPath}");

			Transform(trxPath, outPath, PrepareXsl());
		}


		private static void Transform(string fileName, string outPath, XmlDocument xsl)
		{
			var compiled = new XslCompiledTransform(true);
			compiled.Load(xsl, new XsltSettings(true, true), null);

			var args = new XsltArgumentList();
			args.AddExtensionObject("urn:Pens", new Pens());

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
