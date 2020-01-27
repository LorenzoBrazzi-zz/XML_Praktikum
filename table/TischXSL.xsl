<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">
    <xsl:variable name="nummer5" select="number(50)"/>

    <xsl:template match="/">
        <svg width="100%" height="100%" version="1.1" viewBox="0 0 1600 900"
             xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
            <!-- allgemeine Variabeln einfügen -->
            <xsl:include href="allgemeine_Werte.xsl" />
            <!-- Hintergrund -->
            <rect id="hintergrund" fill="brown" width="100%" height="100%" />


            <!-- Tischform -->
            <circle cx="800" cy="0" r="900" fill="green" />
            <circle cx="800" cy="0" r="900" style="fill:none;stroke:#54391A;stroke-width:50"/>


            <!-- Dealer Platz -->
            <rect x="550" y="50" rx="20" ry="20" width="450" height="150" style="fill:none;stroke:#fff;stroke-width:4"/>

            <!-- Karten- und Einsatzpositionen-->
            <circle cx="150" cy="350" r="75" style="fill:none;stroke:white;stroke-width:4"/>
            <circle cx="425" cy="600" r="75" style="fill:none;stroke:white;stroke-width:4"/>
            <circle cx="800" cy="750" r="75" style="fill:none;stroke:white;stroke-width:4"/>
            <circle cx="1175" cy="600" r="75" style="fill:none;stroke:white;stroke-width:4"/>
            <circle cx="1450" cy="350" r="75" style="fill:none;stroke:white;stroke-width:4"/>

            <!--Spielernamen-->

            <!-- Tischtexte -->
            <text x="600" y="300" font-family="Algerian" font-size="30" fill="black">
                BLACKJACK PAYS 3 TO 2
            </text>
            <text x="700" y="350" font-family="Arial" font-size="15" fill="black">
                Insurance Pays 2 to 1
            </text>

            <!-- UI-->
            <circle cx="{$nummer5}" cy="50" r="50" fill="red"/>
            <circle cx="155" cy="50" r="50" fill="blue"/>
            <circle cx="255" cy="50" r="50" fill="purple"/>

        </svg>
    </xsl:template>

</xsl:stylesheet>