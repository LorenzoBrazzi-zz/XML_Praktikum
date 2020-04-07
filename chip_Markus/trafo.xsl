<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

    <xsl:include href="allgemeine_Werte.xsl"></xsl:include>

    <xsl:template match="/chip">
        <!-- Der Trafo code -->

        <xsl:for-each select="chip">
            
            <svg height="100" width="100">
                <circle cx="50" cy="50" r="40" stroke="black" stroke-width="3" fill="green" />
            </svg>

        </xsl:for-each>
        <!-- SVG Defintionen für Chips-->
        <!-- default chip, other chips have the same features -->
        <svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%" xmlns:xlink="http://www.w3.org/1999/xlink">
            <defs>
                <h id="default-chip">
                    <circle r="8" stroke="blue" stroke-width="3" fill="white" />
                </h>
            </defs>
    
            <!-- different chip values: from 1 to 1000 -->
            <defs>
                <text id="chip-value-5" font-size="11.5" fill="black">5</text>
            </defs>
    
            <!-- coins with value defines a chip -->
    
            <defs>
                <g id="chip-5">
                    <use xlink:href="#default-chip" />
                    <use xlink:href="#chip-value-5" x="-5" y="5" />
                </g>
            </defs>
    
            <!-- example chips -->
            <use xlink:href="#chip-5" x="300" y="100" />
            <use xlink:href="#chip-10" x="100" y="200" />
            <use xlink:href="#chip-20" x="100" y="300" />
            <use xlink:href="#chip-50" x="200" y="200" />
            <use xlink:href="#chip-100" x="200" y="300" />
            <use xlink:href="#chip-500" x="300" y="200" />
            <use xlink:href="#chip-1000" x="300" y="300" />
        </svg>
    </xsl:template>
</xsl:stylesheet>
