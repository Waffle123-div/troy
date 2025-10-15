<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" omit-xml-declaration="yes"/>

  <xsl:template match="/">
    <div>
      <style>
        table { width: 100%; border-collapse: collapse; }
        thead th { 
          text-align: left; 
          padding: 16px; 
          font-size: 14px; 
          font-weight: 600; 
          color: #1b3554; 
          border-bottom: 2px solid #80aad3; 
          background: rgba(192, 230, 253, 0.3); 
        }
        tbody td { 
          padding: 16px; 
          font-size: 14px; 
          border-bottom: 1px solid rgba(128, 170, 211, 0.3); 
          color: #000f22;
        }
        tbody tr:last-child td { 
          border-bottom: none; 
        }
        tbody tr { 
          transition: all 0.2s ease; 
        }
        tbody tr:hover { 
          background: rgba(192, 230, 253, 0.2); 
          transform: scale(1.01); 
        }
      </style>
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Course</th>
            <th>Year</th>
            <th>GPA</th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="students/student">
            <xsl:sort select="@id" data-type="text"/>
            <tr>
              <td><xsl:value-of select="@id"/></td>
              <td><xsl:value-of select="name"/></td>
              <td><xsl:value-of select="course"/></td>
              <td>
                <xsl:value-of select="year"/>
                <xsl:choose>
                  <xsl:when test="year='1'">st</xsl:when>
                  <xsl:when test="year='2'">nd</xsl:when>
                  <xsl:when test="year='3'">rd</xsl:when>
                  <xsl:otherwise>th</xsl:otherwise>
                </xsl:choose>
                Year
              </td>
              <td>
                <xsl:value-of select="grade"/>
                <xsl:if test="grade &lt;= 2.0">
                  <span style="display:inline-block;margin-left:8px;background:linear-gradient(135deg,#fbbf24,#f59e0b);color:white;padding:2px 8px;border-radius:10px;font-size:11px;font-weight:700;">⭐ Dean's List</span>
                </xsl:if>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </div>
  </xsl:template>
</xsl:stylesheet>


