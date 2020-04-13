<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

    <!-- Values -->
    <xsl:variable name="buttonTextSize" select="20" />
    <xsl:variable name="chipsTextSize" select="40" />

    <!-- Colors -->
    <xsl:variable name="tableColor" select="'#097111'" />
    <xsl:variable name="tableColorEdge" select="'#54391A'" />


    <!-- Players -->
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


    <!-- Player names -->
    <xsl:variable name="playerNameTextSize" select="15" />
    <xsl:variable name="lineSpacing" select="$playerNameTextSize + 15" />

    <!-- Current bet -->
    <xsl:variable name="radiusDummyChips" select="$radiusPlayer div 2"/>

    <xsl:variable name="p1CurrentBetX" select="$player1x +($radiusPlayer * 2)"/>
    <xsl:variable name="p2CurrentBetX" select="$player2x +($radiusPlayer)"/>
    <xsl:variable name="p3CurrentBetX" select="$player3x + 0"/>
    <xsl:variable name="p4CurrentBetX" select="$player4x - ($radiusPlayer)"/>
    <xsl:variable name="p5CurrentBetX" select="$player5x -($radiusPlayer * 2)"/>

    <xsl:variable name="p1CurrentBetY" select="$player1y - $radiusPlayer"/>
    <xsl:variable name="p2CurrentBetY" select="$player2y - $cardHeight"/>
    <xsl:variable name="p3CurrentBetY" select="$player3y - $cardHeight -$lineSpacing*2"/>
    <xsl:variable name="p4CurrentBetY" select="$player4y - $cardHeight"/>
    <xsl:variable name="p5CurrentBetY" select="$player5y - $radiusPlayer"/>

    <!-- card positions -->
    <xsl:variable name="cardDealerX" select="550" />
    <xsl:variable name="cardDealerY" select="50" />
    <xsl:variable name="cardSpacing" select="20" />

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

    <!-- current card -->
    <xsl:variable name="cardWidth" select="100"/>
    <xsl:variable name="cardHeight" select="($cardWidth * 1.5)"/>
    <xsl:variable name="cardX" select="0"/>
    <xsl:variable name="cardY" select="0"/>

    <xsl:variable name="symbolRotationX" select="($cardWidth div 2)"/>
    <xsl:variable name="symbolRotationY" select="($cardHeight div 4.25)"/>

    <xsl:variable name="valueXMini" select="($cardWidth div 10)"/>
    <xsl:variable name="valueYMini" select="($cardHeight div 7.5)"/>

    <xsl:variable name="symbolXMini" select="($cardWidth div 10)"/>
    <xsl:variable name="symbolYMini" select="($cardHeight div 4.5)"/>
    <xsl:variable name="sizeBigSymbol" select="($cardWidth * 0.4)"/>
    <xsl:variable name="sizeSmallSymbol" select="($cardWidth * 0.15)"/>
    <xsl:variable name="sizeValue" select="($cardWidth * 0.15)"/>
    <xsl:variable name="sizeAceSymbol" select="($cardWidth * 1.3)"/>
    <xsl:variable name="yAceSymbol" select="($cardHeight div 1.33)"/>

    <xsl:variable name="xCardMid" select="($cardWidth div 2)"/>
    <xsl:variable name="yCardMid" select="($cardHeight div 2)"/>
    <xsl:variable name="yBigSymbolTop" select="($cardHeight div 4.25)"/>
    <xsl:variable name="yBigSymbolTopToMid" select="($cardHeight div 3)"/>
    <xsl:variable name="xBigSymbolMidToEdge" select="($cardWidth div 5)"/>
    <xsl:variable name="yBigSymbolTenMid" select="($cardHeight div 7.55)"/>
    <xsl:variable name="yBigSymbolNineSide" select="($cardHeight div 4.5)"/>
    <xsl:variable name="yBigSymbolUsdBotAdd" select="($cardHeight div 3.75)"/>
    <xsl:variable name="xMiniAdd" select="($cardWidth div 2.5)"/>
    <xsl:variable name="yMiniSymbolAddUsd" select="($cardHeight div 3.55)"/>
    <xsl:variable name="yMiniValueAddUsd" select="($cardHeight div 2.75)"/>




    <!-- Buttons -->
    <xsl:variable name="radiusButtons" select="50" />
    <xsl:variable name="buttonSpacing" select="5" />

    <xsl:variable name="button1x" select="50"/>
    <xsl:variable name="button2x" select="$button1x + $radiusButtons + $radiusButtons + $buttonSpacing"/>
    <xsl:variable name="button3x" select="$button2x + $radiusButtons + $radiusButtons + $buttonSpacing"/>
    <xsl:variable name="button4x" select="$button3x + $radiusButtons + $radiusButtons + $buttonSpacing"/>

    <xsl:variable name="buttonsY" select="50" />

    <xsl:variable name="testButton1x" select="-65"/>
    <xsl:variable name="testButton1y" select="750"/>
    <xsl:variable name="testButton2x" select="250"/>
    <xsl:variable name="testButton2y" select="200"/>


</xsl:stylesheet>