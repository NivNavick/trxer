<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:t="http://microsoft.com/schemas/VisualStudio/TeamTest/2010"
    xmlns:trxreport="urn:my-scripts"
    xmlns:pens="urn:Pens">

  <xsl:param name="ReportTitle"></xsl:param>

  <xsl:output method="html" indent="yes"/>
  <xsl:key name="TestMethods" match="t:TestMethod" use="@className"/>

  <!--
  HTML arrow codes: https://www.key-shortcut.com/en/writing-systems/35-symbols/arrows/
  -->

  <xsl:template match="/" >
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
    <xsl:variable name="testRunName" select="/t:TestRun/@name" />
    <xsl:variable name="storage" select="/t:TestRun/t:TestDefinitions/t:UnitTest/@storage" />
    <xsl:variable name="reportSubtitle" select="pens:GetReportSubtitle($testRunName,$storage)" />
    <html>
      <head>
        <meta charset="utf-8"/>
        <link rel="stylesheet" type="text/css" href="Reporter.css"/>
        <script language="javascript" type="text/javascript" src="Reporter.js"></script>
        <title>
          <xsl:value-of select="$reportSubtitle"/>
        </title>
      </head>
      <body>
        <div id="wrapper" class="wrapper">

          <!-- Title - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

          <xsl:call-template name="BuildTitleBar">
            <xsl:with-param name="title" select="$ReportTitle"/>
            <xsl:with-param name="subtitle" select="$reportSubtitle"/>
            <xsl:with-param name="countersExecuted" select="/t:TestRun/t:ResultSummary/t:Counters/@executed"/>
            <xsl:with-param name="countersPassed" select="/t:TestRun/t:ResultSummary/t:Counters/@passed"/>
            <xsl:with-param name="countersFailed" select="/t:TestRun/t:ResultSummary/t:Counters/@failed"/>
          </xsl:call-template>

          <div class="summaryWrapper">
            <div>
              <table class="info">
                <caption>Summary</caption>
                <thead>
                  <tr>
                    <th>Pie View</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>
                      <div id="summaryGraph"></div>
                    </td>
                  </tr>
                  <tr>
                    <td class="centered">
                      <a href="#" id="downloadButton" download="{/t:TestRun/@name}StatusesPie.png">Save graph</a>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div>
              <table class="info">
                <caption>Statuses</caption>
                <tbody>
                  <tr>
                    <th>Total</th>
                    <td class="centered">
                      <xsl:value-of select="/t:TestRun/t:ResultSummary/t:Counters/@total" />
                    </td>
                  </tr>
                  <tr>
                    <th>Executed</th>
                    <td class="centered">
                      <xsl:value-of select="/t:TestRun/t:ResultSummary/t:Counters/@executed" />
                    </td>
                  </tr>
                  <tr>
                    <th>Passed</th>
                    <td class="centered">
                      <xsl:value-of select="/t:TestRun/t:ResultSummary/t:Counters/@passed" />
                    </td>
                  </tr>
                  <tr>
                    <th>Failed</th>
                    <td class="centered">
                      <xsl:value-of select="/t:TestRun/t:ResultSummary/t:Counters/@failed" />
                    </td>
                  </tr>
                  <tr>
                    <th>Inconclusive</th>
                    <td class="centered">
                      <xsl:value-of select="/t:TestRun/t:ResultSummary/t:Counters/@inconclusive" />
                    </td>
                  </tr>
                  <tr>
                    <th>Error</th>
                    <td class="centered">
                      <xsl:value-of select="/t:TestRun/t:ResultSummary/t:Counters/@error" />
                    </td>
                  </tr>
                  <tr>
                    <th>Warning</th>
                    <td class="centered">
                      <xsl:value-of select="/t:TestRun/t:ResultSummary/t:Counters/@warning" />
                    </td>
                  </tr>
                  <tr>
                    <th>Timeout</th>
                    <td class="centered">
                      <xsl:value-of select="/t:TestRun/t:ResultSummary/t:Counters/@timeout" />
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div>
              <table class="info">
                <caption>Runtime/Context</caption>
                <tbody>
                  <xsl:for-each select="/t:TestRun/t:Times">
                    <tr>
                      <th>Start Time</th>
                      <td class="nowrap">
                        <xsl:value-of select="pens:GetShortDateTime(@start)" />
                      </td>
                    </tr>
                    <tr>
                      <th>End Time</th>
                      <td class="nowrap">
                        <xsl:value-of select="pens:GetShortDateTime(@finish)" />
                      </td>
                    </tr>
                    <tr>
                      <th>Duration</th>
                      <td class="nowrap">
                        <xsl:value-of select="pens:ToExactTimeDefinition(@start,@finish)"/>
                      </td>
                    </tr>
                  </xsl:for-each>
                  <!--tr>
                    <th>User</th>
                    <td class="nowrap">
                      <xsl:value-of select="/t:TestRun/@runUser" />
                    </td>
                  </tr-->
                  <tr>
                    <th>Machine</th>
                    <td class="nowrap">
                      <xsl:value-of select="//t:UnitTestResult/@computerName" />
                    </td>
                  </tr>
                  <tr>
                    <th>Build</th>
                    <td class="nowrap">
                      <xsl:value-of select="pens:GetBuildName($storage)" disable-output-escaping="yes" />
                    </td>
                  </tr>
                  <tr>
                    <th>Branch</th>
                    <td class="nowrap">
                      <xsl:value-of select="pens:GetBranchName()" />
                    </td>
                  </tr>
                  <tr>
                    <th>Description</th>
                    <td class="nowrap">
                      <xsl:value-of select="/t:TestRun/t:TestRunConfiguration/t:Description"/>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- Details - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

          <xsl:variable name="features" select="//t:TestMethod[generate-id(.)=generate-id(key('TestMethods', @className))]" />
          <xsl:variable name="featureCount" select="count($features)" />

          <table id="ReportsTable" class="info section">
            <caption>
              All Scenarios By Feature (<xsl:value-of select="$featureCount" />)
            </caption>
            <thead>
              <tr>
                <th class="section">Status</th>
                <th class="section left">
                  <div style="float:left">Feature</div>
                  <div class="toggler" id="toggler" onclick="ToggleAll('TestsContainer','toggler','Expand','Collapse');">
                    Collapse
                  </div>
                </th>
              </tr>
            </thead>
            <tbody>
              <xsl:for-each select="$features">
                <xsl:sort select="@className" order="ascending"/>
                <xsl:variable name="featureClass" select="@className" />
                <xsl:variable name="scenarios" select="key('TestMethods', @className)" />
                <xsl:variable name="scenarioCount" select="count($scenarios)" />

                <xsl:variable name="methods" select="//t:TestMethod[@className=$featureClass]/@name" />
                <xsl:variable name="passed" select="count(/t:TestRun/t:Results/t:UnitTestResult[@testName=$methods and @outcome='Passed'])" />
                <xsl:variable name="skipped" select="count(/t:TestRun/t:Results/t:UnitTestResult[@testName=$methods and @outcome='NotExecuted'])" />

                <!-- Scenario header -->

                <tr>
                  <td class="statusGraph">
                    <canvas id="{generate-id(@className)}canvas" width="100" height="25">
                    </canvas>
                  </td>
                  <td class="scenario" style="text-align:left">
                    <xsl:value-of select="pens:GetFeatureName(@className)" />
                    <xsl:call-template name="BuildCounts">
                      <xsl:with-param name="total" select="$scenarioCount" />
                      <xsl:with-param name="passed" select="$passed" />
                      <xsl:with-param name="skipped" select="$skipped" />
                    </xsl:call-template>
                  </td>
                </tr>
                <tr id="{generate-id(@className)}TestsContainer" class="visibleRow">
                  <td colspan="2">
                    <div class="dropArrow">&#8627;</div>
                    <table class="info">
                      <thead>
                        <tr>
                          <th style="width:80px;">
                            <div style="width:80px;min-width:80px;display:block;">Status</div>
                          </th>
                          <th style="text-align:left">
                            Scenario (<xsl:value-of select="$scenarioCount" />)
                          </th>
                          <th style="width:100px;">
                            <div style="width:100px;min-width:100px;">Duration</div>
                          </th>
                        </tr>
                      </thead>
                      <tbody>
                        <xsl:for-each select="$scenarios">
                          <xsl:sort select="./../@name" order="ascending"/>
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

          <table class="info section">
            <caption>Five slowest scenarios</caption>
            <thead>
              <tr>
                <th class="section">Status</th>
                <th class="section left">Scenario</th>
                <th class="section">Duration</th>
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
                    <td>
                      <xsl:value-of select="pens:GetFeatureName(/t:TestRun/t:TestDefinitions/t:UnitTest[@id=$testId]/t:TestMethod/@className)"/>.<xsl:value-of select="@testName"/>
                    </td>
                    <td class="nowrap">
                      <xsl:value-of select="pens:ToExactTimeDefinition(@duration)"/>
                    </td>
                  </tr>
                </xsl:if>
              </xsl:for-each>
            </tbody>
          </table>

          <footer>
            &#169; <xsl:value-of select="pens:GetYear()"/>, Internal Use Only
          </footer>
        </div>

        <div id="pictureBox" class="pictureBox" onclick="ClosePictureBox()">
          <img id="pictureBoxImg" />
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
    <xsl:param name="subtitle" />
    <xsl:param name="countersExecuted" />
    <xsl:param name="countersPassed" />
    <xsl:param name="countersFailed" />
    <xsl:variable name="status">
      <xsl:choose>
        <xsl:when test="$countersFailed != 0">failed</xsl:when>
        <xsl:when test="($countersPassed + $countersFailed) &lt; $countersExecuted">completed</xsl:when>
        <xsl:otherwise>passed</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div class="titleBar {$status}">
      <div>
        <xsl:value-of select="$title"/>
        <br />
        <span class="subtitle">
          <xsl:value-of select="$subtitle"/>
        </span>
      </div>
    </div>
  </xsl:template>

  <!-- BuildScenarioRow ======================================================================= -->

  <xsl:template name="BuildScenarioRow">
    <xsl:param name="scenarioId" />
    <xsl:for-each select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$scenarioId]">
      <!-- "feature" class used by JavaScript to build graphs -->
      <tr class="feature">
        <xsl:call-template name="BuildStatusColumn">
          <xsl:with-param name="outcome" select="@outcome" />
        </xsl:call-template>
        <td class="left">
          <span class="featureHead" onclick="ToggleOutput(this, '{$scenarioId}Details')">
            <span class="twister">&#11208;</span>
            <xsl:value-of select="@testName" />
          </span>
        </td>
        <td class="nowrap">
          <xsl:value-of select="pens:ToExactTimeDefinition(@duration)" />
        </td>
      </tr>
      <tr id="{$scenarioId}Details" class="messages hiddenRow">
        <td>
          <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text>
        </td>
        <td class="Test messages" colspan="2">
          <xsl:call-template name="BuildOutput">
            <xsl:with-param name="testId" select="$scenarioId" />
          </xsl:call-template>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="BuildCounts">
    <xsl:param name="total" />
    <xsl:param name="passed" />
    <xsl:param name="skipped" />
    <xsl:choose>
      <!--xsl:when test="$passed=$total">
        <div class="counts passed">
          <xsl:value-of select="$passed" /> of <xsl:value-of select="$total"/> passed
        </div>
      </xsl:when-->
      <xsl:when test="$passed=$total">
        <div class="counts passed">
          <xsl:value-of select="$passed" /> of <xsl:value-of select="$total"/> passed
        </div>
      </xsl:when>
      <xsl:when test="$passed+$skipped=$total">
        <div class="counts passed">
          <xsl:value-of select="$passed" /> of <xsl:value-of select="$total"/> passed, <xsl:value-of select="$skipped" /> skipped
        </div>
      </xsl:when>
      <xsl:when test="$skipped>0">
        <div class="counts failed">
          <xsl:value-of select="$passed" /> of <xsl:value-of select="$total"/> passed, <xsl:value-of select="$skipped" /> skipped
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="counts failed">
          <xsl:value-of select="$passed" /> of <xsl:value-of select="$total"/> passed<xsl:if test="$skipped>0">
            , <xsl:value-of select="$skipped" /> skipped
          </xsl:if>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- BuildStatusColumn ====================================================================== -->

  <xsl:template name="BuildStatusColumn">
    <xsl:param name="outcome" />
    <xsl:choose>
      <xsl:when test="$outcome='Passed'">
        <td class="passed centered">
          PASSED
        </td>
      </xsl:when>
      <xsl:when test="$outcome='Failed'">
        <td class="failed centered">
          FAILED
        </td>
      </xsl:when>
      <xsl:when test="$outcome='Inconclusive'">
        <td class="warn centered">
          INCONCLUSIVE
        </td>
      </xsl:when>
      <xsl:when test="$outcome='Timeout'">
        <td class="failed centered">
          TIMEOUT
        </td>
      </xsl:when>
      <xsl:when test="$outcome='Error'">
        <td class="failed centered">
          ERROR
        </td>
      </xsl:when>
      <xsl:when test="$outcome='Warn'">
        <td class="warn centered">
          WARN
        </td>
      </xsl:when>
      <xsl:when test="$outcome='NotExecuted'">
        <td class="warn centered">
          Skipped
        </td>
      </xsl:when>
      <xsl:otherwise>
        <td class="info">
          OTHER
        </td>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- BuildOutput ============================================================================ -->

  <xsl:template name="BuildOutput">
    <xsl:param name="testId" />

    <xsl:for-each select="/t:TestRun/t:Results/t:UnitTestResult[@testId=$testId]/t:Output">
      <xsl:variable name="stdOut" select="t:StdOut"/>
      <xsl:if test="$stdOut">
        <xsl:value-of select="pens:FormatOutput($stdOut)" disable-output-escaping="yes" />
        <br/>
      </xsl:if>

      <xsl:variable name="stdErr" select="t:StdErr"/>
      <xsl:if test="$stdErr">
        <xsl:value-of select="$stdErr"/>
        <br/>
      </xsl:if>

      <xsl:variable name="error" select="t:ErrorInfo/t:Message"/>
      <xsl:if test="$error">
        <div class="errorMessage">
          <xsl:value-of select="$error"/>
          <br/>
        </div>
      </xsl:if>

      <xsl:if test="$stdErr or $error">
        <xsl:variable name="trace" select="t:ErrorInfo/t:StackTrace" />
        <div class="stacktrace visibleRow" id="{generate-id($testId)}Stacktrace">
          <div class="dropArrow">&#8627;</div>
          <div class="exceptionScroller">
            <pre class="exception">
              <!-- trim off the first space char -->
              <xsl:value-of select="substring($trace,2)" />
            </pre>
          </div>
        </div>
      </xsl:if>

    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
