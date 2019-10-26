<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:emd="http://easy.dans.knaw.nl/easy/easymetadata/"
                xmlns:eas="http://easy.dans.knaw.nl/easy/easymetadata/eas/"
                xmlns="http://www.openarchives.org/OAI/2.0/"
                exclude-result-prefixes="xs"
                version="2.0">
    <xsl:output method="text" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="/">
        <xsl:call-template name="metadata-json"/>
    </xsl:template>
    <xsl:template name="metadata-json">
        <xsl:variable name="doi-identifier" select="//emd:identifier/dc:identifier[@eas:scheme='DOI']/."/>
        <xsl:variable name="title">
            <xsl:call-template name="string-replace-whitespaceCharacters">
                <xsl:with-param name="eko" select="//emd:easymetadata/emd:title/dc:title[1]/."></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="desc">
            <xsl:call-template name="string-replace-whitespaceCharacters">
                <xsl:with-param name="eko" select="//emd:easymetadata/emd:description/dc:description[1]/."></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="author">
            <xsl:call-template name="string-replace-whitespaceCharacters">
                <xsl:with-param name="eko" select="//emd:creator/."></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        {"datasetVersion": {
        "termsOfUse": "CC0 Waiver",
        "license": "CC0",
        "protocol": "doi",
        "authority":"10.5072",
        "identifier":"doi:10.5072/<xsl:value-of select="substring-after($doi-identifier, '/')"/>",
        "metadataBlocks": {"citation": {
        "fields": [
        {
        "typeName": "title",
        "multiple": false,
        "value": "<xsl:value-of select="$title"/>",
        "typeClass": "primitive"
        },
        {
        "typeName": "productionDate",
        "multiple": false,
        "value": "2011-02-23",
        "typeClass": "primitive"
        },
        {
        "typeName": "dsDescription",
        "multiple": true,
        "value": [{"dsDescriptionValue": {
        "typeName": "dsDescriptionValue",
        "multiple": false,
        "value": "<xsl:value-of select="$desc"/>",
        "typeClass": "primitive"
        }}],
        "typeClass": "compound"
        },
        {
        "typeName": "subject",
        "multiple": true,
        "value": ["Medicine, Health and Life Sciences"],
        "typeClass": "controlledVocabulary"
        },
        {
        "typeName": "author",
        "multiple": true,
        "value": [
        {
        "authorAffiliation": {
        "typeName": "authorAffiliation",
        "multiple": false,
        "value": "LibraScholar Medical School",
        "typeClass": "primitive"
        },
        "authorName": {
        "typeName": "authorName",
        "multiple": false,
        "value": "<xsl:value-of select="$author"/>",
        "typeClass": "primitive"
        }
        }
        ],
        "typeClass": "compound"
        },
        {
        "typeName": "depositor",
        "multiple": false,
        "value": "Prof, Arthur",
        "typeClass": "primitive"
        },
        {
        "typeName": "datasetContact",
        "multiple": true,
        "value": [{"datasetContactEmail": {
        "typeName": "datasetContactEmail",
        "multiple": false,
        "value": "aprof@mailinator.com",
        "typeClass": "primitive"
        }}],
        "typeClass": "compound"
        }
        ],
        "displayName": "Citation Metadata"
        }},
        "files": [
        <xsl:for-each select="//files/file">
            <xsl:variable name="fn">
                <xsl:call-template name="file_name"><xsl:with-param name="text" select="@path"></xsl:with-param></xsl:call-template>
            </xsl:variable>
            <xsl:variable name="fnx">
                <xsl:call-template name="string-replace-all">
                    <xsl:with-param name="text" select="$fn"></xsl:with-param>
                    <xsl:with-param name="replace" select="';'"></xsl:with-param>
                    <xsl:with-param name="by" select="'-'"></xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="fnxy" select="replace($fnx, '#', '-')"/>
            <xsl:variable name="fnxyz" select="replace($fnxy, ':', '-')"/>

            <xsl:variable name="dn">
                <xsl:call-template name="file_path"><xsl:with-param name="text" select="@path"></xsl:with-param></xsl:call-template>
            </xsl:variable>
            <xsl:variable name="apos">'</xsl:variable>
            <xsl:variable name="dnx">
                <xsl:call-template name="string-replace-all">
                    <xsl:with-param name="text" select="$dn"></xsl:with-param>
                    <xsl:with-param name="replace" select="$apos"></xsl:with-param>
                    <xsl:with-param name="by" select="'-'"></xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="dnxy">
                <xsl:call-template name="string-replace-all">
                    <xsl:with-param name="text" select="$dnx"></xsl:with-param>
                    <xsl:with-param name="replace" select="','"></xsl:with-param>
                    <xsl:with-param name="by" select="'-'"></xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="dnxyz">
                <xsl:call-template name="string-replace-all">
                    <xsl:with-param name="text" select="$dnxy"></xsl:with-param>
                    <xsl:with-param name="replace" select="'('"></xsl:with-param>
                    <xsl:with-param name="by" select="'-'"></xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="dnxyza">
                <xsl:call-template name="string-replace-all">
                    <xsl:with-param name="text" select="$dnxyz"></xsl:with-param>
                    <xsl:with-param name="replace" select="')'"></xsl:with-param>
                    <xsl:with-param name="by" select="'-'"></xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="dnxyzab" select="replace($dnxyza, '&amp;', '-')"/>
            <xsl:variable name="dnxyzabc" select="replace($dnxyzab, '\+', '-')"/>
            {
            "label": "<xsl:value-of select="$fnxyz"/>",
            "restricted": false,
            "directoryLabel": "<xsl:value-of select="$dnxyzabc"/>",
            "version": 1,
            "dataFile": {
            "contentType": "<xsl:value-of select="mimeType/."/>",
            "filesize": <xsl:value-of select="size/."/>,
            "storageIdentifier": "<xsl:value-of select="sha1/."/>",
            "rootDataFileId": -1,
            "checksum": {
            "type": "SHA-1",
            "value": "<xsl:value-of select="sha1/."/>"
            }
            }
            }
            <xsl:if test="position() != last()">
                <xsl:text>,</xsl:text>
            </xsl:if>
        </xsl:for-each>
        ]
        }}

    </xsl:template>
    <!-- Mapping from the Dataverse keywords to the Narcis Discipline types (https://easy.dans.knaw.nl/schemas/vocab/2015/narcis-type.xsd) -->
    <xsl:template name="audiencefromkeyword">
        <xsl:param name="val"/>
        <!-- make our own map, it's small -->
        <xsl:choose>
            <xsl:when test="$val = 'Agricultural sciences'">
                <xsl:value-of select="'D18000'"/>
            </xsl:when>
            <xsl:when test="$val = 'Law'">
                <xsl:value-of select="'D40000'"/>
            </xsl:when>
            <xsl:when test="$val = 'Social Sciences'">
                <xsl:value-of select="'D60000'"/>
            </xsl:when>
            <xsl:when test="$val = 'Arts and Humanities'">
                <xsl:value-of select="'D30000'"/>
            </xsl:when>
            <xsl:when test="$val = 'Astronomy and Astrophysics'">
                <xsl:value-of select="'D17000'"/>
            </xsl:when>
            <xsl:when test="$val = 'Business and Management'">
                <xsl:value-of select="'D70000'"/>
            </xsl:when>
            <xsl:when test="$val = 'Chemistry'">
                <xsl:value-of select="'D13000'"/>
            </xsl:when>
            <xsl:when test="$val = 'Computer and Information Science'">
                <xsl:value-of select="'D16000'"/>
            </xsl:when>
            <xsl:when test="$val = 'Earth and Environmental Sciences'">
                <xsl:value-of select="'D15000'"/>
            </xsl:when>
            <xsl:when test="$val = 'Engineering'">
                <xsl:value-of select="'D14400'"/>
            </xsl:when>
            <xsl:when test="$val = 'Mathematical Sciences'">
                <xsl:value-of select="'D11000'"/>
            </xsl:when>
            <xsl:when test="$val = 'Medicine, Health and Life Sciences'">
                <xsl:value-of select="'D20000'"/>
            </xsl:when>
            <xsl:when test="$val = 'Physics'">
                <xsl:value-of select="'D12000'"/>
            </xsl:when>
            <xsl:when test="$val = 'Other'">
                <xsl:value-of select="'E10000'"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- Don't do the default mapping to E10000, otherwise we cannot detect that nothing was found -->
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="string-replace-all">
        <xsl:param name="text" />
        <xsl:param name="replace" />
        <xsl:param name="by" />
        <xsl:choose>
            <xsl:when test="contains($text, $replace)">
                <xsl:value-of select="substring-before($text,$replace)" />
                <xsl:value-of select="$by" />
                <xsl:call-template name="string-replace-all">
                    <xsl:with-param name="text"
                                    select="substring-after($text,$replace)" />
                    <xsl:with-param name="replace" select="$replace" />
                    <xsl:with-param name="by" select="$by" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="string-replace-whitespaceCharacters">
        <xsl:param name="eko" />
        <xsl:variable name="text0">
            <xsl:value-of select="replace($eko, '&#34;','\\&#34;')"/>
        </xsl:variable>
        <xsl:variable name="text1">
            <xsl:value-of select="replace($text0, '&#09;','\\t')"/>
        </xsl:variable>
        <xsl:variable name="text2">
            <xsl:value-of select="replace($text1, '&#10;','\\n')"/>
        </xsl:variable>
        <xsl:variable name="text3">
            <xsl:value-of select="replace($text2, '&#13;','\\r')"/>
        </xsl:variable>
        <xsl:call-template name="string-replace-all">
            <xsl:with-param name="text" select="$text3" />
            <xsl:with-param name="replace" select="'&#13;'" />
            <xsl:with-param name="by" select="'\r'" />
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="file_name">
        <xsl:param name="text"/>
        <xsl:param name="separator" select="'/'"/>
        <xsl:choose>
            <xsl:when test="not(contains($text, $separator))">
                <xsl:value-of select="normalize-space($text)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="file_name">
                    <xsl:with-param name="text" select="substring-after($text, $separator)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="file_path">
        <xsl:param name="text"/>
        <xsl:param name="separator" select="'/'"/>
        <xsl:choose>
            <xsl:when test="not(contains($text, $separator))"/>
            <xsl:otherwise>
                <xsl:value-of select="concat(normalize-space(substring-before($text, $separator)), '/')"/>
                <xsl:call-template name="file_path">
                    <xsl:with-param name="text" select="substring-after($text, $separator)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>