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
            <xsl:if test="position() &lt; 1001">
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
                "<xsl:value-of select="'Agricultural Sciences'"/>"
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
