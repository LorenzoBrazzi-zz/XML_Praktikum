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
    <!-- Jede card wird als ein Svg element ausgegeben -->
    <xsl:template match="/card">
        <xsl:variable name="Color" select="color"></xsl:variable>
        <xsl:variable name="value" select="value"></xsl:variable>
        <svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%" xmlns:xlink="http://www.w3.org/1999/xlink">
            <g alignment-baseline="baseline" />
            <rect height="350" width="250" x="45" y="10" rx="30" ry="30" style="fill:white;stroke:black;stroke-width:5;opacity:1.0" />
            <xsl:choose>

                <!-- Spezial cardn Sonderfälle-->
                <xsl:when test="$value = 'K'">
                    <xsl:choose>
                        <xsl:when test="$Color = 'Spade'">
                            <use href="#Spade-K" />
                        </xsl:when>
                        <xsl:when test="$Color = 'Heart'">
                            <use href="#Heart-K" />
                        </xsl:when>
                        <xsl:when test="$Color = 'Diamond'">
                            <use href="#Diamond-K" />
                        </xsl:when>
                        <xsl:when test="$Color = 'Club'">
                            <use href="#Club-K" />
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$value = 'Q'">
                    <xsl:choose>
                        <xsl:when test="$Color = 'Spade'">
                            <use href="#Spade-Q" />
                        </xsl:when>
                        <xsl:when test="$Color = 'Heart'">
                            <use href="#Heart-Q" />
                        </xsl:when>
                        <xsl:when test="$Color = 'Diamond'">
                            <use href="#Diamond-Q" />
                        </xsl:when>
                        <xsl:when test="$Color = 'Club'">
                            <use href="#Club-Q" />
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$value = 'B'">
                    <xsl:choose>
                        <xsl:when test="$Color = 'Spade'">
                            <use href="#Spade-B" />
                        </xsl:when>
                        <xsl:when test="$Color = 'Heart'">
                            <use href="#Heart-B" />
                        </xsl:when>
                        <xsl:when test="$Color = 'Diamond'">
                            <use href="#Diamond-B" />
                        </xsl:when>
                        <xsl:when test="$Color = 'Club'">
                            <use href="#Club-B" />
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>

                <!-- Symbole und reguläre Zahlen, die aus der XML Datei entnommen werden -->
                <xsl:when test="$Color = 'Spade'">

                    <g>

                        <text id="kar" x="57" y="70" font-size="55" fill="black">
                            <xsl:value-of select="value"></xsl:value-of>
                        </text>
                        <use xlink:href="#kar" x="200" y="290" transform="rotate(180, 268, 330)" />
                        <use xlink:href="#Spade-{$value}" />

                    </g>

                </xsl:when>
                <xsl:when test="$Color = 'Club'">
                    <g>
                        <text id="kar" x="57" y="70" font-size="55" fill="black">
                            <xsl:value-of select="value"></xsl:value-of>
                        </text>
                        <use xlink:href="#kar" x="200" y="290" transform="rotate(180, 268, 330)" />
                        <use xlink:href="#Club-{$value}" />
                    </g>
                </xsl:when>
                <xsl:when test="$Color = 'Heart'">
                    <g>
                        <text id="kar" x="57" y="70" font-size="55" fill="red">
                            <xsl:value-of select="value"></xsl:value-of>
                        </text>
                        <use xlink:href="#kar" x="200" y="290" transform="rotate(180, 268, 330)" />
                        <use xlink:href="#Heart-{$value}"/>
                    </g>
                </xsl:when>
                <xsl:when test="$Color = 'Diamond'">
                           
                            <g>
                                <text id="kar" x="57" y="70" font-size="55" fill="red">
                                    <xsl:value-of select="value"></xsl:value-of>
                                </text>
                                <use xlink:href="#kar" x="200" y="290" transform="rotate(180, 268, 330)" />
                                <use xlink:href="#Diamond-{$value}" />
                            </g>
                </xsl:when>
            </xsl:choose>


            <!-- SVG Definitionen um Redundanz zu vermeiden -->
            <defs>
                <g id="CardTemplate">
                    <rect height="350" width="250" x="45" y="10" rx="30" ry="30" style="fill:white;stroke:black;stroke-width:5;opacity:1.0" />
                </g>
            </defs>
            <defs>
                <g id="Diamond-K">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/0/06/KD.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>

            <defs>
                <g id="Diamond-Q">

                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/6/63/QD.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            <defs>
                <g id="Diamond-B">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/3/33/JD.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            <defs>
                <g id="Heart-K">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/e/e5/KH.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>

            <defs>
                <g id="Heart-Q">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/d/d2/QH.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>

            <defs>
                <g id="Heart-B">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/1/15/JH.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            <defs>
                <g id="Club-K">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/e/e1/KC.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>

            <defs>
                <g id="Club-Q">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/9/9e/QC.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>

            <defs>
                <g id="Club-B">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/1/11/JC.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            <defs>
                <g id="Spade-K">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/5/5c/KS.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>

            <defs>
                <g id="Spade-Q">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/3/35/QS.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>

            <defs>
                <g id="Spade-B">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/d/d9/JS.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>

            <!-- alle Spades -->
            <defs>
                <g id="Spade-A">
                    <text x="120" y="240" font-size="180" fill="black">♠</text>
                </g>

            </defs>
            <defs>
                <g id="Spade-2">
                    <text id="Spade_symbol" x="140" y="110" font-size="80" fill="black">♠</text>
                    <!-- Das Symbol an der Y achse spiegeln -->

                    <use xlink:href="#Spade_symbol" x="145" y="200" transform="rotate(180, 233, 290)" />
                </g>

            </defs>

            <defs>
                <g id="Spade-3">
                    <use xlink:href="#Spade-2" />
                    <text x="140" y="215" font-size="80" fill="black">♠</text>
                </g>
            </defs>

            <defs>
                <g id="Spade-4">
                    <use xlink:href="#Spade-2" transform="translate(-40, 0)" />
                    <use xlink:href="#Spade-2" transform="translate(40, 0)" />
                </g>
            </defs>

            <defs>
                <g id="Spade-5">
                    <use xlink:href="#Spade-4" />
                    <text x="140" y="215" font-size="80" fill="black">♠</text>
                </g>
            </defs>
            <defs>
                <g id="Spade-6">
                    <use xlink:href="#Spade-3" transform="translate(-40,0)" />
                    <use xlink:href="#Spade-3" transform="translate(40,0)" />
                </g>
            </defs>
            <defs>
                <g id="Spade-7">
                    <use xlink:href="#Spade-6" />
                    <text x="140" y="170" font-size="80" fill="black">♠</text>
                </g>
            </defs>
            <defs>
                <g id="Spade-8">
                    <use xlink:href="#Spade-4" />
                    <g id="Spade-Zweier">
                        <text x="100" y="173" font-size="80" fill="black">♠</text>
                        <text x="180" y="173" font-size="80" fill="black">♠</text>
                    </g>
                    <use xlink:href="#Spade-Zweier" transform="rotate(180, 161, 190)" />
                </g>
            </defs>
            <defs>
                <g id="Spade-9">
                    <use xlink:href="#Spade-8" />
                    <text x="140" y="215" font-size="80" fill="black">♠</text>
                </g>
            </defs>
            <defs>
                <g id="Spade-10">
                    <use xlink:href="#Spade-8" />
                    <text id="Spade_Einser" x="140" y="150" font-size="80" fill="black">♠</text>
                    <use xlink:href="#Spade_Einser" transform="rotate(180, 161, 190)" />
                </g>
            </defs>

            <!-- alle Clube -->
            <defs>
                <g id="Club-A">
                    <text x="110" y="240" font-size="180" fill="black">♣</text>
                </g>

            </defs>
            <defs>
                <g id="Club-2">
                    <text id="Club_symbol" x="140" y="110" font-size="80" fill="black">♣</text>
                    <!-- Das Symbol an der X-Achse spiegeln -->

                    <use xlink:href="#Club_symbol" x="135" y="200" transform="rotate(180, 233, 290)" />
                </g>

            </defs>

            <defs>
                <g id="Club-3">
                    <use xlink:href="#Club-2" />
                    <text x="135" y="215" font-size="80" fill="black">♣</text>
                </g>
            </defs>

            <defs>
                <g id="Club-4">
                    <use xlink:href="#Club-2" transform="translate(-40, 0)" />
                    <use xlink:href="#Club-2" transform="translate(40, 0)" />
                </g>
            </defs>

            <defs>
                <g id="Club-5">
                    <use xlink:href="#Club-4" />
                    <text x="140" y="215" font-size="80" fill="black">♣</text>
                </g>
            </defs>
            <defs>
                <g id="Club-6">
                    <use xlink:href="#Club-3" transform="translate(-40,0)" />
                    <use xlink:href="#Club-3" transform="translate(40,0)" />
                </g>
            </defs>
            <defs>
                <g id="Club-7">
                    <use xlink:href="#Club-6" />
                    <text x="140" y="170" font-size="80" fill="black">♣</text>
                </g>
            </defs>
            <defs>
                <g id="Club-8">
                    <use xlink:href="#Club-4" />
                    <g id="Club-Zweier">
                        <text x="100" y="173" font-size="80" fill="black">♣</text>
                        <text x="180" y="173" font-size="80" fill="black">♣</text>
                    </g>
                    <use xlink:href="#Club-Zweier" transform="rotate(180, 166, 183)" />
                </g>
            </defs>
            <defs>
                <g id="Club-9">
                    <use xlink:href="#Club-8" />
                    <text x="140" y="215" font-size="80" fill="black">♣</text>
                </g>
            </defs>
            <defs>
                <g id="Club-10">
                    <use xlink:href="#Club-8" />
                    <text id="Club_Einser" x="140" y="150" font-size="80" fill="black">♣</text>
                    <use xlink:href="#Club_Einser" transform="rotate(180, 167, 196)" />
                </g>
            </defs>

            <!-- alle Hearten -->

            <defs>
                <g id="Heart-A">
                    <text x="120" y="240" font-size="180" fill="red">♥</text>
                </g>

            </defs>
            <defs>
                <g id="Heart-2">
                    <text id="Heart_symbol" x="140" y="110" font-size="80" fill="red">♥</text>
                    <!-- Das Symbol an der X-Achse spiegeln -->

                    <use xlink:href="#Heart_symbol" x="145" y="200" transform="rotate(180, 235, 290)" />
                </g>

            </defs>

            <defs>
                <g id="Heart-3">
                    <use xlink:href="#Heart-2" />
                    <text x="140" y="215" font-size="80" fill="red">♥</text>
                </g>
            </defs>

            <defs>
                <g id="Heart-4">
                    <use xlink:href="#Heart-2" transform="translate(-40, 0)" />
                    <use xlink:href="#Heart-2" transform="translate(40, 0)" />
                </g>
            </defs>

            <defs>
                <g id="Heart-5">
                    <use xlink:href="#Heart-4" />
                    <text x="140" y="215" font-size="80" fill="red">♥</text>
                </g>
            </defs>
            <defs>
                <g id="Heart-6">
                    <use xlink:href="#Heart-3" transform="translate(-40,0)" />
                    <use xlink:href="#Heart-3" transform="translate(40,0)" />
                </g>
            </defs>
            <defs>
                <g id="Heart-7">
                    <use xlink:href="#Heart-6" />
                    <text x="140" y="170" font-size="80" fill="red">♥</text>
                </g>
            </defs>
            <defs>
                <g id="Heart-8">
                    <use xlink:href="#Heart-4" />
                    <g id="Heart-Zweier">
                        <text x="99" y="173" font-size="80" fill="red">♥</text>
                        <text x="180" y="173" font-size="80" fill="red">♥</text>
                    </g>
                    <use xlink:href="#Heart-Zweier" transform="rotate(180, 162, 190)" />
                </g>
            </defs>
            <defs>
                <g id="Heart-9">
                    <use xlink:href="#Heart-8" />
                    <text x="140" y="215" font-size="80" fill="red">♥</text>
                </g>
            </defs>
            <defs>
                <g id="Heart-10">
                    <use xlink:href="#Heart-8" />
                    <text id="Heart_Einser" x="140" y="150" font-size="80" fill="red">♥</text>
                    <use xlink:href="#Heart_Einser" transform="rotate(180, 162, 190)" />
                </g>
            </defs>

            <!-- alle Diamond -->
            <defs>
                <g id="Diamond-A">
                    <text x="120" y="240" font-size="180" fill="red">♦</text>
                </g>

            </defs>
            <defs>
                <g id="Diamond-2">
                    <text id="Diamond_symbol" x="140" y="110" font-size="80" fill="red">♦</text>
                    <!-- Das Symbol an der X-Achse spiegeln -->

                    <use xlink:href="#Diamond_symbol" transform="rotate(180, 160, 190)" />
                </g>

            </defs>

            <defs>
                <g id="Diamond-3">
                    <use xlink:href="#Diamond-2" />
                    <text x="140" y="215" font-size="80" fill="red">♦</text>
                </g>
            </defs>

            <defs>
                <g id="Diamond-4">
                    <use xlink:href="#Diamond-2" transform="translate(-40, 0)" />
                    <use xlink:href="#Diamond-2" transform="translate(40, 0)" />
                </g>
            </defs>

            <defs>
                <g id="Diamond-5">
                    <use xlink:href="#Diamond-4" />
                    <text x="140" y="215" font-size="80" fill="red">♦</text>
                </g>
            </defs>
            <defs>
                <g id="Diamond-6">
                    <use xlink:href="#Diamond-3" transform="translate(-40,0)" />
                    <use xlink:href="#Diamond-3" transform="translate(40,0)" />
                </g>
            </defs>
            <defs>
                <g id="Diamond-7">
                    <use xlink:href="#Diamond-6" />
                    <text x="140" y="170" font-size="80" fill="red">♦</text>
                </g>
            </defs>
            <defs>
                <g id="Diamond-8">
                    <use xlink:href="#Diamond-4" />
                    <g id="Diamond-Zweier">
                        <text x="100" y="173" font-size="80" fill="red">♦</text>
                        <text x="180" y="173" font-size="80" fill="red">♦</text>
                    </g>
                    <use xlink:href="#Diamond-Zweier" transform="rotate(180, 160, 190)" />
                </g>
            </defs>
            <defs>
                <g id="Diamond-9">
                    <use xlink:href="#Diamond-8" />
                    <text x="140" y="215" font-size="80" fill="red">♦</text>
                </g>
            </defs>
            <defs>
                <g id="Diamond-10">
                    <use xlink:href="#Diamond-8" />
                    <text id="Diamond_Einser" x="140" y="150" font-size="80" fill="red">♦</text>
                    <use xlink:href="#Diamond_Einser" transform="rotate(180, 160, 190)" />
                </g>
            </defs>
        </svg>
    </xsl:template>
    <xsl:template match="/chip">
        <!-- Der Trafo code -->


        <!-- SVG Defintionen für Chips-->
        <!-- default chip, other chips have the same features -->
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
    </xsl:template>
    <xsl:template match="/table">
        <svg width="100%" height="100%" version="1.1" viewBox="0 0 1600 900"
             xmlns="http://www.w3.org/2000/svg">
            <!-- allgemeine Variabeln einfügen -->

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
            <circle cx ="{$num}" cy="50" r="50" fill="red"/>
            <circle cx="155" cy="50" r="50" fill="blue"/>
            <circle cx="255" cy="50" r="50" fill="purple"/>

        </svg>
    </xsl:template>
</xsl:stylesheet>