using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Xml;
using System.Xml.Xsl;

namespace TrxerConsole
{
    class Program
    {
        /// <summary>
        /// Embedded Resource name
        /// </summary>
        private const string XSLT_FILE = "Trxer.xslt";
        /// <summary>
        /// Trxer output format
        /// </summary>
        private const string OUTPUT_FILE_EXT = ".html";

        /// <summary>
        /// Main entry of TrxerConsole
        /// </summary>
        /// <param name="args">First cell shoud be TRX path</param>
        static void Main(string[] args)
        {
            if (args.Any() == false)
            {
                Console.WriteLine("No trx file,  Trxer.exe <filename>");
                return;
            }
            Console.WriteLine("Trx File\n{0}", args[0]);
            string outputFilePath;
            if (args.Length == 2)
            {
                outputFilePath = Path.Combine(args[1], Path.GetFileName(args[0]) + OUTPUT_FILE_EXT);
            }
            else
            {
                outputFilePath = args[0] + OUTPUT_FILE_EXT;
            }

            Transform(args[0], PrepareXsl(), outputFilePath);
        }

        /// <summary>
        /// Transforms trx int html document using xslt
        /// </summary>
        /// <param name="fileName">Trx file path</param>
        /// <param name="xsl">Xsl document</param>
        /// <param name="outputFile"></param>
        private static void Transform(string fileName, XmlDocument xsl, string outputFile)
        {
            XslCompiledTransform x = new XslCompiledTransform(true);
            x.Load(xsl, new XsltSettings(true, true), null);
            Console.WriteLine("Transforming...");
            x.Transform(fileName, outputFile);
            Console.WriteLine("Done transforming xml into html");
        }

        /// <summary>
        /// Loads xslt form embedded resource
        /// </summary>
        /// <returns>Xsl document</returns>
        private static XmlDocument PrepareXsl()
        {
            XmlDocument xslDoc = new XmlDocument();
            Console.WriteLine("Loading xslt template...");
            xslDoc.Load(ResourceReader.StreamFromResource(XSLT_FILE));
            MergeCss(xslDoc);
            MergeJavaScript(xslDoc);
            return xslDoc;
        }

        /// <summary>
        /// Merge all javascript linked to page into Trxer html report itself
        /// </summary>
        /// <param name="xslDoc">Xsl document</param>
        private static void MergeJavaScript(XmlDocument xslDoc)
        {
            Console.WriteLine("Loading javascript...");
            XmlNodeList linkNodes = xslDoc.GetElementsByTagName("script");
            List<XmlNode> toChangeList = linkNodes.Cast<XmlNode>().ToList();
            foreach (XmlNode xmlNode in toChangeList)
            {
                XmlAttribute scriptSrc = xmlNode.Attributes["src"];
                if (scriptSrc == null)
                {
                    continue;
                }
                string script = ResourceReader.LoadTextFromResource(scriptSrc.Value);
                xmlNode.Attributes.Remove(scriptSrc);
                xmlNode.InnerText = script;
            }
        }

        /// <summary>
        /// Merge all css linked to page ito Trxer html report itself
        /// </summary>
        /// <param name="xslDoc">Xsl document</param>
        private static void MergeCss(XmlDocument xslDoc)
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
