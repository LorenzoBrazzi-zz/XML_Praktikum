<?xml version="1.0" encoding="UTF-8"?>
<!-- Style-sheet einbinnden -->
<svg xmlns=<!-- stylesheet link einfügen --> width="100%" height="100%">
    <g alignment-baseline="baseline" />
    
    <!-- default chip, other chips have the same features -->
    <defs>
        <h id="default-chip">
            <circle r="8" stroke="blue" stroke-width="3" fill="white" />
        </h>
    </defs>
    
    <!-- different chip values: from 5 to 1000 -->
    <defs>
        <text id="chip-value-5" font-size="11.5" fill="black">5</text>
    </defs>
    
    <defs>
        <text id="chip-value-10" font-size="11.5" fill="black">10</text>
    </defs>
    
    <defs>
        <text id="chip-value-20" font-size="11.5" fill="black">20</text>
    </defs>
    
    <defs>
        <text id="chip-value-50" font-size="11.5" fill="black">50</text>
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
        <g id="chip-5">
            <use xlink:href="#default-chip" />
            <use xlink:href="#chip-value-5" x="-2" y="5" />
        </g>
    </defs>
    
    <defs>
        <g id="chip-10">
            <use xlink:href="#default-chip" />
            <use xlink:href="#chip-value-10" x="-5" y="5" />
        </g>
    </defs>
    
    <defs>
        <g id="chip-20">
            <use xlink:href="#default-chip" />
            <use xlink:href="#chip-value-20" x="-5" y="5" />
        </g>
    </defs>
    
    <defs>
        <g id="chip-50">
            <use xlink:href="#default-chip" />
            <use xlink:href="#chip-value-50" x="-5" y="5" />
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
    
    <!-- example chips -->
	<use xlink:href="#chip-5" x="300" y="100" />
    <use xlink:href="#chip-10" x="100" y="200" />
    <use xlink:href="#chip-20" x="100" y="300" />
    <use xlink:href="#chip-50" x="200" y="200" />
    <use xlink:href="#chip-100" x="200" y="300" />
    <use xlink:href="#chip-500" x="300" y="200" />
    <use xlink:href="#chip-1000" x="300" y="300" />
</svg>
