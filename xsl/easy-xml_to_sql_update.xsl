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
    <xsl:output method="text" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>
    <xsl:template match="/">
        <xsl:variable name="doi-identifier" select="//emd:identifier/dc:identifier[@eas:scheme='DOI']/."/>
        <xsl:variable name="pd" select="/dataset/published"/>
UPDATE dvobject SET authority='<xsl:value-of select="substring-before($doi-identifier, '/')"/>', createdate='<xsl:value-of select="$pd"/>', globalidcreatetime='<xsl:value-of select="$pd"/>', modificationtime='<xsl:value-of select="$pd"/>', publicationdate='<xsl:value-of select="$pd"/>' WHERE dtype='Dataset' AND identifier='<xsl:value-of select="substring-after($doi-identifier, '/')"/>';
UPDATE datasetversion SET createtime='<xsl:value-of select="$pd"/>', releasetime='<xsl:value-of select="$pd"/>' WHERE dataset_id=(SELECT id FROM dvobject WHERE dtype='Dataset' AND identifier='<xsl:value-of select="substring-after($doi-identifier, '/')"/>');
</xsl:template>
</xsl:stylesheet>