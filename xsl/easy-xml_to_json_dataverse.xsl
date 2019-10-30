<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dct="http://purl.org/dc/terms/"
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
            <xsl:call-template name="string-escape-characters">
                <xsl:with-param name="text" select="//emd:easymetadata/emd:title/dc:title[1]/."></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="alternative-title">
            <xsl:call-template name="string-escape-characters">
                <xsl:with-param name="text" select="//emd:easymetadata/emd:title/dct:alternative[1]/."></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="description">
            <xsl:for-each select="//emd:easymetadata/emd:description/dc:description">
                <xsl:variable name="desc">
                    <xsl:call-template name="string-escape-characters">
                        <xsl:with-param name="text" select="."/>
                    </xsl:call-template>
                </xsl:variable>
                {
                "dsDescriptionValue": {
                "typeName": "dsDescriptionValue",
                "multiple": false,
                "value": "<xsl:value-of select="$desc"/>",
                "typeClass": "primitive"
                }
                }
                <xsl:if test="position() != last()">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>

        </xsl:variable>

        <xsl:variable name="author-eas">
            <xsl:choose>
                <xsl:when test="not(//emd:creator/eas:creator/eas:surname)">
                    <xsl:value-of select="//emd:creator/eas:creator/eas:organization"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat(//emd:creator/eas:creator/eas:prefix
                                                    ,' ',//emd:creator/eas:creator/eas:surname
                                                    ,', ',//emd:creator/eas:creator/eas:initials
                                                    ,//emd:creator/eas:creator/eas:title)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="author">
            <xsl:value-of select="//emd:creator/dc:creator"/>
        </xsl:variable>
        <xsl:variable name="subject">
            <xsl:for-each select="//emd:audience/dct:audience">
                <xsl:call-template name="audiencefromkeyword"><xsl:with-param name="val" select="."></xsl:with-param></xsl:call-template>
                <xsl:if test="position() != last()">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
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
        "typeName": "alternativeTitle",
        "multiple": false,
        "typeClass": "primitive",
        "value": "<xsl:value-of select="$alternative-title"/>"
        },
        {
        "typeName": "dsDescription",
        "multiple": true,
        "typeClass": "compound",
        "value": [<xsl:value-of select="$description"/>]
        },
        {
        "typeName": "subject",
        "multiple": true,
        "value": [<xsl:value-of select="normalize-space($subject)"/>],
        "typeClass": "controlledVocabulary"
        },
        {
        "typeName": "author",
        "multiple": true,
        "typeClass": "compound",
        "value": [
        <xsl:if test="$author-eas !=''">
            {
            "authorName": {
            "typeName": "authorName",
            "multiple": false,
            "value": "<xsl:value-of select="normalize-space($author-eas)"/>",
            "typeClass": "primitive"
            },
            "authorAffiliation": {
            "typeName": "authorAffiliation",
            "multiple": false,
            "value": "<xsl:value-of select="//emd:creator/eas:creator/eas:organization"/>",
            "typeClass": "primitive"
            }
            }
        </xsl:if>
        <xsl:if test="$author">
            <xsl:if test="$author-eas != ''">,</xsl:if>
            {
            "authorName": {
            "typeName": "authorName",
            "multiple": false,
            "value": "<xsl:value-of select="normalize-space($author)"/>",
            "typeClass": "primitive"
            }
            }
        </xsl:if>
        ]
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
        "value": "info@dans.knaw.nl",
        "typeClass": "primitive"
        }}],
        "typeClass": "compound"
        }
        ],
        "displayName": "Citation Metadata"
        }},
        "files": [
        <xsl:for-each select="//files/file">
            <xsl:if test="position() &lt; 1001">
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
                <xsl:variable name="fnxyz" select="replace($fnxy, '&#58;', '-')"/>
                <xsl:variable name="fnxyza" select="replace($fnxyz, '\&#63;', '-')"/>

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
                <xsl:variable name="dnxyzabcd"  select="replace($dnxyzabc, '&#58;', '-')"/>
                <xsl:variable name="dnxyzabcde" select="replace($dnxyzabcd, '&#246;','-')"/>
                {
                "label": "<xsl:value-of select="$fnxyza"/>",
                "restricted": false,
                "directoryLabel": "<xsl:value-of select="$dnxyzabcde"/>",
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
                <xsl:if test="position() != last() and position() &lt; 1000">
                    <xsl:text>,</xsl:text>
                </xsl:if>
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
            <xsl:when test="$val = 'easy-discipline:135'">
                "<xsl:value-of select="'Agricultural sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:23'">
                "<xsl:value-of select="'Law'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:42'">
                "<xsl:value-of select="'Social Sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:1'">
                "<xsl:value-of select="'Arts and Humanities'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:134'">
                "<xsl:value-of select="'Astronomy and Astrophysics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:24'">
                "<xsl:value-of select="'Business and Management'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:75'">
                "<xsl:value-of select="'Chemistry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:125'">
                "<xsl:value-of select="'Computer and Information Science'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:118'">
                "<xsl:value-of select="'Earth and Environmental Sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:98'">
                "<xsl:value-of select="'Engineering'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:58'">
                "<xsl:value-of select="'Mathematical Sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:54'">
                "<xsl:value-of select="'Medicine, Health and Life Sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:67'">
                "<xsl:value-of select="'Physics'"/>"
            </xsl:when>
            <!-- <xsl:when test="$val = 'easy-discipline:2'">
                 "<xsl:value-of select="'Archaeology'"/>"
             </xsl:when>-->
            <xsl:when test="$val = 'easy-discipline:219'">
                "<xsl:value-of select="'Other'"/>"
            </xsl:when>
            <xsl:otherwise>
                <!-- Don't do the default mapping to E10000, otherwise we cannot detect that nothing was found -->
                "<xsl:value-of select="'Other'"/>"
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
    <xsl:template name="string-escape-characters">
        <xsl:param name="text" />
        <xsl:variable name="text-0">
            <xsl:value-of select="replace($text, '\\','\\\\')"/>
        </xsl:variable>
        <xsl:variable name="text-1">
            <xsl:value-of select="replace($text-0, '&#34;','\\&#34;')"/>
        </xsl:variable>
        <xsl:variable name="text-2">
            <xsl:value-of select="replace($text-1, '&#09;','\\t')"/>
        </xsl:variable>
        <xsl:variable name="text-3">
            <xsl:value-of select="replace($text-2, '&#10;','\\n')"/>
        </xsl:variable>
        <xsl:variable name="text-4">
            <xsl:value-of select="replace($text-3, '&#13;','\\r')"/>
        </xsl:variable>
        <xsl:value-of select="$text-4"/>
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