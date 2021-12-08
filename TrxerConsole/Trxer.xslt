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
    <![CDATA[
    public string RemoveAssemblyName(string asm)
    {
      if(asm.IndexOf(',')>0) {
        return asm.Substring(0,asm.IndexOf(','));
      }
      else 
      {
        return asm;
      }
    }
    public string RemoveNamespace(string asm) 
    {
      if(asm.IndexOf(',')>0) {
        int coma = asm.IndexOf(',');
        return asm.Substring(coma + 2, asm.Length - coma - 2);
      }
      return asm;
    }
    public string GetShortDateTime(string time)
    {
      if( string.IsNullOrEmpty(time) )
      {
        return string.Empty;
      }
      
      return DateTime.Parse(time).ToString();
    }
    
    private string ToExtactTime(double ms)
    {
      if (ms < 1000)
        return ms + " ms";

      if (ms >= 1000 && ms < 60000)
        return string.Format("{0:0.00} seconds", TimeSpan.FromMilliseconds(ms).TotalSeconds);

      if (ms >= 60000 && ms < 3600000)
        return string.Format("{0:0.00} minutes", TimeSpan.FromMilliseconds(ms).TotalMinutes);

      return string.Format("{0:0.00} hours", TimeSpan.FromMilliseconds(ms).TotalHours);
    }
    
    public string ToExactTimeDefinition(string duration)
    {
      if( string.IsNullOrEmpty(duration) )
      {
        return string.Empty;
      } 
    
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
    
    public string ExtractImageUrl(string text)
    {
       Match match = Regex.Match(text, "('|\")([^\\s]+(\\.(?i)(jpg|png|gif|bmp)))('|\")",
	      RegexOptions.IgnoreCase);

	
	   if (match.Success)
	   {
	      return match.Value.Replace("\'",string.Empty).Replace("\"",string.Empty).Replace("\\","\\\\");
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
        <link rel="stylesheet" type="text/css" href="Trxer.css"/>
        <link rel="stylesheet" type="text/css" href="TrxerTable.css"/>
        <script language="javascript" type="text/javascript" src="functions.js"></script>
        <title>
          <xsl:value-of select="/t:TestRun/@name"/>
        </title>
      </head>
      <body>
        <div id="divToRefresh" class="wrapOverall">
          <div id="floatingImageBackground" class="floatingImageBackground" style="visibility: hidden;">
            <div class="floatingImageCloseButton" onclick="hide('floatingImageBackground');"></div>
            <img src="" id="floatingImage"/>
          </div>
          <br />
          <xsl:variable name="testRunOutcome" select="t:TestRun/t:ResultSummary/@outcome"/>

          <div class="StatusBar statusBar{$testRunOutcome}">
            <div class="statusBar{$testRunOutcome}Inner">
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
              <caption>Run Time Summary</caption>
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
              </tbody>
            </table>
            <table class="DetailsTable">
              <caption>Tests Details</caption>
              <tbody>
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
                    Faileds
                  </td>
                  <td class="Message" name="{generate-id(faileds)}Id">
                    <xsl:value-of select="concat(testsFailedCount,' Tests')" />
                  </td>
                  <td class="ex">
                    <div class="OpenMoreButton" onclick="ShowHide('{generate-id(faileds)}TestsContainer','{generate-id(faileds)}Button','Show Tests','Hide Tests');">
                      <div class="MoreButtonText" id="{generate-id(faileds)}Button">Hide Tests</div>
                    </div>
                  </td>
                </tr>
                <tr id="{generate-id(faileds)}TestsContainer" class="visibleRow">
                  <td colspan="4">
                    <div id="exceptionArrow">↳</div>
                    <table>
                      <thead>
                        <tr class="odd">
                          <th scope="col" class="TestsTable">Time</th>
                          <th scope="col" class="TestsTable" abbr="Status">Status</th>
                          <th scope="col" class="TestsTable" abbr="Test">Test</th>
                          <th scope="col" class="TestsTable" abbr="Message">Message</th>
                          <th scope="col" class="TestsTable" abbr="Message">Owner</th>
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
                <th scope="col">Time</th>
                <th scope="col" abbr="Status">Status</th>
                <th scope="col" abbr="Test">
                  Classes <div class="NumberTag">
                    <xsl:value-of select="$classCount" />
                  </div>
                </th>
                <th scope="col" abbr="Message">Message</th>
                <th scope="col" abbr="Exception">More</th>
              </tr>
            </thead>
            <tbody>
              <xsl:for-each select="$classSet">
                <xsl:variable name="testsSet" select="key('TestMethods', @className)" />
                <xsl:variable name="testsCount" select="count($testsSet)" />
                <tr>
                  <th scope="row" class="column1">7/21/2014 10:56:45 PM</th>
                  <td class="PackageStatus">
                    <canvas id="{generate-id(@className)}canvas" width="100" height="25">
                    </canvas>
                  </td>
                  <td class="Function">
                    <xsl:value-of select="trxreport:RemoveAssemblyName(@className)" />
                  </td>
                  <td class="Message" name="{generate-id(@className)}Id">
                    <xsl:value-of select="concat($testsCount,' Tests')" />
                  </td>
                  <td class="ex">
                    <div class="OpenMoreButton" onclick="ShowHide('{generate-id(@className)}TestsContainer','{generate-id(@className)}Button','Show Tests','Hide Tests');">
                      <div class="MoreButtonText" id="{generate-id(@className)}Button">Show Tests</div>
                    </div>
                  </td>
                </tr>
                <tr id="{generate-id(@className)}TestsContainer" class="hiddenRow">
                  <td colspan="5">
                    <div id="exceptionArrow">↳</div>
                    <table>
                      <thead>
                        <tr class="odd">
                          <th scope="col" class="TestsTable">Time</th>
                          <th scope="col" class="TestsTable" abbr="Status">Status</th>
                          <th scope="col" class="TestsTable" abbr="Test">Test</th>
                          <th scope="col" class="TestsTable" abbr="Message">Message</th>
                          <th scope="col" class="TestsTable" abbr="Message">Owner</th>
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
                  CalculateTestsStatuses('<xsl:value-of select="generate-id(@className)"/>TestsContainer','<xsl:value-of select="generate-id(@className)"/>canvas');
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
                      <xsl:value-of select="trxreport:RemoveAssemblyName(/t:TestRun/t:TestDefinitions/t:UnitTest[@id=$testId]/t:TestMethod/@className)"/>
                      .<xsl:value-of select="@testName"/>
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
      </script>
    </html>
  </xsl:template>


  <xsl:template name="tStatus">
    <xsl:param name="testId" />
    <xsl:for-each select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$testId]">
      <xsl:choose>
        <xsl:when test="@outcome='Passed'">
          <td class="passed">PASSED</td>
        </xsl:when>
        <xsl:when test="@outcome='Failed'">
          <td class="failed">FAILED</td>
        </xsl:when>
        <xsl:when test="@outcome='Inconclusive'">
          <td class="warn">Inconclusive</td>
        </xsl:when>
        <xsl:when test="@outcome='Timeout'">
          <td class="failed">Timeout</td>
        </xsl:when>
        <xsl:when test="@outcome='Error'">
          <td class="failed">Error</td>
        </xsl:when>
        <xsl:when test="@outcome='Warn'">
          <td class="warn">Warn</td>
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
        <th scope="row" class="column1">
          <xsl:value-of select="trxreport:GetShortDateTime(@startTime)" />
        </th>


        <xsl:call-template name="tStatus">
          <xsl:with-param name="testId" select="$testId" />
        </xsl:call-template>

        <td class="Function">
          <xsl:value-of select="@testName" />

          <xsl:call-template name="imageExtractor">
            <xsl:with-param name="testId" select="$testId" />
          </xsl:call-template>


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
        <td class="Message">
          <xsl:value-of select="trxreport:ToExactTimeDefinition(@duration)" />
        </td>
      </tr>
      <tr id="{generate-id($testId)}Stacktrace" class="hiddenRow">
        <!--Outer-->
        <td colspan="6">
          <div id="exceptionArrow">↳</div>
          <table>
            <!--Inner-->
            <tbody>
              <tr class="visibleRow">
                <td class="ex">
                  <xsl:value-of select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$testId]/t:Output/t:ErrorInfo/t:StackTrace" />
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
      <xsl:choose>
        <xsl:when test="$MessageErrorStacktrace">
          <div class="atachmentImage" onclick="show('floatingImageBackground');updateFloatingImage('{$MessageErrorStacktrace}');"></div>
        </xsl:when>
        <xsl:when test="$StdOut">
          <div class="atachmentImage" onclick="show('floatingImageBackground');updateFloatingImage('{$StdOut}');"></div>
        </xsl:when>
        <xsl:when test="$StdErr">
          <div class="atachmentImage" onclick="show('floatingImageBackground');updateFloatingImage('{$StdErr}');"></div>
        </xsl:when>
        <xsl:when test="$MessageErrorInfo">
          <div class="atachmentImage" onclick="show('floatingImageBackground');updateFloatingImage('{$MessageErrorInfo}');"></div>
        </xsl:when>
      </xsl:choose>

    </xsl:for-each>
  </xsl:template>







  <xsl:template name="debugInfo">
    <xsl:param name="testId" />
    <xsl:for-each select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$testId]/t:Output">

      <xsl:variable name="MessageErrorStacktrace" select="t:ErrorInfo/t:StackTrace"/>

      <xsl:variable name="StdOut" select="t:StdOut"/>
      <xsl:if test="$StdOut or $MessageErrorStacktrace">
        <xsl:value-of select="$StdOut"/>
        <xsl:if test="$MessageErrorStacktrace">
          <a style="float:right;" id="{generate-id($testId)}StacktraceToggle" href="javascript:ShowHide('{generate-id($testId)}Stacktrace','{generate-id($testId)}StacktraceToggle','Show Stacktrace','Hide Stacktrace');">Show Stacktrace</a>
        </xsl:if>
        <xsl:if test="$StdOut">
          <br/>
        </xsl:if>
      </xsl:if>
      <xsl:value-of select="t:StdErr" />
      <xsl:variable name="StdErr" select="t:StdErr"/>
      <xsl:if test="$StdErr">
        <xsl:value-of select="$StdErr"/>
        <br/>
      </xsl:if>
      <xsl:variable name="MessageErrorInfo" select="t:ErrorInfo/t:Message"/>
      <xsl:if test="$MessageErrorInfo">
        <xsl:value-of select="$MessageErrorInfo"/>
        <br/>
      </xsl:if>



    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>

