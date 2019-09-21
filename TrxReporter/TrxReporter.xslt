<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:t="http://microsoft.com/schemas/VisualStudio/TeamTest/2010"
    xmlns:trxreport="urn:my-scripts"
    xmlns:pens="urn:Pens">
  <xsl:output method="html" indent="yes"/>
  <xsl:key name="TestMethods" match="t:TestMethod" use="@className"/>
  <!--<xsl:namespace-alias stylesheet-prefix="t" result-prefix="#default"/>-->

  <xsl:template match="/" >
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
    <html>
      <head>
        <meta charset="utf-8"/>
        <link rel="stylesheet" type="text/css" href="TrxReporter.css"/>
        <link rel="stylesheet" type="text/css" href="TrxReporterTable.css"/>
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

          <xsl:call-template name="tTitleBar">
            <xsl:with-param name="title" select="/t:TestRun/@name"/>
            <xsl:with-param name="countersExecuted" select="/t:TestRun/t:ResultSummary/t:Counters/@executed"/>
            <xsl:with-param name="countersPassed" select="/t:TestRun/t:ResultSummary/t:Counters/@passed"/>
            <xsl:with-param name="countersFailed" select="/t:TestRun/t:ResultSummary/t:Counters/@failed"/>
          </xsl:call-template>

          <div class="SummaryDiv">
            <table class="summaryLayout">
              <tr class="summaryLayout">
                <td rowspan="2" class="summaryLayout">
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
                </td>
                <td rowspan="2" class="summaryLayout">
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
                </td>
                <td class="summaryLayout">
                  <table class="SummaryTable">
                    <caption>Run Time Summary</caption>
                    <tbody>
                      <xsl:for-each select="/t:TestRun/t:Times">
                        <tr class="odd">
                          <th class="column1">Start Time</th>
                          <td>
                            <xsl:value-of select="pens:GetShortDateTime(@start)" />
                          </td>
                        </tr>
                        <tr>
                          <th class="column1">End Time</th>
                          <td>
                            <xsl:value-of select="pens:GetShortDateTime(@finish)" />
                          </td>
                        </tr>
                        <tr>
                          <th class="column1">Duration</th>
                          <td>
                            <xsl:value-of select="pens:ToExactTimeDefinition(@start,@finish)"/>
                          </td>
                        </tr>
                      </xsl:for-each>
                    </tbody>
                  </table>
                </td>
                <td class="summaryLayout">
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
                </td>
              </tr>
              <tr class="summaryLayout">
                <td colspan="2" class="summaryLayout" style="vertical-align:top">
                  <div class="storage">
                    <xsl:value-of select="t:TestRun/t:TestDefinitions/t:UnitTest/@storage" />
                  </div>
                </td>
              </tr>
            </table>
          </div>


          <xsl:variable name="testsFailedSet" select="//t:TestRun/t:Results/t:UnitTestResult[@outcome='Failed']" />
          <xsl:variable name="testsFailedCount" select="count(testsFailedSet)" />

          <xsl:variable name="classSet" select="//t:TestMethod[generate-id(.)=generate-id(key('TestMethods', @className))]" />
          <xsl:variable name="classCount" select="count($classSet)" />
          <table id="ReportsTable">
            <caption>All Tests By Class</caption>
            <thead>
              <tr class="odd">
                <th scope="col" abbr="Status">Status</th>
                <th scope="col" abbr="Test">
                  Classes <div class="NumberTag">
                    <xsl:value-of select="$classCount" />
                  </div>
                </th>
                <th scope="col" abbr="Message">Count</th>
                <th scope="col" abbr="Exception"></th>
              </tr>
            </thead>
            <tbody>
              <xsl:for-each select="$classSet">
                <xsl:variable name="testsSet" select="key('TestMethods', @className)" />
                <xsl:variable name="testsCount" select="count($testsSet)" />
                <tr>
                  <td class="PackageStatus">
                    <canvas id="{generate-id(@className)}canvas" width="100" height="25">
                    </canvas>
                  </td>
                  <td class="Function">
                    <xsl:value-of select="pens:RemoveAssemblyName(@className)" />
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
                  <td colspan="4">
                    <div id="exceptionArrow">↳</div>
                    <table>
                      <thead>
                        <tr class="odd">
                          <th scope="col" class="TestsTable">Time/Duration</th>
                          <!--th scope="col" class="TestsTable" abbr="Test">Test</th-->
                          <th scope="col" class="TestsTable" abbr="Message">Message</th>
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
            <caption>Five slowest tests</caption>
            <thead>
              <tr class="odd">
                <th scope="col">Time/Duration</th>
                <th scope="col" abbr="Test">Test</th>
                <th scope="col" abbr="Message">Duration</th>
              </tr>
            </thead>
            <tbody>
              <xsl:for-each select="/t:TestRun/t:Results/t:UnitTestResult">
                <xsl:sort select="@duration" order="descending"/>
                <xsl:if test="position() &gt;= 1 and position() &lt;=5">
                  <xsl:variable name="testId" select="@testId" />
                  <tr>
                    <!--th scope="row" class="column1">
                      <xsl:value-of select="pens:GetShortDateTime(@startTime)" />
                    </th-->
                    <xsl:call-template name="tStatus">
                      <xsl:with-param name="testId" select="@testId" />
                    </xsl:call-template>
                    <td class="Function slowest">
                      <xsl:value-of select="pens:RemoveAssemblyName(/t:TestRun/t:TestDefinitions/t:UnitTest[@id=$testId]/t:TestMethod/@className)"/>
                      .<xsl:value-of select="@testName"/>
                    </td>
                    <td class="Message slowest">
                      <div style="white-space: nowrap">
                        <xsl:value-of select="pens:ToExactTimeDefinition(@duration)"/>
                      </div>
                    </td>
                  </tr>
                </xsl:if>
              </xsl:for-each>
            </tbody>
          </Table>
          <h6 style="text-align:center">
            &#169; <xsl:value-of select="pens:GetYear()"/> Waters Corporation, Internal Use Only
          </h6>

        </div>
      </body>
      <script>
        CalculateTotalPrecents();
      </script>
    </html>
  </xsl:template>

  <!-- titleBar =============================================================================== -->

  <xsl:template name="tTitleBar">
    <xsl:param name="title" />
    <xsl:param name="countersExecuted" />
    <xsl:param name="countersPassed" />
    <xsl:param name="countersFailed" />
    <xsl:choose>
      <xsl:when test="$countersFailed != 0">
        <div class="StatusBar statusBarFailed">
          <div class="statusBarFailedInner">
            <center>
              <h1>
                <div class="titleCenterd">
                  <xsl:value-of select="$title"/>
                </div>
              </h1>
            </center>
          </div>
        </div>
      </xsl:when>
      <xsl:when test="($countersPassed + $countersFailed) &lt; $countersExecuted">
        <div class="StatusBar statusBarCompleted">
          <div class="statusBarCompletedInner">
            <center>
              <h1>
                <div class="titleCenterd">
                  <xsl:value-of select="$title"/>
                </div>
              </h1>
            </center>
          </div>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="StatusBar statusBarPassed">
          <div class="statusBarPassedInner">
            <center>
              <h1>
                <div class="titleCenterd">
                  <xsl:value-of select="$title"/>
                </div>
              </h1>
            </center>
          </div>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- status ================================================================================= -->

  <xsl:template name="tStatus">
    <xsl:param name="testId" />
    <xsl:param name="withDuration" />
    <xsl:for-each select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$testId]">
      <xsl:choose>
        <xsl:when test="@outcome='Passed'">
          <td class="passed top">
            PASSED
            <div class="times">
              <xsl:value-of select="pens:GetShortDateTime(@startTime)" />
              <xsl:if test="($withDuration='yes')">
                <br/>
                <br/>
                <xsl:value-of select="pens:ToExactTimeDefinition(@duration)" />
              </xsl:if>
            </div>
          </td>
        </xsl:when>
        <xsl:when test="@outcome='Failed'">
          <td class="failed top">
            FAILED
            <div class="times">
              <xsl:value-of select="pens:GetShortDateTime(@startTime)" />
              <xsl:if test="($withDuration='yes')">
                <br/>
                <br/>
                <xsl:value-of select="pens:ToExactTimeDefinition(@duration)" />
              </xsl:if>
            </div>
          </td>
        </xsl:when>
        <xsl:when test="@outcome='Inconclusive'">
          <td class="warn top">
            Inconclusive
            <div class="times">
              <xsl:value-of select="pens:GetShortDateTime(@startTime)" />
              <xsl:if test="($withDuration='yes')">
                <br/>
                <br/>
                <xsl:value-of select="pens:ToExactTimeDefinition(@duration)" />
              </xsl:if>
            </div>
          </td>
        </xsl:when>
        <xsl:when test="@outcome='Timeout'">
          <td class="failed top">
            Timeout
            <div class="times">
              <xsl:value-of select="pens:GetShortDateTime(@startTime)" />
              <xsl:if test="($withDuration='yes')">
                <br/>
                <br/>
                <xsl:value-of select="pens:ToExactTimeDefinition(@duration)" />
              </xsl:if>
            </div>
          </td>
        </xsl:when>
        <xsl:when test="@outcome='Error'">
          <td class="failed top">
            Error
            <div class="times">
              <xsl:value-of select="pens:GetShortDateTime(@startTime)" />
              <xsl:if test="($withDuration='yes')">
                <br/>
                <br/>
                <xsl:value-of select="pens:ToExactTimeDefinition(@duration)" />
              </xsl:if>
            </div>
          </td>
        </xsl:when>
        <xsl:when test="@outcome='Warn'">
          <td class="warn top">
            Warn
            <div class="times">
              <xsl:value-of select="pens:GetShortDateTime(@startTime)" />
              <xsl:if test="($withDuration='yes')">
                <br/>
                <br/>
                <xsl:value-of select="pens:ToExactTimeDefinition(@duration)" />
              </xsl:if>
            </div>
          </td>
        </xsl:when>
        <xsl:otherwise>
          <td class="info top">
            OTHER
            <div class="times">
              <xsl:value-of select="pens:GetShortDateTime(@startTime)" />
              <xsl:if test="($withDuration='yes')">
                <br/>
                <br/>
                <xsl:value-of select="pens:ToExactTimeDefinition(@duration)" />
              </xsl:if>
            </div>
          </td>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- tDetails =============================================================================== -->

  <xsl:template name="tDetails">
    <xsl:param name="testId" />
    <xsl:param name="testDescription" />
    <xsl:for-each select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$testId]">
      <tr class="Test">
        <!--th scope="row" class="column1">
          <div style="white-space: nowrap">
            <xsl:value-of select="pens:GetShortDateTime(@startTime)" />
            <br/>
            <br/>
            <xsl:value-of select="pens:ToExactTimeDefinition(@duration)" />
          </div>
        </th-->

        <xsl:call-template name="tStatus">
          <xsl:with-param name="testId" select="$testId" />
          <xsl:with-param name="withDuration" select="'yes'" />
        </xsl:call-template>

        <td class="Messages">
          <div class="testName">
            <xsl:value-of select="@testName" />
          </div>
          <xsl:call-template name="imageExtractor">
            <xsl:with-param name="testId" select="$testId" />
          </xsl:call-template>

          <xsl:call-template name="debugInfo">
            <xsl:with-param name="testId" select="$testId" />
          </xsl:call-template>
        </td>
      </tr>
      <tr id="{generate-id($testId)}Stacktrace" class="hiddenRow">
        <!--Outer-->
        <td colspan="2">
          <div id="exceptionArrow">↳</div>
          <table>
            <!--Inner-->
            <tbody>
              <tr class="visibleRow">
                <td class="ex">
                  <div class="exScroller">
                    <pre class="exMessage">
                      <xsl:value-of select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$testId]/t:Output/t:ErrorInfo/t:StackTrace" />
                    </pre>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>

  <!-- imageExtractor ========================================================================= -->

  <xsl:template name="imageExtractor">
    <xsl:param name="testId" />
    <xsl:for-each select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$testId]/t:Output">

      <xsl:variable name="MessageErrorStacktrace" select="pens:ExtractImageUrl(t:ErrorInfo/t:StackTrace)"/>
      <xsl:variable name="StdOut" select="pens:ExtractImageUrl(t:StdOut)"/>
      <xsl:variable name="StdErr" select="pens:ExtractImageUrl(t:StdErr)"/>
      <xsl:variable name="MessageErrorInfo" select="pens:ExtractImageUrl(t:ErrorInfo/t:Message)"/>
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

  <!-- debugInfo ============================================================================== -->

  <xsl:template name="debugInfo">
    <xsl:param name="testId" />

    <xsl:for-each select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$testId]/t:Output">
      <xsl:variable name="MessageErrorStacktrace" select="t:ErrorInfo/t:StackTrace"/>
      <xsl:variable name="StdOut" select="t:StdOut"/>

      <xsl:if test="$StdOut or $MessageErrorStacktrace">
        <xsl:value-of select="pens:FormatOutput($StdOut)" disable-output-escaping="yes" />
        <xsl:if test="$MessageErrorStacktrace">
          <div class="OpenMoreButton">
            <div class="MoreButtonText" id="Button">
              <a class="Message" id="{generate-id($testId)}StacktraceToggle"
                  href="javascript:ShowHide('{generate-id($testId)}Stacktrace','{generate-id($testId)}StacktraceToggle','Show Stacktrace','Hide Stacktrace');">Show Stacktrace</a>
            </div>
          </div>
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
        <div class="exMessage">
          <xsl:value-of select="$MessageErrorInfo"/>
        </div>
        <br/>
      </xsl:if>

    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>

