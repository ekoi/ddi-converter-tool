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
            <xsl:call-template name="display-name">
                <xsl:with-param name="display-title" select="//emd:creator/eas:creator/eas:title"/>
                <xsl:with-param name="display-initials" select="//emd:creator/eas:creator/eas:initials"/>
                <xsl:with-param name="display-prefix" select="//emd:creator/eas:creator/eas:prefix"/>
                <xsl:with-param name="display-surname" select="//emd:creator/eas:creator/eas:surname"/>
                <xsl:with-param name="display-organization" select="//emd:creator/eas:creator/eas:organization"/>
            </xsl:call-template>
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
        <xsl:variable name="distribution-date" select="//emd:date/dct:issued"/>
        {"datasetVersion": {
        "termsOfUse": "CC0 Waiver",
        "license": "CC0",
        "protocol": "doi",
        "authority":"10.5072",
        "identifier":"doi:10.5072/<xsl:value-of select="substring-after($doi-identifier, '/')"/>",
        "metadataBlocks": {"citation": {
        "displayName": "Citation Metadata",
        "fields": [
        {
        "typeName": "title",
        "multiple": false,
        "value": "<xsl:value-of select="$title"/>",
        "typeClass": "primitive"
        },
        <xsl:if test="$alternative-title !=''">
            {
            "typeName": "alternativeTitle",
            "multiple": false,
            "typeClass": "primitive",
            "value": "<xsl:value-of select="$alternative-title"/>"
            },
        </xsl:if>
        {
        "typeName": "dsDescription",
        "multiple": true,
        "typeClass": "compound",
        "value": [<xsl:value-of select="$description"/>]
        },
        <xsl:if test="//emd:language !=''">

            {
            "typeName": "language",
            "multiple": true,
            "typeClass": "controlledVocabulary",
            "value": [<xsl:for-each select="//emd:language/dc:language[@eas:scheme='ISO 639']">
            <xsl:call-template name="languages"><xsl:with-param name="val" select="."></xsl:with-param></xsl:call-template>
            <xsl:if test="position() != last()">
                <xsl:text>,</xsl:text>
            </xsl:if>
        </xsl:for-each>]
            },
        </xsl:if>
        <xsl:if test="//emd:relation/eas:isReferencedBy !=''">
            {
            "typeName": "publication",
            "multiple": true,
            "typeClass": "compound",
            "value": [
            <xsl:for-each select="//emd:relation/eas:isReferencedBy">
                <xsl:variable name="pub-title">
                    <xsl:call-template name="string-escape-characters">
                        <xsl:with-param name="text" select="./eas:subject-title"></xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                {
                "publicationCitation": {
                "typeName": "publicationCitation",
                "multiple": false,
                "typeClass": "primitive",
                "value": "<xsl:value-of select="$pub-title"/>"
                },
                "publicationURL": {
                "typeName": "publicationURL",
                "multiple": false,
                "typeClass": "primitive",
                "value": "<xsl:value-of select="./eas:subject-link"/>"
                }
                }
                <xsl:if test="position() != last()">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
            ]
            },
        </xsl:if>
        <xsl:if test="//emd:relation/eas:references/eas:subject-title !=''">
            {
            "typeName": "otherReferences",
            "multiple": true,
            "typeClass": "primitive",
            "value": [
            <xsl:for-each select="//emd:relation/eas:references/eas:subject-title">
                <xsl:variable name="pub-title">
                    <xsl:call-template name="string-escape-characters">
                        <xsl:with-param name="text" select="."></xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                "<xsl:value-of select="$pub-title"/>"
                <xsl:if test="position() != last()">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
            ]
            },
        </xsl:if>
        <xsl:if test="//emd:relation/eas:references/eas:subject-link !=''">
            {
            "typeName": "otherReferences",
            "multiple": true,
            "typeClass": "primitive",
            "value": [
            <xsl:for-each select="//emd:relation/eas:references/eas:subject-link">
                "<xsl:value-of select="."/>"
                <xsl:if test="position() != last()">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
            ]
            },
        </xsl:if>
        {
        "typeName": "author",
        "multiple": true,
        "typeClass": "compound",
        "value": [
        <xsl:for-each select="//emd:creator/eas:creator">
            <xsl:if test="$author-eas !=''">
                <xsl:variable name="auth-affiliation">
                    <xsl:call-template name="string-escape-characters">
                        <xsl:with-param name="text" select="normalize-space(./eas:organization)"></xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
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
                "value": "<xsl:value-of select="$auth-affiliation"/>",
                "typeClass": "primitive"
                }
                }
            </xsl:if>
            <xsl:if test="$author!=''">
                <xsl:variable name="author-norm">
                    <xsl:call-template name="string-escape-characters">
                        <xsl:with-param name="text" select="normalize-space($author)"></xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:if test="$author-eas != ''">,</xsl:if>
                {
                "authorName": {
                "typeName": "authorName",
                "multiple": false,
                "value": "<xsl:value-of select="normalize-space($author-norm)"/>",
                "typeClass": "primitive"
                }
                }
            </xsl:if>
            <xsl:if test="position() != last()">
                <xsl:text>,</xsl:text>
            </xsl:if>
        </xsl:for-each>
        ]
        },
        {
        "typeName": "subject",
        "multiple": true,
        "value": [<xsl:value-of select="normalize-space($subject)"/>],
        "typeClass": "controlledVocabulary"
        },
        <xsl:if test="//emd:subject/dc:subject !=''">
            {
            "typeName": "keyword",
            "multiple": true,
            "typeClass": "compound",
            "value": [
            <xsl:for-each select="//emd:subject/dc:subject">
                <xsl:variable name="keyword">
                    <xsl:call-template name="string-escape-characters">
                        <xsl:with-param name="text" select="normalize-space(.)"></xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                {
                "keywordValue": {
                "typeName": "keywordValue",
                "multiple": false,
                "typeClass": "primitive",
                "value": "<xsl:value-of select="$keyword"/>"
                }
                }
                <xsl:if test="position() != last()">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
            ]
            },
        </xsl:if>
        <xsl:if test="//emd:publisher/dc:publisher !=''">
            {
            "typeName": "distributor",
            "multiple": true,
            "typeClass": "compound",
            "value": [
            <xsl:for-each select="//emd:publisher/dc:publisher">
                <xsl:if test=". != ''">
                    <xsl:variable name="publisher">
                        <xsl:call-template name="string-escape-characters">
                            <xsl:with-param name="text" select="normalize-space(.)"></xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    {
                    "distributorName": {
                    "typeName": "distributorName",
                    "multiple": false,
                    "typeClass": "primitive",
                    "value": "<xsl:value-of select="$publisher"/>"
                    }
                    }
                </xsl:if>
                <xsl:if test="position() != last()">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
            ]
            },
        </xsl:if>
        <xsl:if test="$distribution-date !=''">
            {
            "typeName": "distributionDate",
            "multiple": false,
            "typeClass": "primitive",
            "value": "2007-07-07"
            },
        </xsl:if>
        <xsl:if test="//emd:contributor/eas:contributor !='' and //emd:contributor/eas:contributor/eas:role[@eas:scheme='DATACITE'] !='' ">
            {
            "typeName": "contributor",
            "multiple": true,
            "typeClass": "compound",
            "value": [
            <xsl:for-each select="//emd:contributor/eas:contributor">
                <xsl:variable name="contributor-eas">
                    <xsl:call-template name="display-name">
                        <xsl:with-param name="display-title" select="./eas:title"/>
                        <xsl:with-param name="display-initials" select="./eas:initials"/>
                        <xsl:with-param name="display-prefix" select="./eas:prefix"/>
                        <xsl:with-param name="display-surname" select="./eas:surname"/>
                        <xsl:with-param name="display-organization" select="./eas:organization"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:if test="$contributor-eas !=''">
                    <xsl:variable name="role-data-cite" select="./eas:role[@eas:scheme='DATACITE']"/>
                    {
                    "contributorType": {
                    "typeName": "contributorType",
                    "multiple": false,
                    "typeClass": "controlledVocabulary",
                    "value": "Project Leader"
                    },
                    "contributorName": {
                    "typeName": "contributorName",
                    "multiple": false,
                    "typeClass": "primitive",
                    "value": "<xsl:value-of select="$contributor-eas"/>"
                    }
                    }
                    <xsl:if test="position() != last()">
                        <xsl:text>,</xsl:text>
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>
            ]
            },
        </xsl:if>


        <xsl:if test="//emd:type !=''">
            {
            "typeName":"kindOfData",
            "multiple":true,
            "typeClass":"primitive",
            "value":[<xsl:for-each select="//emd:type/dc:type">
            <xsl:variable name="kind-norm">
                <xsl:call-template name="string-escape-characters">
                    <xsl:with-param name="text" select="normalize-space(.)"></xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            "<xsl:value-of select="$kind-norm"/>"
            <xsl:if test="position() != last()">
                <xsl:text>,</xsl:text>
            </xsl:if>
        </xsl:for-each>]
            },
        </xsl:if>
        <xsl:variable name="isbn" select="//emd:identifier/dc:identifier[@eas:scheme='ISBN']"/>
        <xsl:variable name="eDNA-project" select="//emd:identifier/dc:identifier[@eas:scheme='eDNA-project']"/>
        <xsl:variable name="AIP_ID" select="//emd:identifier/dc:identifier[@eas:scheme='AIP_ID']"/>
        <xsl:variable name="PID" select="//emd:identifier/dc:identifier[@eas:scheme='PID']"/>
        <xsl:variable name="DMO_ID" select="//emd:identifier/dc:identifier[@eas:scheme='DMO_ID']"/>
        <xsl:if test="$isbn !='' or $eDNA-project !='' or $AIP_ID !='' or $PID !='' or $DMO_ID !=''">
            {
            "typeName": "otherId",
            "multiple": true,
            "typeClass": "compound",
            "value": [

            <xsl:if test="$isbn !=''">
                {
                "otherIdAgency": {
                "typeName": "otherIdAgency",
                "multiple": false,
                "typeClass": "primitive",
                "value": "ISBN"
                },
                "otherIdValue": {
                "typeName": "otherIdValue",
                "multiple": false,
                "typeClass": "primitive",
                "value": "<xsl:value-of select="$isbn"/>"
                }
                }
            </xsl:if>

            <xsl:if test="$eDNA-project !=''">
                <xsl:if test="$isbn !=''">,</xsl:if>
                {
                "otherIdAgency": {
                "typeName": "otherIdAgency",
                "multiple": false,
                "typeClass": "primitive",
                "value": "eDNA-project"
                },
                "otherIdValue": {
                "typeName": "otherIdValue",
                "multiple": false,
                "typeClass": "primitive",
                "value": "<xsl:value-of select="$eDNA-project"/>"
                }
                }
            </xsl:if>

            <xsl:if test="$AIP_ID !=''">
                <xsl:if test="$isbn !='' or $eDNA-project !=''">,</xsl:if>
                {
                "otherIdAgency": {
                "typeName": "otherIdAgency",
                "multiple": false,
                "typeClass": "primitive",
                "value": "AIP_ID"
                },
                "otherIdValue": {
                "typeName": "otherIdValue",
                "multiple": false,
                "typeClass": "primitive",
                "value": "<xsl:value-of select="$AIP_ID"/>"
                }
                }
            </xsl:if>

            <xsl:if test="$PID !=''">
                <xsl:if test="$isbn !='' or $eDNA-project !='' or $AIP_ID !=''">,</xsl:if>
                {
                "otherIdAgency": {
                "typeName": "otherIdAgency",
                "multiple": false,
                "typeClass": "primitive",
                "value": "PID"
                },
                "otherIdValue": {
                "typeName": "otherIdValue",
                "multiple": false,
                "typeClass": "primitive",
                "value": "<xsl:value-of select="$PID"/>"
                }
                }
            </xsl:if>

            <xsl:if test="$DMO_ID !=''">
                <xsl:if test="$isbn !='' or $eDNA-project !='' or $AIP_ID !='' or $PID !=''">,</xsl:if>
                {
                "otherIdAgency": {
                "typeName": "otherIdAgency",
                "multiple": false,
                "typeClass": "primitive",
                "value": "DMO_ID"
                },
                "otherIdValue": {
                "typeName": "otherIdValue",
                "multiple": false,
                "typeClass": "primitive",
                "value": "<xsl:value-of select="$DMO_ID"/>"
                }
                }
            </xsl:if>

            ]
            },
        </xsl:if>
        <xsl:variable name="source" select="//emd:source/dc:source"/>
        <xsl:if test="$source !=''">
            <xsl:variable name="source-norm">
                <xsl:call-template name="string-escape-characters">
                    <xsl:with-param name="text" select="normalize-space($source)"></xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            {
            "typeName": "dataSources",
            "multiple": true,
            "typeClass": "primitive",
            "value": ["<xsl:value-of select="normalize-space($source-norm)"/>"]
            },
        </xsl:if>
        {
        "typeName": "datasetContact",
        "multiple": true,
        "typeClass": "compound",
        "value": [
        {
        "datasetContacEmail": {
        "typeName": "datasetContactEmail",
        "multiple": false,
        "value": "info@dans.knaw.nl",
        "typeClass": "primitive"
        }
        }
        ]
        }
        ]

        }
        <xsl:if test="//emd:coverage ='skip-this'">
            ,
            "geospatial": {
            "displayName": "Geospatial Metadata",
            "fields":
            [
            {
            "typeName": "geographicCoverage",
            "multiple": true,
            "typeClass": "compound",
            "value": [
            {
            "country": {
            "typeName": "country",
            "multiple": false,
            "typeClass": "controlledVocabulary",
            "value": "Netherlands"
            },
            "city": {
            "typeName": "city",
            "multiple": false,
            "typeClass": "primitive",
            "value": "Leiden"
            }
            }
            ]
            }
            <xsl:if test="//emd:coverage/eas:spatial/eas:box[@eas:scheme='degrees'] !=''">
                ,
                {
                "typeName": "geographicBoundingBox",
                "multiple": true,
                "typeClass": "compound",
                "value": [
                {
                "northLongitude": {
                "typeName": "northLongitude",
                "multiple": false,
                "typeClass": "primitive",
                "value": "<xsl:value-of select="//emd:coverage/eas:spatial/eas:box/eas:north"/>"
                },
                "westLongitude": {
                "typeName": "westLongitude",
                "multiple": false,
                "typeClass": "primitive",
                "value": "<xsl:value-of select="//emd:coverage/eas:spatial/eas:box/eas:west"/>"
                },
                "eastLongitude": {
                "typeName": "eastLongitude",
                "multiple": false,
                "typeClass": "primitive",
                "value": "<xsl:value-of select="//emd:coverage/eas:spatial/eas:box/eas:east"/>"
                },

                "southLongitude": {
                "typeName": "southLongitude",
                "multiple": false,
                "typeClass": "primitive",
                "value": "<xsl:value-of select="//emd:coverage/eas:spatial/eas:box/eas:south"/>"
                }
                }
                ]
                }
            </xsl:if>
            ]
            }
        </xsl:if>
        },
        "files": [
        <xsl:for-each select="//files/file">
            <xsl:if test="position() &lt; 101">
                <xsl:variable name="fn">
                    <xsl:call-template name="file_name"><xsl:with-param name="text" select="@name"></xsl:with-param></xsl:call-template>
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

                <xsl:variable name="dn" select="@path"/>
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
                <xsl:variable name="sha1">
                    <xsl:choose>
                        <xsl:when test="sha1/. = '' or sha1/.='null'">
                            <xsl:value-of select="$fnxyza"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="sha1/."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                {
                "label": "<xsl:value-of select="$fnxyza"/>",
                "restricted": false,
                "directoryLabel": "<xsl:value-of select="$dnxyzabcde"/>",
                "version": 1,
                "dataFile": {
                "contentType": "<xsl:value-of select="mimeType/."/>",
                "filesize": <xsl:value-of select="size/."/>,
                "storageIdentifier": "<xsl:value-of select="$sha1"/>",
                "rootDataFileId": -1,
                "checksum": {
                "type": "SHA-1",
                "value": "<xsl:value-of select="$sha1"/>"
                }
                }
                }
                <xsl:if test="position() != last() and position() &lt; 100">
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

            <xsl:when test="$val = 'easy-discipline:76'">
                "<xsl:value-of select="'Analytical chemistry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:30'">
                "<xsl:value-of select="'History of law'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:179'">
                "<xsl:value-of select="'Cardiovascular disorders'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:57'">
                "<xsl:value-of select="'Science and technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:86'">
                "<xsl:value-of select="'Technical mechanics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:187'">
                "<xsl:value-of select="'Otorhinolaryngology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:172'">
                "<xsl:value-of select="'Dermatology, venereology, rheumatology, orthopaedics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:207'">
                "<xsl:value-of select="'Rehabilitation'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:170'">
                "<xsl:value-of select="'Traumatology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:147'">
                "<xsl:value-of select="'Life sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:48'">
                "<xsl:value-of select="'Personnel administration and management'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:6'">
                "<xsl:value-of select="'Social Sciences (Dutch)'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:41'">
                "<xsl:value-of select="'Educational theory'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:4'">
                "<xsl:value-of select="'Carare'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:129'">
                "<xsl:value-of select="'Information systems, databases'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:200'">
                "<xsl:value-of select="'Social medicine'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:51'">
                "<xsl:value-of select="'Sociology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:73'">
                "<xsl:value-of select="'Gases, fluid dynamics, plasma physics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:180'">
                "<xsl:value-of select="'Gastrointestinal system'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:75'">
                "<xsl:value-of select="'Chemistry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:66'">
                "<xsl:value-of select="'Numerical analysis'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:126'">
                "<xsl:value-of select="'Computer systems, architectures, networks'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:80'">
                "<xsl:value-of select="'Physical chemistry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:89'">
                "<xsl:value-of select="'Road vehicles, rail vehicles'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:120'">
                "<xsl:value-of select="'Paleontology, stratigraphy'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:211'">
                "<xsl:value-of select="'History and philosphy of the life sciences, ethics, evolution biology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:171'">
                "<xsl:value-of select="'Organs and organ systems '"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:116'">
                "<xsl:value-of select="'Energy'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:72'">
                "<xsl:value-of select="'Atomic and molecular physics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:5'">
                "<xsl:value-of select="'Common Language Resources and Technology Infrastructure'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:1'">
                "<xsl:value-of select="'Oral History'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:122'">
                "<xsl:value-of select="'Petrology, mineralogy, sedimentology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:60'">
                "<xsl:value-of select="'Algebra, group theory'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:47'">
                "<xsl:value-of select="'Leisure and recreation studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:5'">
                "<xsl:value-of select="'History of arts and architecture'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:192'">
                "<xsl:value-of select="'Anesthesiology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:153'">
                "<xsl:value-of select="'Anatomy, morphology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:193'">
                "<xsl:value-of select="'Radiology, radiotherapy'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:94'">
                "<xsl:value-of select="'Telecommunication engineering'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:85'">
                "<xsl:value-of select="'Mechanical engineering'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:49'">
                "<xsl:value-of select="'Social geography'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:root'">
                "<xsl:value-of select="''"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:213'">
                "<xsl:value-of select="'History and philosophy of the behavioural sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:61'">
                "<xsl:value-of select="'Functions, differential equations'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:224'">
                "<xsl:value-of select="'Nanotechnology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-research-area:root'">
                "<xsl:value-of select="''"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:69'">
                "<xsl:value-of select="'Theoretical physics, (quantum) mechanics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:2'">
                "<xsl:value-of select="'World War II'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:173'">
                "<xsl:value-of select="'Dermatology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:93'">
                "<xsl:value-of select="'Electrical engineering'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:215'">
                "<xsl:value-of select="'Architecture and building construction'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:79'">
                "<xsl:value-of select="'Inorganic chemistry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:3'">
                "<xsl:value-of select="'Arts and culture'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:15'">
                "<xsl:value-of select="'Baltic and Slavonic language and literature studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:163'">
                "<xsl:value-of select="'Zoology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:132'">
                "<xsl:value-of select="'Computer graphics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:107'">
                "<xsl:value-of select="'Chemical technology, process technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:205'">
                "<xsl:value-of select="'Nutrition'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:3'">
                "<xsl:value-of select="'Getuigen Verhalen'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:198'">
                "<xsl:value-of select="'Pediatrics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:125'">
                "<xsl:value-of select="'Computer science'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:17'">
                "<xsl:value-of select="'Germanic language and literature studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:208'">
                "<xsl:value-of select="'Veterinary medicine'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:20'">
                "<xsl:value-of select="'Paleography, bibliology, bibliography,  library science'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:222'">
                "<xsl:value-of select="'Migration, ethnic relations and multiculturalism'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:90'">
                "<xsl:value-of select="'Vessels'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:214'">
                "<xsl:value-of select="'History and philosophy of the social sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:206'">
                "<xsl:value-of select="'Kinesiology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:174'">
                "<xsl:value-of select="'Venereology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:16'">
                "<xsl:value-of select="'Classic studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:212'">
                "<xsl:value-of select="'History and philosophy of the humanities'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:154'">
                "<xsl:value-of select="'Physiology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:142'">
                "<xsl:value-of select="'Agriculture and horticulture'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:46'">
                "<xsl:value-of select="'Development studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:140'">
                "<xsl:value-of select="'Nature and landscape'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:4'">
                "<xsl:value-of select="'Dramaturgy'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:63'">
                "<xsl:value-of select="'Geometry, topology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:164'">
                "<xsl:value-of select="'Toxicology (plants, invertebrates)'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:186'">
                "<xsl:value-of select="'Neurology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:87'">
                "<xsl:value-of select="'Engines, energy converters'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:96'">
                "<xsl:value-of select="'Electrical energy technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:35'">
                "<xsl:value-of select="'International law'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:117'">
                "<xsl:value-of select="'Technology assessment'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:55'">
                "<xsl:value-of select="'Health sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:78'">
                "<xsl:value-of select="'Organic chemistry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:121'">
                "<xsl:value-of select="'Physical geology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:141'">
                "<xsl:value-of select="'Plant production and animal production'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:62'">
                "<xsl:value-of select="'Fourier analysis, functional analysis'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:43'">
                "<xsl:value-of select="'Communication sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:178'">
                "<xsl:value-of select="'Blood and lymphatic diseases'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:109'">
                "<xsl:value-of select="'Organic-chemical technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:194'">
                "<xsl:value-of select="'Biopharmacology, toxicology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:root'">
                "<xsl:value-of select="''"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:131'">
                "<xsl:value-of select="'Artificial intelligence, expert systems'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:123'">
                "<xsl:value-of select="'Atmospheric sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:195'">
                "<xsl:value-of select="'Psychiatry, clinical psychology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:216'">
                "<xsl:value-of select="'Linguistics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:149'">
                "<xsl:value-of select="'Biophysics, clinical physics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:7'">
                "<xsl:value-of select="'Musicology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:209'">
                "<xsl:value-of select="'Digital humanities'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:23'">
                "<xsl:value-of select="'Law and public administration '"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:114'">
                "<xsl:value-of select="'Engineering geology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:220'">
                "<xsl:value-of select="'Biotechnology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:128'">
                "<xsl:value-of select="'Theoretical computer science'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:67'">
                "<xsl:value-of select="'Physics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:95'">
                "<xsl:value-of select="'Microelectronics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:185'">
                "<xsl:value-of select="'Neurology, otorhinolaryngology, opthalmology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:175'">
                "<xsl:value-of select="'Rheumatology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:204'">
                "<xsl:value-of select="'Health education, prevention'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:42'">
                "<xsl:value-of select="'Social sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:158'">
                "<xsl:value-of select="'Microbiology'"/>"
            </xsl:when>

            <xsl:when test="$val = 'easy-discipline:199'">
                "<xsl:value-of select="'Geriatrics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:56'">
                "<xsl:value-of select="'Geodesy, physical geography'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:139'">
                "<xsl:value-of select="'Soil'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:88'">
                "<xsl:value-of select="'Vehicle and transport technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:39'">
                "<xsl:value-of select="'Pedagogics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:191'">
                "<xsl:value-of select="'Surgery'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:225'">
                "<xsl:value-of select="'Greenhouse gas mitigation'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:21'">
                "<xsl:value-of select="'Philosophy'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:181'">
                "<xsl:value-of select="'Gynaecology and obstetrics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:135'">
                "<xsl:value-of select="'Agriculture and the physical environment'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:104'">
                "<xsl:value-of select="'Drinking water supply'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:2'">
                "<xsl:value-of select="'Archaeology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:98'">
                "<xsl:value-of select="'Civil engineering, building technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:190'">
                "<xsl:value-of select="'Medical specialisms'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:28'">
                "<xsl:value-of select="'Social and public administration'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:124'">
                "<xsl:value-of select="'Hydrospheric sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:221'">
                "<xsl:value-of select="'Technology in medicine and health care'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:138'">
                "<xsl:value-of select="'Surfacewater and groundwater'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:177'">
                "<xsl:value-of select="'Internal medicine'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:156'">
                "<xsl:value-of select="'Epidemiology and medical statistics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:169'">
                "<xsl:value-of select="'Allergology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:68'">
                "<xsl:value-of select="'Metrology, scientific instrumentation'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:115'">
                "<xsl:value-of select="'Industrial design'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:84'">
                "<xsl:value-of select="'Materials technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:165'">
                "<xsl:value-of select="'Medicine'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:103'">
                "<xsl:value-of select="'Sanitary engineering'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:44'">
                "<xsl:value-of select="'Cultural anthropology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:203'">
                "<xsl:value-of select="'Nursing sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:110'">
                "<xsl:value-of select="'Fuel technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:168'">
                "<xsl:value-of select="'Oncology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:118'">
                "<xsl:value-of select="'Earth sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:146'">
                "<xsl:value-of select="'Agriculturural technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:52'">
                "<xsl:value-of select="'Urban and rural planning'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:59'">
                "<xsl:value-of select="'Logic, set theory and arithmetic'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:182'">
                "<xsl:value-of select="'Pulmonary disorders'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:32'">
                "<xsl:value-of select="'Criminal (procedural) law and criminology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:148'">
                "<xsl:value-of select="'Bioinformatics, biomathematics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:81'">
                "<xsl:value-of select="'Catalysis'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:130'">
                "<xsl:value-of select="'User interfaces, multimedia'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:133'">
                "<xsl:value-of select="'Computer simulation, virtual reality'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:58'">
                "<xsl:value-of select="'Mathematics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:50'">
                "<xsl:value-of select="'Social security studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:161'">
                "<xsl:value-of select="'Ecology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:24'">
                "<xsl:value-of select="'Economics and Business Administration'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:151'">
                "<xsl:value-of select="'Genetics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:145'">
                "<xsl:value-of select="'Forestry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:99'">
                "<xsl:value-of select="'Building technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:31'">
                "<xsl:value-of select="'Private (procedural) law'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:159'">
                "<xsl:value-of select="'Biogeography, taxonomy'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:82'">
                "<xsl:value-of select="'Theoretical chemistry, quantum chemistry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:83'">
                "<xsl:value-of select="'Technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:77'">
                "<xsl:value-of select="'Macromolecular chemistry, polymer chemistry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:19'">
                "<xsl:value-of select="'Language and literature studies of other language groups'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:71'">
                "<xsl:value-of select="'Elementary particle physics and nuclear physics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:97'">
                "<xsl:value-of select="'Measurement and control engineering'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:65'">
                "<xsl:value-of select="'Operations research'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:36'">
                "<xsl:value-of select="'Traffic and transport studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:166'">
                "<xsl:value-of select="'Pathology, pathological anatomy'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:33'">
                "<xsl:value-of select="'Constitutional and administrative law'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:18'">
                "<xsl:value-of select="'Romance language and literature studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:226'">
                "<xsl:value-of select="'Biobased economy'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:37'">
                "<xsl:value-of select="'Behavioural and educational sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:202'">
                "<xsl:value-of select="'Occupational medicine'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:102'">
                "<xsl:value-of select="'Offshore technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:196'">
                "<xsl:value-of select="'Age-related medical specialisms'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:160'">
                "<xsl:value-of select="'Animal ethology, animal psychology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:6'">
                "<xsl:value-of select="'Media sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:40'">
                "<xsl:value-of select="'Psychology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:167'">
                "<xsl:value-of select="'Infections, parasitology, virology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:64'">
                "<xsl:value-of select="'Probability theory, statistics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:70'">
                "<xsl:value-of select="'Electromagnetism, optics, acoustics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:150'">
                "<xsl:value-of select="'Biochemistry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:105'">
                "<xsl:value-of select="'Waste water treatment'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:91'">
                "<xsl:value-of select="'Aircraft and spacecraft'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:22'">
                "<xsl:value-of select="'Theology and religious studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:136'">
                "<xsl:value-of select="'Exploitation and management  physical environment'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:127'">
                "<xsl:value-of select="'Software, algorithms, control systems'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:26'">
                "<xsl:value-of select="'Political and administrative sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:9'">
                "<xsl:value-of select="'Antiquity'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:134'">
                "<xsl:value-of select="'Astronomy, astrophysics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-sdef:oai-item1'">
                "<xsl:value-of select="'Service Definition for easy-model:oai-item1'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:210'">
                "<xsl:value-of select="'History and philosophy of science and technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:201'">
                "<xsl:value-of select="'Primary care (including General practice)'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:217'">
                "<xsl:value-of select="'Area Studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:27'">
                "<xsl:value-of select="'Political science'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:188'">
                "<xsl:value-of select="'Ophthalmology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:155'">
                "<xsl:value-of select="'Immunology, serology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:137'">
                "<xsl:value-of select="'Air'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:108'">
                "<xsl:value-of select="'Inorganic-chemical technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:157'">
                "<xsl:value-of select="'Biology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-model:oai-set1'">
                "<xsl:value-of select="'Content Model of OAI Set Objects'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:144'">
                "<xsl:value-of select="'Fisheries'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:184'">
                "<xsl:value-of select="'Urology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:189'">
                "<xsl:value-of select="'Dentistry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:10'">
                "<xsl:value-of select="'Middle Ages'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:218'">
                "<xsl:value-of select="'Defence'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:38'">
                "<xsl:value-of select="'Gerontology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:152'">
                "<xsl:value-of select="'Histology, cell biology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:14'">
                "<xsl:value-of select="'Language and literature studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:100'">
                "<xsl:value-of select="'Civil engineering'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:101'">
                "<xsl:value-of select="'Hydraulic engineering'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:8'">
                "<xsl:value-of select="'History'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:119'">
                "<xsl:value-of select="'Geochemistry, geophysics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:34'">
                "<xsl:value-of select="'Interdisciplinary branches of law'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:11'">
                "<xsl:value-of select="'Modern and contemporary history'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:223'">
                "<xsl:value-of select="'Environmental studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:92'">
                "<xsl:value-of select="'Manufacturing technology, mechanical technology, robotics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:143'">
                "<xsl:value-of select="'Animal husbandry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:113'">
                "<xsl:value-of select="'Mining engineering'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:111'">
                "<xsl:value-of select="'Food technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:106'">
                "<xsl:value-of select="'Waste treatment'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-sdep:oai-item1'">
                "<xsl:value-of select="'Deployment of easy-sdef:oai-item1'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:54'">
                "<xsl:value-of select="'Life sciences, medicine and health care '"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:197'">
                "<xsl:value-of select="'Neonatology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:45'">
                "<xsl:value-of select="'Demography'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:74'">
                "<xsl:value-of select="'Solid-state physics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:53'">
                "<xsl:value-of select="'Gender studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:176'">
                "<xsl:value-of select="'Orthopaedics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:162'">
                "<xsl:value-of select="'Botany'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:29'">
                "<xsl:value-of select="'Science of law'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:1'">
                "<xsl:value-of select="'Humanities'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:219'">
                "<xsl:value-of select="'Interdisciplinary sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-data:oai-driverset1'">
                "<xsl:value-of select="'OAI set: Open Access DRIVERset'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:183'">
                "<xsl:value-of select="'Nephrology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:112'">
                "<xsl:value-of select="'Geotechnics'"/>"
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
    <xsl:template name ="display-name">
        <xsl:param name="display-title"/>
        <xsl:param name="display-initials"/>
        <xsl:param name="display-prefix"/>
        <xsl:param name="display-surname"/>
        <xsl:param name="display-organization"/>
        <xsl:choose>
            <xsl:when test="not($display-surname)">
                <xsl:value-of select="$display-organization"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$display-prefix"/>&#160;<xsl:value-of select="$display-surname"/>, <xsl:value-of select="$display-initials"/> <xsl:value-of select="$display-title"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="languages">
        <xsl:param name="val"/>
        <!-- make our own map, it's small -->
        <xsl:choose>
            <xsl:when test="$val = 'dut/nld'">
                "<xsl:value-of select="'Dutch'"/>"
            </xsl:when>
            <xsl:when test="$val = 'eng'">
                "<xsl:value-of select="'English'"/>"
            </xsl:when>
            <xsl:when test="$val = 'ger/deu'">
                "<xsl:value-of select="'German'"/>"
            </xsl:when>
            <xsl:when test="$val = 'fre/fra'">
                "<xsl:value-of select="'French'"/>"
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
