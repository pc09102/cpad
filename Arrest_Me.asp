<%
	DIM NEWDATE
	DIM BIRTHDATE
	DIM IUCR
	DIM LAST
	dim count
	DIM DISTSTRING
	DIM ID
	DIM PWD

	NEWDATE = Request.Form("startyear")
	BIRTHDATE = Request.Form("birthmonth")&"/"& Request.Form("birthday")&"/" & Request.Form("birthyear")
	NEWNICK = UCase(Request.Form("NICK"))
	NEWSCAR = UCase(Request.Form("scars"))
	NEWID = Request.Form("ID")
	NEWPWD = Request.Form("PWD")
	NEWRD = UCase(Request.Form("RD"))
	NEWLAST = UCase(Request.Form("LAST"))
	NEWFIRST = UCase(Request.Form("FIRST"))
	NEWDISTRICT = Request.Form("DISTRICT MENU")
	NEWSEX = UCase(Request.Form("SEX"))
	NEWRACE = Request.Form("RACE")
	NEWAGE = Request.Form("AGE")
	NEWHGT = Request.Form("HGT")
	NEWWGT = Request.Form("WGT")
	NEWBEAT = Request.Form("BEAT MENU")

if NEWLAST <> "" then
	NEWLASTSTRING = " " & NEWLAST
	NEWLAST=" and (Arrests.LAST_NME like '" & NEWLAST & "%')"
else
	NEWLAST=""
	NEWLASTSTRING = ""
end if

if NEWFIRST <> "" then
	NEWFIRSTSTRING = " " & NEWFIRST
	NEWFIRST=" and (Arrests.FIRST_NME like '" & NEWFIRST & "%')"
else
	NEWFIRST=""
end if

if NEWSEX <> "" then
	NEWSEXSTRING = " " & NEWSEX
	NEWSEX=" and (Arrests.SEX_CODE_CD = '" & NEWSEX & "')"
else
	NEWSEX=""
end if

if NEWRACE <> "" then
	NEWRACESTRING = " " & NEWRACE
	NEWRACE=" and (Arrests.RACE_CODE_CD = '" & NEWRACE & "')"
else
	NEWRACE=""
end if

if NEWAGE <> "" then
	NEWAGESTRING = " " & NEWAGE
	NEWAGE=" and (Arrests.AGE like '" & NEWAGE & "%')"
else
	NEWAGE=""
end if

if NEWHGT <> "" then
	NEWHGTSTRING = " " & NEWHGT
	NEWHGT=" and (Arrests.HEIGHT like '" & NEWHGT & "%')"
else
	NEWHGT=""
end if

if NEWWGT <> "" then
	NEWWGTSTRING = " " & NEWWGT
	NEWWGT=" and (Arrests.WEIGHT like '" & NEWWGT & "%')"
else
	NEWWGT=""
end if

if NEWNICK <> "" then
	NEWNICKSTRING = " " & NEWNICK
	NEWNICK=" and (Arrests.NICKNAME like '" & NEWNICK & "%')"
else
	NEWNICK=""
	NEWNICKSTRING = ""
end if

if NEWSCAR <> "" then
	NEWSCARSTRING = " Mark/Scar/Tattoo - " & NEWSCAR
	NEWSCAR=" and (Arrests.SCARS_MARKS like '%" & NEWSCAR & "%')"
else
	NEWSCARSTRING = ""
	NEWSCAR = ""
end if

Select Case NEWDISTRICT
	Case "-"
	DISTSTRING = " ((Arrests.O_DISTRICT between 1 and 99) OR (Arrests.O_DISTRICT IS NULL))"
	NEWDISTSTRING = "Districts, CityWide"
	Case "Area 1"
	DISTSTRING = " Arrests.O_AREA = 1"
	NEWDISTSTRING = "Districts, " & NEWDISTRICT
	Case "Area 2"
	DISTSTRING = " Arrests.O_AREA = 2"
	NEWDISTSTRING = "Districts, " & NEWDISTRICT
	Case "Area 3"
	DISTSTRING = " Arrests.O_AREA = 3"
	NEWDISTSTRING = "Districts, " & NEWDISTRICT
	Case "Area 4"
	DISTSTRING = " Arrests.O_AREA = 4"
	NEWDISTSTRING = "Districts, " & NEWDISTRICT
	Case "Area 5"
	DISTSTRING = " Arrests.O_AREA = 5"
	NEWDISTSTRING = "Districts, " & NEWDISTRICT
	Case Else
	DISTSTRING = " Arrests.O_DISTRICT = " & NEWDISTRICT
	NEWDISTSTRING = " " & NEWDISTRICT
End Select

Select Case NEWBEAT
	Case "-"
		BEATSTRING = ""
	NEWBEATSTRING = " All Beats"
	Case Else
		DISTSTRING = ""
	NEWDISTSTRING = " "
		BEATSTRING = " Arrests.O_BEAT = " & NEWBEAT
	NEWBEATSTRING = " Beat " & NEWBEAT
End Select

If BIRTHDATE = "-/-/" Then
		NEWBIRTHDATE = " "
Else
		NEWBIRTHDATE = " and Arrests.BIRTH_DATE = TO_DATE('" & BIRTHDATE & "', 'MM/DD/YYYY')"
		BIRTHSTRING = " D.O.B. of " & BIRTHDATE
End If

if (NEWNICKSTRING <> "" and NEWLASTSTRING <> "") then
TITLESTRING = "Name/Nickname Like" & NEWLASTSTRING & NEWNICKSTRING
else
	if NEWLASTSTRING <> "" then
TITLESTRING = "Named Like" & NEWLASTSTRING
else
		if NEWNICKSTRING <> "" then
TITLESTRING = "NickNamed Like" & NEWNICKSTRING
		end if
	end if
end if

Select Case NEWDATE
	Case "-"
	YEARDATE = "ALL"
	Case "1990"
	YEARDATE = "90"
	Case "1991"
	YEARDATE = "91"
	Case "1992"
	YEARDATE = "92"
	Case "1993"
	YEARDATE = "93"
	Case "1994"
	YEARDATE = "94"
	Case "1995"
	YEARDATE = "95"
	Case "1996"
	YEARDATE = "96"
	Case "1997"
	YEARDATE = "97"
	Case "1998"
	YEARDATE = "98"
	Case "1999"
	YEARDATE = "99"
	Case "2000"
	YEARDATE = "00"
	Case "2001"
	YEARDATE = "01"
	Case Else
	YEARDATE = "00"
End Select

Set objConn = CreateObject("ADODB.Connection")
objConn.open "DSN=CHRISTEST;UID=" & NEWID & ";Pwd= " & NEWPWD &"" ,"",""

strCmd = "SELECT Arrests.STAT_DESCR as Charges, TO_CHAR(Arrests.ARREST_DATE,'DD-MON-YYYY') as Arrest_Date, Arrests.O_STREET_NO as St#," & _
" Arrests.O_STREET_DIRECTION_CD as Dir, Arrests.O_STREET_NME as Street, Arrests.O_BEAT, Arrests.LAST_NME as LName, Arrests.FIRST_NME as FName," & _
" Arrests.NICKNAME, Arrests.SEX_CODE_CD as Sex, Arrests.RACE_CODE_CD as Race, Arrests.AGE as Age, Arrests.BIRTH_DATE as DOB," & _
" Arrests.HEIGHT as Hgt, Arrests.SCARS_MARKS as Scar_Mrk, Arrests.IR_NO, Arrests.CB_NO" & _
" FROM pc09102.Arrest_" & YEARDATE & " Arrests" & _
" WHERE " & _
 DISTSTRING & BEATSTRING & NEWBIRTHDATE & NEWNICK & NEWSCAR & NEWLAST & NEWFIRST & NEWSEX & NEWRACE & NEWAGE & NEWHGT & NEWWGT

    Set oRs = CreateObject("ADODB.Recordset")
    oRs.Open strCmd, objConn, , 1, 1
%>

<table align="center" BORDER="0" BGCOLOR="#ffffff" CELLSPACING="0">
  <tr>
    <td align="middle"><big><font FACE="Arial" color="#0000ff"><big><b>Arrestee List From <% =NEWDATE %> </b></big></font></big></td>
  </tr>
  <tr>
    <td align="middle"><big><font FACE="Arial" color="#0000ff"><big><b>
	    <% =TITLESTRING %><% =BIRTHSTRING %><% =NEWSCARSTRING %></b></big></font></td>
  </tr>
  <tr>
    <td align="middle"><big><font FACE="Arial" color="#0000ff"><big><b>
	   For&nbsp;<% =NEWDISTSTRING %><% =NEWBEATSTRING %></b></big></font></td>
  </tr>
 <tr>
    <td align="middle"><font FACE="Arial" color="#0000ff">Report Date= <%Response.write date()%><br>
    <strong>For Official Police Use Only!&nbsp; Not For Dissemination, Currently Available Data Only!</strong></font></td>
    <br>
  </tr>
</table>
<br>
<table align="center" BORDER="1" BGCOLOR="#ffffff" CELLSPACING="0">
<THEAD>
  <tr>
<% For I = 0 to oRs.fields.count - 1 %>
    <th BGCOLOR="#c0c0c0" BORDERCOLOR="#000000"><font SIZE="1" FACE="Arial" color="#0000ff"><%=oRs.Fields(I).name%></font></th>
<%next%>
  </tr>
</THEAD>

<%
On Error Resume Next
oRs.MoveFirst
do while Not oRs.eof
%>
  <tr VALIGN="top">

<% For I = 0 to oRs.fields.count - 1 %>
    <td BORDERCOLOR="#c0c0c0"><font SIZE="1" FACE="Arial" COLOR="#000000"><%=(oRs.Fields(I).Value) & "&nbsp;"%><br>
    </font></td>
<%next%>
  </tr>
<%
count = count + 1
oRs.MoveNext
oRs.CacheSize = 10
loop %>

<TFOOT>
</TFOOT>
</table>
<br>

<%
Response.Write "This results table currently has <B><FONT COLOR=""#FF0000"">"
If count > 0 Then Response.Write count Else Response.Write "</FONT></B> NO" End If
Response.Write "</FONT></B> records in it.<BR>" & vbCrLf
'If NEWIUCR = "" Then Response.Write "<B><FONT COLOR=""#FF0000""> There was no IUCR code selected! </FONT></B>" End If
%>
</BODY>
</html>















