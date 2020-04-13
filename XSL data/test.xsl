<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="/">
        <html>
            <head>
                <title>TEST</title>
            </head>
            <body>
                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="game">
    <svg>
        <xsl:for-each select="card">
            <xsl:variable name="Color" select="color"/>
            <xsl:variable name="value" select="value"/>
            <xsl:variable name="counter" select="position()-1"/>
            <rect height="100" width="100" rx="5" ry="5" x = "{0 + 125*$counter}" y = "0"
                  style="fill:white;stroke:black;stroke-width:2;opacity:1.0"/>

            <xsl:value-of select="$counter"/>
        </xsl:for-each>

    </svg>
    </xsl:template>

</xsl:stylesheet>