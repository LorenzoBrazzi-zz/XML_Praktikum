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
                        <xsl:when test="$Farbe = Kreuz">
                            <use href="#Herz-K" />
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
                        <xsl:when test="$Farbe = Kreuz">
                            <use href="#Herz-Q" />
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
                        <xsl:when test="$Farbe = Kreuz">
                            <use href="#Herz-B" />
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>

                <!-- Symbole (Einzel, mehrfach muss noch gemacht werden) und reguläre Zahlen, die aus der XML Datei entnommen werden -->
                <xsl:when test="$Farbe = 'Pik'">
                    <g>
                        <polygon points="170,130 130,180 210,180" style="stroke-width:1" />
                        <circle cx="150" cy="201" r="29" />
                        <circle cx="190" cy="201" r="29 " />
                        <line x1="170" y1="190" x2="170" y2="255" style="stroke:#000;fill:#000;stroke-width:10" />

                    </g>
                    <g>
                        <text id="kar" x="57" y="70" font-size="70" fill="black">
                            <xsl:value-of select="wert"></xsl:value-of>
                        </text>
                        <use xlink:href="#kar" x="200" y="290" transform="rotate(180, 268, 330)" />
                    </g>
                </xsl:when>
                <xsl:when test="$Farbe = 'Kreuz'">
                    <g>
                        <circle cx="170" cy="165" r="29" />
                        <circle cx="200" cy="201" r="29 " />
                        <circle cx="140" cy="201" r="29" />
                        <line x1="170" y1="190" x2="170" y2="255" style="stroke:#000;fill:#000;stroke-width:10" />

                    </g>
                    <g>
                        <text id="kar" x="57" y="70" font-size="70" fill="black">
                            <xsl:value-of select="wert"></xsl:value-of>
                        </text>
                        <use xlink:href="#kar" x="200" y="290" transform="rotate(180, 268, 330)" />
                    </g>
                </xsl:when>
                <xsl:when test="$Farbe = 'Herz'">
                    <g>
                        <polygon points="170,160 130,115 210,115" style="stroke:red;fill:red;stroke-width:1" />
                        <circle cx="150" cy="159" r="20" style="stroke:red;fill:red" />
                        <circle cx="190" cy="159" r="20" style="stroke:red;fill:red" />

                    </g>
                    <g>
                        <text id="kar" x="57" y="70" font-size="70" fill="red">
                            <xsl:value-of select="wert"></xsl:value-of>
                        </text>
                        <use xlink:href="#kar" x="200" y="290" transform="rotate(180, 268, 330)" />
                    </g>
                </xsl:when>
                <xsl:when test="$Farbe = 'Karo'">
                    <xsl:choose>
                        <xsl:when test="$wert = 'K'">
                            <use href="#Karo-K" />
                        </xsl:when>
                        <xsl:otherwise>
                            <g>
                                <polygon points="170,30 140,80 170,130 200,80" style="fill:red;stroke:red;stroke-width:1" />
                                <polygon points="170,230 140,280 170,330 200,280" style="fill:red;stroke:red;stroke-width:1" />

                            </g>
                            <g>
                                <text id="kar" x="57" y="70" font-size="70" fill="red">
                                    <xsl:value-of select="wert"></xsl:value-of>
                                </text>
                                <use xlink:href="#kar" x="200" y="290" transform="rotate(180, 268, 330)" />
                            </g>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>


            <!-- SVG Definitionen um Redundanz zu vermeiden -->
            <defs>
                <g id="Kartenrand">
                    <rect height="350" width="250" x="45" y="10" rx="30" ry="30" style="fill:white;stroke:black;stroke-width:5;opacity:1.0" />
                </g>
            </defs>
            <defs>
                <use href="'Kartenrand" />
                <g id="Karo-K">
                    <image xlink:href="https://t4.ftcdn.net/jpg/00/40/03/67/500_F_40036731_mPYQRYDtnqpLXIqxewu5bmq5q8ItclVE.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>

            <defs>
                <g id="Karo-Q">
                    <use xlink:href="#Kartenrand" />
                    <image xlink:href="
                            https://t4.ftcdn.net/jpg/00/40/22/75/500_F_40227576_KVEzuQcMDkW9KrFNoVIhTBjaKwAiWnnh.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            <defs>
                <g id="Karo-B">
                    <use xlink:href="#Kartenrand" />
                    <image xlink:href="https://t3.ftcdn.net/jpg/00/40/03/66/500_F_40036663_ezasrJwmIyGGPlLptnFD76PPm9wukzyF.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            <defs>
                <g id="Herz-K">
                    <use xlink:href="#Kartenrand" />
                    <image xlink:href="https://t3.ftcdn.net/jpg/00/40/03/64/500_F_40036471_ezXtaJezu9hsSeuk6CpQHVm2zXaH8WZd.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>

            <defs>
                <g id="Herz-Q">
                    <use xlink:href="#Kartenrand" />
                    <image xlink:href="https://t3.ftcdn.net/jpg/00/40/03/64/500_F_40036449_s0yWNKg9MyFrZ4siWskMTxvdFEltiFIQ.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>

            <defs>
                <g id="Herz-B">
                    <use xlink:href="#Kartenrand" />
                    <image xlink:href="https://t3.ftcdn.net/jpg/00/40/03/64/500_F_40036415_56z5BJ2vcHYOW34CG3xdpDDPRH2VKGMF.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            <defs>
                <g id="Kreuz-K">
                    <use xlink:href="#Kartenrand" />
                    <image xlink:href="https://t3.ftcdn.net/jpg/00/40/03/70/500_F_40037001_yiHav7FQ1ww6Tl5PbQXI0wGRF0CBLigA.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>

            <defs>
                <g id="Kreuz-Q">
                    <use xlink:href="#Kartenrand" />
                    <image xlink:href="https://t3.ftcdn.net/jpg/00/40/22/76/500_F_40227647_m0JvJccVZuHargU9QnT0s7gqkU55VC47.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>

            <defs>
                <g id="Kreuz-B">
                    <use xlink:href="#Kartenrand" />
                    <image xlink:href="https://t4.ftcdn.net/jpg/00/40/03/69/500_F_40036926_6E84Mh57txnlb6a3LhA58y0I5ELGAQL6.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
            <defs>
                <g id="Pik-K">
                    <use xlink:href="#Kartenrand" />
                    <image xlink:href="https://t3.ftcdn.net/jpg/00/40/03/72/500_F_40037201_OzwAPPdNIESKCALqZ1UZTrUHC1ub8csM.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>

            <defs>
                <g id="Pik-Q">
                    <use xlink:href="#Kartenrand" />
                    <image xlink:href="https://t4.ftcdn.net/jpg/00/40/03/71/500_F_40037169_qHdy4yyUxubUewdd6MKK84tRy2zLkFsR.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>

            <defs>
                <g id="Pik-B">
                    <use xlink:href="#Kartenrand" />
                    <image xlink:href="https://t4.ftcdn.net/jpg/00/40/03/71/500_F_40037139_yHRxBbB4ITnfYJ7AW0CDqszVJ9wiR0HG.jpg" width="250" height="330" x="45" y="20" />
                </g>
            </defs>
        </svg>
    </xsl:template>
</xsl:stylesheet>