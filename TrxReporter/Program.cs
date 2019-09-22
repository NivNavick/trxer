namespace TrxReporter
{
	using System;
	using System.IO;
	using System.Linq;
	using System.Xml;
	using System.Xml.Xsl;


	class Program
	{

		private const string XsltFile = "TrxReporter.xslt";
		private const string OutputFileExt = ".html";


		static void Main(string[] args)
		{
			if (args.Any() == false)
			{
				Console.WriteLine("No trx file, TrxReporter.exe <filename>");
				return;
			}

			Console.WriteLine($"... transforming {args[0]}");

			Transform(args[0], PrepareXsl());
		}


		private static void Transform(string fileName, XmlDocument xsl)
		{
			var compiled = new XslCompiledTransform(true);
			compiled.Load(xsl, new XsltSettings(true, true), null);

			var args = new XsltArgumentList();
			args.AddExtensionObject("urn:Pens", new Pens());

			Console.WriteLine("... transforming");
			using (var writer = new StreamWriter(fileName + OutputFileExt))
			{
				compiled.Transform(fileName, args, writer);
			}

			Console.WriteLine($"... {fileName + OutputFileExt}");
		}


		private static XmlDocument PrepareXsl()
		{
			Console.WriteLine("... loading xslt template");
			var doc = new XmlDocument();
			doc.Load(ResourceReader.StreamFromResource(XsltFile));
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
