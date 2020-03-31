<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

    <xsl:include href="allgemeine_Werte.xsl"></xsl:include>
<!--
    Bemerkungen zum Spielfeld:
    Im Spielfeld sollten die Knöpfe:    STAND, HIT, DOUBLE, INSURANCE fixiert sein.
    Zusätzlich muss jeder Chip einmal abgebildet sein (am besten die Zeile über den Knöpfen), die dann im Backend anklickbar
    gemacht werden.
    Der Insurance knopf soll grau sein bis Insurance möglich wird. Dann soll dieser Heller und farbig werden!
-->

    </xsl:template>
    <xsl:template match="/chip">
        <!-- Der Trafo code -->


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
                <text id="chip-value-1" font-size="11.5" fill="black">1</text>
            </defs>
    
            <defs>
                <text id="chip-value-5" font-size="11.5" fill="black">5</text>
            </defs>
    
            <defs>
                <text id="chip-value-25" font-size="11.5" fill="black">25</text>
            </defs>
    
            <defs>
                <text id="chip-value-100" font-size="11.5" fill="black">100</text>
            </defs>
    
            <defs>
                <text id="chip-value-500" font-size="11.5" fill="black">500</text>
            </defs>
    
            <defs>
                <text id="chip-value-1000" font-size="11.5" fill="black">1000</text>
            </defs>
    
            <!-- coins with value defines a chip -->
    
            <defs>
                <g id="chip-1">
                    <use xlink:href="#default-chip" />
                    <use xlink:href="#chip-value-1" x="-2" y="5" />
                </g>
            </defs>
    
            <defs>
                <g id="chip-5">
                    <use xlink:href="#default-chip" />
                    <use xlink:href="#chip-value-5" x="-5" y="5" />
                </g>
            </defs>
    
            <defs>
                <g id="chip-25">
                    <use xlink:href="#default-chip" />
                    <use xlink:href="#chip-value-25" x="-5" y="5" />
                </g>
            </defs>
    
            <defs>
                <g id="chip-100">
                    <use xlink:href="#default-chip" />
                    <use xlink:href="#chip-value-100" x="-8.5" y="5" />
                </g>
            </defs>
    
            <defs>
                <g id="chip-500">
                    <use xlink:href="#default-chip" />
                    <use xlink:href="#chip-value-500" x="-8.5" y="5" />
                </g>
            </defs>
    
            <defs>
                <g id="chip-1000">
                    <use xlink:href="#default-chip" />
                    <use xlink:href="#chip-value-1000" x="-8.5" y="5" />
                </g>
            </defs>
        </svg>
    </xsl:template>
</xsl:stylesheet>

####################

<defs>
<g id="avatar">
    <ellipse cx="25" cy="30" rx="25" ry="30" fill="none" stroke="black" stroke-width="6"></ellipse>
    <path d="M-30,120 c0,-75 110,-75 110,0" fill="none" stroke="black" stroke-width="6"/>
</g>

<g id="avatar_active">
    <ellipse cx="25" cy="30" rx="25" ry="30" fill="green" stroke="black" stroke-width="6"></ellipse>
    <path d="M-30,120 c0,-75 110,-75 110,0" fill="green" stroke="black" stroke-width="6"/>
</g>

<g id="chip-coin">
    <circle r="15" stroke="black" stroke-width="3" fill="gold" />
</g>

<text id="chip-value-2" font-size="11.5" fill="black">2</text>
<text id="chip-value-5" font-size="11.5" fill="black">5</text>
<text id="chip-value-10" font-size="11.5" fill="black">10</text>
<text id="chip-value-20" font-size="11.5" fill="black">20</text>

<g id="chip-2">
    <use xlink:href="#chip-coin" />
    <use xlink:href="#chip-value-2" x="-2" y="5" />
</g>
<g id="chip-5">
    <use xlink:href="#chip-coin" />
    <use xlink:href="#chip-value-5" x="-2" y="5" />
</g>
<g id="chip-10">
    <use xlink:href="#chip-coin" />
    <use xlink:href="#chip-value-10" x="-2" y="5" />
</g>
<g id="chip-20">
    <use xlink:href="#chip-coin" />
    <use xlink:href="#chip-value-20" x="-2" y="5" />
</g>
<g id="chipP1">
    <use xlink:href="#chip-coin" x="{$xCoin1}" y="{$yCoin1}" />
    <text x="{$xCoin1}" y="{$yCoin1}"  fill="black" text-anchor="middle" dominant-baseline="central"  >
        <xsl:value-of select="$player1/bet"/>
    </text>
</g>
<g id="chipP2">
    <use xlink:href="#chip-coin" x="{$xCoin2}" y="{$yCoin2}" />
    <text x="{$xCoin2}" y="{$yCoin2}" fill="black" text-anchor="middle" dominant-baseline="central" >
        <xsl:value-of select="$player2/bet"/>
    </text>
</g>
<g id="chipP3">
    <use xlink:href="#chip-coin" x="{$xCoin3}" y="{$yCoin3}" />
    <text x="{$xCoin3}" y="{$yCoin3}" fill="black" text-anchor="middle" dominant-baseline="central">
        <xsl:value-of select="$player3/bet"/>
    </text>
</g>
<g id="chipP4">
    <use xlink:href="#chip-coin" x="{$xCoin4}" y="{$yCoin4}" />
    <text x="{$xCoin4}" y="{$yCoin4}" fill="black" text-anchor="middle" dominant-baseline="central" >
        <xsl:value-of select="$player4/bet"/>
    </text>
</g>
<g id="chipP5">
    <use xlink:href="#chip-coin" x="{$xCoin5}" y="{$yCoin5}" />
    <text x="{$xCoin5}" y="{$yCoin5}" fill="black" text-anchor="middle" dominant-baseline="central" >
        <xsl:value-of select="$player5/bet"/>
    </text>
</g>

<g id="chipInsuranceP1">
    <use xlink:href="#chip-coin" x="710" y="366" />
    <text x="710" y="366"  fill="black" text-anchor="middle" dominant-baseline="central"  >
        <xsl:value-of select="$player1/insurance"/>
    </text>
</g>
<g id="chipInsuranceP2">
    <use xlink:href="#chip-coin" x="668" y="379" />
    <text x="668" y="379" fill="black" text-anchor="middle" dominant-baseline="central" >
        <xsl:value-of select="$player2/insurance"/>
    </text>
</g>
<g id="chipInsuranceP3">
    <use xlink:href="#chip-coin" x="612" y="388" />
    <text x="612" y="388" fill="black" text-anchor="middle" dominant-baseline="central">
        <xsl:value-of select="$player3/insurance"/>
    </text>
</g>
<g id="chipInsuranceP4">
    <use xlink:href="#chip-coin" x="554" y="383" />
    <text x="554" y="383" fill="black" text-anchor="middle" dominant-baseline="central" >
        <xsl:value-of select="$player4/insurance"/>
    </text>
</g>
<g id="chipInsuranceP5">
    <use xlink:href="#chip-coin" x="500" y="366" />
    <text x="500" y="366" fill="black" text-anchor="middle" dominant-baseline="central" >
        <xsl:value-of select="$player5/insurance"/>
    </text>
</g>
</defs>



<xsl:choose>
<xsl:when test="$player1/bet>0">
    <use  xlink:href="#chipP1" />

</xsl:when>
</xsl:choose>
<xsl:choose>
<xsl:when test="$player2/bet>0">
    <use  xlink:href="#chipP2" />

</xsl:when>
</xsl:choose>
<xsl:choose>
<xsl:when test="$player3/bet>0">
    <use  xlink:href="#chipP3" />

</xsl:when>
</xsl:choose>
<xsl:choose>
<xsl:when test="$player4/bet>0">
    <use  xlink:href="#chipP4" />

</xsl:when>
</xsl:choose>
<xsl:choose>
<xsl:when test="$player5/bet>0">
    <use  xlink:href="#chipP5" />

</xsl:when>
</xsl:choose>
