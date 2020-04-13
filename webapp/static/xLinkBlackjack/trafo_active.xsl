<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

    <xsl:include href="general_values.xsl"></xsl:include>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="game">
        <!-- Some variable definitions -->
        <xsl:variable name="player1" select="players/player[position = 1]"/>
        <xsl:variable name="player2" select="players/player[position = 2]"/>
        <xsl:variable name="player3" select="players/player[position = 3]"/>
        <xsl:variable name="player4" select="players/player[position = 4]"/>
        <xsl:variable name="player5" select="players/player[position = 5]"/>
        <xsl:variable name="activePlayer" select="activePlayer"/>
        <xsl:variable name="dealer" select="dealer"/>
        <xsl:variable name="gameID" select="id/text()"/>
        <xsl:variable name="state" select="state"/>
        <xsl:variable name="isInsurance" select="dealer/isInsurance"/>


        <svg width="100%" height="100%" version="1.1" viewBox="0 0 1600 900"
             xmlns="http://www.w3.org/2000/svg">

            <style>

                .notifications {
                position:absolute;
                top:20;
                right:30;
                height:20%;
                width:30%;
                border:1px solid #ccc;
                font:16px/26px;
                overflow:auto;
                font-family:'Courier New',Verdana,sans-serif;
                background-color: white;
                border-radius: 15px;
                padding: 10px;
                padding-top: 3px;
                padding-left:3px;
                box-shadow: 1px 1px 25px #46464f
                }

                .glow {
                font-size: 30px;
                color: #fff;
                text-align: center;
                -webkit-animation: glow 1s ease-in-out infinite alternate;
                -moz-animation: glow 1s ease-in-out infinite alternate;
                animation: glow 1s ease-in-out infinite alternate;
                }

                @-webkit-keyframes glow {
                from {
                text-shadow: 0 0 10px #fff, 0 0 20px #fff, 0 0 30px #e60073, 0 0 40px #e60073, 0 0 50px #e60073, 0 0
                60px #e60073, 0 0 70px #e60073;
                }
                to {
                text-shadow: 0 0 20px #fff, 0 0 30px #ff4da6, 0 0 40px #ff4da6, 0 0 50px #ff4da6, 0 0 60px #ff4da6, 0 0
                70px #ff4da6, 0 0 80px #ff4da6;
                }
                }

                /* Chrome, Safari, Edge, Opera */
                input::-webkit-outer-spin-button,
                input::-webkit-inner-spin-button {
                -webkit-appearance: none;
                margin: 0;
                }

                /* Firefox */
                input[type=number] {
                -moz-appearance: textfield;
                }

                .form-inline {
                display: flex;
                flex-flow: row wrap;
                align-items: center;
                }

                .form-inline input {
                vertical-align: middle;
                padding: 10px;
                background-color: #fff;
                border: 1px solid #ddd;
                }

                .form-inline button {
                padding: 10px 20px;
                background-color: dodgerblue;
                border: 1px solid #ddd;
                color: white;
                cursor: pointer;
                }

                .form-inline button:hover {
                background-color: royalblue;
                }

                @media (max-width: 800px) {
                .form-inline input {
                margin: 10px 0;
                }

                .form-inline {
                flex-direction: column;
                align-items: stretch;
                }
                }
            </style>

            <!-- background -->
            <rect id="background" fill="#8a2c2c" width="1000%" height="1000%" x="-3000"/>

            <!-- table form -->
            <circle cx="800" cy="0" r="900" fill="{$tableColor}"/>
            <circle cx="800" cy="0" r="900" style="fill:none;stroke:{$tableColorEdge};stroke-width:50"/>

            <!-- Dealer box -->
            <rect x="550" y="50" rx="15" ry="15" width="450" height="150" style="fill:none;stroke:#fff;stroke-width:4"/>

            <!-- cards and bet positions -->
            <circle cx="{$player1x}" cy="{$player1y}" r="{$radiusPlayer}"
                    style="fill:none;stroke:white;stroke-width:2.5"/>
            <circle cx="{$player2x}" cy="{$player2y}" r="{$radiusPlayer}"
                    style="fill:none;stroke:white;stroke-width:2.5"/>
            <circle cx="{$player3x}" cy="{$player3y}" r="{$radiusPlayer}"
                    style="fill:none;stroke:white;stroke-width:2.5"/>
            <circle cx="{$player4x}" cy="{$player4y}" r="{$radiusPlayer}"
                    style="fill:none;stroke:white;stroke-width:2.5"/>
            <circle cx="{$player5x}" cy="{$player5y}" r="{$radiusPlayer}"
                    style="fill:none;stroke:white;stroke-width:2.5"/>

            <!-- current bet dummies -->
            <circle cx="{$p1CurrentBetX}" cy="{$p1CurrentBetY}" r="{$radiusDummyChips}"
                    style="fill:none;stroke:purple;stroke-width:1">
                <xsl:value-of select="$player1/currentBet"/>
            </circle>
            <circle cx="{$p2CurrentBetX}" cy="{$p2CurrentBetY}" r="{$radiusDummyChips}"
                    style="fill:none;stroke:purple;stroke-width:1">
                <xsl:value-of select="$player2/currentBet"/>
            </circle>
            <circle cx="{$p3CurrentBetX}" cy="{$p3CurrentBetY}" r="{$radiusDummyChips}"
                    style="fill:none;stroke:purple;stroke-width:1">
                <xsl:value-of select="$player3/currentBet"/>
            </circle>
            <circle cx="{$p4CurrentBetX}" cy="{$p4CurrentBetY}" r="{$radiusDummyChips}"
                    style="fill:none;stroke:purple;stroke-width:1">
                <xsl:value-of select="$player4/currentBet"/>
            </circle>
            <circle cx="{$p5CurrentBetX}" cy="{$p5CurrentBetY}" r="{$radiusDummyChips}"
                    style="fill:none;stroke:purple;stroke-width:1">
                <xsl:value-of select="$player5/currentBet"/>
            </circle>


            <!-- player names, if active player then highlighted with yellow and glow,
             also all non-playing buttons for the active player are transformed in here-->


            <!-- Player 1 -->
            <xsl:choose>
                <xsl:when test="$player1/id = $activePlayer">
                    <text x="{$player1x}" y="{$player1y + $radiusPlayer + $lineSpacing}" class="glow"
                          font-family="Arial"
                          font-style="italic" fill="yellow" text-anchor="middle">

                        <xsl:value-of select="$player1/name"/>

                    </text>
                    <xsl:choose>
                        <xsl:when test="$state = 'ready'">
                            <text x="{$testButton1x + 100}" y="{$testButton1y - 25}" style="
                                 font-weight: bold; font-size: 26pt" fill="white" font-family="Arial">Bereit?
                            </text>
                            <foreignObject height="50%" width="50%" x="{$testButton1x + 100}"
                                           y="{$testButton1y}">
                                <form xmls="http://www.w3.org/1999/xhtml" action="/xLinkbj/ready/{$gameID}" method="POST"
                                      target="hiddenFrame">
                                    <button style="background:transparent; border:none; color:transparent;"
                                            type="submit">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/e/e0/Check_green_icon.svg"
                                             width="80"/>
                                    </button>
                                </form>
                            </foreignObject>

                        </xsl:when>
                        <xsl:when test="$state = 'continue'">
                            <text x="{$testButton1x + 60}" y="{$testButton1y}" style="
                                 font-weight: bold; font-size: 26pt" fill="white" font-family="Arial">Weiterspielen?
                            </text>
                            <foreignObject height="50%" width="50%" x="{$testButton1x + 65}"
                                           y="{$testButton1y + 15}">
                                <form xmls="http://www.w3.org/1999/xhtml" action="/xLinkbj/continue/{$gameID}/true"
                                      method="POST" target="hiddenFrame">
                                    <button style="background:transparent; border:none; color:transparent;"
                                            type="submit">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/e/e0/Check_green_icon.svg"
                                             width="80"/>
                                    </button>
                                </form>
                            </foreignObject>
                            <foreignObject height="10%" width="10%" x="{$testButton1x + 165}"
                                           y="{$testButton1y + 15}">
                                <form xmls="http://www.w3.org/1999/xhtml" action="/xLinkbj/continue/{$gameID}/false"
                                      method="POST">
                                    <button style="background:transparent; border:none; color:transparent;"
                                            type="submit">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/c/cc/Cross_red_circle.svg"
                                             width="80"/>
                                    </button>
                                </form>
                            </foreignObject>
                        </xsl:when>
                        <xsl:when test="$state = 'bet'">
                            <foreignObject height="5%" width="17%" x="{$p1CurrentBetX - 50}"
                                           y="{$p1CurrentBetY + $radiusDummyChips + 10}">
                                <form xmlns="http://www.w3.org/1999/xhtml"
                                      action="/xLinkbj/setBet/{$gameID}" method="POST" class="form-inline"
                                      target="hiddenFrame">
                                    <span style="display: inline">
                                        <input type="number" id="bet" name="bet" placeholder="Set a bet"/>
                                        <button type="submit">Bet
                                        </button>
                                    </span>
                                </form>
                            </foreignObject>
                        </xsl:when>
                        <xsl:when test="$state = 'evaluate'">
                            <text x="{$testButton1x - 100}" y="{$testButton1y - 35}" style="
                             font-weight: bold; font-size: 26pt" fill="white">Ergebnis anzeigen!
                            </text>
                            <foreignObject height="50%" width="50%" x="{$testButton1x}"
                                           y="{$testButton1y}">
                                <form xmls="http://www.w3.org/1999/xhtml" action="/xLinkbj/evaluate/{$gameID}" method="POST"
                                      target="hiddenFrame">
                                    <button style="background:transparent; border:none; color:transparent;"
                                            type="submit">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/e/e0/Check_green_icon.svg"
                                             width="100"/>
                                    </button>
                                </form>
                            </foreignObject>

                        </xsl:when>
                    </xsl:choose>
                </xsl:when>

                <xsl:otherwise>
                    <text x="{$player1x}" y="{$player1y + $radiusPlayer + $lineSpacing}" font-family="Arial"
                          font-size="{$playerNameTextSize}" fill="white" text-anchor="middle" fill-opacity="0.5">
                        <xsl:value-of select="$player1/name"/>
                    </text>
                </xsl:otherwise>
            </xsl:choose>


            <!-- Player 2 -->
            <xsl:choose>
                <xsl:when test="$player2/id = $activePlayer">
                    <text x="{$player2x}" y="{$player2y + $radiusPlayer + $lineSpacing}" font-family="Arial"
                          class="glow" fill="yellow" text-anchor="middle">
                        <xsl:value-of select="$player2/name"/>
                    </text>
                    <xsl:choose>
                        <xsl:when test="$state = 'ready'">
                            <text x="{$testButton1x + 100}" y="{$testButton1y - 25}" style="
                                 font-weight: bold; font-size: 26pt" fill="white" font-family="Arial">Bereit?
                            </text>
                            <foreignObject height="50%" width="50%" x="{$testButton1x + 100}"
                                           y="{$testButton1y}">
                                <form xmls="http://www.w3.org/1999/xhtml" action="/xLinkbj/ready/{$gameID}" method="POST"
                                      target="hiddenFrame">
                                    <button style="background:transparent; border:none; color:transparent;"
                                            type="submit">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/e/e0/Check_green_icon.svg"
                                             width="80"/>
                                    </button>
                                </form>
                            </foreignObject>
                        </xsl:when>
                        <xsl:when test="state = 'bet'">
                            <foreignObject height="5%" width="17%" x="{$p2CurrentBetX - 50}"
                                           y="{$p2CurrentBetY + $radiusDummyChips + 10}">
                                <form xmlns="http://www.w3.org/1999/xhtml" style="margin: 0; padding: 0"
                                      action="/xLinkbj/setBet/{$gameID}" class="form-inline" method="POST"
                                      target="hiddenFrame">
                                    <span style="display: inline">
                                        <input type="number" id="bet" name="bet" placeholder="Set a bet"/>
                                        <button type="submit">Bet
                                        </button>
                                    </span>
                                </form>
                            </foreignObject>
                        </xsl:when>
                        <xsl:when test="$state = 'continue'">
                            <text x="{$testButton1x + 60}" y="{$testButton1y}" style="
                             font-weight: bold; font-size: 26pt" fill="white" font-family="Arial">Weiterspielen?
                            </text>
                            <foreignObject height="50%" width="50%" x="{$testButton1x + 65}"
                                           y="{$testButton1y + 15}">
                                <form xmls="http://www.w3.org/1999/xhtml" action="/xLinkbj/continue/{$gameID}/true"
                                      method="POST" target="hiddenFrame">
                                    <button style="background:transparent; border:none; color:transparent;"
                                            type="submit">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/e/e0/Check_green_icon.svg"
                                             width="80"/>
                                    </button>
                                </form>
                            </foreignObject>
                            <foreignObject height="10%" width="10%" x="{$testButton1x + 165}"
                                           y="{$testButton1y + 15}">
                                <form xmls="http://www.w3.org/1999/xhtml" action="/xLinkbj/continue/{$gameID}/false"
                                      method="POST" target="hiddenFrame">
                                    <button style="background:transparent; border:none; color:transparent;"
                                            type="submit">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/c/cc/Cross_red_circle.svg"
                                             width="80"/>
                                    </button>
                                </form>
                            </foreignObject>

                        </xsl:when>
                        <xsl:when test="$state = 'evaluate'">
                            <text x="{$testButton1x - 100}" y="{$testButton1y - 35}" style="
                             font-weight: bold; font-size: 26pt" fill="white">Ergebnis anzeigen!
                            </text>
                            <foreignObject height="50%" width="50%" x="{$testButton1x}"
                                           y="{$testButton1y}">
                                <form xmls="http://www.w3.org/1999/xhtml" action="/xLinkbj/evaluate/{$gameID}" method="POST"
                                      target="hiddenFrame">
                                    <button style="background:transparent; border:none; color:transparent;"
                                            type="submit">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/e/e0/Check_green_icon.svg"
                                             width="100"/>
                                    </button>
                                </form>
                            </foreignObject>

                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <text x="{$player2x}" y="{$player2y + $radiusPlayer + $lineSpacing}" font-family="Arial"
                          font-size="{$playerNameTextSize}" fill="white" text-anchor="middle" fill-opacity="0.5">
                        <xsl:value-of select="$player2/name"/>
                    </text>
                </xsl:otherwise>
            </xsl:choose>

            <!-- Player 3 -->
            <xsl:choose>
                <xsl:when test="$player3/id = $activePlayer">
                    <text x="{$player3x}" y="{$player3y + $radiusPlayer + $lineSpacing}" font-family="Arial"
                          class="glow" fill="yellow" text-anchor="middle">
                        <xsl:value-of select="$player3/name"/>
                    </text>
                    <xsl:choose>
                        <xsl:when test="$state = 'ready'">
                            <text x="{$testButton1x + 100}" y="{$testButton1y - 25}" style="
                                 font-weight: bold; font-size: 26pt" fill="white" font-family="Arial">Bereit?
                            </text>
                            <foreignObject height="50%" width="50%" x="{$testButton1x + 100}"
                                           y="{$testButton1y}">
                                <form xmls="http://www.w3.org/1999/xhtml" action="/xLinkbj/ready/{$gameID}" method="POST"
                                      target="hiddenFrame">
                                    <button style="background:transparent; border:none; color:transparent;"
                                            type="submit">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/e/e0/Check_green_icon.svg"
                                             width="80"/>
                                    </button>
                                </form>
                            </foreignObject>
                        </xsl:when>
                        <xsl:when test="state = 'bet'">
                            <foreignObject height="5%" width="17%" x="{$p3CurrentBetX - 50}"
                                           y="{$p3CurrentBetY + $radiusDummyChips + 10}">
                                <form xmlns="http://www.w3.org/1999/xhtml" style="margin: 0; padding: 0"
                                      action="/xLinkbj/setBet/{$gameID}" method="POST" class="form-inline"
                                      target="hiddenFrame">
                                    <span style="display: inline">
                                        <input type="number" id="bet" name="bet" placeholder="Set a bet"/>
                                        <button type="submit">Bet
                                        </button>
                                    </span>
                                </form>
                            </foreignObject>
                        </xsl:when>
                        <xsl:when test="$state = 'continue'">
                            <text x="{$testButton1x + 65}" y="{$testButton1y}" style="
                             font-weight: bold; font-size: 26pt" fill="white" font-family="Arial">Weiterspielen?
                            </text>
                            <foreignObject height="50%" width="50%" x="{$testButton1x + 65}"
                                           y="{$testButton1y + 15}">
                                <form xmls="http://www.w3.org/1999/xhtml" action="/xLinkbj/continue/{$gameID}/true"
                                      method="POST" target="hiddenFrame">
                                    <button style="background:transparent; border:none; color:transparent;"
                                            type="submit">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/e/e0/Check_green_icon.svg"
                                             width="80"/>
                                    </button>
                                </form>
                            </foreignObject>
                            <foreignObject height="10%" width="10%" x="{$testButton1x + 165}"
                                           y="{$testButton1y + 15}">
                                <form xmls="http://www.w3.org/1999/xhtml" action="/xLinkbj/continue/{$gameID}/false"
                                      method="POST" target="hiddenFrame">
                                    <button style="background:transparent; border:none; color:transparent;"
                                            type="submit">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/c/cc/Cross_red_circle.svg"
                                             width="80"/>
                                    </button>
                                </form>
                            </foreignObject>

                        </xsl:when>
                        <xsl:when test="$state = 'evaluate'">
                            <text x="{$testButton1x - 100}" y="{$testButton1y - 35}" style="
                             font-weight: bold; font-size: 26pt" fill="white">Ergebnis anzeigen!
                            </text>
                            <foreignObject height="50%" width="50%" x="{$testButton1x}"
                                           y="{$testButton1y}">
                                <form xmls="http://www.w3.org/1999/xhtml" action="/xLinkbj/evaluate/{$gameID}" method="POST"
                                      target="hiddenFrame">
                                    <button style="background:transparent; border:none; color:transparent;"
                                            type="submit">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/e/e0/Check_green_icon.svg"
                                             width="100"/>
                                    </button>
                                </form>
                            </foreignObject>

                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <text x="{$player3x}" y="{$player3y + $radiusPlayer + $lineSpacing}" font-family="Arial"
                          font-size="{$playerNameTextSize}" fill="white" text-anchor="middle" fill-opacity="0.5">
                        <xsl:value-of select="$player3/name"/>
                    </text>
                </xsl:otherwise>
            </xsl:choose>


            <!-- Player 4 -->
            <xsl:choose>
                <xsl:when test="$player4/id = $activePlayer">
                    <text x="{$player4x}" y="{$player4y + $radiusPlayer + $lineSpacing}" font-family="Arial"
                          class="glow" fill="yellow" text-anchor="middle">
                        <xsl:value-of select="$player4/name"/>
                    </text>
                    <xsl:choose>
                        <xsl:when test="$state = 'ready'">
                            <text x="{$testButton1x + 100}" y="{$testButton1y - 25}" style="
                                 font-weight: bold; font-size: 26pt" fill="white" font-family="Arial">Bereit?
                            </text>
                            <foreignObject height="50%" width="50%" x="{$testButton1x + 100}"
                                           y="{$testButton1y}">
                                <form xmls="http://www.w3.org/1999/xhtml" action="/xLinkbj/ready/{$gameID}" method="POST"
                                      target="hiddenFrame">
                                    <button style="background:transparent; border:none; color:transparent;"
                                            type="submit">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/e/e0/Check_green_icon.svg"
                                             width="80"/>
                                    </button>
                                </form>
                            </foreignObject>
                        </xsl:when>
                        <xsl:when test="state = 'bet'">
                            <foreignObject height="5%" width="17%" x="{$p4CurrentBetX - 50}"
                                           y="{$p4CurrentBetY + $radiusDummyChips + 10}">
                                <form xmlns="http://www.w3.org/1999/xhtml" style="margin: 0; padding: 0"
                                      action="/xLinkbj/setBet/{$gameID}" method="POST" class="form-inline"
                                      target="hiddenFrame">
                                    <span style="display: inline">
                                        <input type="number" id="bet" name="bet" placeholder="Set a bet"/>
                                        <button type="submit">Bet
                                        </button>
                                    </span>
                                </form>
                            </foreignObject>
                        </xsl:when>
                        <xsl:when test="$state = 'continue'">
                            <text x="{$testButton1x + 65}" y="{$testButton1y}" style="
                             font-weight: bold; font-size: 26pt" fill="white" font-family="Arial">Weiterspielen?
                            </text>
                            <foreignObject height="50%" width="50%" x="{$testButton1x + 65}"
                                           y="{$testButton1y + 15}">
                                <form xmls="http://www.w3.org/1999/xhtml" action="/xLinkbj/continue/{$gameID}/true"
                                      method="POST" target="hiddenFrame">
                                    <button style="background:transparent; border:none; color:transparent;"
                                            type="submit">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/e/e0/Check_green_icon.svg"
                                             width="80"/>
                                    </button>
                                </form>
                            </foreignObject>
                            <foreignObject height="10%" width="10%" x="{$testButton1x + 165}"
                                           y="{$testButton1y + 15}">
                                <form xmls="http://www.w3.org/1999/xhtml" action="/xLinkbj/continue/{$gameID}/false"
                                      method="POST" target="hiddenFrame">
                                    <button style="background:transparent; border:none; color:transparent;"
                                            type="submit">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/c/cc/Cross_red_circle.svg"
                                             width="80"/>
                                    </button>
                                </form>
                            </foreignObject>

                        </xsl:when>
                        <xsl:when test="$state = 'evaluate'">
                            <text x="{$testButton1x - 100}" y="{$testButton1y - 35}" style="
                             font-weight: bold; font-size: 26pt" fill="white">Ergebnis anzeigen!
                            </text>
                            <foreignObject height="50%" width="50%" x="{$testButton1x}"
                                           y="{$testButton1y}">
                                <form xmls="http://www.w3.org/1999/xhtml" action="/xLinkbj/evaluate/{$gameID}" method="POST"
                                      target="hiddenFrame">
                                    <button style="background:transparent; border:none; color:transparent;"
                                            type="submit">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/e/e0/Check_green_icon.svg"
                                             width="100"/>
                                    </button>
                                </form>
                            </foreignObject>

                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <text x="{$player4x}" y="{$player4y + $radiusPlayer + $lineSpacing}" font-family="Arial"
                          font-size="{$playerNameTextSize}" fill="white" text-anchor="middle" fill-opacity="0.5">
                        <xsl:value-of select="$player4/name"/>
                    </text>
                </xsl:otherwise>
            </xsl:choose>


            <!-- Player 5 -->
            <xsl:choose>
                <xsl:when test="$player5/id = $activePlayer">
                    <text x="{$player5x}" y="{$player5y + $radiusPlayer + $lineSpacing}" font-family="Arial"
                          class="glow" fill="yellow" text-anchor="middle">
                        <xsl:value-of select="$player5/name"/>
                    </text>
                    <xsl:choose>
                        <xsl:when test="$state = 'ready'">
                            <text x="{$testButton1x + 100}" y="{$testButton1y - 25}" style="
                                 font-weight: bold; font-size: 26pt" fill="white" font-family="Arial">Bereit?
                            </text>
                            <foreignObject height="50%" width="50%" x="{$testButton1x + 100}"
                                           y="{$testButton1y}">
                                <form xmls="http://www.w3.org/1999/xhtml" action="/xLinkbj/ready/{$gameID}" method="POST"
                                      target="hiddenFrame">
                                    <button style="background:transparent; border:none; color:transparent;"
                                            type="submit">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/e/e0/Check_green_icon.svg"
                                             width="80"/>
                                    </button>
                                </form>
                            </foreignObject>
                        </xsl:when>
                        <xsl:when test="state = 'bet'">
                            <foreignObject height="5%" width="17%" x="{$p5CurrentBetX - 50}"
                                           y="{$p5CurrentBetY + $radiusDummyChips + 10}">
                                <form xmlns="http://www.w3.org/1999/xhtml" style="margin: 0; padding: 0"
                                      action="/xLinkbj/setBet/{$gameID}" method="POST" class="form-inline"
                                      target="hiddenFrame">
                                    <span style="display: inline">
                                        <input type="number" id="bet" name="bet" placeholder="Set a bet"/>
                                        <button type="submit">Bet
                                        </button>
                                    </span>
                                </form>
                            </foreignObject>
                        </xsl:when>
                        <xsl:when test="$state = 'continue'">
                            <text x="{$testButton1x + 65}" y="{$testButton1y}" style="
                             font-weight: bold; font-size: 26pt" fill="white" font-family="Arial">Weiterspielen?
                            </text>
                            <foreignObject height="50%" width="50%" x="{$testButton1x + 65}"
                                           y="{$testButton1y + 15}">
                                <form xmls="http://www.w3.org/1999/xhtml" action="/xLinkbj/continue/{$gameID}/true"
                                      method="POST" target="hiddenFrame">
                                    <button style="background:transparent; border:none; color:transparent;"
                                            type="submit">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/e/e0/Check_green_icon.svg"
                                             width="80"/>
                                    </button>
                                </form>
                            </foreignObject>
                            <foreignObject height="10%" width="10%" x="{$testButton1x + 165}"
                                           y="{$testButton1y + 15}">
                                <form xmls="http://www.w3.org/1999/xhtml" action="/xLinkbj/continue/{$gameID}/false"
                                      method="POST" target="hiddenFrame">
                                    <button style="background:transparent; border:none; color:transparent;"
                                            type="submit">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/c/cc/Cross_red_circle.svg"
                                             width="80"/>
                                    </button>
                                </form>
                            </foreignObject>

                        </xsl:when>
                        <xsl:when test="$state = 'evaluate'">
                            <text x="{$testButton1x - 100}" y="{$testButton1y - 35}" style="
                             font-weight: bold; font-size: 26pt" fill="white">Ergebnis anzeigen!
                            </text>
                            <foreignObject height="50%" width="50%" x="{$testButton1x}"
                                           y="{$testButton1y}">
                                <form xmls="http://www.w3.org/1999/xhtml" action="/xLinkbj/evaluate/{$gameID}" method="POST"
                                      target="hiddenFrame">
                                    <button style="background:transparent; border:none; color:transparent;"
                                            type="submit">
                                        <img src="https://upload.wikimedia.org/wikipedia/commons/e/e0/Check_green_icon.svg"
                                             width="100"/>
                                    </button>
                                </form>
                            </foreignObject>

                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <text x="{$player5x}" y="{$player5y + $radiusPlayer + $lineSpacing}" font-family="Arial"
                          font-size="{$playerNameTextSize}" fill="white" text-anchor="middle" fill-opacity="0.5">
                        <xsl:value-of select="$player5/name"/>
                    </text>
                </xsl:otherwise>
            </xsl:choose>

            <!-- Player Cash -->
            <text x="{$player1x}" y="{$player1y + $radiusPlayer + ($lineSpacing * 1.6)}" font-family="Arial"
                  font-size="{$playerNameTextSize}" fill="white" text-anchor="middle" fill-opacity="0.5">
                <xsl:value-of select="$player1/balance"/>
            </text>
            <text x="{$player2x}" y="{$player2y + $radiusPlayer + ($lineSpacing * 1.6)}" font-family="Arial"
                  font-size="{$playerNameTextSize}" fill="white" text-anchor="middle" fill-opacity="0.5">
                <xsl:value-of select="$player2/balance"/>
            </text>
            <text x="{$player3x}" y="{$player3y + $radiusPlayer + ($lineSpacing * 1.6)}" font-family="Arial"
                  font-size="{$playerNameTextSize}" fill="white" text-anchor="middle" fill-opacity="0.5">
                <xsl:value-of select="$player3/balance"/>
            </text>
            <text x="{$player4x}" y="{$player4y + $radiusPlayer + ($lineSpacing * 1.6)}" font-family="Arial"
                  font-size="{$playerNameTextSize}" fill="white" text-anchor="middle" fill-opacity="0.5">
                <xsl:value-of select="$player4/balance"/>
            </text>
            <text x="{$player5x}" y="{$player5y + $radiusPlayer + ($lineSpacing * 1.6)}" font-family="Arial"
                  font-size="{$playerNameTextSize}" fill="white" text-anchor="middle" fill-opacity="0.5">
                <xsl:value-of select="$player5/balance"/>
            </text>

            <!-- table text  -->
            <text x="300"  y="250" font-family="Algerian" font-size="50" fill="white" fill-opacity="0.85">
                <textPath xlink:href="#bjTextPath" >
                    BLACKJACK PAYS 3 TO 2
                </textPath>
            </text> <text x="425"  y="250" font-family="Algerian" font-size="30" fill="white" fill-opacity="0.6">
            <textPath xlink:href="#insuranceTextPath" >
                Insurance pays 2 to 1
            </textPath>
        </text>


            <!-- Playing state UI, i.e. chips, hit, stand, double and insurance-->
            <xsl:choose>
                <xsl:when test="$state='play'">
                    <foreignObject width="7%" height="13%" x="{$button1x}"
                                   y="{$buttonsY}">
                        <form xmlns="http://www.w3.org/1999/xhtml" action="/xLinkbj/hit/{$gameID}" id="formHit" method="POST"
                              target="hiddenFrame">
                            <button class="buttonHit" type="submit" form="formHit" value="Submit">Hit
                            </button>
                        </form>
                    </foreignObject>
                    <foreignObject width="7%" height="13%" x="{$button2x}"
                                   y="{$buttonsY}">
                        <form xmlns="http://www.w3.org/1999/xhtml" action="/xLinkbj/stand/{$gameID}" id="formStand"
                              method="POST" target="hiddenFrame">
                            <button class="buttonStand" type="submit" form="formStand" value="Submit">Stand
                            </button>
                        </form>
                    </foreignObject>
                    <foreignObject width="7%" height="13%" x="{$button3x}"
                                   y="{$buttonsY}">
                        <form xmlns="http://www.w3.org/1999/xhtml" action="/xLinkbj/double/{$gameID}" id="formDouble"
                              method="POST" target="hiddenFrame">
                            <button class="buttonDouble" type="submit" form="formDouble" value="Submit">Double
                            </button>
                        </form>
                    </foreignObject>


                    <!-- player 1 Chip -->
                    <xsl:variable name="currentBet1" select="players/player[1]/currentBet"/>
                    <xsl:choose>
                        <xsl:when test="$currentBet1 &lt; 101">
                            <use xlink:href="#Blue Chip"
                                 transform="translate({$p1CurrentBetX - 45} {$p1CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:20px" x="{$p1CurrentBetX}" y="{$p1CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="$currentBet1"/> </text>
                        </xsl:when>
                        <xsl:when test="$currentBet1 &lt; 501">
                            <use xlink:href="#Green Chip"
                                 transform="translate({$p1CurrentBetX - 45} {$p1CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:20px" x="{$p1CurrentBetX}" y="{$p1CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="$currentBet1"/> </text>
                        </xsl:when>
                        <xsl:when test="$currentBet1 &lt; 1000">
                            <use xlink:href="#Purple Chip"
                                 transform="translate({$p1CurrentBetX - 45} {$p1CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:20px" x="{$p1CurrentBetX}" y="{$p1CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="$currentBet1"/> </text>
                        </xsl:when>
                        <xsl:when test="$currentBet1 &lt; 5001">
                            <use xlink:href="#Red Chip"
                                 transform="translate({$p1CurrentBetX - 45} {$p1CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:20px" x="{$p1CurrentBetX}" y="{$p1CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="format-number($currentBet1 div 1000 ,'##0.0' )"/>K</text>
                        </xsl:when>
                        <xsl:when test="$currentBet1 &gt; 5000">
                            <use xlink:href="#Black Chip"
                                 transform="translate({$p1CurrentBetX - 45} {$p1CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:17px" x="{$p1CurrentBetX}" y="{$p1CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="format-number($currentBet1 div 1000 ,'##0.0' )"/>K</text>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>

                    <!-- Player 2 Chip -->
                    <xsl:variable name="currentBet2" select="players/player[2]/currentBet"/>
                    <xsl:choose>
                        <xsl:when test="$currentBet2 &lt; 101">
                            <use xlink:href="#Blue Chip"
                                 transform="translate({$p2CurrentBetX - 45} {$p2CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:20px" x="{$p2CurrentBetX}" y="{$p2CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="$currentBet2"/> </text>
                        </xsl:when>
                        <xsl:when test="$currentBet2 &lt; 501">
                            <use xlink:href="#Green Chip"
                                 transform="translate({$p2CurrentBetX - 45} {$p2CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:20px" x="{$p2CurrentBetX}" y="{$p2CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="$currentBet2"/> </text>
                        </xsl:when>
                        <xsl:when test="$currentBet2 &lt; 1000">
                            <use xlink:href="#Purple Chip"
                                 transform="translate({$p2CurrentBetX - 45} {$p2CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:20px" x="{$p2CurrentBetX}" y="{$p2CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="$currentBet2"/> </text>
                        </xsl:when>
                        <xsl:when test="$currentBet2 &lt; 5001">
                            <use xlink:href="#Red Chip"
                                 transform="translate({$p2CurrentBetX - 45} {$p2CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:17px" x="{$p2CurrentBetX}" y="{$p2CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="format-number($currentBet2 div 1000 ,'##0.0' )"/>K</text>
                        </xsl:when>
                        <xsl:when test="$currentBet2 &gt; 5000">
                            <use xlink:href="#Black Chip"
                                 transform="translate({$p2CurrentBetX - 45} {$p2CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:17px" x="{$p2CurrentBetX}" y="{$p2CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="format-number($currentBet2 div 1000 ,'##0.0' )"/>K</text>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>

                    <!-- Player 3 Chip -->
                    <xsl:variable name="currentBet3" select="players/player[3]/currentBet"/>
                    <xsl:choose>
                        <xsl:when test="$currentBet3 &lt; 101">
                            <use xlink:href="#Blue Chip"
                                 transform="translate({$p3CurrentBetX - 45} {$p3CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:20px" x="{$p3CurrentBetX}" y="{$p3CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="$currentBet3"/> </text>
                        </xsl:when>
                        <xsl:when test="$currentBet3 &lt; 501">
                            <use xlink:href="#Green Chip"
                                 transform="translate({$p3CurrentBetX - 45} {$p3CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:20px" x="{$p3CurrentBetX}" y="{$p3CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="$currentBet3"/> </text>
                        </xsl:when>
                        <xsl:when test="$currentBet3 &lt; 1000">
                            <use xlink:href="#Purple Chip"
                                 transform="translate({$p3CurrentBetX - 45} {$p3CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:20px" x="{$p3CurrentBetX}" y="{$p3CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="$currentBet3"/> </text>
                        </xsl:when>
                        <xsl:when test="$currentBet3 &lt; 5001">
                            <use xlink:href="#Red Chip"
                                 transform="translate({$p3CurrentBetX - 45} {$p3CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:17px" x="{$p3CurrentBetX}" y="{$p3CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="format-number($currentBet3 div 1000 ,'##0.0' )"/>K</text>
                        </xsl:when>
                        <xsl:when test="$currentBet3 &gt; 5000">
                            <use xlink:href="#Black Chip"
                                 transform="translate({$p3CurrentBetX - 45} {$p3CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:17px" x="{$p3CurrentBetX}" y="{$p3CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="format-number($currentBet3 div 1000 ,'##0.0' )"/>K</text>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>

                    <!-- Player 4 Chip -->
                    <xsl:variable name="currentBet4" select="players/player[4]/currentBet"/>
                    <xsl:choose>
                        <xsl:when test="$currentBet4 &lt; 101">
                            <use xlink:href="#Blue Chip"
                                 transform="translate({$p4CurrentBetX - 45} {$p4CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:20px" x="{$p4CurrentBetX}" y="{$p4CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="$currentBet4"/> </text>
                        </xsl:when>
                        <xsl:when test="$currentBet4 &lt; 501">
                            <use xlink:href="#Green Chip"
                                 transform="translate({$p4CurrentBetX - 45} {$p4CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:20px" x="{$p4CurrentBetX}" y="{$p4CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="$currentBet4"/> </text>
                        </xsl:when>
                        <xsl:when test="$currentBet4 &lt; 1000">
                            <use xlink:href="#Purple Chip"
                                 transform="translate({$p4CurrentBetX - 45} {$p4CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:20px" x="{$p4CurrentBetX}" y="{$p4CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="$currentBet4"/> </text>
                        </xsl:when>
                        <xsl:when test="$currentBet4 &lt; 5001">
                            <use xlink:href="#Red Chip"
                                 transform="translate({$p4CurrentBetX - 45} {$p4CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:17px" x="{$p4CurrentBetX}" y="{$p4CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="format-number($currentBet4 div 1000 ,'##0.0' )"/>K</text>
                        </xsl:when>
                        <xsl:when test="$currentBet4 &gt; 5000">
                            <use xlink:href="#Black Chip"
                                 transform="translate({$p4CurrentBetX - 45} {$p4CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:17px" x="{$p4CurrentBetX}" y="{$p4CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="format-number($currentBet4 div 1000 ,'##0.0' )"/>K</text>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>

                    <!-- Player 5 Chip -->
                    <xsl:variable name="currentBet5" select="players/player[5]/currentBet"/>
                    <xsl:choose>
                        <xsl:when test="$currentBet5 &lt; 101">
                            <use xlink:href="#Blue Chip"
                                 transform="translate({$p5CurrentBetX - 45} {$p5CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:20px" x="{$p5CurrentBetX}" y="{$p5CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="$currentBet5"/> </text>
                        </xsl:when>
                        <xsl:when test="$currentBet5 &lt; 501">
                            <use xlink:href="#Green Chip"
                                 transform="translate({$p5CurrentBetX - 45} {$p5CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:20px" x="{$p5CurrentBetX}" y="{$p5CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="$currentBet5"/> </text>
                        </xsl:when>
                        <xsl:when test="$currentBet5 &lt; 1000">
                            <use xlink:href="#Purple Chip"
                                 transform="translate({$p5CurrentBetX - 45} {$p5CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:20px" x="{$p5CurrentBetX}" y="{$p5CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="$currentBet5"/> </text>
                        </xsl:when>
                        <xsl:when test="$currentBet5 &lt; 5001">
                            <use xlink:href="#Red Chip"
                                 transform="translate({$p5CurrentBetX - 45} {$p5CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:17px" x="{$p5CurrentBetX}" y="{$p5CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="format-number($currentBet5 div 1000 ,'##0.0' )"/>K</text>
                        </xsl:when>
                        <xsl:when test="$currentBet5 &gt; 5000">
                            <use xlink:href="#Black Chip"
                                 transform="translate({$p5CurrentBetX - 45} {$p5CurrentBetY - 45}) scale(0.09, 0.09)"/>
                            <text fill="white" style="font-size:17px" x="{$p5CurrentBetX}" y="{$p5CurrentBetY + 6}" text-anchor="middle"><xsl:value-of select="format-number($currentBet5 div 1000 ,'##0.0' )"/>K</text>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                <xsl:choose>
                    <xsl:when
                            test="$isInsurance='true' and $state='play' and players/player[id = $activePlayer]/insurance/text() = 'false'">
                        <!-- Only for when the insurance flag is setted to true -->
                        <foreignObject width="7%" height="13%" x="{$button4x}"
                                       y="{$buttonsY}">
                            <form xmlns="http://www.w3.org/1999/xhtml" action="/xLinkbj/setInsurance/{$gameID}"
                                  id="formInsurance"
                                  method="POST" target="hiddenFrame">
                                <button class="buttonInsurance" type="submit" form="formInsurance" value="Submit">Insurance
                                </button>
                            </form>
                        </foreignObject>
                    </xsl:when>
                </xsl:choose>
                </xsl:when>
            </xsl:choose>
            

            <!-- SVG definitions -->
            <defs>
                <path id="bjTextPath" d="M400,0 a80,80 0 0,0 750,0"/>
                <path id="insuranceTextPath" d="M400,50 a80,80 0 0,0 750,0"/>
                <g id="CardTemplate">
                    <rect height="{$cardHeight}" width="{$cardWidth}" rx="5" ry="5"
                          style="fill:white;stroke:black;stroke-width:2;opacity:1.0"/>
                </g>

                <g id="cardBack">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/8/87/Card_back_05.svg"
                           width="{$cardWidth}"
                           height="{$cardHeight}" x="{$cardX}" y="{$cardY}"/>
                </g>
                <!-- Symbols for upper lower corner of card -->

                <g id="Club_mini">
                    <text id="Club_symbol" x="{$symbolXMini}" y="{$symbolYMini}" font-size="{$sizeSmallSymbol}"
                          fill="black" text-anchor="middle">♣
                    </text>
                    <text id="Club_symbol_usd"
                          transform="rotate(180,{$symbolXMini - ($symbolXMini div 2)+ $xMiniAdd},{$symbolYMini - ($symbolYMini div 2)+$yMiniSymbolAddUsd})"
                          font-size="{$sizeSmallSymbol}" fill="black" text-anchor="middle">♣
                    </text>
                </g>

                <g id="Spade_mini">
                    <text id="Spade_symbol" x="{$symbolXMini}" y="{$symbolYMini}" font-size="{$sizeSmallSymbol}"
                          fill="black" text-anchor="middle">♠
                    </text>
                    <text id="Spade_symbol_usd"
                          transform="rotate(180,{$symbolXMini - ($symbolXMini div 2)+ $xMiniAdd},{$symbolYMini - ($symbolYMini div 2)+$yMiniSymbolAddUsd})"
                          font-size="{$sizeSmallSymbol}" fill="black" text-anchor="middle">♠
                    </text>
                </g>

                <g id="Heart_mini">
                    <text id="Heart_symbol" x="{$symbolXMini}" y="{$symbolYMini}" font-size="{$sizeSmallSymbol}"
                          fill="red" text-anchor="middle">♥
                    </text>
                    <text id="Heart_symbol_usd"
                          transform="rotate(180,{$symbolXMini - ($symbolXMini div 2)+ $xMiniAdd},{$symbolYMini - ($symbolYMini div 2)+$yMiniSymbolAddUsd})"
                          font-size="{$sizeSmallSymbol}" fill="red" text-anchor="middle">♥
                    </text>
                </g>

                <g id="Diamond_mini">
                    <text id="Diamond_symbol" x="{$symbolXMini}" y="{$symbolYMini}" font-size="{$sizeSmallSymbol}"
                          fill="red" text-anchor="middle">♦
                    </text>
                    <text id="Diamond_symbol_usd"
                          transform="rotate(180,{$symbolXMini - ($symbolXMini div 2)+ $xMiniAdd},{$symbolYMini - ($symbolYMini div 2)+$yMiniSymbolAddUsd})"
                          font-size="{$sizeSmallSymbol}" fill="red" text-anchor="middle">♦
                    </text>
                </g>


                <!-- Numbers for upper and lower corner of card  -->

                <g id="red-A">
                    <text id="kar" x="{$valueXMini}" y="{$valueYMini}" font-size="{$sizeValue}" fill="red"
                          text-anchor="middle">
                        A
                    </text>
                    <text id="kar_usd"
                          transform="rotate(180,{$valueXMini - ($valueXMini div 2) + $xMiniAdd},{$valueYMini - ($valueYMini div 2)+$yMiniValueAddUsd})"
                          font-size="{$sizeValue}" fill="red" text-anchor="middle">
                        A
                    </text>
                </g>

                <g id="red-2">
                    <text id="kar" x="{$valueXMini}" y="{$valueYMini}" font-size="{$sizeValue}" fill="red"
                          text-anchor="middle">
                        2
                    </text>
                    <text id="kar_usd"
                          transform="rotate(180,{$valueXMini - ($valueXMini div 2) + $xMiniAdd},{$valueYMini - ($valueYMini div 2)+$yMiniValueAddUsd})"
                          font-size="{$sizeValue}" fill="red" text-anchor="middle">
                        2
                    </text>
                </g>

                <g id="red-3">
                    <text id="kar" x="{$valueXMini}" y="{$valueYMini}" font-size="{$sizeValue}" fill="red"
                          text-anchor="middle">
                        3
                    </text>
                    <text id="kar_usd"
                          transform="rotate(180,{$valueXMini - ($valueXMini div 2) + $xMiniAdd},{$valueYMini - ($valueYMini div 2)+$yMiniValueAddUsd})"
                          font-size="{$sizeValue}" fill="red" text-anchor="middle">
                        3
                    </text>
                </g>

                <g id="red-4">
                    <text id="kar" x="{$valueXMini}" y="{$valueYMini}" font-size="{$sizeValue}" fill="red"
                          text-anchor="middle">
                        4
                    </text>
                    <text id="kar_usd"
                          transform="rotate(180,{$valueXMini - ($valueXMini div 2) + $xMiniAdd},{$valueYMini - ($valueYMini div 2)+$yMiniValueAddUsd})"
                          font-size="{$sizeValue}" fill="red" text-anchor="middle">
                        4
                    </text>
                </g>

                <g id="red-5">
                    <text id="kar" x="{$valueXMini}" y="{$valueYMini}" font-size="{$sizeValue}" fill="red"
                          text-anchor="middle">
                        5
                    </text>
                    <text id="kar_usd"
                          transform="rotate(180,{$valueXMini - ($valueXMini div 2) + $xMiniAdd},{$valueYMini - ($valueYMini div 2)+$yMiniValueAddUsd})"
                          font-size="{$sizeValue}" fill="red" text-anchor="middle">
                        5
                    </text>
                </g>

                <g id="red-6">
                    <text id="kar" x="{$valueXMini}" y="{$valueYMini}" font-size="{$sizeValue}" fill="red"
                          text-anchor="middle">
                        6
                    </text>
                    <text id="kar_usd"
                          transform="rotate(180,{$valueXMini - ($valueXMini div 2) + $xMiniAdd},{$valueYMini - ($valueYMini div 2)+$yMiniValueAddUsd})"
                          font-size="{$sizeValue}" fill="red" text-anchor="middle">
                        6
                    </text>
                </g>

                <g id="red-7">
                    <text id="kar" x="{$valueXMini}" y="{$valueYMini}" font-size="{$sizeValue}" fill="red"
                          text-anchor="middle">
                        7
                    </text>
                    <text id="kar_usd"
                          transform="rotate(180,{$valueXMini - ($valueXMini div 2) + $xMiniAdd},{$valueYMini - ($valueYMini div 2)+$yMiniValueAddUsd})"
                          font-size="{$sizeValue}" fill="red" text-anchor="middle">
                        7
                    </text>
                </g>

                <g id="red-8">
                    <text id="kar" x="{$valueXMini}" y="{$valueYMini}" font-size="{$sizeValue}" fill="red"
                          text-anchor="middle">
                        8
                    </text>
                    <text id="kar_usd"
                          transform="rotate(180,{$valueXMini - ($valueXMini div 2) + $xMiniAdd},{$valueYMini - ($valueYMini div 2)+$yMiniValueAddUsd})"
                          font-size="{$sizeValue}" fill="red" text-anchor="middle">
                        8
                    </text>
                </g>

                <g id="red-9">
                    <text id="kar" x="{$valueXMini}" y="{$valueYMini}" font-size="{$sizeValue}" fill="red"
                          text-anchor="middle">
                        9
                    </text>
                    <text id="kar_usd"
                          transform="rotate(180,{$valueXMini - ($valueXMini div 2) + $xMiniAdd},{$valueYMini - ($valueYMini div 2)+$yMiniValueAddUsd})"
                          font-size="{$sizeValue}" fill="red" text-anchor="middle">
                        9
                    </text>
                </g>

                <g id="red-10">
                    <text id="kar" x="{$valueXMini}" y="{$valueYMini}" font-size="{$sizeValue}" fill="red"
                          text-anchor="middle">
                        10
                    </text>
                    <text id="kar_usd"
                          transform="rotate(180,{$valueXMini - ($valueXMini div 2) + $xMiniAdd},{$valueYMini - ($valueYMini div 2)+$yMiniValueAddUsd})"
                          font-size="{$sizeValue}" fill="red" text-anchor="middle">
                        10
                    </text>
                </g>

                <g id="black-A">
                    <text id="kar" x="{$valueXMini}" y="{$valueYMini}" font-size="{$sizeValue}" fill="black"
                          text-anchor="middle">
                        A
                    </text>
                    <text id="kar_usd"
                          transform="rotate(180,{$valueXMini - ($valueXMini div 2) + $xMiniAdd},{$valueYMini - ($valueYMini div 2)+$yMiniValueAddUsd})"
                          font-size="{$sizeValue}" fill="black" text-anchor="middle">
                        A
                    </text>
                </g>

                <g id="black-2">
                    <text id="kar" x="{$valueXMini}" y="{$valueYMini}" font-size="{$sizeValue}" fill="black"
                          text-anchor="middle">
                        2
                    </text>
                    <text id="kar_usd"
                          transform="rotate(180,{$valueXMini - ($valueXMini div 2) + $xMiniAdd},{$valueYMini - ($valueYMini div 2)+$yMiniValueAddUsd})"
                          font-size="{$sizeValue}" fill="black" text-anchor="middle">
                        2
                    </text>
                </g>

                <g id="black-3">
                    <text id="kar" x="{$valueXMini}" y="{$valueYMini}" font-size="{$sizeValue}" fill="black"
                          text-anchor="middle">
                        3
                    </text>
                    <text id="kar_usd"
                          transform="rotate(180,{$valueXMini - ($valueXMini div 2) + $xMiniAdd},{$valueYMini - ($valueYMini div 2)+$yMiniValueAddUsd})"
                          font-size="{$sizeValue}" fill="black" text-anchor="middle">
                        3
                    </text>
                </g>

                <g id="black-4">
                    <text id="kar" x="{$valueXMini}" y="{$valueYMini}" font-size="{$sizeValue}" fill="black"
                          text-anchor="middle">
                        4
                    </text>
                    <text id="kar_usd"
                          transform="rotate(180,{$valueXMini - ($valueXMini div 2) + $xMiniAdd},{$valueYMini - ($valueYMini div 2)+$yMiniValueAddUsd})"
                          font-size="{$sizeValue}" fill="black" text-anchor="middle">
                        4
                    </text>
                </g>

                <g id="black-5">
                    <text id="kar" x="{$valueXMini}" y="{$valueYMini}" font-size="{$sizeValue}" fill="black"
                          text-anchor="middle">
                        5
                    </text>
                    <text id="kar_usd"
                          transform="rotate(180,{$valueXMini - ($valueXMini div 2) + $xMiniAdd},{$valueYMini - ($valueYMini div 2)+$yMiniValueAddUsd})"
                          font-size="{$sizeValue}" fill="black" text-anchor="middle">
                        5
                    </text>
                </g>

                <g id="black-6">
                    <text id="kar" x="{$valueXMini}" y="{$valueYMini}" font-size="{$sizeValue}" fill="black"
                          text-anchor="middle">
                        6
                    </text>
                    <text id="kar_usd"
                          transform="rotate(180,{$valueXMini - ($valueXMini div 2) + $xMiniAdd},{$valueYMini - ($valueYMini div 2)+$yMiniValueAddUsd})"
                          font-size="{$sizeValue}" fill="black" text-anchor="middle">
                        6
                    </text>
                </g>

                <g id="black-7">
                    <text id="kar" x="{$valueXMini}" y="{$valueYMini}" font-size="{$sizeValue}" fill="black"
                          text-anchor="middle">
                        7
                    </text>
                    <text id="kar_usd"
                          transform="rotate(180,{$valueXMini - ($valueXMini div 2) + $xMiniAdd},{$valueYMini - ($valueYMini div 2)+$yMiniValueAddUsd})"
                          font-size="{$sizeValue}" fill="black" text-anchor="middle">
                        7
                    </text>
                </g>

                <g id="black-8">
                    <text id="kar" x="{$valueXMini}" y="{$valueYMini}" font-size="{$sizeValue}" fill="black"
                          text-anchor="middle">
                        8
                    </text>
                    <text id="kar_usd"
                          transform="rotate(180,{$valueXMini - ($valueXMini div 2) + $xMiniAdd},{$valueYMini - ($valueYMini div 2)+$yMiniValueAddUsd})"
                          font-size="{$sizeValue}" fill="black" text-anchor="middle">
                        8
                    </text>
                </g>

                <g id="black-9">
                    <text id="kar" x="{$valueXMini}" y="{$valueYMini}" font-size="{$sizeValue}" fill="black"
                          text-anchor="middle">
                        9
                    </text>
                    <text id="kar_usd"
                          transform="rotate(180,{$valueXMini - ($valueXMini div 2) + $xMiniAdd},{$valueYMini - ($valueYMini div 2)+$yMiniValueAddUsd})"
                          font-size="{$sizeValue}" fill="black" text-anchor="middle">
                        9
                    </text>
                </g>

                <g id="black-10">
                    <text id="kar" x="{$valueXMini}" y="{$valueYMini}" font-size="{$sizeValue}" fill="black"
                          text-anchor="middle">
                        10
                    </text>
                    <text id="kar_usd"
                          transform="rotate(180,{$valueXMini - ($valueXMini div 2) + $xMiniAdd},{$valueYMini - ($valueYMini div 2)+$yMiniValueAddUsd})"
                          font-size="{$sizeValue}" fill="black" text-anchor="middle">
                        10
                    </text>
                </g>

                <g id="Diamond-K">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/0/06/KD.svg" width="{$cardWidth}"
                           height="{$cardHeight}" x="{$cardX}" y="{$cardY}"/>
                </g>

                <g id="Diamond-D">

                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/6/63/QD.svg" width="{$cardWidth}"
                           height="{$cardHeight}" x="{$cardX}" y="{$cardY}"/>
                </g>

                <g id="Diamond-B">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/3/33/JD.svg" width="{$cardWidth}"
                           height="{$cardHeight}" x="{$cardX}" y="{$cardY}"/>
                </g>

                <g id="Heart-K">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/e/e5/KH.svg" width="{$cardWidth}"
                           height="{$cardHeight}" x="{$cardX}" y="{$cardY}"/>
                </g>

                <g id="Heart-D">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/d/d2/QH.svg" width="{$cardWidth}"
                           height="{$cardHeight}" x="{$cardX}" y="{$cardY}"/>
                </g>

                <g id="Heart-B">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/1/15/JH.svg" width="{$cardWidth}"
                           height="{$cardHeight}" x="{$cardX}" y="{$cardY}"/>
                </g>

                <g id="Club-K">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/e/e1/KC.svg" width="{$cardWidth}"
                           height="{$cardHeight}" x="{$cardX}" y="{$cardY}"/>
                </g>

                <g id="Club-D">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/9/9e/QC.svg" width="{$cardWidth}"
                           height="{$cardHeight}" x="{$cardX}" y="{$cardY}"/>
                </g>

                <g id="Club-B">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/1/11/JC.svg" width="{$cardWidth}"
                           height="{$cardHeight}" x="{$cardX}" y="{$cardY}"/>
                </g>

                <g id="Spade-K">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/5/5c/KS.svg" width="{$cardWidth}"
                           height="{$cardHeight}" x="{$cardX}" y="{$cardY}"/>
                </g>

                <g id="Spade-D">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/3/35/QS.svg" width="{$cardWidth}"
                           height="{$cardHeight}" x="{$cardX}" y="{$cardY}"/>
                </g>

                <g id="Spade-B">
                    <image xlink:href="https://upload.wikimedia.org/wikipedia/commons/d/d9/JS.svg" width="{$cardWidth}"
                           height="{$cardHeight}" x="{$cardX}" y="{$cardY}"/>
                </g>

                <!-- all Spades -->

                <g id="Spade-A">
                    <text x="{$xCardMid}" y="{$yAceSymbol}" font-size="{$sizeAceSymbol}" fill="black"
                          text-anchor="middle">♠
                    </text>
                </g>


                <g id="Spade-2">
                    <text id="Spade_symbol_big" x="{$xCardMid}" y="{$yBigSymbolTop}" font-size="{$sizeBigSymbol}"
                          fill="black" text-anchor="middle">♠
                    </text>
                    <!-- Das Symbol an der Y achse spiegeln -->
                    <text id="Spade_symbol_big_usd"
                          transform="rotate(180,{$symbolRotationX - ($symbolRotationX div 2)},{$symbolRotationY - ($symbolRotationY div 2)+$yBigSymbolUsdBotAdd})"
                          font-size="{$sizeBigSymbol}" fill="black" text-anchor="middle">♠
                    </text>
                </g>


                <g id="Spade-3">
                    <use xlink:href="#Spade-2"/>
                    <use xlink:href="#Spade_symbol_big" x="0" y="{$yBigSymbolTopToMid}"/>
                </g>

                <g id="Spade-4">
                    <use xlink:href="#Spade-2" transform="translate(-{$xBigSymbolMidToEdge}, 0)"/>
                    <use xlink:href="#Spade-2" transform="translate({$xBigSymbolMidToEdge}, 0)"/>
                </g>

                <g id="Spade-5">
                    <use xlink:href="#Spade-4"/>
                    <use xlink:href="#Spade_symbol_big" x="0" y="{$yBigSymbolTopToMid}"/>
                </g>

                <g id="Spade-6">
                    <use xlink:href="#Spade-3" transform="translate(-{$xBigSymbolMidToEdge},0)"/>
                    <use xlink:href="#Spade-3" transform="translate({$xBigSymbolMidToEdge},0)"/>
                </g>

                <g id="Spade-7">
                    <use xlink:href="#Spade-6"/>
                    <use xlink:href="#Spade_symbol_big" x="0" y="{$yBigSymbolTopToMid div 2}"/>
                </g>

                <g id="Spade-8">
                    <use xlink:href="#Spade-7"/>
                    <use xlink:href="#Spade_symbol_big_usd" x="0" y="-{$yBigSymbolTopToMid div 2}"/>
                </g>

                <g id="Spade-9">
                    <use xlink:href="#Spade-5"/>
                    <g id="Spade_Doppel">
                        <g id="Spade_Einzel">
                            <use xlink:href="#Spade_symbol_big" x="-{$xBigSymbolMidToEdge}" y="{$yBigSymbolNineSide}"/>
                            <use xlink:href="#Spade_symbol_big_usd" x="-{$xBigSymbolMidToEdge}"
                                 y="-{$yBigSymbolNineSide}"/>
                        </g>
                        <use xlink:href="#Spade_Einzel" transform="translate({($xBigSymbolMidToEdge *2)},0)"/>
                    </g>
                </g>

                <g id="Spade-10">
                    <use xlink:href="#Spade-4"/>
                    <use xlink:href="#Spade_Doppel"/>
                    <use xlink:href="#Spade_symbol_big" x="0" y="{$yBigSymbolTenMid}"/>
                    <use xlink:href="#Spade_symbol_big_usd" x="0" y="-{$yBigSymbolTenMid}"/>
                </g>


                <!-- all Clubs -->

                <g id="Club-A">
                    <text x="{$xCardMid}" y="{$yAceSymbol}" font-size="{$sizeAceSymbol}" fill="black"
                          text-anchor="middle">♣
                    </text>
                </g>


                <g id="Club-2">
                    <text id="Club_symbol_big" x="{$xCardMid}" y="{$yBigSymbolTop}" font-size="{$sizeBigSymbol}"
                          fill="black" text-anchor="middle">♣
                    </text>
                    <!-- Das Symbol an der Y achse spiegeln -->
                    <text id="Club_symbol_big_usd"
                          transform="rotate(180,{$symbolRotationX - ($symbolRotationX div 2)},{$symbolRotationY - ($symbolRotationY div 2)+$yBigSymbolUsdBotAdd})"
                          font-size="{$sizeBigSymbol}" fill="black" text-anchor="middle">♣
                    </text>
                </g>


                <g id="Club-3">
                    <use xlink:href="#Club-2"/>
                    <use xlink:href="#Club_symbol_big" x="0" y="{$yBigSymbolTopToMid}"/>
                </g>

                <g id="Club-4">
                    <use xlink:href="#Club-2" transform="translate(-{$xBigSymbolMidToEdge}, 0)"/>
                    <use xlink:href="#Club-2" transform="translate({$xBigSymbolMidToEdge}, 0)"/>
                </g>

                <g id="Club-5">
                    <use xlink:href="#Club-4"/>
                    <use xlink:href="#Club_symbol_big" x="0" y="{$yBigSymbolTopToMid}"/>
                </g>

                <g id="Club-6">
                    <use xlink:href="#Club-3" transform="translate(-{$xBigSymbolMidToEdge},0)"/>
                    <use xlink:href="#Club-3" transform="translate({$xBigSymbolMidToEdge},0)"/>
                </g>

                <g id="Club-7">
                    <use xlink:href="#Club-6"/>
                    <use xlink:href="#Club_symbol_big" x="0" y="{$yBigSymbolTopToMid div 2}"/>
                </g>

                <g id="Club-8">
                    <use xlink:href="#Club-7"/>
                    <use xlink:href="#Club_symbol_big_usd" x="0" y="-{$yBigSymbolTopToMid div 2}"/>
                </g>

                <g id="Club-9">
                    <use xlink:href="#Club-5"/>
                    <g id="Club_Doppel">
                        <g id="Club_Einzel">
                            <use xlink:href="#Club_symbol_big" x="-{$xBigSymbolMidToEdge}" y="{$yBigSymbolNineSide}"/>
                            <use xlink:href="#Club_symbol_big_usd" x="-{$xBigSymbolMidToEdge}"
                                 y="-{$yBigSymbolNineSide}"/>
                        </g>
                        <use xlink:href="#Club_Einzel" transform="translate({($xBigSymbolMidToEdge *2)},0)"/>
                    </g>
                </g>

                <g id="Club-10">
                    <use xlink:href="#Club-4"/>
                    <use xlink:href="#Club_Doppel"/>
                    <use xlink:href="#Club_symbol_big" x="0" y="{$yBigSymbolTenMid}"/>
                    <use xlink:href="#Club_symbol_big_usd" x="0" y="-{$yBigSymbolTenMid}"/>
                    <text id="kar" x="{$valueXMini}" y="{$valueYMini}" font-size="{$sizeValue}" fill="black"
                          text-anchor="middle">
                        10
                    </text>
                    <text id="kar_usd"
                          transform="rotate(180,{$valueXMini - ($valueXMini div 2) + $xMiniAdd},{$valueYMini - ($valueYMini div 2)+$yMiniValueAddUsd})"
                          font-size="{$sizeValue}" fill="black" text-anchor="middle">
                        10
                    </text>

                </g>

                <!-- all Hearts -->


                <g id="Heart-A">
                    <text x="{$xCardMid}" y="{$yAceSymbol}" font-size="{$sizeAceSymbol}" fill="red"
                          text-anchor="middle">♥
                    </text>
                </g>

                <g id="Heart-2">
                    <text id="Heart_symbol_big" x="{$xCardMid}" y="{$yBigSymbolTop}" font-size="{$sizeBigSymbol}"
                          fill="red" text-anchor="middle">♥
                    </text>
                    <!-- Das Symbol an der Y achse spiegeln -->
                    <text id="Heart_symbol_big_usd"
                          transform="rotate(180,{$symbolRotationX - ($symbolRotationX div 2)},{$symbolRotationY - ($symbolRotationY div 2)+$yBigSymbolUsdBotAdd})"
                          font-size="{$sizeBigSymbol}" fill="red" text-anchor="middle">♥
                    </text>
                </g>


                <g id="Heart-3">
                    <use xlink:href="#Heart-2"/>
                    <use xlink:href="#Heart_symbol_big" x="0" y="{$yBigSymbolTopToMid}"/>
                </g>

                <g id="Heart-4">
                    <use xlink:href="#Heart-2" transform="translate(-{$xBigSymbolMidToEdge}, 0)"/>
                    <use xlink:href="#Heart-2" transform="translate({$xBigSymbolMidToEdge}, 0)"/>
                </g>

                <g id="Heart-5">
                    <use xlink:href="#Heart-4"/>
                    <use xlink:href="#Heart_symbol_big" x="0" y="{$yBigSymbolTopToMid}"/>
                </g>

                <g id="Heart-6">
                    <use xlink:href="#Heart-3" transform="translate(-{$xBigSymbolMidToEdge},0)"/>
                    <use xlink:href="#Heart-3" transform="translate({$xBigSymbolMidToEdge},0)"/>
                </g>

                <g id="Heart-7">
                    <use xlink:href="#Heart-6"/>
                    <use xlink:href="#Heart_symbol_big" x="0" y="{$yBigSymbolTopToMid div 2}"/>
                </g>

                <g id="Heart-8">
                    <use xlink:href="#Heart-7"/>
                    <use xlink:href="#Heart_symbol_big_usd" x="0" y="-{$yBigSymbolTopToMid div 2}"/>
                </g>

                <g id="Heart-9">
                    <use xlink:href="#Heart-5"/>
                    <g id="Heart_Doppel">
                        <g id="Heart_Einzel">
                            <use xlink:href="#Heart_symbol_big" x="-{$xBigSymbolMidToEdge}" y="{$yBigSymbolNineSide}"/>
                            <use xlink:href="#Heart_symbol_big_usd" x="-{$xBigSymbolMidToEdge}"
                                 y="-{$yBigSymbolNineSide}"/>
                        </g>
                        <use xlink:href="#Heart_Einzel" transform="translate({($xBigSymbolMidToEdge *2)},0)"/>
                    </g>
                </g>

                <g id="Heart-10">
                    <use xlink:href="#Heart-4"/>
                    <use xlink:href="#Heart_Doppel"/>
                    <use xlink:href="#Heart_symbol_big" x="0" y="{$yBigSymbolTenMid}"/>
                    <use xlink:href="#Heart_symbol_big_usd" x="0" y="-{$yBigSymbolTenMid}"/>
                </g>


                <!-- all Diamonds -->

                <g id="Diamond-A">
                    <text x="{$xCardMid}" y="{$yAceSymbol}" font-size="{$sizeAceSymbol}" fill="red"
                          text-anchor="middle">♦
                    </text>
                </g>


                <g id="Diamond-2">
                    <text id="Diamond_symbol_big" x="{$xCardMid}" y="{$yBigSymbolTop}" font-size="{$sizeBigSymbol}"
                          fill="red" text-anchor="middle">♦
                    </text>
                    <!-- Das Symbol an der Y achse spiegeln -->
                    <text id="Diamond_symbol_big_usd"
                          transform="rotate(180,{$symbolRotationX - ($symbolRotationX div 2)},{$symbolRotationY - ($symbolRotationY div 2)+$yBigSymbolUsdBotAdd})"
                          font-size="{$sizeBigSymbol}" fill="red" text-anchor="middle">♦
                    </text>
                </g>


                <g id="Diamond-3">
                    <use xlink:href="#Diamond-2"/>
                    <use xlink:href="#Diamond_symbol_big" x="0" y="{$yBigSymbolTopToMid}"/>
                </g>

                <g id="Diamond-4">
                    <use xlink:href="#Diamond-2" transform="translate(-{$xBigSymbolMidToEdge}, 0)"/>
                    <use xlink:href="#Diamond-2" transform="translate({$xBigSymbolMidToEdge}, 0)"/>
                </g>

                <g id="Diamond-5">
                    <use xlink:href="#Diamond-4"/>
                    <use xlink:href="#Diamond_symbol_big" x="0" y="{$yBigSymbolTopToMid}"/>
                </g>

                <g id="Diamond-6">
                    <use xlink:href="#Diamond-3" transform="translate(-{$xBigSymbolMidToEdge},0)"/>
                    <use xlink:href="#Diamond-3" transform="translate({$xBigSymbolMidToEdge},0)"/>
                </g>

                <g id="Diamond-7">
                    <use xlink:href="#Diamond-6"/>
                    <use xlink:href="#Diamond_symbol_big" x="0" y="{$yBigSymbolTopToMid div 2}"/>
                </g>

                <g id="Diamond-8">
                    <use xlink:href="#Diamond-7"/>
                    <use xlink:href="#Diamond_symbol_big_usd" x="0" y="-{$yBigSymbolTopToMid div 2}"/>
                </g>

                <g id="Diamond-9">
                    <use xlink:href="#Diamond-5"/>
                    <g id="Diamond_Doppel">
                        <g id="Diamond_Einzel">
                            <use xlink:href="#Diamond_symbol_big" x="-{$xBigSymbolMidToEdge}"
                                 y="{$yBigSymbolNineSide}"/>
                            <use xlink:href="#Diamond_symbol_big_usd" x="-{$xBigSymbolMidToEdge}"
                                 y="-{$yBigSymbolNineSide}"/>
                        </g>
                        <use xlink:href="#Diamond_Einzel" transform="translate({($xBigSymbolMidToEdge *2)},0)"/>
                    </g>
                </g>

                <g id="Diamond-10">
                    <use xlink:href="#Diamond-4"/>
                    <use xlink:href="#Diamond_Doppel"/>
                    <use xlink:href="#Diamond_symbol_big" x="0" y="{$yBigSymbolTenMid}"/>
                    <use xlink:href="#Diamond_symbol_big_usd" x="0" y="-{$yBigSymbolTenMid}"/>
                </g>


                <!-- Chip definitions -->
                <g id="panel">

                    <path d="M500 100 V 180  C 600 180, 650 210 ,700 250 C 570 150, 610 180 , 752 190" fill="white"
                          stroke="white"/>
                </g>
                <g id="panel2" transform="rotate(70 500 500)">
                    <use xlink:href="#panel"/>
                </g>

                <g id="panel3" transform="rotate(140 500 500)">
                    <use xlink:href="#panel"/>
                </g>

                <g id="Black Chip">
                    <circle cx="500" cy="500" r="400" fill="black"/>
                    <circle cx="500" cy="500" r="290" fill="white"/>
                    <circle cx="500" cy="500" r="280" fill="black"/>
                    <use xlink:href="#panel"/>
                    <use xlink:href="#panel2"/>
                    <use xlink:href="#panel3"/>
                    <use xlink:href="#panel3" transform="rotate(144 500 500)"/>
                    <use xlink:href="#panel3" transform="rotate(72 500 500)"/>
                </g>

                <g id="Red Chip">
                    <circle cx="500" cy="500" r="400" fill="darkred"/>
                    <circle cx="500" cy="500" r="290" fill="white"/>
                    <circle cx="500" cy="500" r="280" fill="darkred"/>
                    <use xlink:href="#panel"/>
                    <use xlink:href="#panel2"/>
                    <use xlink:href="#panel3"/>
                    <use xlink:href="#panel3" transform="rotate(144 500 500)"/>
                    <use xlink:href="#panel3" transform="rotate(72 500 500)"/>
                </g>

                <g id="Green Chip">
                    <circle cx="500" cy="500" r="400" fill="darkgreen"/>
                    <circle cx="500" cy="500" r="290" fill="white"/>
                    <circle cx="500" cy="500" r="280" fill="darkgreen"/>
                    <use xlink:href="#panel"/>
                    <use xlink:href="#panel2"/>
                    <use xlink:href="#panel3"/>
                    <use xlink:href="#panel3" transform="rotate(144 500 500)"/>
                    <use xlink:href="#panel3" transform="rotate(72 500 500)"/>
                </g>

                <g id="Purple Chip">
                    <circle cx="500" cy="500" r="400" fill="purple"/>
                    <circle cx="500" cy="500" r="290" fill="white"/>
                    <circle cx="500" cy="500" r="280" fill="purple"/>
                    <use xlink:href="#panel"/>
                    <use xlink:href="#panel2"/>
                    <use xlink:href="#panel3"/>
                    <use xlink:href="#panel3" transform="rotate(144 500 500)"/>
                    <use xlink:href="#panel3" transform="rotate(72 500 500)"/>
                </g>

                <g id="Blue Chip">
                    <circle cx="500" cy="500" r="400" fill="darkblue"/>
                    <circle cx="500" cy="500" r="290" fill="white"/>
                    <circle cx="500" cy="500" r="280" fill="darkblue"/>
                    <use xlink:href="#panel"/>
                    <use xlink:href="#panel2"/>
                    <use xlink:href="#panel3"/>
                    <use xlink:href="#panel3" transform="rotate(144 500 500)"/>
                    <use xlink:href="#panel3" transform="rotate(72 500 500)"/>
                </g>


            </defs>

            <!-- Drawing the cards -->

            <!-- Dealer -->

            <xsl:for-each select="$dealer/currentHand/card">
                <xsl:variable name="value" select="value"/>
                <xsl:variable name="color" select="color"/>
                <xsl:variable name="counter" select="position()-1"/>
                <xsl:variable name="turned" select="turned"/>

                <use x="{$cardDealerX + $counter* $cardSpacing}" y="{$cardDealerY}" xlink:href="#CardTemplate"/>

                <xsl:choose>
                    <xsl:when test="$turned = 'true'">
                        <use x="{$cardDealerX + $counter * $cardSpacing}" y="{$cardDealerY}" xlink:href="#cardBack"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$value = 'K' or $value = 'Q' or $value = 'B'">
                                <use x="{$cardDealerX + $counter * $cardSpacing}" y="{$cardDealerY}"
                                     xlink:href="#{$color}-{$value}"/>
                            </xsl:when>
                            <xsl:when test="$color = 'Spade'">
                                <use x="{$cardDealerX + $counter * $cardSpacing}" y="{$cardDealerY}"
                                     xlink:href="#{$color}-{$value}"/>
                                <use x="{$cardDealerX + $counter * $cardSpacing}" y="{$cardDealerY}"
                                     xlink:href="#black-{$value}"/>
                                <use x="{$cardDealerX + $counter * $cardSpacing}" y="{$cardDealerY}"
                                     xlink:href="#Spade_mini"/>
                            </xsl:when>
                            <xsl:when test="$color = 'Club'">
                                <use x="{$cardDealerX + $counter * $cardSpacing}" y="{$cardDealerY}"
                                     xlink:href="#{$color}-{$value}"/>
                                <use x="{$cardDealerX + $counter * $cardSpacing}" y="{$cardDealerY}"
                                     xlink:href="#black-{$value}"/>
                                <use x="{$cardDealerX + $counter * $cardSpacing}" y="{$cardDealerY}"
                                     xlink:href="#Club_mini"/>
                            </xsl:when>
                            <xsl:when test="$color = 'Heart'">
                                <use x="{$cardDealerX + $counter * $cardSpacing}" y="{$cardDealerY}"
                                     xlink:href="#{$color}-{$value}"/>
                                <use x="{$cardDealerX + $counter * $cardSpacing}" y="{$cardDealerY}"
                                     xlink:href="#red-{$value}"/>
                                <use x="{$cardDealerX + $counter * $cardSpacing}" y="{$cardDealerY}"
                                     xlink:href="#Heart_mini"/>
                            </xsl:when>
                            <xsl:when test="$color = 'Diamond'">
                                <use x="{$cardDealerX + $counter * $cardSpacing}" y="{$cardDealerY}"
                                     xlink:href="#{$color}-{$value}"/>
                                <use x="{$cardDealerX + $counter * $cardSpacing}" y="{$cardDealerY}"
                                     xlink:href="#red-{$value}"/>
                                <use x="{$cardDealerX + $counter * $cardSpacing}" y="{$cardDealerY}"
                                     xlink:href="#Diamond_mini"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>


            </xsl:for-each>

            <!-- Player 1 -->
            <xsl:for-each select="$player1/currentHand/cards/card">
                <xsl:variable name="value" select="value"/>
                <xsl:variable name="color" select="color"/>
                <xsl:variable name="counter" select="position()-1"/>


                <use x="{$cardPlayer1x + $counter* $cardSpacing}" y="{$cardPlayer1y}" xlink:href="#CardTemplate"/>
                <xsl:choose>
                    <xsl:when test="$value = 'K' or $value = 'Q' or $value = 'B'">
                        <use x="{$cardPlayer1x + $counter * $cardSpacing}" y="{$cardPlayer1y}"
                             xlink:href="#{$color}-{$value}"/>
                    </xsl:when>
                    <xsl:when test="$color = 'Spade'">
                        <use x="{$cardPlayer1x + $counter * $cardSpacing}" y="{$cardPlayer1y}"
                             xlink:href="#{$color}-{$value}"/>
                        <use x="{$cardPlayer1x + $counter * $cardSpacing}" y="{$cardPlayer1y}"
                             xlink:href="#black-{$value}"/>
                        <use x="{$cardPlayer1x + $counter * $cardSpacing}" y="{$cardPlayer1y}"
                             xlink:href="#Spade_mini"/>
                    </xsl:when>
                    <xsl:when test="$color = 'Club'">
                        <use x="{$cardPlayer1x + $counter * $cardSpacing}" y="{$cardPlayer1y}"
                             xlink:href="#{$color}-{$value}"/>
                        <use x="{$cardPlayer1x + $counter * $cardSpacing}" y="{$cardPlayer1y}"
                             xlink:href="#black-{$value}"/>
                        <use x="{$cardPlayer1x + $counter * $cardSpacing}" y="{$cardPlayer1y}" xlink:href="#Club_mini"/>
                    </xsl:when>
                    <xsl:when test="$color = 'Heart'">
                        <use x="{$cardPlayer1x + $counter * $cardSpacing}" y="{$cardPlayer1y}"
                             xlink:href="#{$color}-{$value}"/>
                        <use x="{$cardPlayer1x + $counter * $cardSpacing}" y="{$cardPlayer1y}"
                             xlink:href="#red-{$value}"/>
                        <use x="{$cardPlayer1x + $counter * $cardSpacing}" y="{$cardPlayer1y}"
                             xlink:href="#Heart_mini"/>
                    </xsl:when>
                    <xsl:when test="$color = 'Diamond'">
                        <use x="{$cardPlayer1x + $counter * $cardSpacing}" y="{$cardPlayer1y}"
                             xlink:href="#{$color}-{$value}"/>
                        <use x="{$cardPlayer1x + $counter * $cardSpacing}" y="{$cardPlayer1y}"
                             xlink:href="#red-{$value}"/>
                        <use x="{$cardPlayer1x + $counter * $cardSpacing}" y="{$cardPlayer1y}"
                             xlink:href="#Diamond_mini"/>
                    </xsl:when>
                </xsl:choose>

            </xsl:for-each>

            <!-- Player 2 -->
            <xsl:for-each select="$player2/currentHand/cards/card">
                <xsl:variable name="value" select="value"/>
                <xsl:variable name="color" select="color"/>
                <xsl:variable name="counter" select="position()-1"/>


                <use x="{$cardPlayer2x + $counter*$cardSpacing}" y="{$cardPlayer2y}" xlink:href="#CardTemplate"/>
                <xsl:choose>
                    <xsl:when test="$value = 'K' or $value = 'Q' or $value = 'B'">
                        <use x="{$cardPlayer2x + $counter * $cardSpacing}" y="{$cardPlayer2y}"
                             xlink:href="#{$color}-{$value}"/>
                    </xsl:when>
                    <xsl:when test="$color = 'Spade'">
                        <use x="{$cardPlayer2x + $counter * $cardSpacing}" y="{$cardPlayer2y}"
                             xlink:href="#{$color}-{$value}"/>
                        <use x="{$cardPlayer2x + $counter * $cardSpacing}" y="{$cardPlayer2y}"
                             xlink:href="#black-{$value}"/>
                        <use x="{$cardPlayer2x + $counter * $cardSpacing}" y="{$cardPlayer2y}"
                             xlink:href="#Spade_mini"/>
                    </xsl:when>
                    <xsl:when test="$color = 'Club'">
                        <use x="{$cardPlayer2x + $counter * $cardSpacing}" y="{$cardPlayer2y}"
                             xlink:href="#{$color}-{$value}"/>
                        <use x="{$cardPlayer2x + $counter * $cardSpacing}" y="{$cardPlayer2y}"
                             xlink:href="#black-{$value}"/>
                        <use x="{$cardPlayer2x + $counter * $cardSpacing}" y="{$cardPlayer2y}" xlink:href="#Club_mini"/>
                    </xsl:when>
                    <xsl:when test="$color = 'Heart'">
                        <use x="{$cardPlayer2x + $counter * $cardSpacing}" y="{$cardPlayer2y}"
                             xlink:href="#{$color}-{$value}"/>
                        <use x="{$cardPlayer2x + $counter * $cardSpacing}" y="{$cardPlayer2y}"
                             xlink:href="#red-{$value}"/>
                        <use x="{$cardPlayer2x + $counter * $cardSpacing}" y="{$cardPlayer2y}"
                             xlink:href="#Heart_mini"/>
                    </xsl:when>
                    <xsl:when test="$color = 'Diamond'">
                        <use x="{$cardPlayer2x + $counter * $cardSpacing}" y="{$cardPlayer2y}"
                             xlink:href="#{$color}-{$value}"/>
                        <use x="{$cardPlayer2x + $counter * $cardSpacing}" y="{$cardPlayer2y}"
                             xlink:href="#red-{$value}"/>
                        <use x="{$cardPlayer2x + $counter * $cardSpacing}" y="{$cardPlayer2y}"
                             xlink:href="#Diamond_mini"/>
                    </xsl:when>
                </xsl:choose>

            </xsl:for-each>

            <!-- Player 3 -->
            <xsl:for-each select="$player3/currentHand/cards/card">
                <xsl:variable name="value" select="value"/>
                <xsl:variable name="color" select="color"/>
                <xsl:variable name="counter" select="position()-1"/>


                <use x="{$cardPlayer3x + $counter* $cardSpacing}" y="{$cardPlayer3y}" xlink:href="#CardTemplate"/>
                <xsl:choose>
                    <xsl:when test="$value = 'K' or $value = 'Q' or $value = 'B'">
                        <use x="{$cardPlayer3x + $counter * $cardSpacing}" y="{$cardPlayer3y}"
                             xlink:href="#{$color}-{$value}"/>
                    </xsl:when>
                    <xsl:when test="$color = 'Spade'">
                        <use x="{$cardPlayer3x + $counter * $cardSpacing}" y="{$cardPlayer3y}"
                             xlink:href="#{$color}-{$value}"/>
                        <use x="{$cardPlayer3x + $counter * $cardSpacing}" y="{$cardPlayer3y}"
                             xlink:href="#black-{$value}"/>
                        <use x="{$cardPlayer3x + $counter * $cardSpacing}" y="{$cardPlayer3y}"
                             xlink:href="#Spade_mini"/>
                    </xsl:when>
                    <xsl:when test="$color = 'Club'">
                        <use x="{$cardPlayer3x + $counter * $cardSpacing}" y="{$cardPlayer3y}"
                             xlink:href="#{$color}-{$value}"/>
                        <use x="{$cardPlayer3x + $counter * $cardSpacing}" y="{$cardPlayer3y}"
                             xlink:href="#black-{$value}"/>
                        <use x="{$cardPlayer3x + $counter * $cardSpacing}" y="{$cardPlayer3y}" xlink:href="#Club_mini"/>
                    </xsl:when>
                    <xsl:when test="$color = 'Heart'">
                        <use x="{$cardPlayer3x + $counter * $cardSpacing}" y="{$cardPlayer3y}"
                             xlink:href="#{$color}-{$value}"/>
                        <use x="{$cardPlayer3x + $counter * $cardSpacing}" y="{$cardPlayer3y}"
                             xlink:href="#red-{$value}"/>
                        <use x="{$cardPlayer3x + $counter * $cardSpacing}" y="{$cardPlayer3y}"
                             xlink:href="#Heart_mini"/>
                    </xsl:when>
                    <xsl:when test="$color = 'Diamond'">
                        <use x="{$cardPlayer3x + $counter * $cardSpacing}" y="{$cardPlayer3y}"
                             xlink:href="#{$color}-{$value}"/>
                        <use x="{$cardPlayer3x + $counter * $cardSpacing}" y="{$cardPlayer3y}"
                             xlink:href="#red-{$value}"/>
                        <use x="{$cardPlayer3x + $counter * $cardSpacing}" y="{$cardPlayer3y}"
                             xlink:href="#Diamond_mini"/>
                    </xsl:when>
                </xsl:choose>

            </xsl:for-each>

            <!-- Player 4 -->
            <xsl:for-each select="$player4/currentHand/cards/card">
                <xsl:variable name="value" select="value"/>
                <xsl:variable name="color" select="color"/>
                <xsl:variable name="counter" select="position()-1"/>


                <use x="{$cardPlayer4x + $counter* $cardSpacing}" y="{$cardPlayer4y}" xlink:href="#CardTemplate"/>
                <xsl:choose>
                    <xsl:when test="$value = 'K' or $value = 'Q' or $value = 'B'">
                        <use x="{$cardPlayer4x + $counter * $cardSpacing}" y="{$cardPlayer4y}"
                             xlink:href="#{$color}-{$value}"/>
                    </xsl:when>
                    <xsl:when test="$color = 'Spade'">
                        <use x="{$cardPlayer4x + $counter * $cardSpacing}" y="{$cardPlayer4y}"
                             xlink:href="#{$color}-{$value}"/>
                        <use x="{$cardPlayer4x + $counter * $cardSpacing}" y="{$cardPlayer4y}"
                             xlink:href="#black-{$value}"/>
                        <use x="{$cardPlayer4x + $counter * $cardSpacing}" y="{$cardPlayer4y}"
                             xlink:href="#Spade_mini"/>
                    </xsl:when>
                    <xsl:when test="$color = 'Club'">
                        <use x="{$cardPlayer4x + $counter * $cardSpacing}" y="{$cardPlayer4y}"
                             xlink:href="#{$color}-{$value}"/>
                        <use x="{$cardPlayer4x + $counter * $cardSpacing}" y="{$cardPlayer4y}"
                             xlink:href="#black-{$value}"/>
                        <use x="{$cardPlayer4x + $counter * $cardSpacing}" y="{$cardPlayer4y}" xlink:href="#Club_mini"/>
                    </xsl:when>
                    <xsl:when test="$color = 'Heart'">
                        <use x="{$cardPlayer4x + $counter * $cardSpacing}" y="{$cardPlayer4y}"
                             xlink:href="#{$color}-{$value}"/>
                        <use x="{$cardPlayer4x + $counter * $cardSpacing}" y="{$cardPlayer4y}"
                             xlink:href="#red-{$value}"/>
                        <use x="{$cardPlayer4x + $counter * $cardSpacing}" y="{$cardPlayer4y}"
                             xlink:href="#Heart_mini"/>
                    </xsl:when>
                    <xsl:when test="$color = 'Diamond'">
                        <use x="{$cardPlayer4x + $counter * $cardSpacing}" y="{$cardPlayer4y}"
                             xlink:href="#{$color}-{$value}"/>
                        <use x="{$cardPlayer4x + $counter * $cardSpacing}" y="{$cardPlayer4y}"
                             xlink:href="#red-{$value}"/>
                        <use x="{$cardPlayer4x + $counter * $cardSpacing}" y="{$cardPlayer4y}"
                             xlink:href="#Diamond_mini"/>
                    </xsl:when>
                </xsl:choose>

            </xsl:for-each>

            <!-- Player 5 -->
            <xsl:for-each select="$player5/currentHand/cards/card">
                <xsl:variable name="value" select="value"/>
                <xsl:variable name="color" select="color"/>
                <xsl:variable name="counter" select="position()-1"/>


                <use x="{$cardPlayer5x + $counter* $cardSpacing}" y="{$cardPlayer5y}" xlink:href="#CardTemplate"/>
                <xsl:choose>
                    <xsl:when test="$value = 'K' or $value = 'Q' or $value = 'B'">
                        <use x="{$cardPlayer5x + $counter * $cardSpacing}" y="{$cardPlayer5y}"
                             xlink:href="#{$color}-{$value}"/>
                    </xsl:when>
                    <xsl:when test="$color = 'Spade'">
                        <use x="{$cardPlayer5x + $counter * $cardSpacing}" y="{$cardPlayer5y}"
                             xlink:href="#{$color}-{$value}"/>
                        <use x="{$cardPlayer5x + $counter * $cardSpacing}" y="{$cardPlayer5y}"
                             xlink:href="#black-{$value}"/>
                        <use x="{$cardPlayer5x + $counter * $cardSpacing}" y="{$cardPlayer5y}"
                             xlink:href="#Spade_mini"/>
                    </xsl:when>
                    <xsl:when test="$color = 'Club'">
                        <use x="{$cardPlayer5x + $counter * $cardSpacing}" y="{$cardPlayer5y}"
                             xlink:href="#{$color}-{$value}"/>
                        <use x="{$cardPlayer5x + $counter * $cardSpacing}" y="{$cardPlayer5y}"
                             xlink:href="#black-{$value}"/>
                        <use x="{$cardPlayer5x + $counter * $cardSpacing}" y="{$cardPlayer5y}" xlink:href="#Club_mini"/>
                    </xsl:when>
                    <xsl:when test="$color = 'Heart'">
                        <use x="{$cardPlayer5x + $counter * $cardSpacing}" y="{$cardPlayer5y}"
                             xlink:href="#{$color}-{$value}"/>
                        <use x="{$cardPlayer5x + $counter * $cardSpacing}" y="{$cardPlayer5y}"
                             xlink:href="#red-{$value}"/>
                        <use x="{$cardPlayer5x + $counter * $cardSpacing}" y="{$cardPlayer5y}"
                             xlink:href="#Heart_mini"/>
                    </xsl:when>
                    <xsl:when test="$color = 'Diamond'">
                        <use x="{$cardPlayer5x + $counter * $cardSpacing}" y="{$cardPlayer5y}"
                             xlink:href="#{$color}-{$value}"/>
                        <use x="{$cardPlayer5x + $counter * $cardSpacing}" y="{$cardPlayer5y}"
                             xlink:href="#red-{$value}"/>
                        <use x="{$cardPlayer5x + $counter * $cardSpacing}" y="{$cardPlayer5y}"
                             xlink:href="#Diamond_mini"/>
                    </xsl:when>
                </xsl:choose>

            </xsl:for-each>

            <div class="notifications">
                <xsl:for-each select="notifications/notification">
                    <xsl:choose>
                        <xsl:when test="type='error'">
                            <div style="color:red !important; font-weight:bold">[<xsl:value-of select="time"/>]
                                <xsl:value-of select="text"/>
                            </div>
                        </xsl:when>
                        <xsl:otherwise>
                            <div>[<xsl:value-of select="time"/>]
                                <xsl:value-of select="text"/>
                            </div>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </div>

            <!-- Hidden Frame to store the results of the PUT request -->
            <foreignObject width="0" height="0">
                <iframe class="hiddenFrame" xmlns="http://www.w3.org/1999/xhtml" name="hiddenFrame"
                        style="height: 0px;"></iframe>
            </foreignObject>

        </svg>

    </xsl:template>
</xsl:stylesheet>