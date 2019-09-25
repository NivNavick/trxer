﻿<?xml version="1.0" encoding="utf-8"?>
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

          <!-- Title - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

          <xsl:variable name="testRunName" select="/t:TestRun/@name" />
          <xsl:variable name="storage" select="/t:TestRun/t:TestDefinitions/t:UnitTest/@storage" />

          <xsl:call-template name="BuildTitleBar">
            <xsl:with-param name="title" select="pens:MakeCustomName($testRunName,$storage)"/>
            <xsl:with-param name="countersExecuted" select="/t:TestRun/t:ResultSummary/t:Counters/@executed"/>
            <xsl:with-param name="countersPassed" select="/t:TestRun/t:ResultSummary/t:Counters/@passed"/>
            <xsl:with-param name="countersFailed" select="/t:TestRun/t:ResultSummary/t:Counters/@failed"/>
          </xsl:call-template>

          <div class="SummaryDiv">
            <table class="summaryLayout">
              <tr class="summaryLayout">
                <td class="summaryLayout">
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
                <td class="summaryLayout">
                  <table class="DetailsTable StatusesTable">
                    <caption>Statuses</caption>
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
                  <table class="summaryLayout">
                    <tr>
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
                          <caption>Context</caption>
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
                          <xsl:value-of select="/t:TestRun/t:TestDefinitions/t:UnitTest/@storage" />
                        </div>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </div>

          <!-- Details - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

          <!--
          <xsl:variable name="testsFailedSet" select="//t:TestRun/t:Results/t:UnitTestResult[@outcome='Failed']" />
          <xsl:variable name="testsFailedCount" select="count(testsFailedSet)" />
          -->

          <xsl:variable name="features" select="//t:TestMethod[generate-id(.)=generate-id(key('TestMethods', @className))]" />
          <xsl:variable name="featureCount" select="count($features)" />
          <table id="ReportsTable">
            <caption>
              All Scenarios By Feature (<xsl:value-of select="$featureCount" />)
            </caption>
            <thead>
              <tr>
                <th class="features" scope="col" abbr="Status">Status</th>
                <th class="featuresLeft" scope="col" abbr="Feature">Feature</th>
              </tr>
            </thead>
            <tbody>
              <xsl:for-each select="$features">
                <xsl:variable name="scenarios" select="key('TestMethods', @className)" />
                <xsl:variable name="scenarioCount" select="count($scenarios)" />

                <!-- Scenario header -->

                <tr class="Scenario">
                  <td class="PackageStatus">
                    <canvas id="{generate-id(@className)}canvas" width="100" height="25">
                    </canvas>
                  </td>
                  <td class="scenario" style="text-align:left">
                    <xsl:value-of select="pens:RemoveAssemblyName(@className)" />
                  </td>
                </tr>
                <tr id="{generate-id(@className)}TestsContainer">
                  <td colspan="2">
                    <div id="exceptionArrow">↳</div>
                    <table>
                      <thead>
                        <tr class="odd">
                          <th scope="col" class="TestsTable" style="width:80px;">
                            <div style="width:80px;min-width:80px;display:block;">Status</div>
                          </th>
                          <th scope="col" class="TestsTable" style="text-align:left">
                            Scenario (<xsl:value-of select="$scenarioCount" />)
                          </th>
                          <th scope="col" class="TestsTable" style="width:100px;">
                            <div style="width:100px;min-width:100px;">Duration</div>
                          </th>
                          <th style="width:80px">
                            <div style="width:80px;min-width:80px;">
                              <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
                            </div>
                          </th>
                        </tr>
                      </thead>
                      <tbody>
                        <xsl:for-each select="$scenarios">
                          <xsl:call-template name="BuildScenarioRow">
                            <xsl:with-param name="scenarioId" select="./../@id" />
                            <!--xsl:with-param name="testDescription" select="./../t:Description" /-->
                          </xsl:call-template>
                        </xsl:for-each>
                      </tbody>
                    </table>
                  </td>
                </tr>

                <script>
                  CalculateTestsStatuses(
                  '<xsl:value-of select="generate-id(@className)"/>TestsContainer',
                  '<xsl:value-of select="generate-id(@className)"/>canvas');
                </script>
              </xsl:for-each>
            </tbody>
          </table>

          <!-- Five Slowest - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

          <Table>
            <caption>Five slowest features</caption>
            <thead>
              <tr class="odd">
                <th class="features" scope="col">Status</th>
                <th class="featuresLeft" scope="col" abbr="Feature">Feature</th>
                <th class="features" scope="col" abbr="Duration">Duration</th>
              </tr>
            </thead>
            <tbody>
              <xsl:for-each select="/t:TestRun/t:Results/t:UnitTestResult">
                <xsl:sort select="@duration" order="descending"/>
                <xsl:if test="position() &gt;= 1 and position() &lt;=5">
                  <xsl:variable name="testId" select="@testId" />
                  <tr>
                    <xsl:call-template name="BuildStatusColumn">
                      <xsl:with-param name="outcome" select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$testId]/@outcome" />
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
            &#169; <xsl:value-of select="pens:GetYear()"/>, Internal Use Only
          </h6>
        </div>

        <div id="pictureBox" class="pictureBox" onclick="ClosePictureBox()">
          <img class="pictureBoxImg" id="pictureBoxImg" />
        </div>

      </body>
      <script>
        CalculateTotalPrecents();
      </script>
    </html>
  </xsl:template>

  <!-- BuildTitleBar ========================================================================== -->

  <xsl:template name="BuildTitleBar">
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

  <!-- BuildScenarioRow ======================================================================= -->

  <xsl:template name="BuildScenarioRow">
    <xsl:param name="scenarioId" />
    <xsl:for-each select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$scenarioId]">
      <tr class="Test">
        <xsl:call-template name="BuildStatusColumn">
          <xsl:with-param name="outcome" select="@outcome" />
        </xsl:call-template>
        <td class="Function">
          <xsl:value-of select="@testName" />
        </td>
        <td>
          <xsl:value-of select="pens:ToExactTimeDefinition(@duration)" />
        </td>
        <td>
          <div class="OpenMoreButton" onclick="ShowHide('{$scenarioId}Details','{$scenarioId}DetailsButton','Show Gherkin','Hide Gherkin');">
            <div class="MoreButtonText" id="{$scenarioId}DetailsButton">Show Gherkin</div>
          </div>
        </td>
      </tr>
      <tr id="{$scenarioId}Details" class="Messages hiddenRow">
        <td>
          <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
        </td>
        <td class="Test Messages" colspan="3">
          <xsl:call-template name="BuildDetailInfo">
            <xsl:with-param name="testId" select="$scenarioId" />
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>

  <!-- BuildStatusColumn ====================================================================== -->

  <xsl:template name="BuildStatusColumn">
    <xsl:param name="outcome" />
    <xsl:choose>
      <xsl:when test="$outcome='Passed'">
        <td class="passed top">
          PASSED
        </td>
      </xsl:when>
      <xsl:when test="$outcome='Failed'">
        <td class="failed top">
          FAILED
        </td>
      </xsl:when>
      <xsl:when test="$outcome='Inconclusive'">
        <td class="warn top">
          Inconclusive
        </td>
      </xsl:when>
      <xsl:when test="$outcome='Timeout'">
        <td class="failed top">
          Timeout
        </td>
      </xsl:when>
      <xsl:when test="$outcome='Error'">
        <td class="failed top">
          Error
        </td>
      </xsl:when>
      <xsl:when test="$outcome='Warn'">
        <td class="warn top">
          Warn
        </td>
      </xsl:when>
      <xsl:otherwise>
        <td class="info top">
          OTHER
        </td>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- BuildDetailInfo ======================================================================== -->

  <xsl:template name="BuildDetailInfo">
    <xsl:param name="testId" />

    <xsl:for-each select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$testId]/t:Output">
      <xsl:variable name="MessageErrorStacktrace" select="t:ErrorInfo/t:StackTrace"/>
      <xsl:variable name="StdOut" select="t:StdOut"/>

      <xsl:if test="$StdOut or $MessageErrorStacktrace">
        <xsl:value-of select="pens:FormatOutput($StdOut)" disable-output-escaping="yes" />
        <!--xsl:if test="$MessageErrorStacktrace">
          <div class="OpenMoreButton">
            <div class="MoreButtonText" id="Button">
              <a class="Message" id="{generate-id($testId)}StacktraceToggle"
                  href="javascript:ShowHide('{generate-id($testId)}Stacktrace','{generate-id($testId)}StacktraceToggle','Show Stacktrace','Hide Stacktrace');">Show Stacktrace</a>
            </div>
          </div>
        </xsl:if-->
        <xsl:if test="$StdOut">
          <br/>
        </xsl:if>
      </xsl:if>

      <xsl:value-of select="t:StdErr" />
      <xsl:variable name="StdErr" select="t:StdErr"/>
      <xsl:if test="$StdErr">
        [StdErr: <xsl:value-of select="$StdErr"/> ]
        <br/>
      </xsl:if>

      <xsl:variable name="MessageErrorInfo" select="t:ErrorInfo/t:Message"/>
      <xsl:if test="$MessageErrorInfo">
        <div class="exMessage">
          <xsl:value-of select="$MessageErrorInfo"/>
        </div>
        <br/>
      </xsl:if>

      <xsl:if test="$StdErr or $MessageErrorInfo">
        <xsl:variable name="trace" select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$testId]/t:Output/t:ErrorInfo/t:StackTrace" />
        <div class="stacktrace visibleRow" id="{generate-id($testId)}Stacktrace">
          <div id="exceptionArrow">↳</div>
          <table>
            <tbody>
              <tr class="visibleRow">
                <td class="ex">
                  <div class="exScroller">
                    <pre class="exMessage">
                      <!-- trim off the first space char -->
                      <xsl:value-of select="substring($trace,2)" />
                    </pre>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </xsl:if>

    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>

