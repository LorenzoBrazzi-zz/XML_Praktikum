<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.0">

    <!-- Jede Karte wird als ein Svg element ausgegeben -->
    <xsl:template match="/karte">
        <xsl:variable name="Farbe" select="farbe"></xsl:variable>
        <xsl:variable name="wert" select="wert"></xsl:variable>
        <svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%" xmlns:xlink="http://www.w3.org/1999/xlink">
            <g alignment-baseline="baseline" />
            <rect height="350" width="250" x="45" y="10" rx="30" ry="30" style="fill:white;stroke:black;stroke-width:5;opacity:1.0" />
            <xsl:choose>

                <!-- Spezial Karten Sonderfälle-->
                <xsl:when test="$wert = 'K'">
                    <xsl:choose>
                        <xsl:when test="$Farbe = 'Pik'">
                            <use href="#Pik-K" />
                        </xsl:when>
                        <xsl:when test="$Farbe = 'Herz'">
                            <use href="#Herz-K" />
                        </xsl:when>
                        <xsl:when test="$Farbe = 'Karo'">
                            <use href="#Karo-K" />
                        </xsl:when>
                        <xsl:when test="$Farbe = 'Kreuz'">
                            <use href="#Kreuz-K" />
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$wert = 'Q'">
                    <xsl:choose>
                        <xsl:when test="$Farbe = 'Pik'">
                            <use href="#Pik-Q" />
                        </xsl:when>
                        <xsl:when test="$Farbe = 'Herz'">
                            <use href="#Herz-Q" />
                        </xsl:when>
                        <xsl:when test="$Farbe = 'Karo'">
                            <use href="#Karo-Q" />
                        </xsl:when>
                        <xsl:when test="$Farbe = 'Kreuz'">
                            <use href="#Kreuz-Q" />
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$wert = 'B'">
                    <xsl:choose>
                        <xsl:when test="$Farbe = 'Pik'">
                            <use href="#Pik-B" />
                        </xsl:when>
                        <xsl:when test="$Farbe = 'Herz'">
                            <use href="#Herz-B" />
                        </xsl:when>
                        <xsl:when test="$Farbe = 'Karo'">
                            <use href="#Karo-B" />
                        </xsl:when>
                        <xsl:when test="$Farbe = 'Kreuz'">
                            <use href="#Kreuz-B" />
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>

                <!-- Symbole (Einzel, mehrfach muss noch gemacht werden) und reguläre Zahlen, die aus der XML Datei entnommen werden -->
                <xsl:when test="$Farbe = 'Pik'">

                    <g>

                        <text id="kar" x="57" y="70" font-size="55" fill="black">
                            <xsl:value-of select="wert"></xsl:value-of>
                        </text>
                        <use xlink:href="#kar" x="200" y="290" transform="rotate(180, 268, 330)" />
                        <use xlink:href="#Pik-{$wert}" />

                    </g>

                </xsl:when>
                <xsl:when test="$Farbe = 'Kreuz'">
                    <g>
                        <text id="kar" x="57" y="70" font-size="55" fill="black">
                            <xsl:value-of select="wert"></xsl:value-of>
                        </text>
                        <use xlink:href="#kar" x="200" y="290" transform="rotate(180, 268, 330)" />
                        <use xlink:href="#Kreuz-{$wert}" />
                    </g>
                </xsl:when>
                <xsl:when test="$Farbe = 'Herz'">
                    <g>
                        <text id="kar" x="57" y="70" font-size="55" fill="red">
                            <xsl:value-of select="wert"></xsl:value-of>
                        </text>
                        <use xlink:href="#kar" x="200" y="290" transform="rotate(180, 268, 330)" />
                        <use xlink:href="#Herz-{$wert}"/>
                    </g>
                </xsl:when>
                <xsl:when test="$Farbe = 'Karo'">
                           
                            <g>
                                <text id="kar" x="57" y="70" font-size="55" fill="red">
                                    <xsl:value-of select="wert"></xsl:value-of>
                                </text>
                                <use xlink:href="#kar" x="200" y="290" transform="rotate(180, 268, 330)" />
                                <use xlink:href="#Karo-{$wert}" />
                            </g>
                </xsl:when>
            </xsl:choose>


            <!-- SVG Definitionen um Redundanz zu vermeiden -->
            <defs>
                <g id="Kartenrand">
                    <rect height="350" width="250" x="45" y="10" rx="30" ry="30" style="fill:white;stroke:black;stroke-width:5;opacity:1.0" />
                </g>
            </defs>
            <defs>
                <g id="Karo-K">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/0/06/KD.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>

            <defs>
                <g id="Karo-Q">

                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/6/63/QD.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            <defs>
                <g id="Karo-B">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/3/33/JD.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            <defs>
                <g id="Herz-K">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/e/e5/KH.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>

            <defs>
                <g id="Herz-Q">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/d/d2/QH.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>

            <defs>
                <g id="Herz-B">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/1/15/JH.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            <defs>
                <g id="Kreuz-K">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/e/e1/KC.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>

            <defs>
                <g id="Kreuz-Q">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/9/9e/QC.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>

            <defs>
                <g id="Kreuz-B">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/1/11/JC.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            <defs>
                <g id="Pik-K">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/5/5c/KS.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>

            <defs>
                <g id="Pik-Q">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/3/35/QS.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>

            <defs>
                <g id="Pik-B">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/d/d9/JS.svg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            <!-- Einzelsymbole -->
            <defs>
                <g id="Pik_einzeln">
                    <polygon points="170,130 130,180 210,180" style="stroke-width:1" />
                    <circle cx="150" cy="201" r="29" />
                    <circle cx="190" cy="201" r="29 " />
                    <line x1="170" y1="190" x2="170" y2="255" style="stroke:#000;fill:#000;stroke-width:10" />

                </g>
            </defs>

            <!-- alle Piks -->
            <defs>
                <g id="Pik-A">
                    <text x="120" y="240" font-size="180" fill="black">♠</text>
                </g>

            </defs>
            <defs>
                <g id="Pik-2">
                    <text id="Pik_symbol" x="140" y="110" font-size="80" fill="black">♠</text>
                    <!-- Das Symbol an der Y achse spiegeln -->

                    <use xlink:href="#Pik_symbol" x="145" y="200" transform="rotate(180, 233, 290)" />
                </g>

            </defs>

            <defs>
                <g id="Pik-3">
                    <use xlink:href="#Pik-2" />
                    <text x="140" y="215" font-size="80" fill="black">♠</text>
                </g>
            </defs>

            <defs>
                <g id="Pik-4">
                    <use xlink:href="#Pik-2" transform="translate(-40, 0)" />
                    <use xlink:href="#Pik-2" transform="translate(40, 0)" />
                </g>
            </defs>

            <defs>
                <g id="Pik-5">
                    <use xlink:href="#Pik-4" />
                    <text x="140" y="215" font-size="80" fill="black">♠</text>
                </g>
            </defs>
            <defs>
                <g id="Pik-6">
                    <use xlink:href="#Pik-3" transform="translate(-40,0)" />
                    <use xlink:href="#Pik-3" transform="translate(40,0)" />
                </g>
            </defs>
            <defs>
                <g id="Pik-7">
                    <use xlink:href="#Pik-6" />
                    <text x="140" y="170" font-size="80" fill="black">♠</text>
                </g>
            </defs>
            <defs>
                <g id="Pik-8">
                    <use xlink:href="#Pik-4" />
                    <g id="Pik-Zweier">
                        <text x="100" y="173" font-size="80" fill="black">♠</text>
                        <text x="180" y="173" font-size="80" fill="black">♠</text>
                    </g>
                    <use xlink:href="#Pik-Zweier" transform="rotate(180, 161, 190)" />
                </g>
            </defs>
            <defs>
                <g id="Pik-9">
                    <use xlink:href="#Pik-8" />
                    <text x="140" y="215" font-size="80" fill="black">♠</text>
                </g>
            </defs>
            <defs>
                <g id="Pik-10">
                    <use xlink:href="#Pik-8" />
                    <text id="Pik_Einser" x="140" y="150" font-size="80" fill="black">♠</text>
                    <use xlink:href="#Pik_Einser" transform="rotate(180, 161, 190)" />
                </g>
            </defs>

            <!-- alle Kreuze -->
            <defs>
                <g id="Kreuz-A">
                    <text x="110" y="240" font-size="180" fill="black">♣</text>
                </g>

            </defs>
            <defs>
                <g id="Kreuz-2">
                    <text id="Kreuz_symbol" x="140" y="110" font-size="80" fill="black">♣</text>
                    <!-- Das Symbol an der X-Achse spiegeln -->

                    <use xlink:href="#Kreuz_symbol" x="135" y="200" transform="rotate(180, 233, 290)" />
                </g>

            </defs>

            <defs>
                <g id="Kreuz-3">
                    <use xlink:href="#Kreuz-2" />
                    <text x="135" y="215" font-size="80" fill="black">♣</text>
                </g>
            </defs>

            <defs>
                <g id="Kreuz-4">
                    <use xlink:href="#Kreuz-2" transform="translate(-40, 0)" />
                    <use xlink:href="#Kreuz-2" transform="translate(40, 0)" />
                </g>
            </defs>

            <defs>
                <g id="Kreuz-5">
                    <use xlink:href="#Kreuz-4" />
                    <text x="140" y="215" font-size="80" fill="black">♣</text>
                </g>
            </defs>
            <defs>
                <g id="Kreuz-6">
                    <use xlink:href="#Kreuz-3" transform="translate(-40,0)" />
                    <use xlink:href="#Kreuz-3" transform="translate(40,0)" />
                </g>
            </defs>
            <defs>
                <g id="Kreuz-7">
                    <use xlink:href="#Kreuz-6" />
                    <text x="140" y="170" font-size="80" fill="black">♣</text>
                </g>
            </defs>
            <defs>
                <g id="Kreuz-8">
                    <use xlink:href="#Kreuz-4" />
                    <g id="Kreuz-Zweier">
                        <text x="100" y="173" font-size="80" fill="black">♣</text>
                        <text x="180" y="173" font-size="80" fill="black">♣</text>
                    </g>
                    <use xlink:href="#Kreuz-Zweier" transform="rotate(180, 166, 183)" />
                </g>
            </defs>
            <defs>
                <g id="Kreuz-9">
                    <use xlink:href="#Kreuz-8" />
                    <text x="140" y="215" font-size="80" fill="black">♣</text>
                </g>
            </defs>
            <defs>
                <g id="Kreuz-10">
                    <use xlink:href="#Kreuz-8" />
                    <text id="Kreuz_Einser" x="140" y="150" font-size="80" fill="black">♣</text>
                    <use xlink:href="#Kreuz_Einser" transform="rotate(180, 167, 196)" />
                </g>
            </defs>

            <!-- alle Herzen -->

            <defs>
                <g id="Herz-A">
                    <text x="120" y="240" font-size="180" fill="red">♥</text>
                </g>

            </defs>
            <defs>
                <g id="Herz-2">
                    <text id="Herz_symbol" x="140" y="110" font-size="80" fill="red">♥</text>
                    <!-- Das Symbol an der X-Achse spiegeln -->

                    <use xlink:href="#Herz_symbol" x="145" y="200" transform="rotate(180, 235, 290)" />
                </g>

            </defs>

            <defs>
                <g id="Herz-3">
                    <use xlink:href="#Herz-2" />
                    <text x="140" y="215" font-size="80" fill="red">♥</text>
                </g>
            </defs>

            <defs>
                <g id="Herz-4">
                    <use xlink:href="#Herz-2" transform="translate(-40, 0)" />
                    <use xlink:href="#Herz-2" transform="translate(40, 0)" />
                </g>
            </defs>

            <defs>
                <g id="Herz-5">
                    <use xlink:href="#Herz-4" />
                    <text x="140" y="215" font-size="80" fill="red">♥</text>
                </g>
            </defs>
            <defs>
                <g id="Herz-6">
                    <use xlink:href="#Herz-3" transform="translate(-40,0)" />
                    <use xlink:href="#Herz-3" transform="translate(40,0)" />
                </g>
            </defs>
            <defs>
                <g id="Herz-7">
                    <use xlink:href="#Herz-6" />
                    <text x="140" y="170" font-size="80" fill="red">♥</text>
                </g>
            </defs>
            <defs>
                <g id="Herz-8">
                    <use xlink:href="#Herz-4" />
                    <g id="Herz-Zweier">
                        <text x="99" y="173" font-size="80" fill="red">♥</text>
                        <text x="180" y="173" font-size="80" fill="red">♥</text>
                    </g>
                    <use xlink:href="#Herz-Zweier" transform="rotate(180, 162, 190)" />
                </g>
            </defs>
            <defs>
                <g id="Herz-9">
                    <use xlink:href="#Herz-8" />
                    <text x="140" y="215" font-size="80" fill="red">♥</text>
                </g>
            </defs>
            <defs>
                <g id="Herz-10">
                    <use xlink:href="#Herz-8" />
                    <text id="Herz_Einser" x="140" y="150" font-size="80" fill="red">♥</text>
                    <use xlink:href="#Herz_Einser" transform="rotate(180, 162, 190)" />
                </g>
            </defs>

            <!-- alle Karo -->
            <defs>
                <g id="Karo-A">
                    <text x="120" y="240" font-size="180" fill="red">♦</text>
                </g>

            </defs>
            <defs>
                <g id="Karo-2">
                    <text id="Karo_symbol" x="140" y="110" font-size="80" fill="red">♦</text>
                    <!-- Das Symbol an der X-Achse spiegeln -->

                    <use xlink:href="#Karo_symbol" transform="rotate(180, 160, 190)" />
                </g>

            </defs>

            <defs>
                <g id="Karo-3">
                    <use xlink:href="#Karo-2" />
                    <text x="140" y="215" font-size="80" fill="red">♦</text>
                </g>
            </defs>

            <defs>
                <g id="Karo-4">
                    <use xlink:href="#Karo-2" transform="translate(-40, 0)" />
                    <use xlink:href="#Karo-2" transform="translate(40, 0)" />
                </g>
            </defs>

            <defs>
                <g id="Karo-5">
                    <use xlink:href="#Karo-4" />
                    <text x="140" y="215" font-size="80" fill="red">♦</text>
                </g>
            </defs>
            <defs>
                <g id="Karo-6">
                    <use xlink:href="#Karo-3" transform="translate(-40,0)" />
                    <use xlink:href="#Karo-3" transform="translate(40,0)" />
                </g>
            </defs>
            <defs>
                <g id="Karo-7">
                    <use xlink:href="#Karo-6" />
                    <text x="140" y="170" font-size="80" fill="red">♦</text>
                </g>
            </defs>
            <defs>
                <g id="Karo-8">
                    <use xlink:href="#Karo-4" />
                    <g id="Karo-Zweier">
                        <text x="100" y="173" font-size="80" fill="red">♦</text>
                        <text x="180" y="173" font-size="80" fill="red">♦</text>
                    </g>
                    <use xlink:href="#Karo-Zweier" transform="rotate(180, 160, 190)" />
                </g>
            </defs>
            <defs>
                <g id="Karo-9">
                    <use xlink:href="#Karo-8" />
                    <text x="140" y="215" font-size="80" fill="red">♦</text>
                </g>
            </defs>
            <defs>
                <g id="Karo-10">
                    <use xlink:href="#Karo-8" />
                    <text id="Karo_Einser" x="140" y="150" font-size="80" fill="red">♦</text>
                    <use xlink:href="#Karo_Einser" transform="rotate(180, 160, 190)" />
                </g>
            </defs>
        </svg>
    </xsl:template>
</xsl:stylesheet>