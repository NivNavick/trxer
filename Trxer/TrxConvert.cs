using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml;
using System.Xml.Xsl;

namespace Trxer
{
    public static class TrxConvert
    {
        private const string XSLT_FILE = "Trxer.xslt";
        private const string OUTPUT_FILE = ".html";

       public static void Convert(string trxPath)
        {
            Console.WriteLine("Working...");
            if (string.IsNullOrEmpty(trxPath))
            {
                Console.WriteLine("No trx file");
                return;
            }
            Console.WriteLine("Trx File\n{0}", trxPath);
            Transform(trxPath, PrepareXsl());
        }

        private static void Transform(string fileName, XmlDocument xsl)
        {
            XslCompiledTransform x = new XslCompiledTransform(true);
            x.Load(xsl, new XsltSettings(true, true), null);
            x.Transform(fileName, fileName + OUTPUT_FILE);
            Console.WriteLine("Done transforming xml into html");
        }

        private static XmlDocument PrepareXsl()
        {
            XmlDocument xslDoc = new XmlDocument();
            Console.WriteLine("Loading xslt template...");
            xslDoc.Load(ResourceReader.StreamFromResource(XSLT_FILE));
            IncludeStyle(xslDoc);
            IncludeScript(xslDoc);
            return xslDoc;
        }

        private static void IncludeScript(XmlDocument xslDoc)
        {
            Console.WriteLine("Loading javascript...");
            XmlNode scriptEl = xslDoc.GetElementsByTagName("script")[0];
            XmlAttribute scriptSrc = scriptEl.Attributes["src"];
            string script = ResourceReader.LoadTextFromResource(scriptSrc.Value);
            scriptEl.Attributes.Remove(scriptSrc);
            scriptEl.InnerText = script;
        }

        private static void IncludeStyle(XmlDocument xslDoc)
        {
            Console.WriteLine("Loading css...");
            XmlNode headNode = xslDoc.GetElementsByTagName("head")[0];
            XmlNodeList linkNodes = xslDoc.GetElementsByTagName("link");
            List<XmlNode> toChangeList = linkNodes.Cast<XmlNode>().ToList();

            foreach (XmlNode xmlElement in toChangeList)
            {
                XmlElement styleEl = xslDoc.CreateElement("style");
                styleEl.InnerText = ResourceReader.LoadTextFromResource(xmlElement.Attributes["href"].Value);
                headNode.ReplaceChild(styleEl, xmlElement);
            }
        }
    }
}
