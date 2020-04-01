<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

    <xsl:template match="/">
        <svg width="100%" height="100%" version="1.1" viewBox="0 0 1600 900"
             xmlns="http://www.w3.org/2000/svg">
        <foreignObject height="10%" width="30%" x="60"
                       y="400">
            <form xmlns="http://www.w3.org/1999/xhtml" action="/bj/form" id="form2" >
                <input type="text" name="name" placeholder="Name"/>
                <input type="number" name="minBet" placeholder="Minimum Bet"/>
                <input type="number" name="maxBet" placeholder="Maximum Bet"/>
                <button class="textMediumStyle lobbyButton" type="submit" form="form2" value="Submit" id="startGame">Submit</button>
            </form>
        </foreignObject>


                <xsl:variable name="playerID" select ="generate-id()"/>

                <div style="position:absolute;top:20;right:30;height:60%;width:30%;border:1px solid #ccc;font:16px/26px; overflow:auto;font-family:'Courier New',Verdana,sans-serif; background-color: white; border-radius: 15px; padding: 10px; padding-top: 3px; padding-left:3px">
                    <xsl:for-each select="games/game">
                        <xsl:variable name="gameID" select="id"/>
                    <xsl:variable name="players" select="count(players/player)"/>
                        <xsl:choose>
                            <xsl:when test="available='true'">
                                <div>
                                    <form action="/bj/insertPlayer/{$gameID}/{$playerID}" id="joinForm">
                                        <input type="text" name="name" placeholder="Name"/>
                                        <div style="color:red !important; font-weight:bold"><xsl:value-of select="$players"/>/5 </div>
                                        <button form="joinForm" type="submit">Joinen</button>
                                    </form>
                                </div>
                            </xsl:when>
                            <xsl:otherwise>
                                <div style="color:red !important; font-weight:bold"><xsl:value-of select="$players"/>/5 </div>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </div>
        </svg>
    </xsl:template>

</xsl:stylesheet>