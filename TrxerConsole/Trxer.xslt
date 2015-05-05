<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:t="http://microsoft.com/schemas/VisualStudio/TeamTest/2010"
    xmlns:trxreport="urn:my-scripts"
>
  <xsl:output method="html" indent="yes"/>
  <xsl:key name="TestMethods" match="t:TestMethod" use="@className"/>
  <!--<xsl:namespace-alias stylesheet-prefix="t" result-prefix="#default"/>-->

  <msxsl:script language="C#" implements-prefix="trxreport">
    <msxsl:using namespace="System.Collections.Generic" />
    <![CDATA[
    public string RemoveAssemblyName(string asm) 
    {
      return asm.Substring(0,asm.IndexOf(','));
    }
    public string RemoveNamespace(string asm) 
    {
      int coma = asm.IndexOf(',');
      return asm.Substring(coma + 2, asm.Length - coma - 2);
    }
    public string GetShortDateTime(string time)
    {
      return DateTime.Parse(time).ToString();
    }
    
    private string ToExtactTime(double ms)
    {
      if (ms < 1000)
       return string.Format("{0:0.00} ms", ms);

      if (ms >= 1000 && ms < 60000)
        return string.Format("{0:0.00} seconds", TimeSpan.FromMilliseconds(ms).TotalSeconds);

      if (ms >= 60000 && ms < 3600000)
        return string.Format("{0:0.00} minutes", TimeSpan.FromMilliseconds(ms).TotalMinutes);

      return string.Format("{0:0.00} hours", TimeSpan.FromMilliseconds(ms).TotalHours);
    }
    
    public string ToExactTimeDefinition(string duration)
    {
         return  ToExtactTime(TimeSpan.Parse(duration).TotalMilliseconds);
    }
    
    public string ToExactTimeDefinition(string start,string finish)
    {
      TimeSpan datetime=DateTime.Parse(finish)-DateTime.Parse(start);
      return ToExtactTime(datetime.TotalMilliseconds);
    }
    
    public string CurrentDateTime()
    {
      return DateTime.Now.ToString();
    }
    
   public string ExtractMultipleImages(string message,string stacktrace,string stdout,string stderr)
    {
      List<string> imagesUrl=new List<string>();
      string[] textArray= {message,stacktrace,stdout,stderr};
      foreach(string posibleImageUrl in textArray)
      {
          string image = ExtractImageUrl("\""+posibleImageUrl+"\"");
          if(string.IsNullOrEmpty(image)==false)
          {
            imagesUrl.Add(posibleImageUrl);
          }
      }
      return imagesUrl.Count>0?"'"+string.Join("|",imagesUrl)+"'":string.Empty;
    }
    
    public string ExtractImageUrl(string text)
    {
    
     //('|\")([^\\s]+(\\.(?i)(jpg|png|gif|bmp)))('|\")
    //(\"|').*(\\.(?i)(jpg|png|gif|bmp))(\"|')
       MatchCollection matches = Regex.Matches(text, "((https:)|(http:(s?))|([/|.|\\w|\\s]))*\\.(?:jpg|gif|png)",
	     RegexOptions.IgnoreCase);
      
      List<string> matchesList=new List<string>();
      foreach(Match match in matches) 
      {
        if (match.Success)
	      {
	        matchesList.Add(match.Value.Replace("\'",string.Empty).Replace("\"",string.Empty).Replace("\\","\\\\"));
	      }
        
        return string.Join("|",matchesList);
      }
      
	   
      return string.Empty;
    }
    
    public string ShortenMessage(string message)
    {
      if(message.Length>300)
      {
         return message.Substring(0,300);
      }
      return string.Empty;
    }
        
    ]]>
  </msxsl:script>

  <xsl:template match="/" >
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
    <html>
      <head>
        <meta charset="utf-8"/>
        <link rel="stylesheet" type="text/css" href="Css.Trxer.css"/>
        <link rel="stylesheet" type="text/css" href="Css.TrxerTable.css"/>
        <link rel="stylesheet" type="text/css" href="Css.Buttons.css"/>
        <link rel="stylesheet" type="text/css" href="Css.ImageView.css"/>
        <link rel="stylesheet" type="text/css" href="Css.Statuses.css"/>
        <link rel="stylesheet" type="text/css" href="Css.ToolTip.css"/>
        <link rel="stylesheet" type="text/css" href="Css.HtmlTags.css"/>
        <link rel="stylesheet" type="text/css" href="Css.Pie.css"/>
        <script language="javascript" type="text/javascript" src="Javascript.Graphs.js"></script>
        <script language="javascript" type="text/javascript" src="Javascript.ImageView.js"></script>
        <script language="javascript" type="text/javascript" src="Javascript.Utils.js"></script>
        <title>
          <xsl:value-of select="/t:TestRun/@name"/>
        </title>
      </head>
      <body>
        <div id="divToRefresh" class="wrapOverall">
          <div id="floatingGrayBackground" onclick="hide('floatingGrayBackground');hide('floatingImageBackground');"></div>
          <div id="floatingImageBackground">
            <div id="navigation">
              <table border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="arrowCell">
                    <div id="leftArrow" onclick="slideimagesLeft();"></div>
                  </td>
                  <td valign="top">
                    <div class="overFlowImage">
                      <img src="" class="displayed"  id="floatingImage"/>
                    </div>
                  </td>
                  <td class="arrowCell">
                    <div id="rightArrow" onclick="slideimagesRight();"></div>
                  </td>
                </tr>
                <tr>
                  <td></td>
                  <td colspan="4" class="closeImageViewButton">
                    <a href="javascript:hide('floatingImageBackground');hide('floatingGrayBackground')">&#10006; Close</a>
                  </td>
                  <td></td>
                </tr>
              </table>
            </div>
          </div>
          <br />
          <xsl:variable name="testRunOutcome" select="t:TestRun/t:ResultSummary/@outcome"/>

          <div class="StatusBar statusBar{$testRunOutcome}">
            <div class="statusBarInner statusBar{$testRunOutcome}Inner">
              <center>
                <h1 class="hWhite">
                  <div class="titleCenterd">
                    <xsl:value-of select="/t:TestRun/@name"/>
                  </div>
                </h1>
              </center>
            </div>
          </div>
          <div class="SummaryDiv">






            <!--   <table id="TotalTestsTable">
              <caption>Results Summary</caption>
              <thead>
                <tr class="odd">
                  <th scope="col" abbr="Status">
                   \f080; Pie View
                  </th>
                </tr>
                <tr class="odd">
                  <th scope="col" abbr="Status">
                    Tests Statuses
                  </th>
                </tr>
                <tr class="odd">
                  <th scope="col" abbr="Status">
                    Summary
                  </th>
                </tr>
              </thead>
              <tbody>

              </tbody>
            </table>-->

            <table id="TotalTestsTable">
              <caption>Results Summary</caption>
              <thead>
                <tr class="odd">
                  <th scope="col" abbr="Status">
                    Pie View
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>
                    <div id="dataViewer"></div>
                  </td>
                </tr>
                <tr id="DownloadSection">
                  <td>
                    <a href="#" class="button" id="btn-download" download="{/t:TestRun/@name}StatusesPie.png">Save graph</a>
                  </td>
                </tr>
              </tbody>
            </table>
            <table class="DetailsTable StatusesTable">
              <caption>Tests Statuses</caption>
              <tbody>
                <tr class="odd">
                  <th class="column1 statusCount">Total</th>
                  <td class="statusCount">
                    <xsl:value-of select="/t:TestRun/t:ResultSummary/t:Counters/@total" />
                  </td>
                </tr>
                <tr>
                  <th scope="row" class="column1 statusCount">Executed</th>
                  <td class="statusCount">
                    <xsl:value-of select="/t:TestRun/t:ResultSummary/t:Counters/@executed" />
                  </td>
                </tr>
                <tr>
                  <th scope="row" class="column1 statusCount">Passed</th>
                  <td class="statusCount">
                    <xsl:value-of select="/t:TestRun/t:ResultSummary/t:Counters/@passed" />
                  </td>
                </tr>
                <tr>
                  <th scope="row" class="column1 statusCount">Failed</th>
                  <td class="statusCount">
                    <xsl:value-of select="/t:TestRun/t:ResultSummary/t:Counters/@failed" />
                  </td>
                </tr>
                <tr>
                  <th scope="row" class="column1 statusCount">Inconclusive</th>
                  <td class="statusCount">
                    <xsl:value-of select="/t:TestRun/t:ResultSummary/t:Counters/@inconclusive" />
                  </td>
                </tr>
                <tr>
                  <th scope="row" class="column1 statusCount">Error</th>
                  <td class="statusCount">
                    <xsl:value-of select="/t:TestRun/t:ResultSummary/t:Counters/@error" />
                  </td>
                </tr>
                <tr>
                  <th scope="row" class="column1 statusCount">Warning</th>
                  <td class="statusCount">
                    <xsl:value-of select="/t:TestRun/t:ResultSummary/t:Counters/@warning" />
                  </td>
                </tr>
                <tr>
                  <th scope="row" class="column1 statusCount">Timeout</th>
                  <td class="statusCount">
                    <xsl:value-of select="/t:TestRun/t:ResultSummary/t:Counters/@timeout" />
                  </td>
                </tr>
              </tbody>
            </table>
            <table class="SummaryTable">
              <caption>Summary</caption>
              <tbody>
                <xsl:for-each select="/t:TestRun/t:Times">
                  <tr class="odd">
                    <th class="column1">Start Time</th>
                    <td>
                      <xsl:value-of select="trxreport:GetShortDateTime(@start)" />
                    </td>
                  </tr>
                  <tr>
                    <th class="column1">End Time</th>
                    <td>
                      <xsl:value-of select="trxreport:GetShortDateTime(@finish)" />
                    </td>
                  </tr>
                  <tr>
                    <th class="column1">Duration</th>
                    <td>
                      <xsl:value-of select="trxreport:ToExactTimeDefinition(@start,@finish)"/>
                    </td>
                  </tr>
                </xsl:for-each>
                <tr class="odd">
                  <th class="column1">User</th>
                  <td>
                    <xsl:value-of select="/t:TestRun/@runUser" />
                  </td>
                </tr>
                <tr>
                  <th scope="row" class="column1">Machine</th>
                  <td>
                    <xsl:value-of select="//t:UnitTestResult/@computerName" />
                  </td>
                </tr>
                <tr>
                  <th scope="row" class="column1">Description</th>
                  <td>
                    <xsl:value-of select="/t:TestRun/t:TestRunConfiguration/t:Description"/>
                  </td>
                </tr>
                <tr>
                  <th scope="row" class="column1">Outcome</th>
                  <td>
                    <xsl:value-of select="$testRunOutcome"/>
                  </td>
                </tr>
                <tr>
                  <th scope="row" class="column1">Message</th>
                  <td class="outcomeMessage">
                    <xsl:value-of select="t:TestRun/t:ResultSummary/t:RunInfos/t:RunInfo/t:Text"/>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>



          <xsl:variable name="testsFailedSet" select="//t:TestRun/t:Results/t:UnitTestResult[@outcome='Failed']" />
          <xsl:variable name="testsFailedCount" select="count(testsFailedSet)" />
          <xsl:if test="$testsFailedSet">
            <table id="ReportsTable">
              <caption>All Failed Tests</caption>

              <tbody>
                <tr>
                  <td class="column1Failed"></td>
                  <td class="Function">
                    Failed tests
                  </td>

                  <td class="ex">
                    <div class="OpenMoreButton" onclick="ShowHideWithChange('{generate-id(faileds)}TestsContainer','{generate-id(faileds)}Button','Show Tests','Hide Tests');">
                      <div class="MoreButtonText" id="{generate-id(faileds)}Button">Hide Tests</div>
                    </div>
                  </td>
                </tr>
                <tr id="{generate-id(faileds)}TestsContainer" class="visibleRow">
                  <td colspan="3">
                    <table>
                      <thead>
                        <tr class="odd">
                          <th scope="col" class="TestsTable" abbr="Status">Status</th>
                          <th scope="col" class="TestsTable" abbr="Test">Test</th>
                          <th scope="col" class="TestsTable" abbr="Message">Message</th>
                          <th scope="col" class="TestsTable" abbr="Message">Owner</th>
                          <th scope="col" class="TestsTable" abbr="Actions"></th>
                          <th scope="col" class="TestsTable" abbr="Exception">Duration</th>
                        </tr>
                      </thead>
                      <tbody>
                        <!--Start of package content-->
                        <xsl:for-each select="$testsFailedSet">
                          <xsl:call-template name="tDetails">
                            <xsl:with-param name="testId" select="@testId" />
                            <xsl:with-param name="testDescription" select="./../t:Description" />
                          </xsl:call-template>
                        </xsl:for-each>
                      </tbody>
                      <!--End of package content-->
                    </table>
                  </td>
                </tr>
              </tbody>
            </table>
          </xsl:if>
          <xsl:variable name="classSet" select="//t:TestMethod[generate-id(.)=generate-id(key('TestMethods', @className))]" />
          <xsl:variable name="classCount" select="count($classSet)" />
          <table id="ReportsTable">
            <caption>All Tests Group By Classes</caption>
            <thead>
              <tr class="odd">
                <th scope="col" abbr="Status"></th>
                <th scope="col" abbr="Test">
                  Classes <div class="Tag NumberTag">
                    <xsl:value-of select="$classCount" />
                  </div>
                </th>
                <th scope="col" abbr="Message"></th>
                <th scope="col" abbr="Exception">More</th>
              </tr>
            </thead>
            <tbody>
              <xsl:for-each select="$classSet">
                <xsl:variable name="testsSet" select="key('TestMethods', @className)" />
                <xsl:variable name="testsCount" select="count($testsSet)" />
                <tr>
                  <td class="PackageStatus">
                    <div id="{generate-id(@className)}Failed" class="graphsDiv NumberTagRed tooltip"></div>
                    <div id="{generate-id(@className)}Passed" class="graphsDiv NumberTagGreen tooltip"></div>
                    <div id="{generate-id(@className)}Warn" class="graphsDiv NumberTagYellow tooltip"></div>
                  </td>
                  <td class="Function">
                    <xsl:value-of select="trxreport:RemoveAssemblyName(@className)" />
                  </td>
                  <td class="TestsCount" name="{generate-id(@className)}Id">
                    <div class="Tag NumberTag">
                      <xsl:value-of select="concat($testsCount,' Tests')" />
                    </div>
                  </td>
                  <td class="ex">
                    <div class="OpenMoreButton" onclick="ShowHideWithChange('{generate-id(@className)}TestsContainer','{generate-id(@className)}Button','Show Tests','Hide Tests');">
                      <div class="MoreButtonText" id="{generate-id(@className)}Button">Show Tests</div>
                    </div>
                  </td>
                </tr>
                <tr id="{generate-id(@className)}TestsContainer" class="hiddenRow">
                  <td colspan="4">
                    <table>
                      <thead>
                        <tr class="odd">
                          <th scope="col" class="TestsTable" abbr="Status">Status</th>
                          <th scope="col" class="TestsTable" abbr="Test">Test</th>
                          <th scope="col" class="TestsTable" abbr="Message">Message</th>
                          <th scope="col" class="TestsTable" abbr="Message">Owner</th>
                          <th scope="col" class="TestsTable" abbr="Actions"></th>
                          <th scope="col" class="TestsTable" abbr="Exception">Duration</th>
                        </tr>
                      </thead>
                      <tbody>
                        <!--Start of package content-->
                        <xsl:for-each select="$testsSet">
                          <xsl:call-template name="tDetails">
                            <xsl:with-param name="testId" select="./../@id" />
                            <xsl:with-param name="testDescription" select="./../t:Description" />
                          </xsl:call-template>
                        </xsl:for-each>
                      </tbody>
                      <!--End of package content-->
                    </table>
                  </td>
                </tr>
                <script>
                  CalculateTestsStatuses('<xsl:value-of select="generate-id(@className)"/>TestsContainer','<xsl:value-of select="generate-id(@className)"/>');
                </script>
              </xsl:for-each>
            </tbody>
          </table>
          <Table>
            <caption>Five most slowest tests</caption>
            <thead>
              <tr class="odd">
                <th scope="col">Time</th>
                <th scope="col" abbr="Status">Status</th>
                <th scope="col" abbr="Test">Test</th>
                <th scope="col" abbr="Message">Owner</th>
                <th scope="col" abbr="Message">Duration</th>
              </tr>
            </thead>
            <tbody>
              <xsl:for-each select="/t:TestRun/t:Results/t:UnitTestResult">
                <xsl:sort select="@duration" order="descending"/>
                <xsl:if test="position() &gt;= 1 and position() &lt;=5">
                  <xsl:variable name="testId" select="@testId" />
                  <tr>
                    <th scope="row" class="column1">
                      <xsl:value-of select="trxreport:GetShortDateTime(@startTime)" />
                    </th>
                    <xsl:call-template name="tStatus">
                      <xsl:with-param name="testId" select="@testId" />
                    </xsl:call-template>
                    <td class="Function slowest">
                      <xsl:value-of select="trxreport:RemoveAssemblyName(/t:TestRun/t:TestDefinitions/t:UnitTest[@id=$testId]/t:TestMethod/@className)"/>.<xsl:value-of select="@testName"/>
                    </td>
                    <td>
                      <xsl:variable name="nameSet" select="/t:TestRun/t:TestDefinitions/t:UnitTest[@id=$testId]/t:Owners/t:Owner"/>
                      <xsl:variable name="nameCount" select="count($nameSet)"/>
                      <xsl:for-each select="$nameSet">
                        <xsl:value-of select="@name"/>
                        <xsl:if test="$nameCount &gt;=position()+1 ">
                          <br/>
                        </xsl:if>
                      </xsl:for-each>
                    </td>
                    <td class="Message slowest">
                      <xsl:value-of select="trxreport:ToExactTimeDefinition(@duration)"/>
                    </td>
                  </tr>
                </xsl:if>
              </xsl:for-each>
              <tr>
                <td colspan="5">
                  <h6>TRX Html Viewer log - Niv Navick 2015</h6>
                </td>
              </tr>
            </tbody>
          </Table>
        </div>
      </body>
      <script>
        CalculateTotalPrecents();
        CreateTotalStatusesGraph();
      </script>
    </html>
  </xsl:template>


  <xsl:template name="tStatus">
    <xsl:param name="testId" />
    <xsl:for-each select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$testId]">
      <xsl:choose>
        <xsl:when test="@outcome='Passed'">
          <td class="passed">
            <div class="Tag StatusTag NumberTagGreen">PASSED</div>
          </td>
        </xsl:when>
        <xsl:when test="@outcome='Failed'">
          <td class="failed">
            <div class="Tag StatusTag NumberTagRed">FAILED</div>
          </td>
        </xsl:when>
        <xsl:when test="@outcome='Inconclusive'">
          <td class="failed">
            <div class="Tag StatusTag NumberTagYellow">INCONCLUSIVE</div>
          </td>
        </xsl:when>
        <xsl:when test="@outcome='Timeout'">
          <td class="failed">Timeout</td>
        </xsl:when>
        <xsl:when test="@outcome='Error'">
          <td class="failed">Error</td>
        </xsl:when>
        <xsl:when test="@outcome='Warn'">
          <td class="warn">
            <div class="Tag StatusTag NumberTagYellow">WARN</div>
          </td>
        </xsl:when>
        <xsl:otherwise>
          <td class="info">OTHER</td>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>


  <xsl:template name="tDetails">
    <xsl:param name="testId" />
    <xsl:param name="testDescription" />
    <xsl:for-each select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$testId]">
      <tr class="Test">
        <xsl:call-template name="tStatus">
          <xsl:with-param name="testId" select="$testId" />
        </xsl:call-template>
        <td class="Function">
          <xsl:value-of select="@testName" />
        </td>
        <td class="Messages">
          <xsl:call-template name="debugInfo">
            <xsl:with-param name="testId" select="$testId" />
          </xsl:call-template>
        </td>
        <td class="Message">
          <xsl:variable name="nameSet" select="/t:TestRun/t:TestDefinitions/t:UnitTest[@id=$testId]/t:Owners/t:Owner"/>
          <xsl:variable name="nameCount" select="count($nameSet)"/>
          <xsl:for-each select="$nameSet">
            <xsl:value-of select="@name"/>
            <xsl:if test="$nameCount &gt;=position()+1 ">
              <br/>
            </xsl:if>
          </xsl:for-each>
        </td>
        <td class="Messages">
          <xsl:call-template name="stracktracButtonInject">
            <xsl:with-param name="testId" select="$testId" />
          </xsl:call-template>
          <xsl:call-template name="stdOutButtnoInject">
            <xsl:with-param name="testId" select="$testId" />
          </xsl:call-template>

          <xsl:call-template name="stdErrButtonInject">
            <xsl:with-param name="testId" select="$testId" />
          </xsl:call-template>
          <xsl:call-template name="imageExtractor">
            <xsl:with-param name="testId" select="$testId" />
          </xsl:call-template>


        </td>
        <td class="Message">
          <xsl:value-of select="trxreport:ToExactTimeDefinition(@duration)" />
        </td>
      </tr>
      <tr id="{generate-id($testId)}Stacktrace" class="hiddenRow">
        <!--Outer-->
        <td colspan="6" class="testOutputs">
          <table>
            <!--Inner-->
            <tbody>
              <tr>
                <td class="testOutputsTitle">
                  StackTrace
                </td>
              </tr>
              <tr class="visibleRow">
                <td class="alert-status-failed">
                  <xsl:value-of select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$testId]/t:Output/t:ErrorInfo/t:StackTrace" />
                </td>
              </tr>
            </tbody>
          </table>
        </td>
      </tr>
      <tr id="{generate-id($testId)}StdOut" class="hiddenRow">
        <!--Outer-->
        <td colspan="6" class="testOutputs">
          <table>
            <!--Inner-->
            <tbody>
              <tr>
                <td class="testOutputsTitle">
                  StdOut
                </td>
              </tr>
              <tr class="visibleRow">
                <td class="alert-status-out">
                  <xsl:value-of select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$testId]/t:Output/t:StdOut" />
                </td>
              </tr>
            </tbody>
          </table>
        </td>
      </tr>
      <tr id="{generate-id($testId)}StdErr" class="hiddenRow">
        <!--Outer-->
        <td colspan="6" class="testOutputs">
          <table>
            <!--Inner-->
            <tbody>
              <tr>
                <td class="testOutputsTitle">
                  StdErr
                </td>
              </tr>
              <tr class="visibleRow">
                <td class="alert-status-err">
                  <xsl:value-of select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$testId]/t:Output/t:StdErr" />
                </td>
              </tr>
            </tbody>
          </table>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="imageExtractor">
    <xsl:param name="testId" />
    <xsl:for-each select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$testId]/t:Output">
      <xsl:variable name="MessageErrorStacktrace" select="trxreport:ExtractImageUrl(t:ErrorInfo/t:StackTrace)"/>
      <xsl:variable name="StdOut" select="trxreport:ExtractImageUrl(t:StdOut)"/>
      <xsl:variable name="StdErr" select="trxreport:ExtractImageUrl(t:StdErr)"/>
      <xsl:variable name="MessageErrorInfo" select="trxreport:ExtractImageUrl(t:ErrorInfo/t:Message)"/>

      <xsl:variable name="imagesUrl" select="trxreport:ExtractMultipleImages($MessageErrorStacktrace,$StdOut,$StdErr,$MessageErrorInfo)"/>
      <xsl:if test="$imagesUrl">
        <div class="atachmentImage tooltip" onclick="AddToArray({$imagesUrl});show('floatingImageBackground');show('floatingGrayBackground')" title="Image"></div>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="stracktracButtonInject">
    <xsl:param name="testId" />
    <xsl:for-each select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$testId]/t:Output">
      <xsl:variable name="MessageErrorStacktrace" select="t:ErrorInfo/t:StackTrace"/>
      <xsl:if test="$MessageErrorStacktrace">
        <div class="stacktraceButton tooltip" title="Stacktrace"  onclick="ShowHide('{generate-id($testId)}Stacktrace');"></div>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="stdOutButtnoInject">
    <xsl:param name="testId" />
    <xsl:variable name="stdOut" select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$testId]/t:Output/t:StdOut"/>
    <xsl:if test="$stdOut">
      <div class="stdOutButton tooltip" title="StdOut"  onclick="ShowHide('{generate-id($testId)}StdOut');"></div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="stdErrButtonInject">
    <xsl:param name="testId" />
    <xsl:variable name="stdErr" select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$testId]/t:Output/t:StdErr"/>
    <xsl:if test="$stdErr">
      <div class="stdErrButton tooltip" title="StdErr"  onclick="ShowHide('{generate-id($testId)}StdErr');"></div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="debugInfo">
    <xsl:param name="testId" />
    <xsl:for-each select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$testId]/t:Output">
      <xsl:variable name="MessageText" select="t:ErrorInfo/t:Message"/>
      <xsl:if test="$MessageText">
        <xsl:variable name="MessageLengthMoreThan300" select="trxreport:ShortenMessage($MessageText)"/>
        <xsl:choose>
          <xsl:when test="$MessageLengthMoreThan300">
            <div id="{generate-id($testId)}TestMessage">
              <xsl:value-of select="$MessageLengthMoreThan300"/>
            </div>
          
            <a href="javascript:ToggleMessageView('{$MessageText}','{$MessageLengthMoreThan300}','{generate-id($testId)}');" id="{generate-id($testId)}TestMessageLink">Show More</a>

          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$MessageText"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>

