<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                
                version="2.0">
    <xsl:output method="text" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="/dataset/collections=' '">
                {  "dataverse":"EASY"  }
            </xsl:when>
            <xsl:otherwise>
                { 
                "dataverse":"<xsl:call-template name="collection">
                    <xsl:with-param name="val" select="//collection[1]"></xsl:with-param>
                </xsl:call-template>"
                ,"linked-dataverse":[
                <xsl:for-each select="//collection">
                        <xsl:if test="position() > 1"> 
                            "<xsl:call-template name="collection">
                                <xsl:with-param name="val" select="."></xsl:with-param>
                            </xsl:call-template>"
                            <xsl:if test="position() != last()">
                                <xsl:text>,</xsl:text>
                            </xsl:if>
                        </xsl:if>
                    
                </xsl:for-each>
                ]
                }
            </xsl:otherwise>
        </xsl:choose>
        
        
    </xsl:template>
    <xsl:template name="collection">
        <xsl:param name="val" />
        <xsl:choose>
            <xsl:when test="$val = 'easy-collection:1'">
                <xsl:value-of select="'Oral-History'"/>
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:2'">
                <xsl:value-of select="'World-War-II'"/>
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:3'">
                <xsl:value-of select="'Getuigen-Verhalen'"/>
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:4'">
                <xsl:value-of select="'Carare'"/>
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:5'">
                <xsl:value-of select="'CLARIN'"/>
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:6'">
                <xsl:value-of select="'Social-Sciences-Dutch'"/>
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:7'">
                <xsl:value-of select="'Social-Sciences-English'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'EASY'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>

    