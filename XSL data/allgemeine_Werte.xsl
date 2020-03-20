<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

    <!-- Werte -->
    <xsl:variable name="buttonTextSize" select="20" />
    <xsl:variable name="chipsTextSize" select="40" />

    <!-- Farben -->
    <xsl:variable name="farbeTisch" select="'#097111'" />
    <xsl:variable name="farbeTischRand" select="'#54391A'" />
    <xsl:variable name="farbeSpielernamen" select="'#A8A7A7'" />
    <xsl:variable name="farbeButton1" select="'#E0282F'" />
    <xsl:variable name="farbeButton2" select="'#0065FF'" />
    <xsl:variable name="farbeButton3" select="'#A12CFF'" />
    <xsl:variable name="farbeButton4" select="'#FFEC00'" />
    <xsl:variable name="farbeInaktiv" select="'#62696D'" />


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

    <!-- zur Anpassung der Kartenpostionen: Abstände aller Spieler in Abhänigkeit von Spieler 1-->

<xsl:variable name="player1zu2x"/>

    <!-- Spielernamen -->
    <xsl:variable name="spielerNamenTextSize" select="15" />
    <xsl:variable name="zeilenAbstand" select="$spielerNamenTextSize + 5" />


    <!-- Karten Positionen -->
    <xsl:variable name="cardDealerx" select="550" />
    <xsl:variable name="cardDealery" select="50" />
    <xsl:variable name="cardAbstand" select="20" />

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

    <!-- Aktuelle Karte -->
    <xsl:variable name="cardWidth" select="100"/>
    <xsl:variable name="cardHeight" select="($cardWidth * 1.5)"/>
    <xsl:variable name="karteX" select="0"/>
    <xsl:variable name="karteY" select="0"/>
    <!-- <xsl:variable name="jetztX" select="$karteX +50"/>
    <xsl:variable name="jetztY" select="$karteY +35"/> -->
    <xsl:variable name="jetztX" select="$karteX +($cardWidth div 2)"/>
    <xsl:variable name="jetztY" select="$karteY +($cardHeight div 4.25)"/>
    <!--<xsl:variable name="valueXMini" select="$karteX +10"/>
    <xsl:variable name="valueYMini" select="$karteY +20"/> -->
    <xsl:variable name="valueXMini" select="$karteX + ($cardWidth div 10)"/>
    <xsl:variable name="valueYMini" select="$karteY +($cardHeight div 7.5)"/>
    <!--<xsl:variable name="symbolXMini" select="$karteX +10"/>
    <xsl:variable name="symbolYMini" select="$karteY +33"/> -->
    <xsl:variable name="symbolXMini" select="$karteX +($cardWidth div 10)"/>
    <xsl:variable name="symbolYMini" select="$karteY +($cardHeight div 4.5)"/>
    <xsl:variable name="sizeBigSymbol" select="($cardWidth * 0.4)"/>
    <xsl:variable name="sizeSmallSymbol" select="($cardWidth * 0.15)"/>
    <xsl:variable name="sizeValue" select="($cardWidth * 0.15)"/>
    <xsl:variable name="sizeAceSymbol" select="($cardWidth * 1.3)"/>
    <xsl:variable name="yAceSymbol" select="$karteY +($cardHeight div 1.33)"/>

    <xsl:variable name="xCardMid" select="$karteX +($cardWidth div 2)"/>
    <xsl:variable name="yCardMid" select="$karteY +($cardHeight div 2)"/>
    <xsl:variable name="yBigSymbolTop" select="$karteY +($cardHeight div 4.25)"/>
    <xsl:variable name="yBigSymbolTopToMid" select="($cardHeight div 3)"/>
    <xsl:variable name="xBigSymbolMidToEdge" select="($cardWidth div 5)"/>
    <xsl:variable name="yBigSymbolTenMid" select="($cardHeight div 7.55)"/>
    <xsl:variable name="yBigSymbolNineSide" select="($cardHeight div 4.5)"/>
    <xsl:variable name="yBigSymbolUsdBotAdd" select="($cardHeight div 3.75)"/>
    <xsl:variable name="xMiniAdd" select="($cardWidth div 2.5)"/>
    <xsl:variable name="yMiniSymbolAddUsd" select="($cardHeight div 3.55)"/>
    <xsl:variable name="yMiniValueAddUsd" select="($cardHeight div 2.75)"/>

    <!--  <xsl:variable name="sizeBigSymbol" select="80"/>
    <xsl:variable name="sizeSmallSymbol" select="30"/>
    <xsl:variable name="sizeValue" select="30"/> -->





    <!-- Buttons -->
    <xsl:variable name="radiusButtons" select="50" />
    <xsl:variable name="abstandButtons" select="5" />
    <xsl:variable name="halbRadiusButton" select="$radiusButtons div 2" />

    <xsl:variable name="button1x" select="50"/>
    <xsl:variable name="button2x" select="$button1x + $radiusButtons + $radiusButtons + $abstandButtons"/>
    <xsl:variable name="button3x" select="$button2x + $radiusButtons + $radiusButtons + $abstandButtons"/>
    <xsl:variable name="button4x" select="$button3x + $radiusButtons + $radiusButtons + $abstandButtons"/>

    <xsl:variable name="buttonsy" select="50" />


    <!-- Chips -->
    <xsl:variable name="radiusChips" select="50" />
    <xsl:variable name="abstandChips" select="5" />
    <xsl:variable name="halbRadiusChip" select="$radiusChips div 2" />

    <xsl:variable name="chip1x" select="1200"/>
    <xsl:variable name="chip2x" select="$chip1x + $radiusChips + $radiusChips + $abstandChips"/>
    <xsl:variable name="chip3x" select="$chip2x + $radiusChips + $radiusChips + $abstandChips"/>
    <xsl:variable name="chip4x" select="$chip3x + $radiusChips + $radiusChips + $abstandChips"/>

    <xsl:variable name="chipsy" select="50" />






</xsl:stylesheet>