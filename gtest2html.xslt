<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE xsl:stylesheet[
  <!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="JOB_NAME" />
	<xsl:param name="BUILD_NUMBER" />
	<xsl:output method="html" version="4.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<html>
		<head>
			<title>General Test Report: <xsl:value-of select="$JOB_NAME"/></title>
			<style type="text/css">
				td#passed {
					color: green;
					font-weight: bold;
				}
				td#failed {
					color: red;
					font-weight: bold;
				}
				td#skipped {
					color: orange;
					font-weight: bold;
				}
				td#failmessage {
					color: red;
				}
				td#skipmessage {
				color: orange;
				}
				b#passrate {
					color: green;
				}
				b#lowrisk {
					color: orange;
				}
				b#critical {
					color: red;
				}
				body {
					width: 80%;
					margin: 40px auto;
					font-family: 'trebuchet MS', 'Lucida sans', Arial;
					font-size: 14px;
					color: #444;
				}
				table {
					*border-collapse: collapse; /* IE7 and lower */
					border-spacing: 0;
					width: 100%;
				}
				.bordered {
					border: solid #ccc 1px;
					-moz-border-radius: 6px;
					-webkit-border-radius: 6px;
					border-radius: 6px;
					-webkit-box-shadow: 0 1px 1px #ccc; 
					-moz-box-shadow: 0 1px 1px #ccc; 
					box-shadow: 0 1px 1px #ccc;         
				}
				.bordered tr:hover {
					background: #fbf8e9;
					-o-transition: all 0.1s ease-in-out;
					-webkit-transition: all 0.1s ease-in-out;
					-moz-transition: all 0.1s ease-in-out;
					-ms-transition: all 0.1s ease-in-out;
					transition: all 0.1s ease-in-out;     
				}    
				.bordered td, .bordered th {
					border-left: 1px solid #ccc;
					border-top: 1px solid #ccc;
					padding: 10px;
					text-align: left;    
				}
				.bordered th {
					background-color: #dce9f9;
					background-image: -webkit-gradient(linear, left top, left bottom, from(#ebf3fc), to(#dce9f9));
					background-image: -webkit-linear-gradient(top, #ebf3fc, #dce9f9);
					background-image:    -moz-linear-gradient(top, #ebf3fc, #dce9f9);
					background-image:     -ms-linear-gradient(top, #ebf3fc, #dce9f9);
					background-image:      -o-linear-gradient(top, #ebf3fc, #dce9f9);
					background-image:         linear-gradient(top, #ebf3fc, #dce9f9);
					-webkit-box-shadow: 0 1px 0 rgba(255,255,255,.8) inset; 
					-moz-box-shadow:0 1px 0 rgba(255,255,255,.8) inset;  
					box-shadow: 0 1px 0 rgba(255,255,255,.8) inset;        
					border-top: none;
					text-shadow: 0 1px 0 rgba(255,255,255,.5); 
				}
				.bordered td:first-child, .bordered th:first-child {
					border-left: none;
					width: 60%;
				}
				.bordered th:first-child {
					-moz-border-radius: 6px 0 0 0;
					-webkit-border-radius: 6px 0 0 0;
					border-radius: 6px 0 0 0;
				}
				.bordered th:last-child {
					-moz-border-radius: 0 6px 0 0;
					-webkit-border-radius: 0 6px 0 0;
					border-radius: 0 6px 0 0;
					text-align: center;
				}
				.bordered th:only-child{
					-moz-border-radius: 6px 6px 0 0;
					-webkit-border-radius: 6px 6px 0 0;
					border-radius: 6px 6px 0 0;
				}
				.bordered tr:last-child td:first-child {
					-moz-border-radius: 0 0 0 6px;
					-webkit-border-radius: 0 0 0 6px;
					border-radius: 0 0 0 6px;	
				}
				.bordered tr:last-child td:last-child {
					-moz-border-radius: 0 0 6px 0;
					-webkit-border-radius: 0 0 6px 0;
					border-radius: 0 0 6px 0;
					width: 5%;
				}
			</style>
		</head>
		<body>
			<xsl:apply-templates/>
		</body>
		</html>
	</xsl:template>

	<xsl:template match="testsuites">
		<xsl:variable name="skipped" select="count(testsuite/testcase[@status='notrun'])"/>
		<xsl:variable name="testsuite" select="count(testsuite)"/>
		<xsl:variable name="successrate" select="format-number((@tests - ($skipped + @failures)) div @tests*100,'##0.00')"/>
		
		<h1>General Test Report: <xsl:value-of select="$JOB_NAME"/> | build&nbsp;#<xsl:value-of select="$BUILD_NUMBER"/></h1>
		<p>
			Executed <b><xsl:value-of select="@tests"/></b> test cases in
			<b><xsl:value-of select="$testsuite"/></b> test suites, 
			<b><xsl:value-of select="@failures"/></b> test cases failed,
			<b><xsl:value-of select="$skipped"/></b> test cases skipped.
			General Execution time <b><xsl:value-of select="@time"/></b>, 
			Success Rate: <xsl:choose>
				<xsl:when test="$successrate &gt; 90"><b id="passrate"><xsl:value-of select="$successrate"/>%</b>,&nbsp;General Success Status: <b id="passrate">OK</b></xsl:when>
				<xsl:when test="$successrate &gt; 70"><b id="lowrisk"><xsl:value-of select="$successrate"/>%</b>,&nbsp;General Success Status: <b id="lowrisk">Low Risk</b></xsl:when>
				<xsl:otherwise><b id="critical"><xsl:value-of select="$successrate"/>%</b>,&nbsp;General Success Status: <b id="critical">CRITICAL</b></xsl:otherwise>
			</xsl:choose>
		</p>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="testsuite">
		<h2>Test Suite: <xsl:choose><xsl:when test="@name"><xsl:value-of select="@name"/></xsl:when><xsl:otherwise><xsl:value-of select="testcase/@classname"/></xsl:otherwise></xsl:choose></h2>
		<table class="bordered">
			<tr><th style="width:30%">Test Cases (run: <xsl:value-of select="@tests"/> / skipped: <xsl:choose><xsl:when test="@disabled"><xsl:value-of select="@disabled"/></xsl:when><xsl:otherwise><xsl:value-of select="@skipped"/></xsl:otherwise></xsl:choose> / failed: <xsl:value-of select="@failures"/>) </th>
				<th>Message</th>
				<th style="width:1%">Result</th>
			</tr>
			<xsl:for-each select="testcase">
			<tr>
				<td><xsl:value-of select="@name"/></td> 
				<xsl:choose> 
				<xsl:when test="failure[@message]">
					<td id="failmessage">
					This test case has been failed. FAILURE MESSAGE:
					<br></br>
							<xsl:for-each select="failure">
										<xsl:if test="@message">
									"<xsl:value-of select="@message"/>"
								</xsl:if> 
							</xsl:for-each>
						</td>
						<td id="failed">FAIL</td>
					</xsl:when>
					<xsl:when test="@status='notrun'">
					<td id="skipmessage">This test case has been skipped</td> 
						<td id="skipped">SKIPPED</td>
					</xsl:when>
					<xsl:otherwise>
						<td>
							<xsl:for-each select="@* [name()!='classname' and name()!='name' and name()!='status' and name()!='time' and name()!='value_param']">
								<xsl:value-of select="name()"/>=<xsl:value-of select="."/><br></br>
							</xsl:for-each>
							<xsl:for-each select="*">
								<xsl:value-of select="@message"/>
							</xsl:for-each>
						</td>
						<td id="passed">PASS</td>
					</xsl:otherwise>
				</xsl:choose>
			</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
</xsl:stylesheet>
