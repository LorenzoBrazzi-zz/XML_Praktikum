<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

    <!-- Werte -->
    <xsl:variable name="buttonTextSize" select="30" />
    <!-- Farben -->
    <xsl:variable name="farbeTisch" select="'#097111'" />
    <xsl:variable name="farbeTischRand" select="'#54391A'" />
    <xsl:variable name="farbeSpielernamen" select="'#A8A7A7'" />
    <xsl:variable name="farbeButton1" select="'#E0282F'" />
    <xsl:variable name="farbeButton2" select="'#0065FF'" />
    <xsl:variable name="farbeButton3" select="'#A12CFF'" />
    <xsl:variable name="farbeButton4" select="'#FFEC00'" />


    <!-- Spieler -->
    <xsl:variable name="radiusPlayer" select="75" />
    <xsl:variable name="player1x" select="150" />
    <xsl:variable name="player1y" select="350" />
    <xsl:variable name="player2x" select="425" />
    <xsl:variable name="player2y" select="600" />
    <xsl:variable name="player3x" select="800" />
    <xsl:variable name="player3y" select="750" />
    <xsl:variable name="player4x" select="1175" />
    <xsl:variable name="player4y" select="600" />
    <xsl:variable name="player5x" select="1450" />
    <xsl:variable name="player5y" select="350" />


    <!-- Karten Positionen -->
    <xsl:variable name="cardDealerx" select="550" />
    <xsl:variable name="cardDealery" select="50" />
    <xsl:variable name="cardAbstand" select="25" />

    <xsl:variable name="cardPlayer1x" select="$player1x - $radiusPlayer" />
    <xsl:variable name="cardPlayer1y" select="$player1y - $radiusPlayer" />
    <xsl:variable name="cardPlayer2x" select="$player2x - $radiusPlayer" />
    <xsl:variable name="cardPlayer2y" select="$player2y - $radiusPlayer" />
    <xsl:variable name="cardPlayer3x" select="$player3x - $radiusPlayer" />
    <xsl:variable name="cardPlayer3y" select="$player3y - $radiusPlayer" />
    <xsl:variable name="cardPlayer4x" select="$player4x - $radiusPlayer" />
    <xsl:variable name="cardPlayer4y" select="$player4y - $radiusPlayer" />
    <xsl:variable name="cardPlayer5x" select="$player5x - $radiusPlayer" />
    <xsl:variable name="cardPlayer5y" select="$player5y - $radiusPlayer" />

    <!-- Buttons -->
    <xsl:variable name="radiusButtons" select="50" />
    <xsl:variable name="abstandButtons" select="5" />
    <xsl:variable name="halbRadiusButton" select="$radiusButtons div 2" />

    <xsl:variable name="button1x" select="50"/>
    <xsl:variable name="button2x" select="$button1x + $radiusButtons + $radiusButtons + $abstandButtons"/>
    <xsl:variable name="button3x" select="$button2x + $radiusButtons + $radiusButtons + $abstandButtons"/>
    <xsl:variable name="button4x" select="$button3x + $radiusButtons + $radiusButtons + $abstandButtons"/>


    <xsl:variable name="buttonsy" select="50" />



</xsl:stylesheet>