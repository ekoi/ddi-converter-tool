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
        <xsl:variable name="subject-custom">
            <xsl:for-each select="//emd:audience/dct:audience">
                <xsl:call-template name="audiencefromkeywordcustom"><xsl:with-param name="val" select="."></xsl:with-param></xsl:call-template>
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
        "authority":"<xsl:value-of select="substring-before($doi-identifier, '/')"/>",
        "identifier":"doi:<xsl:value-of select="substring-before($doi-identifier, '/')"/>/<xsl:value-of select="substring-after($doi-identifier, '/')"/>",
        "metadataBlocks": {
        "easy-metadata": {
        "displayName": "Electronic Archiving SYstem - DANS Custom Metadata",
        "fields": [
        {
        "typeName": "easy-pno",
        "multiple": true,
        "typeClass": "compound",
        "value":
        [
        <xsl:for-each select="//emd:creator/eas:creator">
            <xsl:variable name="easy-pno-role-val">
                <xsl:call-template name="easy-pno-role">
                    <xsl:with-param name="val" select="./eas:role[@eas:scheme='DATACITE']"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="organization-val">
                <xsl:call-template name="string-escape-oraginzation">
                    <xsl:with-param name="text" select="./eas:organization"></xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            {
            <xsl:if test="$easy-pno-role-val !=''">
                "easy-pno-role": {
                "typeName": "easy-pno-role",
                "multiple": false,
                "typeClass": "controlledVocabulary",
                "value": "<xsl:value-of select="$easy-pno-role-val"/>"
                },
            </xsl:if>
            "easy-pno-organisation": {
            "typeName": "easy-pno-organisation",
            "multiple": false,
            "typeClass": "primitive",
            "value": "<xsl:value-of select="$organization-val"/>"
            },

            "easy-pno-titles": {
            "typeName": "easy-pno-titles",
            "multiple": false,
            "typeClass": "primitive",
            "value": "<xsl:value-of select="./eas:title"/>"
            },
            "easy-pno-initials": {
            "typeName": "easy-pno-initials",
            "multiple": false,
            "typeClass": "primitive",
            "value": "<xsl:value-of select="./eas:initials"/>"
            },
            "easy-pno-prefix": {
            "typeName": "easy-pno-prefix",
            "multiple": false,
            "typeClass": "primitive",
            "value": "<xsl:value-of select="./eas:prefix"/>"
            },
            "easy-pno-surname": {
            "typeName": "easy-pno-surname",
            "multiple": false,
            "typeClass": "primitive",
            "value": "<xsl:value-of select="./eas:surname"/>"
            },

            "easy-pno-id-dai": {
            "typeName": "easy-pno-id-dai",
            "multiple": false,
            "typeClass": "primitive",
            "value": "<xsl:value-of select="./eas:role[@eas:scheme='DAI']"/>"
            },
            "easy-pno-id-isni": {
            "typeName": "easy-pno-id-isni",
            "multiple": false,
            "typeClass": "primitive",
            "value": "<xsl:value-of select="./eas:role[@eas:scheme='ISNI']"/>"
            },
            "easy-pno-id-orcid": {
            "typeName": "easy-pno-id-orcid",
            "multiple": false,
            "typeClass": "primitive",
            "value": "<xsl:value-of select="./eas:role[@eas:scheme='ORCID']"/>"
            }
            }
            <xsl:if test="position() != last()">
                <xsl:text>,</xsl:text>
            </xsl:if>
        </xsl:for-each>
        ]
        }
        ,
        <xsl:variable name="easy-collection-val">
            <xsl:call-template name="termfromcollection">
                <xsl:with-param name="val" select="/dataset/collections[1]/collection[1]"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$easy-collection-val !=''">
            {
            "typeName": "easy-collection",
            "multiple": false,
            "typeClass": "controlledVocabulary",
            "value": <xsl:value-of select="$easy-collection-val"/>
            },
        </xsl:if>
        <xsl:if test="$subject-custom !='Other'">
            {
            "typeName": "easy-audience",
            "multiple": true,
            "typeClass": "controlledVocabulary",
            "value": [<xsl:value-of select="$subject-custom"/>]
            }
            ]
            },
        </xsl:if>

        "citation": {
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
            <xsl:variable name="author-eas">
                <xsl:call-template name="display-name-default">
                    <xsl:with-param name="display-initials" select="./eas:initials"/>
                    <xsl:with-param name="display-prefix" select="./eas:prefix"/>
                    <xsl:with-param name="display-surname" select="./eas:surname"/>
                    <xsl:with-param name="display-organization" select="./eas:organization"/>
                </xsl:call-template>
            </xsl:variable>
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
                <xsl:if test="$author-eas != ''">,</xsl:if>
                <xsl:for-each select="//dc:creator">
                    <xsl:variable name="author-norm">
                        <xsl:call-template name="string-escape-characters">
                            <xsl:with-param name="text" select="normalize-space(.)"></xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>

                    {
                    "authorName": {
                    "typeName": "authorName",
                    "multiple": false,
                    "value": "<xsl:value-of select="$author-norm"/>",
                    "typeClass": "primitive"
                    }
                    }
                    <xsl:if test="position() != last()">
                        <xsl:text>,</xsl:text>
                    </xsl:if>
                </xsl:for-each>

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
                    <xsl:call-template name="display-name-default">
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
                <!-- File Name cannot contain any of the following characters:  / : * ? \" < > | ; # -->
                <!-- For xslt: https://www.rapidtables.com/web/html/html-codes.html -->
                <!-- For unicode: https://www.utf8-chartable.de/ -->
                <!-- Replace # with  (U+0023) -->
                <!-- Replace : with  (U+0023) -->
                <!-- Replace ? with  (U+003F) -->
                <xsl:variable name="fnxy" select="replace($fnx, '#', '(U+0023)')"/>
                <xsl:variable name="fnxyz" select="replace($fnxy, '&#58;', '(U+003A)')"/>
                <xsl:variable name="fnxyza" select="replace($fnxyz, '\&#63;', '(U+003F)')"/>
                <!-- Directory name: Valid characters are a-Z, 0-9, '_', '-', '.', '\\', '/' and ' ' (white space) -->
                <xsl:variable name="dn" select="@path"/>
                <xsl:variable name="apos">'</xsl:variable>
                <xsl:variable name="dnx">
                    <xsl:call-template name="string-replace-all">
                        <xsl:with-param name="text" select="$dn"></xsl:with-param>
                        <!-- Replace ' with  _U-0027_ -->
                        <xsl:with-param name="replace" select="$apos"></xsl:with-param>
                        <xsl:with-param name="by" select="'_U-0027_'"></xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="dnxy">
                    <xsl:call-template name="string-replace-all">
                        <xsl:with-param name="text" select="$dnx"></xsl:with-param>
                        <!-- Replace , with  _U-002C_ -->
                        <xsl:with-param name="replace" select="','"></xsl:with-param>
                        <xsl:with-param name="by" select="'_U-002C_'"></xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="dnxyz">
                    <xsl:call-template name="string-replace-all">
                        <xsl:with-param name="text" select="$dnxy"></xsl:with-param>
                        <!-- Replace ( with  _U-0028_ -->
                        <xsl:with-param name="replace" select="'('"></xsl:with-param>
                        <xsl:with-param name="by" select="'_U-0028_'"></xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="dnxyza">
                    <xsl:call-template name="string-replace-all">
                        <xsl:with-param name="text" select="$dnxyz"></xsl:with-param>
                        <!-- Replace ) with  _U-0029_ -->
                        <xsl:with-param name="replace" select="')'"></xsl:with-param>
                        <xsl:with-param name="by" select="'_U-0029_'"></xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <!-- Replace ; with  _U-003B_ -->
                <xsl:variable name="dnxyzab" select="replace($dnxyza, '&amp;', '_U-003B_')"/>
                <!-- Replace + with  _U-002B_ -->
                <xsl:variable name="dnxyzabc" select="replace($dnxyzab, '\+', '_U-002B_')"/>
                <!-- Replace : with  _U-003A_ -->
                <xsl:variable name="dnxyzabcd"  select="replace($dnxyzabc, '&#58;', '_U-003A_')"/>
                <!-- Replace ö with  _U-00D6_ -->
                <xsl:variable name="dnxyzabcde" select="replace($dnxyzabcd, '&#246;','_U-00D6_')"/>
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
                "storageIdentifier": "<xsl:value-of select="@name"/>",
                "rootDataFileId": -1,
                "checksum": {
                "type": "SHA-1",
                "value": "<xsl:value-of select="$sha1"/>"
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
    <xsl:template name="easy-pno-role">
        <xsl:param name="val"/>
        <xsl:choose>
            <xsl:when test="$val = 'Creator'">
                <xsl:value-of select="'Creator'"/>
            </xsl:when>
            <xsl:when test="$val = 'DataCollector'">
                <xsl:value-of select="'Data Collector'"/>
            </xsl:when>
            <xsl:when test="$val = 'Editor'">
                <xsl:value-of select="'Editor'"/>
            </xsl:when>
            <xsl:when test="$val = 'HostingInstitution'">
                <xsl:value-of select="'Hosting institution'"/>
            </xsl:when>
            <xsl:when test="$val = 'ProjectLeader'">
                <xsl:value-of select="'Project leader'"/>
            </xsl:when>
            <xsl:when test="$val = 'ProjectMember'">
                <xsl:value-of select="'Project member'"/>
            </xsl:when>
            <xsl:when test="$val = 'RelatedPerson'">
                <xsl:value-of select="'Related person'"/>
            </xsl:when>
            <xsl:when test="$val = 'ResearchGroup'">
                <xsl:value-of select="'Research group'"/>
            </xsl:when>
            <xsl:when test="$val = 'Researcher'">
                <xsl:value-of select="'Researcher'"/>
            </xsl:when>
            <xsl:when test="$val = 'Sponsor'">
                <xsl:value-of select="'Sponsor'"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="audiencefromkeywordcustom">
        <xsl:param name="val"/>
        <!-- make our own map, it's small -->
        <xsl:choose>

            <xsl:when test="$val = 'easy-discipline:76'">
                "<xsl:value-of select="'------ Analytical chemistry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:30'">
                "<xsl:value-of select="'------ History of law'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:179'">
                "<xsl:value-of select="'------------ Cardiovascular disorders'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:57'">
                "<xsl:value-of select="'Science and technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:86'">
                "<xsl:value-of select="'--------- Technical mechanics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:187'">
                "<xsl:value-of select="'------------ Otorhinolaryngology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:172'">
                "<xsl:value-of select="'--------- Dermatology, venereology, rheumatology, orthopaedics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:207'">
                "<xsl:value-of select="'------ Rehabilitation'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:170'">
                "<xsl:value-of select="'--------- Traumatology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:147'">
                "<xsl:value-of select="'--- Life sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:48'">
                "<xsl:value-of select="'--- Personnel administration and management'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:6'">
                "<xsl:value-of select="'Social Sciences (Dutch)'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:41'">
                "<xsl:value-of select="'--- Educational theory'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:4'">
                "<xsl:value-of select="'Carare'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:129'">
                "<xsl:value-of select="'------ Information systems, databases'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:200'">
                "<xsl:value-of select="'--------- Social medicine'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:51'">
                "<xsl:value-of select="'--- Sociology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:73'">
                "<xsl:value-of select="'------ Gases, fluid dynamics, plasma physics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:180'">
                "<xsl:value-of select="'------------ Gastrointestinal system'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:75'">
                "<xsl:value-of select="'--- Chemistry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:66'">
                "<xsl:value-of select="'------ Numerical analysis'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:126'">
                "<xsl:value-of select="'------ Computer systems, architectures, networks'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:80'">
                "<xsl:value-of select="'------ Physical chemistry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:89'">
                "<xsl:value-of select="'------------ Road vehicles, rail vehicles'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:120'">
                "<xsl:value-of select="'------ Paleontology, stratigraphy'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:211'">
                "<xsl:value-of select="'------ History and philosphy of the life sciences, ethics, evolution biology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:171'">
                "<xsl:value-of select="'Organs and organ systems'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:116'">
                "<xsl:value-of select="'------ Energy'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:72'">
                "<xsl:value-of select="'------ Atomic and molecular physics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:5'">
                "<xsl:value-of select="'Common Language Resources and Technology Infrastructure'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:1'">
                "<xsl:value-of select="'Oral History'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:122'">
                "<xsl:value-of select="'------ Petrology, mineralogy, sedimentology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:60'">
                "<xsl:value-of select="'------ Algebra, group theory'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:47'">
                "<xsl:value-of select="'--- Leisure and recreation studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:5'">
                "<xsl:value-of select="'------ History of arts and architecture'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:192'">
                "<xsl:value-of select="'--------- Anesthesiology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:153'">
                "<xsl:value-of select="'------ Anatomy, morphology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:193'">
                "<xsl:value-of select="'--------- Radiology, radiotherapy'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:94'">
                "<xsl:value-of select="'--------- Telecommunication engineering'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:85'">
                "<xsl:value-of select="'------ Mechanical engineering'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:49'">
                "<xsl:value-of select="'--- Social geography'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:root'">
                "<xsl:value-of select="''"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:213'">
                "<xsl:value-of select="'------ History and philosophy of the behavioural sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:61'">
                "<xsl:value-of select="'------ Functions, differential equations'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:224'">
                "<xsl:value-of select="'--- Nanotechnology'"/>"
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
                "<xsl:value-of select="'------------ Dermatology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:93'">
                "<xsl:value-of select="'------ Electrical engineering'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:215'">
                "<xsl:value-of select="'------ Architecture and building construction'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:79'">
                "<xsl:value-of select="'------ Inorganic chemistry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:3'">
                "<xsl:value-of select="'--- Arts and culture'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:15'">
                "<xsl:value-of select="'------ Baltic and Slavonic language and literature studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:163'">
                "<xsl:value-of select="'------ Zoology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:132'">
                "<xsl:value-of select="'------ Computer graphics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:107'">
                "<xsl:value-of select="'------ Chemical technology, process technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:205'">
                "<xsl:value-of select="'------ Nutrition'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:3'">
                "<xsl:value-of select="'Getuigen Verhalen'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:198'">
                "<xsl:value-of select="'------------ Pediatrics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:125'">
                "<xsl:value-of select="'--- Computer science'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:17'">
                "<xsl:value-of select="'------ Germanic language and literature studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:208'">
                "<xsl:value-of select="'--- Veterinary medicine'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:20'">
                "<xsl:value-of select="'--- Paleography, bibliology, bibliography, library science'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:222'">
                "<xsl:value-of select="'--- Migration, ethnic relations and multiculturalism'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:90'">
                "<xsl:value-of select="'------------ Vessels'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:214'">
                "<xsl:value-of select="'------ History and philosophy of the social sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:206'">
                "<xsl:value-of select="'--- Kinesiology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:174'">
                "<xsl:value-of select="'------------ Venereology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:16'">
                "<xsl:value-of select="'------ Classic studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:212'">
                "<xsl:value-of select="'------ History and philosophy of the humanities'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:154'">
                "<xsl:value-of select="'------ Physiology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:142'">
                "<xsl:value-of select="'--------- Agriculture and horticulture'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:46'">
                "<xsl:value-of select="'--- Development studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:140'">
                "<xsl:value-of select="'--------- Nature and landscape'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:4'">
                "<xsl:value-of select="'------ Dramaturgy'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:63'">
                "<xsl:value-of select="'------ Geometry, topology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:164'">
                "<xsl:value-of select="'Toxicology (plants, invertebrates)'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:186'">
                "<xsl:value-of select="'------------ Neurology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:87'">
                "<xsl:value-of select="'--------- Engines, energy converters'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:96'">
                "<xsl:value-of select="'--------- Electrical energy technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:35'">
                "<xsl:value-of select="'------ International law'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:117'">
                "<xsl:value-of select="'------ Technology assessment'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:55'">
                "<xsl:value-of select="'--- Health sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:78'">
                "<xsl:value-of select="'------ Organic chemistry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:121'">
                "<xsl:value-of select="'------ Physical geology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:141'">
                "<xsl:value-of select="'------ Plant production and animal production'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:62'">
                "<xsl:value-of select="'------ Fourier analysis, functional analysis'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:43'">
                "<xsl:value-of select="'--- Communication sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:178'">
                "<xsl:value-of select="'------------ Blood and lymphatic diseases'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:109'">
                "<xsl:value-of select="'--------- Organic-chemical technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:194'">
                "<xsl:value-of select="'--------- Biopharmacology, toxicology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:root'">
                "<xsl:value-of select="''"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:131'">
                "<xsl:value-of select="'------ Artificial intelligence, expert systems'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:123'">
                "<xsl:value-of select="'------ Atmospheric sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:195'">
                "<xsl:value-of select="'--------- Psychiatry, clinical psychology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:216'">
                "<xsl:value-of select="'------ Linguistics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:149'">
                "<xsl:value-of select="'------ Biophysics, clinical physics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:7'">
                "<xsl:value-of select="'------ Musicology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:209'">
                "<xsl:value-of select="'------ Digital humanities'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:23'">
                "<xsl:value-of select="'Law and public administration'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:114'">
                "<xsl:value-of select="'--------- Engineering geology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:220'">
                "<xsl:value-of select="'--- Biotechnology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:128'">
                "<xsl:value-of select="'------ Theoretical computer science'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:67'">
                "<xsl:value-of select="'--- Physics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:95'">
                "<xsl:value-of select="'--------- Microelectronics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:185'">
                "<xsl:value-of select="'--------- Neurology, otorhinolaryngology, opthalmology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:175'">
                "<xsl:value-of select="'------------ Rheumatology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:204'">
                "<xsl:value-of select="'------ Health education, prevention'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:42'">
                "<xsl:value-of select="'Social sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:158'">
                "<xsl:value-of select="'------ Microbiology'"/>"
            </xsl:when>

            <xsl:when test="$val = 'easy-discipline:199'">
                "<xsl:value-of select="'------------ Geriatrics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:56'">
                "<xsl:value-of select="'------ Geodesy, physical geography'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:139'">
                "<xsl:value-of select="'--------- Soil'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:88'">
                "<xsl:value-of select="'--------- Vehicle and transport technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:39'">
                "<xsl:value-of select="'--- Pedagogics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:191'">
                "<xsl:value-of select="'--------- Surgery'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:225'">
                "<xsl:value-of select="'--- Greenhouse gas mitigation'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:21'">
                "<xsl:value-of select="'--- Philosophy'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:181'">
                "<xsl:value-of select="'------------ Gynaecology and obstetrics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:135'">
                "<xsl:value-of select="'--- Agriculture and the physical environment'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:104'">
                "<xsl:value-of select="'------------ Drinking water supply'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:2'">
                "<xsl:value-of select="'--- Archaeology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:98'">
                "<xsl:value-of select="'------ Civil engineering, building technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:190'">
                "<xsl:value-of select="'------ Medical specialisms'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:28'">
                "<xsl:value-of select="'------ Social and public administration'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:124'">
                "<xsl:value-of select="'------ Hydrospheric sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:221'">
                "<xsl:value-of select="'--- Technology in medicine and health care'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:138'">
                "<xsl:value-of select="'--------- Surfacewater and groundwater'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:177'">
                "<xsl:value-of select="'--------- Internal medicine'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:156'">
                "<xsl:value-of select="'------ Epidemiology and medical statistics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:169'">
                "<xsl:value-of select="'--------- Allergology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:68'">
                "<xsl:value-of select="'------ Metrology, scientific instrumentation'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:115'">
                "<xsl:value-of select="'------ Industrial design'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:84'">
                "<xsl:value-of select="'------ Materials technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:165'">
                "<xsl:value-of select="'--- Medicine'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:103'">
                "<xsl:value-of select="'--------- Sanitary engineering'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:44'">
                "<xsl:value-of select="'--- Cultural anthropology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:203'">
                "<xsl:value-of select="'------ Nursing sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:110'">
                "<xsl:value-of select="'--------- Fuel technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:168'">
                "<xsl:value-of select="'--------- Oncology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:118'">
                "<xsl:value-of select="'--- Earth sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:146'">
                "<xsl:value-of select="'--------- Agriculturural technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:52'">
                "<xsl:value-of select="'--- Urban and rural planning'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:59'">
                "<xsl:value-of select="'------ Logic, set theory and arithmetic'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:182'">
                "<xsl:value-of select="'------------ Pulmonary disorders'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:32'">
                "<xsl:value-of select="'------ Criminal (procedural) law and criminology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:148'">
                "<xsl:value-of select="'------ Bioinformatics, biomathematics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:81'">
                "<xsl:value-of select="'------ Catalysis'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:130'">
                "<xsl:value-of select="'------ User interfaces, multimedia'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:133'">
                "<xsl:value-of select="'------ Computer simulation, virtual reality'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:58'">
                "<xsl:value-of select="'--- Mathematics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:50'">
                "<xsl:value-of select="'--- Social security studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:161'">
                "<xsl:value-of select="'------ Ecology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:24'">
                "<xsl:value-of select="'Economics and Business Administration'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:151'">
                "<xsl:value-of select="'------ Genetics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:145'">
                "<xsl:value-of select="'--------- Forestry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:99'">
                "<xsl:value-of select="'--------- Building technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:31'">
                "<xsl:value-of select="'------ Private (procedural) law'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:159'">
                "<xsl:value-of select="'------ Biogeography, taxonomy'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:82'">
                "<xsl:value-of select="'------ Theoretical chemistry, quantum chemistry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:83'">
                "<xsl:value-of select="'--- Technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:77'">
                "<xsl:value-of select="'------ Macromolecular chemistry, polymer chemistry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:19'">
                "<xsl:value-of select="'------ Language and literature studies of other language groups'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:71'">
                "<xsl:value-of select="'------ Elementary particle physics and nuclear physics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:97'">
                "<xsl:value-of select="'--------- Measurement and control engineering'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:65'">
                "<xsl:value-of select="'------ Operations research'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:36'">
                "<xsl:value-of select="'--- Traffic and transport studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:166'">
                "<xsl:value-of select="'------ Pathology, pathological anatomy'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:33'">
                "<xsl:value-of select="'------ Constitutional and administrative law'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:18'">
                "<xsl:value-of select="'------ Romance language and literature studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:226'">
                "<xsl:value-of select="'--- Biobased economy'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:37'">
                "<xsl:value-of select="'Behavioural and educational sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:202'">
                "<xsl:value-of select="'--------- Occupational medicine'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:102'">
                "<xsl:value-of select="'------------ Offshore technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:196'">
                "<xsl:value-of select="'--------- Age-related medical specialisms'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:160'">
                "<xsl:value-of select="'------ Animal ethology, animal psychology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:6'">
                "<xsl:value-of select="'------ Media sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:40'">
                "<xsl:value-of select="'--- Psychology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:167'">
                "<xsl:value-of select="'--------- Infections, parasitology, virology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:64'">
                "<xsl:value-of select="'------ Probability theory, statistics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:70'">
                "<xsl:value-of select="'------ Electromagnetism, optics, acoustics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:150'">
                "<xsl:value-of select="'Biochemistry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:105'">
                "<xsl:value-of select="'------------ Waste water treatment'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:91'">
                "<xsl:value-of select="'------------ Aircraft and spacecraft'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:22'">
                "<xsl:value-of select="'--- Theology and religious studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:136'">
                "<xsl:value-of select="'Exploitation and management  physical environment'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:127'">
                "<xsl:value-of select="'------ Software, algorithms, control systems'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:26'">
                "<xsl:value-of select="'--- Political and administrative sciences'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:9'">
                "<xsl:value-of select="'------ Antiquity'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:134'">
                "<xsl:value-of select="'--- Astronomy, astrophysics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-sdef:oai-item1'">
                "<xsl:value-of select="'Service Definition for easy-model:oai-item1'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:210'">
                "<xsl:value-of select="'------ History and philosophy of science and technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:201'">
                "<xsl:value-of select="'Primary care (including General practice)'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:217'">
                "<xsl:value-of select="'--- Area Studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:27'">
                "<xsl:value-of select="'------ Political science'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:188'">
                "<xsl:value-of select="'------------ Ophthalmology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:155'">
                "<xsl:value-of select="'------ Immunology, serology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:137'">
                "<xsl:value-of select="'--------- Air'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:108'">
                "<xsl:value-of select="'--------- Inorganic-chemical technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:157'">
                "<xsl:value-of select="'--- Biology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-model:oai-set1'">
                "<xsl:value-of select="'Content Model of OAI Set Objects'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:144'">
                "<xsl:value-of select="'--------- Fisheries'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:184'">
                "<xsl:value-of select="'------------ Urology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:189'">
                "<xsl:value-of select="'--------- Dentistry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:10'">
                "<xsl:value-of select="'------ Middle Ages'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:218'">
                "<xsl:value-of select="'--------- Defence'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:38'">
                "<xsl:value-of select="'--- Gerontology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:152'">
                "<xsl:value-of select="'------ Histology, cell biology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:14'">
                "<xsl:value-of select="'--- Language and literature studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:100'">
                "<xsl:value-of select="'--------- Civil engineering'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:101'">
                "<xsl:value-of select="'--------- Hydraulic engineering'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:8'">
                "<xsl:value-of select="'--- History'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:119'">
                "<xsl:value-of select="'------ Geochemistry, geophysics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:34'">
                "<xsl:value-of select="'------ Interdisciplinary branches of law'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:11'">
                "<xsl:value-of select="'------ Modern and contemporary history'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:223'">
                "<xsl:value-of select="'--- Environmental studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:92'">
                "<xsl:value-of select="'--------- Manufacturing technology, mechanical technology, robotics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:143'">
                "<xsl:value-of select="'--------- Animal husbandry'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:113'">
                "<xsl:value-of select="'--------- Mining engineering'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:111'">
                "<xsl:value-of select="'--------- Food technology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:106'">
                "<xsl:value-of select="'------------ Waste treatment'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-sdep:oai-item1'">
                "<xsl:value-of select="'Deployment of easy-sdef:oai-item1'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:54'">
                "<xsl:value-of select="'Life sciences, medicine and health care'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:197'">
                "<xsl:value-of select="'------------ Neonatology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:45'">
                "<xsl:value-of select="'--- Demography'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:74'">
                "<xsl:value-of select="'------ Solid-state physics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:53'">
                "<xsl:value-of select="'--- Gender studies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:176'">
                "<xsl:value-of select="'------------ Orthopaedics'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:162'">
                "<xsl:value-of select="'------ Botany'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:29'">
                "<xsl:value-of select="'--- Science of law'"/>"
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
                "<xsl:value-of select="'------------ Nephrology'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-discipline:112'">
                "<xsl:value-of select="'------ Geotechnics'"/>"
            </xsl:when>
            <xsl:otherwise>
                <!-- TEMP!! -->
                "<xsl:value-of select="'Other'"/>"
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="termfromcollection">
        <xsl:param name="val"/>
        <!-- make our own map, it's small -->
        <xsl:choose>
            <xsl:when test="$val = 'easy-collection:1'">
                "<xsl:value-of select="'Oral History'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:2'">
                "<xsl:value-of select="'World War II'"/>"
            </xsl:when>
            <!-- Getuigen Verhalen is a subcollection -->
            <xsl:when test="$val = 'easy-collection:3'">
                "<xsl:value-of select="'World War II - Getuigen Verhalen'"/>"
            </xsl:when>
            <!-- possible alternative code -->
            <xsl:when test="$val = 'easy-collection:2:3'">
                "<xsl:value-of select="'World War II - Getuigen Verhalen'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:4'">
                "<xsl:value-of select="'Carare'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:5'">
                "<xsl:value-of select="'CLARIN'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:6'">
                "<xsl:value-of select="'Social Sciences (Dutch)'"/>"
            </xsl:when>
            <xsl:when test="$val = 'easy-collection:7'">
                "<xsl:value-of select="'Social Sciences (English)'"/>"
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="abr">
        <xsl:param name="val"/>
        <xsl:choose>
            <xsl:when test="$val = 'DEPO'">
                "<xsl:value-of select="'Depot'"/>"
            </xsl:when>
            <xsl:when test="$val = 'ELA'">
                "<xsl:value-of select="'Economie - Akker/tuin'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EIBB'">
                "<xsl:value-of select="'Economie - Beenbewerking'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EIB'">
                "<xsl:value-of select="'Economie - Brouwerij'"/>"
            </xsl:when>
            <xsl:when test="$val = 'ELCF'">
                "<xsl:value-of select="'Economie - Celtic field/raatakker'"/>"
            </xsl:when>
            <xsl:when test="$val = 'ELDP'">
                "<xsl:value-of select="'Economie - Drenkplaats/dobbe'"/>"
            </xsl:when>
            <xsl:when test="$val = 'ELEK'">
                "<xsl:value-of select="'Economie - Eendekooi'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EIGB'">
                "<xsl:value-of select="'Economie - Glasblazerij'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EGX'">
                "<xsl:value-of select="'Economie - Grondstofwinning'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EIHB'">
                "<xsl:value-of select="'Economie - Houtbewerking'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EIHK'">
                "<xsl:value-of select="'Economie - Houtskool-/kolenbranderij'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EGYW'">
                "<xsl:value-of select="'Economie - IJzerwinning'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EIX'">
                "<xsl:value-of select="'Economie - Industrie/nijverheid'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EIKB'">
                "<xsl:value-of select="'Economie - Kalkbranderij'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EGKW'">
                "<xsl:value-of select="'Economie - Kleiwinning'"/>"
            </xsl:when>
            <xsl:when test="$val = 'ELX'">
                "<xsl:value-of select="'Economie - Landbouw'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EILL'">
                "<xsl:value-of select="'Economie - Leerlooierij'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EGMW'">
                "<xsl:value-of select="'Economie - Mergel-/kalkwinning'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EIMB'">
                "<xsl:value-of select="'Economie - Metaalbewerking/smederij'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EIM'">
                "<xsl:value-of select="'Economie - Molen'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EIPB'">
                "<xsl:value-of select="'Economie - Pottenbakkerij'"/>"
            </xsl:when>
            <xsl:when test="$val = 'ESCH'">
                "<xsl:value-of select="'Economie - Scheepvaart'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EISM'">
                "<xsl:value-of select="'Economie - Smelterij'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EISB'">
                "<xsl:value-of select="'Economie - Steen-/pannenbakkerij'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EITN'">
                "<xsl:value-of select="'Economie - Textielnijverheid'"/>"
            </xsl:when>
            <xsl:when test="$val = 'ELVK'">
                "<xsl:value-of select="'Economie - Veekraal/schaapskooi'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EGVW'">
                "<xsl:value-of select="'Economie - Veenwinning'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EVX'">
                "<xsl:value-of select="'Economie - Visserij'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EIVB'">
                "<xsl:value-of select="'Economie - Vuursteenbewerking'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EGVU'">
                "<xsl:value-of select="'Economie - Vuursteenwinning'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EGZW'">
                "<xsl:value-of select="'Economie - Zoutwinning/moernering'"/>"
            </xsl:when>
            <xsl:when test="$val = 'EX'">
                "<xsl:value-of select="'Economie, onbepaald'"/>"
            </xsl:when>
            <xsl:when test="$val = 'GC'">
                "<xsl:value-of select="'Begraving - Crematiegraf'"/>"
            </xsl:when>
            <xsl:when test="$val = 'GD'">
                "<xsl:value-of select="'Begraving - Dierengraf'"/>"
            </xsl:when>
            <xsl:when test="$val = 'GHC'">
                "<xsl:value-of select="'Begraving - Grafheuvel, crematie'"/>"
            </xsl:when>
            <xsl:when test="$val = 'GHIC'">
                "<xsl:value-of select="'Begraving - Grafheuvel, gemengd'"/>"
            </xsl:when>
            <xsl:when test="$val = 'GHI'">
                "<xsl:value-of select="'Begraving - Grafheuvel, inhumatie'"/>"
            </xsl:when>
            <xsl:when test="$val = 'GHX'">
                "<xsl:value-of select="'Begraving - Grafheuvel, onbepaald'"/>"
            </xsl:when>
            <xsl:when test="$val = 'GVC'">
                "<xsl:value-of select="'Begraving - Grafveld, crematies'"/>"
            </xsl:when>
            <xsl:when test="$val = 'GVIC'">
                "<xsl:value-of select="'Begraving - Grafveld, gemengd'"/>"
            </xsl:when>
            <xsl:when test="$val = 'GVI'">
                "<xsl:value-of select="'Begraving - Grafveld, inhumaties'"/>"
            </xsl:when>
            <xsl:when test="$val = 'GVX'">
                "<xsl:value-of select="'Begraving - Grafveld, onbepaald'"/>"
            </xsl:when>
            <xsl:when test="$val = 'GI'">
                "<xsl:value-of select="'Begraving - Inhumatiegraf'"/>"
            </xsl:when>
            <xsl:when test="$val = 'GVIK'">
                "<xsl:value-of select="'Begraving - Kerkhof'"/>"
            </xsl:when>
            <xsl:when test="$val = 'GMEG'">
                "<xsl:value-of select="'Begraving - Megalietgraf'"/>"
            </xsl:when>
            <xsl:when test="$val = 'GVIR'">
                "<xsl:value-of select="'Begraving - Rijengrafveld'"/>"
            </xsl:when>
            <xsl:when test="$val = 'GVCU'">
                "<xsl:value-of select="'Begraving - Urnenveld'"/>"
            </xsl:when>
            <xsl:when test="$val = 'GCV'">
                "<xsl:value-of select="'Begraving - Vlakgraf, crematie'"/>"
            </xsl:when>
            <xsl:when test="$val = 'GIV'">
                "<xsl:value-of select="'Begraving - Vlakgraf, inhumatie'"/>"
            </xsl:when>
            <xsl:when test="$val = 'GXV'">
                "<xsl:value-of select="'Begraving - Vlakgraf, onbepaald'"/>"
            </xsl:when>
            <xsl:when test="$val = 'GX'">
                "<xsl:value-of select="'Begraving, onbepaald'"/>"
            </xsl:when>
            <xsl:when test="$val = 'IBRU'">
                "<xsl:value-of select="'Infrastructuur - Brug'"/>"
            </xsl:when>
            <xsl:when test="$val = 'IDAM'">
                "<xsl:value-of select="'Infrastructuur - Dam'"/>"
            </xsl:when>
            <xsl:when test="$val = 'IDIJ'">
                "<xsl:value-of select="'Infrastructuur - Dijk'"/>"
            </xsl:when>
            <xsl:when test="$val = 'IDUI'">
                "<xsl:value-of select="'Infrastructuur - Duiker'"/>"
            </xsl:when>
            <xsl:when test="$val = 'IGEM'">
                "<xsl:value-of select="'Infrastructuur - Gemaal'"/>"
            </xsl:when>
            <xsl:when test="$val = 'IHAV'">
                "<xsl:value-of select="'Infrastructuur - Haven'"/>"
            </xsl:when>
            <xsl:when test="$val = 'IKAN'">
                "<xsl:value-of select="'Infrastructuur - Kanaal/vaarweg'"/>"
            </xsl:when>
            <xsl:when test="$val = 'IPER'">
                "<xsl:value-of select="'Infrastructuur - Percelering/verkaveling'"/>"
            </xsl:when>
            <xsl:when test="$val = 'ISLU'">
                "<xsl:value-of select="'Infrastructuur - Sluis'"/>"
            </xsl:when>
            <xsl:when test="$val = 'ISTE'">
                "<xsl:value-of select="'Infrastructuur - Steiger'"/>"
            </xsl:when>
            <xsl:when test="$val = 'IVW'">
                "<xsl:value-of select="'Infrastructuur - Veenweg/veenbrug'"/>"
            </xsl:when>
            <xsl:when test="$val = 'IWAT'">
                "<xsl:value-of select="'Infrastructuur - Waterweg (natuurlijk)'"/>"
            </xsl:when>
            <xsl:when test="$val = 'IWEG'">
                "<xsl:value-of select="'Infrastructuur - Weg'"/>"
            </xsl:when>
            <xsl:when test="$val = 'IX'">
                "<xsl:value-of select="'Infrastructuur, onbepaald'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NBAS'">
                "<xsl:value-of select="'Nederzetting - Basiskamp/basisnederzetting'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NVB'">
                "<xsl:value-of select="'Nederzetting - Borg/stins/versterkt huis'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NEXT'">
                "<xsl:value-of select="'Nederzetting - Extractiekamp/-nederzetting'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NVH'">
                "<xsl:value-of select="'Nederzetting - Havezathe/ridderhofstad'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NHP'">
                "<xsl:value-of select="'Nederzetting - Huisplaats, onverhoogd'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NHT'">
                "<xsl:value-of select="'Nederzetting - Huisterp'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NKD'">
                "<xsl:value-of select="'Nederzetting - Kampdorp'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NMS'">
                "<xsl:value-of select="'Nederzetting - Moated site'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NRV'">
                "<xsl:value-of select="'Nederzetting - Romeins villa(complex)'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NS'">
                "<xsl:value-of select="'Nederzetting - Stad'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NT'">
                "<xsl:value-of select="'Nederzetting - Terp/wierde'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NWD'">
                "<xsl:value-of select="'Nederzetting - Wegdorp'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NX'">
                "<xsl:value-of select="'Nederzetting, onbepaald'"/>"
            </xsl:when>
            <xsl:when test="$val = 'RCP'">
                "<xsl:value-of select="'Religie - Cultusplaats/heiligdom/tempel'"/>"
            </xsl:when>
            <xsl:when test="$val = 'RKAP'">
                "<xsl:value-of select="'Religie - Kapel'"/>"
            </xsl:when>
            <xsl:when test="$val = 'RKER'">
                "<xsl:value-of select="'Religie - Kerk'"/>"
            </xsl:when>
            <xsl:when test="$val = 'RKLO'">
                "<xsl:value-of select="'Religie - Klooster(complex)'"/>"
            </xsl:when>
            <xsl:when test="$val = 'RX'">
                "<xsl:value-of select="'Religie, onbepaald'"/>"
            </xsl:when>
            <xsl:when test="$val = 'VK'">
                "<xsl:value-of select="'Versterking - Kasteel'"/>"
            </xsl:when>
            <xsl:when test="$val = 'VLW'">
                "<xsl:value-of select="'Versterking - Landweer'"/>"
            </xsl:when>
            <xsl:when test="$val = 'VLP'">
                "<xsl:value-of select="'Versterking - Legerplaats'"/>"
            </xsl:when>
            <xsl:when test="$val = 'VKM'">
                "<xsl:value-of select="'Versterking - Motte/kasteelheuvel/vliedberg'"/>"
            </xsl:when>
            <xsl:when test="$val = 'VSCH'">
                "<xsl:value-of select="'Versterking - Schans'"/>"
            </xsl:when>
            <xsl:when test="$val = 'VWP'">
                "<xsl:value-of select="'Versterking - Wachtpost'"/>"
            </xsl:when>
            <xsl:when test="$val = 'VWB'">
                "<xsl:value-of select="'Versterking - Wal-/vluchtburcht'"/>"
            </xsl:when>
            <xsl:when test="$val = 'VWAL'">
                "<xsl:value-of select="'Versterking - Wal/omwalling'"/>"
            </xsl:when>
            <xsl:when test="$val = 'VKW'">
                "<xsl:value-of select="'Versterking - Waterburcht'"/>"
            </xsl:when>
            <xsl:when test="$val = 'VX'">
                "<xsl:value-of select="'Versterking, onbepaald'"/>"
            </xsl:when>
            <xsl:when test="$val = 'XXX'">
                "<xsl:value-of select="'Onbekend'"/>"
            </xsl:when>
            <xsl:when test="$val = 'PALEO'">
                "<xsl:value-of select="'Paleolithicum: tot 8800 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'PALEOV'">
                "<xsl:value-of select="'Paleolithicum vroeg: tot 300000 C14'"/>"
            </xsl:when>
            <xsl:when test="$val = 'PALEOM'">
                "<xsl:value-of select="'Paleolithicum midden: 300000 - 35000 C14'"/>"
            </xsl:when>
            <xsl:when test="$val = 'PALEOL'">
                "<xsl:value-of select="'Paleolithicum laat: 35000 C14 - 8800 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'PALEOLA'">
                "<xsl:value-of select="'Paleolithicum laat A: 35000 - 18000 C14'"/>"
            </xsl:when>
            <xsl:when test="$val = 'PALEOB'">
                "<xsl:value-of select="'Paleolithicum laat B: 18000 C14 -8800 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'MESO'">
                "<xsl:value-of select="'Mesolithicum: 8800 - 4900 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'MESOV'">
                "<xsl:value-of select="'Mesolithicum vroeg: 8800 - 7100 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'MESOM'">
                "<xsl:value-of select="'Mesolithicum midden: 7100 - 6450 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'MESOL'">
                "<xsl:value-of select="'Mesolithicum laat: 6450 -4900 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NEO'">
                "<xsl:value-of select="'Neolithicum: 5300 - 2000 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NEOV'">
                "<xsl:value-of select="'Neolithicum vroeg: 5300 - 4200 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NEOVA'">
                "<xsl:value-of select="'Neolithicum vroeg A: 5300 - 4900 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NEOVB'">
                "<xsl:value-of select="'Neolithicum vroeg B: 4900 - 4200 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NEOM'">
                "<xsl:value-of select="'Neolithicum midden: 4200 - 2850 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NEOMA'">
                "<xsl:value-of select="'Neolithicum midden A: 4200 - 3400 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NEOMB'">
                "<xsl:value-of select="'Neolithicum midden B: 3400 - 2850 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NEOL'">
                "<xsl:value-of select="'Neolithicum laat: 2850 - 2000 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NEOLA'">
                "<xsl:value-of select="'Neolithicum laat A: 2850 - 2450 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NEOLB'">
                "<xsl:value-of select="'Neolithicum laat B: 2450 - 2000 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'BRONS'">
                "<xsl:value-of select="'Bronstijd: 2000 - 800 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'BRONSV'">
                "<xsl:value-of select="'Bronstijd vroeg: 2000 - 1800 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'BRONSM'">
                "<xsl:value-of select="'Bronstijd midden: 1800 - 1100 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'BRONSMA'">
                "<xsl:value-of select="'Bronstijd midden A: 1800 - 1500 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'BRONSMB'">
                "<xsl:value-of select="'Bronstijd midden B: 1500 - 1100 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'BRONSL'">
                "<xsl:value-of select="'Bronstijd laat: 1100 - 800 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'IJZ'">
                "<xsl:value-of select="'IJzertijd: 800 - 12 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'IJZV'">
                "<xsl:value-of select="'IJzertijd vroeg: 800 - 500 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'IJZM'">
                "<xsl:value-of select="'IJzertijd midden: 500 - 250 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'IJZL'">
                "<xsl:value-of select="'IJzertijd laat: 250 - 12 vC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'ROM'">
                "<xsl:value-of select="'Romeinse tijd: 12 vC - 450 nC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'ROMV'">
                "<xsl:value-of select="'Romeinse tijd vroeg: 12 vC - 70 nC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'ROMVA'">
                "<xsl:value-of select="'Romeinse tijd vroeg A: 12 vC - 25 nC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'ROMVB'">
                "<xsl:value-of select="'Romeinse tijd vroeg B: 25 - 70 nC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'ROMM'">
                "<xsl:value-of select="'Romeinse tijd midden: 70 - 270 nC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'ROMMA'">
                "<xsl:value-of select="'Romeinse tijd midden A: 70 - 150 nC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'ROMMB'">
                "<xsl:value-of select="'Romeinse tijd midden B: 150 - 270 nC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'ROML'">
                "<xsl:value-of select="'Romeinse tijd laat: 270 - 450 nC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'ROMLA'">
                "<xsl:value-of select="'Romeinse tijd laat A: 270 - 350 nC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'ROMLB'">
                "<xsl:value-of select="'Romeinse tijd laat B: 350 - 450 nC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'XME'">
                "<xsl:value-of select="'Middeleeuwen: 450 - 1500 nC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'VME'">
                "<xsl:value-of select="'Middeleeuwen vroeg: 450 - 1050 nC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'VMEA'">
                "<xsl:value-of select="'Middeleeuwen vroeg A: 450 - 525 nC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'VMEB'">
                "<xsl:value-of select="'Middeleeuwen vroeg B: 525 - 725 nC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'VMEC'">
                "<xsl:value-of select="'Middeleeuwen vroeg C: 725 - 900 nC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'VMED'">
                "<xsl:value-of select="'Middeleeuwen vroeg D: 900 - 1050 nC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'LME'">
                "<xsl:value-of select="'Middeleeuwen laat: 1050 - 1500 nC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'LMEA'">
                "<xsl:value-of select="'Middeleeuwen laat A: 1050 - 1250 nC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'LMEB'">
                "<xsl:value-of select="'Middeleeuwen laat B: 1250 - 1500 nC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NT'">
                "<xsl:value-of select="'Nieuwe tijd: 1500 - heden'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NTA'">
                "<xsl:value-of select="'Nieuwe tijd A: 1500 - 1650 nC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NTB'">
                "<xsl:value-of select="'Nieuwe tijd B: 1650 - 1850 nC'"/>"
            </xsl:when>
            <xsl:when test="$val = 'NTC'">
                "<xsl:value-of select="'Nieuwe tijd C: 1850 - heden'"/>"
            </xsl:when>
            <xsl:when test="$val = 'XXX'">
                "<xsl:value-of select="'Onbekend'"/>"
            </xsl:when>
        </xsl:choose>
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
                "<xsl:value-of select="'Organs and organ systems'"/>"
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
                "<xsl:value-of select="'Paleography, bibliology, bibliography, library science'"/>"
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
                "<xsl:value-of select="'Law and public administration'"/>"
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
                "<xsl:value-of select="'Life sciences, medicine and health care'"/>"
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
                <!-- TEMP!!!  -->
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
    <xsl:template name="string-escape-oraginzation">
        <xsl:param name="text" />
        <xsl:variable name="text-0">
            <xsl:value-of select="replace($text, '\\','\\\\')"/>
        </xsl:variable>
        <xsl:variable name="text-1">
            <xsl:value-of select="replace($text-0, '&#38;','\\\\&#38;amp;')"/>
        </xsl:variable>
        <xsl:variable name="text-2">
            <xsl:value-of select="replace($text-1, '&#34;','\\&#34;')"/>
        </xsl:variable>
        <xsl:value-of select="$text-2"/>
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
    <xsl:template name ="display-name-default">
        <xsl:param name="display-initials"/>
        <xsl:param name="display-prefix"/>
        <xsl:param name="display-surname"/>
        <xsl:param name="display-organization"/>
        <xsl:choose>
            <xsl:when test="not($display-surname)">
                <xsl:value-of select="$display-organization"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$display-prefix"/>&#160;<xsl:value-of select="$display-surname"/>, <xsl:value-of select="$display-initials"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name ="display-name-custom">
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