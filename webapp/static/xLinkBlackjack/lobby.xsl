<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

    <xsl:template match="/">
        <div style="background-image: url('../static/xLinkBlackjack/background.jpg')">
            <svg width="100%" height="100%" version="1.1" viewBox="0 0 1600 900"
             xmlns="http://www.w3.org/2000/svg">

                <style>
                    body {
                    font-family:'Courier New',Verdana,sans-serif;
                    }

                    .button::-moz-focus-inner{
                    border: 0;
                    padding: 0;
                    }

                    .button{
                    display: inline-block;
                    *display: inline;
                    zoom: 1;
                    padding: 6px 20px;
                    margin: 0;
                    cursor: pointer;
                    border: 1px solid #bbb;
                    overflow: visible;
                    font: bold 13px arial, helvetica, sans-serif;
                    text-decoration: none;
                    white-space: nowrap;
                    color: #555;


                    -webkit-transition: background-color .2s ease-out;
                    -moz-transition: background-color .2s ease-out;
                    -ms-transition: background-color .2s ease-out;
                    -o-transition: background-color .2s ease-out;
                    transition: background-color .2s ease-out;
                    background-clip: padding-box; /* Fix bleeding */
                    -moz-border-radius: 3px;
                    -webkit-border-radius: 3px;
                    border-radius: 3px;
                    -moz-box-shadow: 0 1px 0 rgba(0, 0, 0, .3), 0 2px 2px -1px rgba(0, 0, 0, .5), 0 1px 0 rgba(255, 255, 255, .3) inset;
                    -webkit-box-shadow: 0 1px 0 rgba(0, 0, 0, .3), 0 2px 2px -1px rgba(0, 0, 0, .5), 0 1px 0 rgba(255, 255, 255, .3) inset;
                    box-shadow: 0 1px 0 rgba(0, 0, 0, .3), 0 2px 2px -1px rgba(0, 0, 0, .5), 0 1px 0 rgba(255, 255, 255, .3) inset;
                    text-shadow: 0 1px 0 rgba(255,255,255, .9);

                    }

                    .button:hover{
                    background-color: #eee;
                    color: #555;
                    }

                    .button:active{
                    background: #e9e9e9;
                    position: relative;
                    top: 1px;
                    text-shadow: none;
                    -moz-box-shadow: 0 1px 1px rgba(0, 0, 0, .3) inset;
                    -webkit-box-shadow: 0 1px 1px rgba(0, 0, 0, .3) inset;
                    box-shadow: 0 1px 1px rgba(0, 0, 0, .3) inset;
                    }

                    .button[disabled], .button[disabled]:hover, .button[disabled]:active{
                    border-color: #eaeaea;
                    background: #fafafa;
                    cursor: default;
                    position: static;
                    color: #999;
                    /* Usually, !important should be avoided but here it's really needed :) */
                    -moz-box-shadow: none !important;
                    -webkit-box-shadow: none !important;
                    box-shadow: none !important;
                    text-shadow: none !important;
                    }

                    /* Smaller buttons styles */

                    .button.small{
                    padding: 4px 12px;
                    }

                    /* Larger buttons styles */

                    .button.large{
                    padding: 12px 30px;
                    text-transform: uppercase;
                    }

                    .button.large:active{
                    top: 2px;
                    }

                    /* Colored buttons styles */

                    .button.green, .button.red, .button.blue {
                    color: #fff;
                    text-shadow: 0 1px 0 rgba(0,0,0,.2);

                    background-image: -webkit-gradient(linear, left top, left bottom, from(rgba(255,255,255,.3)), to(rgba(255,255,255,0)));
                    background-image: -webkit-linear-gradient(top, rgba(255,255,255,.3), rgba(255,255,255,0));
                    background-image: -moz-linear-gradient(top, rgba(255,255,255,.3), rgba(255,255,255,0));
                    background-image: -ms-linear-gradient(top, rgba(255,255,255,.3), rgba(255,255,255,0));
                    background-image: -o-linear-gradient(top, rgba(255,255,255,.3), rgba(255,255,255,0));
                    background-image: linear-gradient(top, rgba(255,255,255,.3), rgba(255,255,255,0));
                    }

                    /* */

                    .button.green{
                    background-color: #57a957;
                    border-color: #57a957;
                    }

                    .button.green:hover{
                    background-color: #62c462;
                    }

                    .button.green:active{
                    background: #57a957;
                    }

                    /* */

                    .button.red{
                    background-color: #ca3535;
                    border-color: #c43c35;
                    }

                    .button.red:hover{
                    background-color: #ee5f5b;
                    }

                    .button.red:active{
                    background: #c43c35;
                    }

                    /* */

                    .button.blue{
                    background-color: #269CE9;
                    border-color: #269CE9;
                    }

                    .button.blue:hover{
                    background-color: #70B9E8;
                    }

                    .button.blue:active{
                    background: #269CE9;
                    }

                    /* */

                    .green[disabled], .green[disabled]:hover, .green[disabled]:active{
                    border-color: #57A957;
                    background: #57A957;
                    color: #D2FFD2;
                    }

                    .red[disabled], .red[disabled]:hover, .red[disabled]:active{
                    border-color: #C43C35;
                    background: #C43C35;
                    color: #FFD3D3;
                    }

                    .blue[disabled], .blue[disabled]:hover, .blue[disabled]:active{
                    border-color: #269CE9;
                    background: #269CE9;
                    color: #93D5FF;
                    }

                    input {
                    margin: 8px 0;
                    padding: 7px 7px;
                    box-sizing: border-box;
                    border: 3px solid #ccc;
                    -webkit-transition: 0.5s;
                    transition: 0.5s;
                    outline: none;
                    text-align: center;
                    }

                    input:focus {
                    border: 3px solid #555;
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

                    ::-webkit-input-placeholder {
                    text-align: center;
                    }

                    :-moz-placeholder { /* Firefox 18- */
                    text-align: center;
                    }

                    ::-moz-placeholder {  /* Firefox 19+ */
                    text-align: center;
                    }

                    :-ms-input-placeholder {
                    text-align: center;
                    }
                </style>

                    <div style="position:absolute;top:400;left:100; height: 70%; width: 50%">
                    <form xmlns="http://www.w3.org/1999/xhtml" style="flex-direction: column; align-items: stretch; display:flex; flex-flow:column wrap; align-items: center;" action="/xLinkbj/form" id="form2" >
                        <input type="text" style="height: 60px; width: 80%" name="name" placeholder="Name to start game with"/>
                        <input type="number" style="height: 60px; width: 80%" name="minBet" placeholder="Minimum Bet"/>
                        <input type="number" style="height: 60px; width: 80%" name="maxBet" placeholder="Maximum Bet"/>
                        <button class="button large green" style="margin-top: 15px" type="submit" form="form2">Spiel erstellen</button>
                    </form>
                    </div>

                <div style="position:absolute;top:20;right:30;height:80%;width:30%;border:1px solid #ccc;font:16px/26px; overflow:auto; background-color: white; border-radius: 15px; padding: 10px; padding-top: 3px; padding-left:3px; margin-bottom: 20px;">
                   <div style="width:100%; height:10%; text-align:center;"><p style="font-weight: bold; font-size: 20px">SELECT A GAME YOU WANT TO JOIN</p></div>
                    <xsl:for-each select="games/game">
                        <xsl:variable name="gameID" select="id"/>
                        <xsl:variable name="players" select="count(players/player)"/>
                        <xsl:choose>
                            <xsl:when test="available='true'">
                                <div style="border: 1px solid black; border-radius: 25px; margin-bottom: 10px">
                                    <form action="/xLinkbj/insertPlayer/{$gameID}" style="margin-top: 2.5%; margin-left: 2%; flex-direction: column; align-items: stretch; display:flex; flex-flow:row wrap; align-items: center;" id="joinForm">
                                        <input type="text" style="margin-right: 15px; height: 10%" name="name" placeholder="Name to join with"/>
                                        <div style="color:#42f542 !important; font-weight:bold"><span style="color:black; font-weight:normal">Aktive Spieler: </span> <span style="margin-left: 10px"><xsl:value-of select="$players"/>/5</span> </div>
                                        <button form="joinForm" class="small blue button" style="margin-left: auto; margin-right: 10px" type="submit">Join</button>
                                    </form>
                                </div>
                            </xsl:when>
                            <xsl:when test="state='deleted'"></xsl:when>
                            <xsl:otherwise>
                                <div style="border: 1px solid black; border-radius: 25px; margin-bottom: 10px">
                                    <form action="/xLinkbj/insertPlayer/{$gameID}" style="margin-top: 2.5%; margin-left: 2%; flex-direction: column; align-items: stretch; display:flex; flex-flow:row wrap; align-items: center;" id="joinForm">
                                        <div style="color:black !important; margin-right: 10px">Spiel ist voll oder wird gespielt</div>
                                        <div style="color:red !important; font-weight:bold; margin-left:15px">Spieler: <xsl:value-of select="$players"/></div>
                                        <button form="joinForm" class="small blue button" style="margin-left: auto; margin-right: 10px" type="submit" disabled="">Join</button>
                                    </form>
                                </div>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </div>
            </svg>
        </div>
    </xsl:template>

</xsl:stylesheet>